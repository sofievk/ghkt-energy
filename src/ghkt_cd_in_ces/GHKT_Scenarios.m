% GHKT_SCENARIOS Run GHKT_Main for several values of rho_prod.
% The unnamed values are stepping stones that help the solver reach rho_Leontief.
if ~exist('pf','var'), pf = "CDinCES"; end

if ~exist('rho_list','var')
    rho_list  = [-1e-6, -0.667, -2.333, -9, -50];
    name_list = ["rho_CD","rho_Salg","","","rho_Leontief"];
end
if ~exist('name_list','var'), name_list = strings(size(rho_list)); end
if ~exist('start_first','var'), start_first = "saved"; end
for s_idx = 1:numel(rho_list)
    rp = rho_list(s_idx);
    clear scenario_name
    if name_list(s_idx) ~= "", scenario_name = char(name_list(s_idx)); end
    if s_idx == 1, start_mode = start_first; else, start_mode = "previous"; end
    GHKT_Main
    x_prev = x;
    close all
    fprintf('rho_prod = %g: exitflag %d, fval %g\n', rp, exitflag, fval);
end
clear pf rp start_mode x_prev s_idx rho_list name_list start_first scenario_name

