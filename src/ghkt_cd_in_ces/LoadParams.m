function params = LoadParams(params)

%% Parameters

arguments
    % Time
    params.T (1,1) double {mustBeInteger, mustBePositive} = 30
    params.n (1,1) double {mustBeInteger, mustBeNonnegative} = 100

    % Climate
    params.phi (1,1) double = 0.0228
    params.phiL (1,1) double = 0.2
    params.phi0 (1,1) double = 0.393
    params.Sbar (1,1) double = 581
    params.S1_2000 (1,1) double = 103
    params.S2_2000 (1,1) double = 699
    params.gamma (1,1) double = 0.000023793                             % Damage elasticity

    % Energy 
    params.rho (1,1) double = -0.058
    params.kappa1 (1,1) double = 0.5429
    params.kappa2 (1,1) double = 0.1015

    params.E1_2008 (1,1) double = 3.43+1.68
    params.E2_2008 (1,1) double = 3.75
    params.E3_2008 (1,1) double = 1.95

    params.gZa_en (1,1) double = 0.02
    params.gAa_y (1,1) double = 0
    params.A2t (1,1) double = 7693
    params.A3t (1,1) double = 1311
    params.R0 (1,1) double = 253.8

    params.a_yps (1,1) double = 8
    params.b_yps (1,1) double = -0.05


    % Final goods production
    params.N (1,1) double = 1
    params.alpha (1,1) double = 0.3
    params.v (1,1) double = 0.04
    params.Y2009 (1,1) double = 70000
    params.r2009 (1,1) double = 0.05
    params.delta (1,1) double = 1
    params.pi00 (1,1) double = 1
    params.rho_prod (1,1) double = -1e-6


    % Time preference
    params.sigma (1,1) double = 1
    params.beta (1,1) double = (.985)^10
 

end

%% Derived parameters

% Time
y = (1:1:params.T);
y(1) = 2010;   

for i = 1:1:params.T-1
    y(1+i) = 2010+((i)*10);
end
    
y2 = (1:1:params.T+params.n);
y2(1) = 2010;    

for i = 1:1:params.T-1+params.n
        y2(1+i) = 2010+((i)*10);
end

% Climate
gamma = zeros(params.T,1);

for i = 1:1:params.T
    gamma(i) = params.gamma;
end

% Energy
kappa3 = 1 - params.kappa1 - params.kappa2;
E0_2008 = ((params.kappa1*params.E1_2008^params.rho) + ...
           (params.kappa2*params.E2_2008^params.rho) + ...
           (kappa3*params.E3_2008^params.rho))^(1/params.rho);

E0 = E0_2008*10;

gZ_en = ((1+params.gZa_en)^10)-1;
gZa_y = ((1+params.gAa_y)^(1/(1-params.alpha-params.v)))-1;
gAd_y = ((1+params.gAa_y)^10)-1;
gZd_y = ones(params.T+params.n,1)*(((1+gZa_y)^10)-1);


A2t = zeros(params.T,1);
A2t(1) = params.A2t;

for i = 1:1:params.T-1
    A2t(i+1) = A2t(i)*(1+gZ_en);
end

ypsilon = zeros(params.T,1);

for i = 1:1:params.T+params.n
    ypsilon(i) = 1/(1+exp((-1)*(params.a_yps+params.b_yps*(i-1)*10)));
end

A3t = zeros(params.T,1);
A3t(1) = params.A3t;

for i = 1:1:params.T-1
    A3t(i+1) = A3t(i)*(1+gZ_en);
end


% Final goods production

gZBGP = gZd_y(params.T);

r2009d = ((1+params.r2009)^10)-1;
Delta = (1-(1-params.delta)^10);
K0 = (params.alpha*params.Y2009*10)/(r2009d+Delta);
A0 = (params.Y2009*10) / ...
    ((exp((-gamma(1))*((params.S1_2000+params.S2_2000)-params.Sbar))) * ...
    ((K0^params.alpha)*((params.N*params.pi00)^(1-params.alpha-params.v))*(E0^params.v)));
At = zeros(params.T,1);
At(1) = A0;
Y0 = params.Y2009*10;
D0 = exp((-gamma(1))*((params.S1_2000+params.S2_2000)-params.Sbar));
alpha_V = params.alpha/(1-params.v);
L0 = params.N*params.pi00;
for i = 1:1:params.T-1
    At(i+1) = At(i)*(1+gZd_y(i))^(1-params.alpha-params.v);
end



%% Collect parameters

params.y = y;
params.y2 = y2;   
params.gamma = gamma;
params.kappa3 = kappa3;
params.r2009d = r2009d;
params.Delta = Delta;
params.K0 = K0;
params.E0_2008 = E0_2008;
params.E0 = E0;
params.A0 = A0;
params.gZ_en = gZ_en;
params.gZa_y = gZa_y;
params.gAd_y = gAd_y;
params.gZd_y = gZd_y;
params.At = At;
params.gZBGP = gZBGP;
params.A2t = A2t;
params.ypsilon = ypsilon;
params.A3t = A3t;
params.Y0 = Y0;
params.D0 = D0;
params.alpha_V = alpha_V;
params.L0 = L0;