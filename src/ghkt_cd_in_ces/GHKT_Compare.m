
%% 1. Load results (run once per session; defines colours, patterns and runs for sections 2-4)
% ---------------- edit here ----------------
run_struct = ["KLxE","KLxE","KExL","KExL"];   % one entry per run
run_rho    = [-0.667 -50 -0.667 -50];         % same length; at most 4 different values
% --------------------------------------------

gr     = [0.6 0.6 0.6];       % GHKT baseline
dkblue = [0.05 0.20 0.55];    % KL x E
ltblue = [0.40 0.70 0.95];    % KE x L
colS = struct('KLxE',dkblue, 'KExL',ltblue);
nm   = struct('KLxE',"KL x E", 'KExL',"KE x L");

% Fixed rho-to-line-style mapping
rho_values = [-50, -4, -2, -0.667];
rho_styles = {'-', '--', '-.', ':'};
patfor = @(r) rho_styles{find(abs(rho_values-r)<1e-8,1)};

runfile = @(st,r) fullfile('results', "results_" + st + "_rho" + ...
    strrep(strrep(sprintf('%g',r),'-','m'),'.','p') + ".mat");

b = load(fullfile('results','results_ghkt_baseline.mat'));
T = b.p.T; y = b.p.y;

nR = numel(run_rho); R = cell(1,nR); ok = false(1,nR);
for i = 1:nR
    fn = runfile(run_struct(i), run_rho(i));
    if isfile(fn)
        R{i} = load(fn); ok(i) = true;
    else
        fprintf('Missing: %s\n', fn);
    end
end

if ~any(ok), error('No results files found for the selected runs'); end
if numel(unique(run_rho(ok))) > 4
    error('Use at most 4 different rho values');
end

fprintf('%-14s %8s  exitflag %2d  fval %.5f\n', ...
    'GHKT baseline', '', b.exitflag, b.fval);
for i = find(ok)
    fprintf('%-14s rho %-5g exitflag %2d  fval %.5f\n', ...
        nm.(run_struct(i)), run_rho(i), R{i}.exitflag, R{i}.fval);
end


%% 2. GDP, energy, capital
show   = ["Yt_ghkt_v1","energy_ghkt_v1","Kt1_ghkt_v1"];
titles = ["GDP","Energy","Capital"];

sel = ok;

figure('Color','w');
tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
ax = gobjects(1,3);

for kv = 1:3
    ax(kv) = nexttile;
    hold on;
    box off;
    title(titles(kv));
    xlabel('Year');

    v = b.(show(kv));
    v = v(:);
    m = min(numel(v),T);
    hbk = plot(y(1:m),v(1:m),'-','Color',gr,'LineWidth',2.2);
    if kv == 1, hbase = hbk; end

    for i = find(sel)
        v = R{i}.(show(kv));
        v = v(:);
        m = min(numel(v),T);
        plot(y(1:m),v(1:m),patfor(run_rho(i)), ...
            'Color',colS.(run_struct(i)),'LineWidth',1.8);
    end
end

H = hbase;
L = "GHKT baseline";

for st = unique(run_struct(sel),'stable')
    H(end+1) = plot(ax(1),NaN,NaN,'LineStyle','none');
    L(end+1) = "\bf" + nm.(st);

    for r = sort(unique(run_rho(sel & run_struct==st)),'descend')
        H(end+1) = plot(ax(1),NaN,NaN,patfor(r), ...
            'Color',colS.(st),'LineWidth',1.8);
        L(end+1) = "\rho = " + r;
    end
end

lgd = legend(ax(1),H,L,'Interpreter','tex','Box','on');
lgd.Layout.Tile = 'east';


%% 3. Utility (absolute numbers) and total welfare
sel = ok;

all_s = [{b}, R(sel)];
idx = find(sel);

figure('Color','w');
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

ax1 = nexttile;
hold on;
box off;
title('Discounted period utility');
xlabel('Year');

lab = "GHKT baseline";
wel = zeros(1,numel(all_s));

for k = 1:numel(all_s)
    s = all_s{k};
    ct = s.Ct_ghkt_v1(1:T)/1e6;
    ct = ct(:);
    ii = (1:T)';

    if s.p.sigma == 1
        u = log(ct);
    else
        u = (ct.^(1-s.p.sigma)-1)/(1-s.p.sigma);
    end

    if k == 1
        hbase = plot(y(1:T),(s.p.beta.^(ii-1)).*u, ...
            '-','Color',gr,'LineWidth',2.2);
    else
        i = idx(k-1);
        plot(y(1:T),(s.p.beta.^(ii-1)).*u, ...
            patfor(run_rho(i)), ...
            'Color',colS.(run_struct(i)),'LineWidth',1.8);

        lab(end+1) = nm.(run_struct(i)) + ...
            ", \rho = " + run_rho(i);
    end

    wel(k) = -s.fval;
