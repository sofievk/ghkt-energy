%% 1. Load results (run once per session)
files = ["results_ghkt_baseline", ...
         "results_KLxE_rhom1em06", "results_KExL_rhom1em06", ...
         "results_KLxE_rhom0p667", "results_KLxE_rhom50", ...
         "results_KExL_rhom0p667", "results_KExL_rhom50"];
names = ["GHKT baseline", ...
         "KL x E, rho \approx 0", "KE x L, rho \approx 0", ...
         "KL x E, Salg", "KL x E, Leontief", ...
         "KE x L, Salg", "KE x L, Leontief"];
blue = [0 0.447 0.741]; red = [0.850 0.325 0.098];
purple = [0.494 0.184 0.556]; green = [0.466 0.674 0.188];
cols = [blue; blue; green; red; red; purple; purple];
sty  = {'-','o-','x:','--','-.','--','-.'};
lw   = [2.5 0.75 1 1.5 1.5 1.5 1.5];
nS = numel(files); S = cell(1,nS);
for k = 1:nS
    fn = fullfile('results', char(files(k)) + ".mat");
    if ~isfile(fn), error('Missing results file: %s', fn); end
    S{k} = load(fn);
end
y = S{1}.p.y; T = S{1}.p.T;
for k = 1:nS
    if isfield(S{k},'exitflag'), ef = S{k}.exitflag; else, ef = NaN; end
    fprintf('%-30s exitflag %2d  fval %.5f\n', names(k), ef, S{k}.fval);
end

%% 2. GDP, energy, temperature
show = ["Yt_ghkt_v1","energy_ghkt_v1","Kt1_ghkt_v1"];
titles = ["GDP","Energy","Capital"];
figure; tiledlayout(1,3);
for kv = 1:3
    nexttile; hold on; title(titles(kv)); hs = gobjects(1,nS);
    for k = 1:nS
        v = S{k}.(show(kv)); v = v(:); m = min(numel(v),T);
        hs(k) = plot(y(1:m), v(1:m), sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:3:m);
    end
end
legend(hs, names, 'Location','best')

%% 3. Utility (absolute numbers)
figure; tiledlayout(1,2);
nexttile; hold on; title('Discounted period utility'); hs = gobjects(1,nS);
for k = 1:nS
    C = S{k}.Ct_ghkt_v1; C = C(:); m = min(numel(C),T); pk = S{k}.p;
    ct = C(1:m)/1e6; i = (1:m)';
    if pk.sigma == 1, u = log(ct); else, u = (ct.^(1-pk.sigma)-1)/(1-pk.sigma); end
    hs(k) = plot(y(1:m), (pk.beta.^(i-1)).*u, sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:3:m);
