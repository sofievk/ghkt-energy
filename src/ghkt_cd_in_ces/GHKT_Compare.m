%% 1. Load (run once per session)
files = ["results_ghkt_baseline","results_rho_CD","results_CESinCD_CD","results_rho_Leontief","results_CESinCD_Leontief"];
names5 = ["GHKT baseline","CD-in-CES, rho \approx 0","CES-in-CD, rho \approx 0","CD-in-CES, near-Leontief","CES-in-CD, near-Leontief"];
blue = [0 0.447 0.741];
cols = [blue; blue; 0.466 0.674 0.188; 0.635 0.078 0.184; 0.494 0.184 0.556];
sty  = {'-','o-','x:','-.','--'}; lw = [2.5 0.75 1 1.5 1.5];
S = cell(1,5);
for k = 1:5, S{k} = load(fullfile('results', files(k)+".mat")); end
y = S{1}.p.y; T = S{1}.p.T;

%% 2. GDP, energy, temperature
show = ["Yt_ghkt_v1","energy_ghkt_v1","temp_ghkt_v1"];
titles = ["GDP","Energy","Temperature increase"];
figure; tiledlayout(1,3);
for kv = 1:3
    nexttile; hold on; title(titles(kv)); hs = gobjects(1,5);
    for k = 1:5
        v = S{k}.(show(kv)); v = v(:); m = min(numel(v),T);
        hs(k) = plot(y(1:m), v(1:m), sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:3:m);
    end
end
legend(hs, names5, 'Location','best')

%% 3. Utility (absolute numbers)
figure; tiledlayout(1,2);
nexttile; hold on; title('Discounted period utility'); hs = gobjects(1,5);
for k = 1:5
    C = S{k}.Ct_ghkt_v1; C = C(:); m = min(numel(C),T); pk = S{k}.p;
    ct = C(1:m)/1e6; i = (1:m)';
    if pk.sigma == 1, u = log(ct); else, u = (ct.^(1-pk.sigma)-1)/(1-pk.sigma); end
    hs(k) = plot(y(1:m), (pk.beta.^(i-1)).*u, sty{k}, 'Color',cols(k,:), 'LineWidth',lw(k), 'MarkerSize',5, 'MarkerIndices',1:3:m);
end
legend(hs, names5, 'Location','best')
nexttile; wel = -cellfun(@(s) s.fval, S);
bar(categorical(names5, names5), wel); title('Total welfare (-fval), higher is better')
text(1:5, wel, string(round(wel,4)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom')
disp(table(names5', wel', 'VariableNames', {'model','welfare'}))