function Y = ProductionFunction(K,L,E,D,params)
% PRODUCTIONFUNCTION Output, normalized to base-year (2009) values.
% K capital, L labour in final goods, E energy, D climate damage factor.
% params.pf_type = "CDinCES": V = CD(K,L), Y = CES(V,E)
% params.pf_type = "CESinCD": M = CES(K,E), Y = CD(M,L)
% rho_prod is the substitution parameter of the CES layer in either case.
switch params.pf_type
    case "CDinCES"
        V = (K/params.K0)^params.alpha_V * (L/params.L0)^(1-params.alpha_V);
        Y = params.Y0 * (D/params.D0) * ((1-params.v)*V^params.rho_prod ...
            + params.v*(E/params.E0)^params.rho_prod)^(1/params.rho_prod);
    case "CESinCD"
        M = (params.w_K*(K/params.K0)^params.rho_prod ...
            + (1-params.w_K)*(E/params.E0)^params.rho_prod)^(1/params.rho_prod);
        Y = params.Y0 * (D/params.D0) * M^params.a_M * (L/params.L0)^(1-params.a_M);
    otherwise
        error('Unknown pf_type: %s', params.pf_type)
end
end