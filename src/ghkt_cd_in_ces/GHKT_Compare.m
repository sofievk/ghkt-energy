% GHKT_COMPARE Overlay the GHKT baseline and CD-in-CES scenarios.
blue = [0 0.447 0.741];
names = ["rho_m1em06","rho_m0p667","rho_m2p333","rho_m9","rho_m50"];
cols = [blue; 0.850 0.325 0.098; 0.466 0.674 0.188; 0.494 0.184 0.556; 0.635 0.078 0.184];
styl = {'-','--','-.',':','--'};
fields = ["Yt_ghkt_v1","energy_ghkt_v1","temp_ghkt_v1"];
ttl = ["GDP","Energy","Temperature increase"];
b = load(fullfile('results','results_ghkt_baseline.mat'));
y = b.p.y; nT = b.p.T;
figure; tiledlayout(1,3);
for kf = 1:3
    nexttile; hold on; title(ttl(kf))
    hs = plot(y, b.(fields(kf))(1:nT), '-', 'Color',blue, 'LineWidth',2.5);
    lab = "GHKT baseline";
    for k = 1:numel(names)
        r = load(fullfile('results',"results_"+names(k)+".mat"), fields(kf), 'p');
        if k == 1
            h = plot(y, r.(fields(kf))(1:nT), 'o-', 'Color',blue, 'LineWidth',0.75, 'MarkerSize',5, 'MarkerIndices',1:2:nT);
        else
            h = plot(y, r.(fields(kf))(1:nT), styl{k}, 'Color',cols(k,:), 'LineWidth',1.5);
        end
        hs(end+1) = h; lab(end+1) = "rho_prod = " + r.p.rho_prod;
    end
end
legend(hs, lab, 'Location','best')