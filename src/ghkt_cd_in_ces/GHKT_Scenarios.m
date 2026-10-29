% GHKT_SCENARIOS Run GHKT_Main for several values of rho_prod.
rho_list = [-1e-6 -0.667 -2.333 -9 -50];
for s_idx = 1:numel(rho_list)
    rp = rho_list(s_idx);
    if s_idx == 1, start_mode = "saved"; else, start_mode = "previous"; end
    GHKT_Main
    x_prev = x;
    close all
    fprintf('rho_prod = %g: exitflag %d, fval %g\n', rp, exitflag, fval);
end
clear rp start_mode x_prev s_idx

