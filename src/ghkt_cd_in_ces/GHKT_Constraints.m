%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 4: Constraints                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c, ceq] = GHKT_Constraints(x,params)
A2t = params.A2t; A3t = params.A3t; At = params.At; Delta = params.Delta;
K0 = params.K0; N = params.N; R0 = params.R0; S1_2000 = params.S1_2000;
S2_2000 = params.S2_2000; Sbar = params.Sbar; T = params.T;
alpha = params.alpha; beta = params.beta; gZ_en = params.gZ_en;
gZd_y = params.gZd_y; gZBGP = params.gZBGP; gamma = params.gamma;
kappa1 = params.kappa1; kappa2 = params.kappa2; kappa3 = params.kappa3;
phi = params.phi; phi0 = params.phi0; phiL = params.phiL; rho = params.rho;
sigma = params.sigma; v = params.v; ypsilon = params.ypsilon;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Positive Consumption Constraint & Positive Oil Constraint%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%Compute consumption and oil resources based on x = [{Kt+1},{Rt+1},{pi0t},{pi2t}]:
%Step 1: Compute implied energy inputs
%Step 2: Compute carbon emissions and concentrations
%Step 3: Compute output and consumption

c = zeros(2*T+1,1);     

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 1: Energy Inputs%%
%%%%%%%%%%%%%%%%%%%%%%%%%

oil = zeros(T,1);
    oil(1) = R0-x(T);
for i = 1:1:T-2;
    oil(1+i) = x(T+i-1)-x(T+i);
end
    ex_Oil = (x(T-1+T-2)-x(T-1+T-1))/(x(T-1+T-2));    %Fraction of oil left extracted in period T-1
    oil(T) = x(T-1+T-1)*ex_Oil;
 for i = 1:1:T;
     c(T+i) = (-1)*(oil(i)-0.0001);                   %Positive oil constraint
 end
    c(2*T+1) = (ex_Oil-1);
coal = zeros(T,1);
for i = 1:1:T;
    coal(i) = x(2*(T-1)+i)*(A2t(i)*N);
end
wind = zeros(T,1);
for i = 1:1:T;
    wind(i) = x(2*(T-1)+T+i)*(A3t(i)*N);
end
energy = zeros(T,1);
for i = 1:1:T; 
    energy(i) = ((kappa1*oil(i)^rho)+(kappa2*coal(i)^rho)+(kappa3*wind(i)^rho))^(1/rho);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 2: Carbon Emissions and Concentrations%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

emiss = zeros(T,1);
for i = 1:1:T;
    emiss(i) = oil(i)+ypsilon(i)*coal(i);
end

S1t = zeros(T,1);        %Non-depreciating stock
S2t_Sbar = zeros(T,1);   %Depreciating stock (S2t-Sbar)
St = zeros(T,1);         %Total carbon concentrations

S1t(1) = S1_2000+phiL*emiss(1);
S2t_Sbar(1) = (1-phi)*(S2_2000-Sbar)+phi0*(1-phiL)*emiss(1);
St(1) = Sbar+S1t(1)+S2t_Sbar(1);

for i = 1:1:T-1;
    S1t(1+i) = S1t(i)+phiL*emiss(1+i);
    S2t_Sbar(1+i) = (1-phi)*S2t_Sbar(i)+phi0*(1-phiL)*emiss(1+i);
    St(1+i) = Sbar+S1t(1+i)+S2t_Sbar(1+i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 3: Output and Consumption%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Yt = zeros(T,1);
Ct = zeros(T,1);
Kt1 = zeros(T,1);
Yt(1) = ProductionFunction(K0, (1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N, energy(1), exp((-gamma(1))*(St(1)-Sbar)), params);Ct(1) = (1-x(1))*Yt(1);
Kt1(1) = x(1)*Yt(1)+(1-Delta)*K0;
for i = 1:1:T-2;
        Yt(1+i) = ProductionFunction(Kt1(i), (1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N, energy(1+i), exp((-gamma(1+i))*(St(1+i)-Sbar)), params);Kt1(1+i) = x(1+i)*Yt(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*Yt(1+i); 
end
Yt(T) = ProductionFunction(Kt1(T-1), (1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N, energy(T), exp((-gamma(T))*(St(T)-Sbar)), params);theta = x(T-1);
Ct(T) = Yt(T)*(1-theta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Positive Consumption Constraint:%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:1:T;
    c(i) = (-1)*(Ct(i)-0.0001);
end


%%%Equality Constraint for Benchmark Case%%%

ceq = [];
end