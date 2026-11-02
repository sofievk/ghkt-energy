% GHKT_TABLE Compare key variables at periods 1, 5, 10 across models.
periods = [1 5 10];
names = ["ghkt_baseline","rho_m1em06","rho_m0p667","rho_m2p333","rho_m9","rho_m50"];
fields = ["Yt_ghkt_v1","energy_ghkt_v1","temp_ghkt_v1","carbon_tax_ghkt_v1"];
b = load(fullfile('results','results_ghkt_baseline.mat'),'p');
yrs = "y" + string(b.p.y(periods));
for f = fields
    M = zeros(numel(names), numel(periods));
    for k = 1:numel(names)
        r = load(fullfile('results',"results_"+names(k)+".mat"), f);
        M(k,:) = reshape(r.(f)(periods),1,[]);
    end
    disp(f); disp(array2table(M,'VariableNames',yrs,'RowNames',cellstr(names)))
end