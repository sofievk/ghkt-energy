% GHKT_COMPARE Overlay GDP, energy and temperature for saved scenarios.
names = ["rho_m1em06","rho_m0p667","rho_m2p333","rho_m9","rho_m50"];
fields = ["Yt_ghkt_v1","energy_ghkt_v1","temp_ghkt_v1"];
ttl = ["GDP","Energy","Temperature increase"];
figure; tiledlayout(1,3);
for k_f = 1:3
    nexttile; hold on
    for nm = names
        r = load(fullfile('results', "results_" + nm + ".mat"), fields(k_f), 'p');
        plot(r.p.y, r.(fields(k_f))(1:r.p.T), '-o')
    end
    title(ttl(k_f))
end
legend(names, 'Interpreter','none', 'Location','best')