end

H = hbase;
L = "GHKT baseline";

for st = unique(run_struct(sel),'stable')
    H(end+1) = plot(ax1,NaN,NaN,'LineStyle','none');
    L(end+1) = "\bf" + nm.(st);

    for r = sort(unique(run_rho(sel & run_struct==st)),'descend')
        H(end+1) = plot(ax1,NaN,NaN,patfor(r), ...
            'Color',colS.(st),'LineWidth',1.8);
        L(end+1) = "\rho = " + r;
    end
end

lgd = legend(ax1,H,L,'Interpreter','tex','Box','on');
lgd.Layout.Tile = 'east';

nexttile;
box off;
title('Total welfare (-fval), higher is better');
bar(categorical(lab,lab),wel);
xtickangle(30);

text(1:numel(wel),wel,string(round(wel,4)), ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','bottom');

disp(table(lab',wel','VariableNames',{'model','welfare'}));


%% 4. Quick plot (change var_name and which_scen)
var_name   = "Kt1_ghkt_v1";    % e.g. coal_ghkt_v1, oil_ghkt_v1, temp_ghkt_v1
which_scen = 1:nR;             % run numbers from the table below

disp(table((1:nR)',run_struct',run_rho', ...
    'VariableNames',{'run','structure','rho'}));

sel = false(1,nR);
sel(which_scen) = true;
sel = sel & ok;

figure('Color','w');
tiledlayout(1,1,'Padding','compact');
ax1 = nexttile;
hold on;
box off;

v = b.(var_name);
v = v(:);
m = min(numel(v),T);
hbase = plot(y(1:m),v(1:m),'-','Color',gr,'LineWidth',2.2);

for i = find(sel)
    v = R{i}.(var_name);
    v = v(:);
    m = min(numel(v),T);
    plot(y(1:m),v(1:m),patfor(run_rho(i)), ...
        'Color',colS.(run_struct(i)),'LineWidth',1.8);
end

xlim([2010 2300]);
xlabel('Year');
title(strrep(var_name,'_',' '));

H = hbase;
L = "GHKT baseline";

for st = unique(run_struct(sel),'stable')
    H(end+1) = plot(ax1,NaN,NaN,'LineStyle','none');
    L(end+1) = "\bf" + nm.(st);

    for r = sort(unique(run_rho(sel & run_struct==st)),'descend')
        H(end+1) = plot(ax1,NaN,NaN,patfor(r), ...
            'Color',colS.(st),'LineWidth',1.8);
        L(end+1) = "\rho = " + r;
    end
end

lgd = legend(ax1,H,L,'Interpreter','tex','Box','on');
lgd.Layout.Tile = 'east';


%% 5. GDP (absolute) and energy per unit of GDP
% ---------------- edit here ----------------
s5_struct = ["KLxE","KLxE","KExL","KExL"];   % one entry per run
s5_rho    = [-4 -50 -4 -50];                 % same length
xl        = [2010 2300];
% --------------------------------------------

nR5 = numel(s5_rho);
R5 = cell(1,nR5);
ok5 = false(1,nR5);

for i = 1:nR5
    fn = runfile(s5_struct(i),s5_rho(i));
    if isfile(fn)
        R5{i} = load(fn);
        ok5(i) = true;
    else
        fprintf('Missing: %s\n',fn);
    end
end

if ~any(ok5), error('No results files found for the selected runs'); end

if numel(unique(s5_rho(ok5))) > 4
    error('Use at most 4 different rho values');
end

G = @(s) s.Yt_ghkt_v1(1:T);
E = @(s) s.energy_ghkt_v1(1:T);
idx100 = @(v) 100*v(:)/v(1);

figure('Color','w');
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

ax1 = nexttile;
hold on;
box off;
title('GDP (model units)');
xlabel('Year');
ylabel('GDP');

hbase = plot(y(1:T),G(b),'-','Color',gr,'LineWidth',2.2);

for i = find(ok5)
    plot(y(1:T),G(R5{i}),patfor(s5_rho(i)), ...
        'Color',colS.(s5_struct(i)),'LineWidth',1.8);
end

xlim(xl);

nexttile;
hold on;
box off;
title('Energy per unit of GDP (index, 2010 = 100)');
subtitle('Energy in model units (GtC-based aggregate)');
xlabel('Year');
ylabel('Index');

plot(y(1:T),idx100(E(b)./G(b)), ...
    '-','Color',gr,'LineWidth',2.2);

for i = find(ok5)
    plot(y(1:T),idx100(E(R5{i})./G(R5{i})), ...
        patfor(s5_rho(i)), ...
        'Color',colS.(s5_struct(i)),'LineWidth',1.8);
end

xlim(xl);

H = hbase;
L = "GHKT baseline";

for st = unique(s5_struct(ok5),'stable')
    H(end+1) = plot(ax1,NaN,NaN,'LineStyle','none');
    L(end+1) = "\bf" + nm.(st);

    for r = sort(unique(s5_rho(ok5 & s5_struct==st)),'descend')
        H(end+1) = plot(ax1,NaN,NaN,patfor(r), ...
            'Color',colS.(st),'LineWidth',1.8);
        L(end+1) = "\rho = " + r;
    end
end

lgd = legend(ax1,H,L,'Interpreter','tex','Box','on');
lgd.Layout.Tile = 'east';


%% 6. Comparison vs baseline (energy E and capital K in one tile, GDP in another)
% ---------------- edit here ----------------
scen_struct = ["KLxE","KExL"];   % structures to show
scen_rho    = [-50 -0.667];          % rho values to show (at most 4)
xl          = [2010 2300];       % time window
% --------------------------------------------

g_struct = strings(1,0);
g_rho = zeros(1,0);

for st = scen_struct
    for r = scen_rho
        g_struct(end+1) = st;
        g_rho(end+1) = r;
    end
end

nG = numel(g_rho);
Rg = cell(1,nG);
okg = false(1,nG);

for i = 1:nG
    fn = runfile(g_struct(i),g_rho(i));
    if isfile(fn)
        Rg{i} = load(fn);
        okg(i) = true;
    else
        fprintf('Missing: %s\n',fn);
    end
end

if ~any(okg), error('No results files found for the selected runs'); end

if numel(unique(g_rho(okg))) > 4
    error('Use at most 4 different rho values');
end

Kc  = @(s) [s.p.K0; s.Kt1_ghkt_v1(1:T-1)];
rel = @(v,w) 100*(v(:)./w(:)-1);

figure('Color','w');
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

ax1 = nexttile;
hold on;
box off;
title('Energy (E) and capital (K) vs baseline');
xlabel('Year');
ylabel('% difference from baseline');

hbase = plot(xl,[0 0],'-','Color',gr,'LineWidth',2.2);

ax2 = nexttile;
hold on;
box off;
title('GDP vs baseline');
xlabel('Year');
ylabel('% difference from baseline');

plot(xl,[0 0],'-','Color',gr,'LineWidth',2.2);

for i = find(okg)
    s = Rg{i};
    c = colS.(g_struct(i));
    ls = patfor(g_rho(i));

    dE = rel(s.energy_ghkt_v1(1:T),b.energy_ghkt_v1(1:T));
    dK = rel(Kc(s),Kc(b));
    dY = rel(s.Yt_ghkt_v1(1:T),b.Yt_ghkt_v1(1:T));

    plot(ax1,y(1:T),dE,ls,'Color',c,'LineWidth',1.8);
    plot(ax1,y(1:T),dK,ls,'Color',c,'LineWidth',1.8);

    plot(ax2,y(1:T),dY,ls,'Color',c,'LineWidth',1.8);
end

xlim(ax1,[xl(1) xl(2)+25]);
xlim(ax2,xl);

% Labels for the two sets of curves, replacing individual E/K endpoint markers
text(ax1,0.98,0.96,'Energy', ...
    'Units','normalized', ...
    'HorizontalAlignment','right', ...
    'VerticalAlignment','top', ...
    'FontWeight','bold', ...
    'BackgroundColor','w');

text(ax1,0.98,0.04,'Capital', ...
    'Units','normalized', ...
    'HorizontalAlignment','right', ...
    'VerticalAlignment','bottom', ...
    'FontWeight','bold', ...
    'BackgroundColor','w');

H = hbase;
L = "GHKT baseline";

for st = unique(g_struct(okg),'stable')
    H(end+1) = plot(ax1,NaN,NaN,'LineStyle','none');
    L(end+1) = "\bf" + nm.(st);

    for r = sort(unique(g_rho(okg & g_struct==st)),'descend')
        H(end+1) = plot(ax1,NaN,NaN,patfor(r), ...
            'Color',colS.(st),'LineWidth',1.8);
        L(end+1) = "\rho = " + r;
    end
end

lgd = legend(ax1,H,L,'Interpreter','tex','Box','on');
lgd.Layout.Tile = 'east';