end
legend(hs, names, 'Location','best')
nexttile; wel = -cellfun(@(s) s.fval, S);
bar(categorical(names, names), wel); title('Total welfare (-fval), higher is better'); xtickangle(30)
text(1:nS, wel, string(round(wel,4)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom')
disp(table(names', wel', 'VariableNames', {'model','welfare'}))

%% 4. Quick plot (change var_name and which_scen)
var_name   = "Kt1_ghkt_v1";
which_scen = [1, 4, 5, 6, 7];     % 1 baseline, 2 KLxE~0, 3 KExL~0, 4 KLxE Salg, 5 KLxE Leontief, 6 KExL Salg, 7 KExL Leontief
figure; hold on
for k = which_scen
    v = S{k}.(var_name); v = v(:); m = min(numel(v), T);
    plot(y(1:m), v(1:m), sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:3:m);
end
xlim([2010 2300]); legend(names(which_scen), 'Location','best'); title(strrep(var_name,'_',' '))

%% 5. GDP and energy vs baseline (one tile), energy per unit of GDP (second tile)
% Colour = structure, pattern = rho (solid Salg, dashed near-Leontief),
% circles = energy, no circles = GDP
idx  = [4 5 6 7];
colr = {red, red, purple, purple};
patt = {'-','--','-','--'};
labs = ["KL x E, Salg","KL x E, near-Leontief","KE x L, Salg","KE x L, near-Leontief"];
xl = [2010 2300]; gr = [0.6 0.6 0.6];
G = @(k) S{k}.Yt_ghkt_v1(1:T);
E = @(k) S{k}.energy_ghkt_v1(1:T);
disp(names(idx))

figure('Color','w'); tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

ax1 = nexttile; hold on; box on
title('GDP and energy vs baseline')
subtitle('Energy: model aggregate of oil, coal and wind (GtC-based units)')
hb = plot(xl,[0 0],'-','Color',gr,'LineWidth',2.2);
h = gobjects(1,numel(idx));
for j = 1:numel(idx)
    h(j) = plot(y(1:T), 100*(G(idx(j))./G(1)-1), patt{j}, 'Color',colr{j}, 'LineWidth',1.8);
    plot(y(1:T), 100*(E(idx(j))./E(1)-1), patt{j}, 'Color',colr{j}, 'LineWidth',1.4, ...
        'Marker','o', 'MarkerSize',4, 'MarkerIndices',1:4:T);
end
hG = plot(NaN,NaN,'-','Color','k','LineWidth',1.5);
hE = plot(NaN,NaN,'-o','Color','k','LineWidth',1.4,'MarkerSize',4);
xlim(xl); xlabel('Year'); ylabel('% difference from baseline')

nexttile; hold on; box on
title('Energy per unit of GDP (2010 = 100)')
subtitle('Energy in model units (GtC-based aggregate)')
rel = @(v) 100*v/v(1);
plot(y(1:T), rel(E(1)./G(1)), '-', 'Color',gr, 'LineWidth',2.2);
for j = 1:numel(idx)
    plot(y(1:T), rel(E(idx(j))./G(idx(j))), patt{j}, 'Color',colr{j}, 'LineWidth',1.8);
end
xlim(xl); xlabel('Year'); ylabel('Index')

lgd = legend(ax1, [hb h hG hE], ["GHKT baseline" labs "GDP (no markers)" "Energy (circles)"], 'Orientation','horizontal');
lgd.NumColumns = 3; lgd.Layout.Tile = 'south';



%% 6. Configurable comparison: edit the block below, then run this section
% ---------------- edit here ----------------
scen_struct = ["KLxE","KExL"];   % structures to show
scen_rho    = [-50 -4 -0.667];             % rho values to show (up to 4); files must exist
xl          = [2010 2300];       % time window
% --------------------------------------------
tag = @(r) strrep(strrep(sprintf('%g',r),'-','m'),'.','p');
b   = load(fullfile('results','results_ghkt_baseline.mat'));
T = b.p.T; y = b.p.y;
Kc  = @(s) [s.p.K0; s.Kt1_ghkt_v1(1:T-1)];
rel = @(v,w) 100*(v(:)./w(:)-1);
colr = struct('KLxE',[0.850 0.325 0.098], 'KExL',[0.494 0.184 0.556]);
patt = {'-','--',':','-.'};
gr = [0.6 0.6 0.6];

figure('Color','w'); tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
ax1 = nexttile; hold on; box on; title('Energy (E) and capital (K) vs baseline')
xlabel('Year'); ylabel('% difference from baseline')
hb = plot(xl,[0 0],'-','Color',gr,'LineWidth',2.2);
ax2 = nexttile; hold on; box on; title('GDP vs baseline'); xlabel('Year')
plot(xl,[0 0],'-','Color',gr,'LineWidth',2.2);

hh = gobjects(0); lb = strings(0); missing = strings(0);
for i = 1:numel(scen_struct)
    for j = 1:numel(scen_rho)
        fn = fullfile('results', "results_" + scen_struct(i) + "_rho" + string(tag(scen_rho(j))) + ".mat");
        if ~isfile(fn), missing(end+1) = scen_struct(i) + " rho " + scen_rho(j); continue, end
        s = load(fn); c = colr.(scen_struct(i)); ls = patt{mod(j-1,numel(patt))+1};
        dE = rel(s.energy_ghkt_v1(1:T), b.energy_ghkt_v1(1:T));
        dK = rel(Kc(s), Kc(b));
        dY = rel(s.Yt_ghkt_v1(1:T), b.Yt_ghkt_v1(1:T));
        hh(end+1) = plot(ax1, y(1:T), dE, ls, 'Color', c, 'LineWidth', 1.8);
        plot(ax1, y(1:T), dK, ls, 'Color', c, 'LineWidth', 1.8);
        text(ax1, y(T), dE(end), ' E', 'Color', c, 'FontWeight', 'bold');
        text(ax1, y(T), dK(end), ' K', 'Color', c, 'FontWeight', 'bold');
        plot(ax2, y(1:T), dY, ls, 'Color', c, 'LineWidth', 1.8);
        lb(end+1) = scen_struct(i) + ", rho = " + scen_rho(j);
    end
end
xlim(ax1, [xl(1) xl(2)+25]); xlim(ax2, xl)
if ~isempty(missing), disp("Missing (not plotted): " + strjoin(missing, "; ")), end
if ~isempty(hh)
    lgd = legend(ax1, [hb hh], ["GHKT baseline" lb], 'Orientation','horizontal');
    lgd.NumColumns = 2; lgd.Layout.Tile = 'south';
end