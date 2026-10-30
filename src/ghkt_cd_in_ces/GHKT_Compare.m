%% 1. Load results (run once per session)
scen = ["rho_CD","rho_Salg","rho_Leontief"];
labs = ["CD (rho \approx 0)","Salg (rho = -0.667)","near-Leontief (rho = -50)"];
names4 = ["GHKT baseline", labs];
blue = [0 0.447 0.741];
cols = [blue; blue; 0.850 0.325 0.098; 0.635 0.078 0.184];
sty  = {'-','o-','--','-.'}; lw = [2.5 0.75 1.5 1.5];
b = load(fullfile('results','results_ghkt_baseline.mat'));
S = {b};
for k = 1:numel(scen), S{end+1} = load(fullfile('results',"results_"+scen(k)+".mat")); end
y = b.p.y; T = b.p.T;

%% 2. Line plots (edit show and titles to change the variables)
show   = ["Yt_ghkt_v1","energy_ghkt_v1","temp_ghkt_v1"];
titles = ["GDP","Energy","Temperature increase"];
figure; tiledlayout(1,numel(show));
for kv = 1:numel(show)
    nexttile; hold on; title(titles(kv)); hs = gobjects(1,4);
    for k = 1:4
        v = S{k}.(show(kv)); v = v(:); m = min(numel(v), T);
        hs(k) = plot(y(1:m), v(1:m), sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:2:m);
    end
end
legend(hs, names4, 'Location','best')

%% 3. Consumption and welfare relative to the GHKT baseline
figure; tiledlayout(1,2);
nexttile; hold on; title('Consumption vs GHKT baseline (%)'); hs = gobjects(1,3);
Cb = b.Ct_ghkt_v1(1:T); Cb = Cb(:);
for k = 2:4
    C = S{k}.Ct_ghkt_v1(1:T); C = C(:);
    hs(k-1) = plot(y(1:T), 100*(C./Cb-1), sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:2:T);
end
yline(0,':k'); legend(hs, names4(2:4), 'Location','best')
nexttile; title('Welfare vs baseline (consumption-equivalent, %)')
ce = 100*(exp((b.fval - cellfun(@(s) s.fval, S))*(1-b.p.beta)) - 1);
bar(categorical(["CD","Salg","Leontief"], ["CD","Salg","Leontief"]), ce(2:4))


%% 4. Energy mix (separate figure)
cw = [0.2 0.7 0.3]; cc = [0.55 0.27 0.07]; co = [0.95 0.65 0.2];
figure; tiledlayout(1,4);
for k = 1:4
    nexttile; hold on; title(names4(k))
    oil = S{k}.oil_ghkt_v1(1:T); coal = S{k}.coal_ghkt_v1(1:T); wind = S{k}.wind_ghkt_v1(1:T);
    tot = oil(:) + coal(:) + wind(:);
    h1 = plot(y(1:T), wind(:)./tot, 'Color',cw, 'LineWidth',1.5);
    h2 = plot(y(1:T), coal(:)./tot, 'Color',cc, 'LineWidth',1.5);
    h3 = plot(y(1:T), oil(:)./tot,  'Color',co, 'LineWidth',1.5);
    xlim([2025 2250]); ylim([0 1])
end
legend([h1 h2 h3], ["Low carbon","Coal","Oil"], 'Location','best')


%% 5. Quick plot: change var_name and which_scen, then run this section
var_name   = "carbon_tax_ghkt_v1";    % any name from the whos list
which_scen = [1 3 4];             % 1 baseline, 2 CD, 3 Salg, 4 Leontief
figure; hold on
for k = which_scen
    v = S{k}.(var_name); v = v(:); m = min(numel(v), T);
    plot(y(1:m), v(1:m), sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:2:m);
end
legend(names4(which_scen), 'Location','best'); title(strrep(var_name,'_',' '))