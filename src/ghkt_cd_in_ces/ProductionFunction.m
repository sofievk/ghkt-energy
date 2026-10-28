function Y = ProductionFunction(K,L,E,D,params)
% PRODUCTIONFUNCTION CD-in-CES output (normalized to base-year values).
% K capital, L labour in final goods, E energy, D climate damage factor.
V = (K/params.K0)^params.alpha_V * (L/params.L0)^(1-params.alpha_V);
Y = params.Y0 * (D/params.D0) * ((1-params.v)*V^params.rho_prod ...
    + params.v*(E/params.E0)^params.rho_prod)^(1/params.rho_prod);
end