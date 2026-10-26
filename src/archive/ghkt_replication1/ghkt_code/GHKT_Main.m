%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%          Sensitivity Analysis for                %%%%%%
%%%%%                                                  %%%%%%
%%%%%  Golosov, Hassler, Krusell, and Tsyvinski (2014) %%%%%%
%%%%%                                                  %%%%%%
%%%%%   Author: Lint Barrage (lint_barrage@brown.edu)  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear


%M-File Outline%
%%%%%%%%%%%%%%%%
%Section 1: Define parameters
%Section 2: Solve for optimal choice variables X
%Section 3: Compute optimal allocations and carbon taxes
%Section 4: Save optimal allocations and carbon taxes
%Section 5: Create graphs from saved output
%Section 6: Compute and compare carbon tax approximations
%Section 7: Save output in Excel


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 1: Parameters        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Time%%
%%%%%%%%
T = 30;             %Number of direct optimization periods T
y = (1:1:T);        %Corresponding calendar years    
y(1) = 2010;
for i = 1:1:T-1;
    y(1+i) = 2010+((i)*10);
end
n = 100;            %Number of pre-balanced growth path simulation periods after T
y2 = (1:1:T+n);     %Corresponding calendar years   
y2(1) = 2010;
   for i = 1:1:T-1+n;
       y2(1+i) = 2010+((i)*10);
   end

%%Climate and Damages%%
%%%%%%%%%%%%%%%%%%%%%%%
phi = 0.0228;
phiL = 0.2;
phi0 = 0.393;
Sbar = 581;         %GtC
S1_2000 = 103;      %GtC
S2_2000 = 699;      %GtC
gamma = zeros(T,1);
for i = 1:1:T;
    gamma(i) = 0.000023793;
end
 
%%Energy Aggregation%%
%%%%%%%%%%%%%%%%%%%%%%
rho = -0.058;
kappa1 = 0.5429;
kappa2 = 0.1015;
kappa3 = 1-kappa1-kappa2;

%%Final Goods Production%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 1;                      %Normalize population
alpha = 0.3;                %Capital output share
v = 0.04;                   %Energy output share
Y2009 = 70000;              %Base year annual GDP in billions of USD
r2009 = 0.05;               %Base year annual net rate of return 
r2009d = ((1+r2009)^10)-1;  %Base yer decadal net rate of return

%%%Depreciation OPTION 1: delta = 100%
delta = 1;                              %Annual depreciation rate
Delta = (1-(1-delta)^10);               %Decadal depreciation rate
K0 = (alpha*Y2009*10)/(r2009d+Delta);   %Base year capital stock in billions of USD

% %%%Depreciation OPTION 2: delta = 65%, no recalibration:
% delta = 0.1;                            %Annual depreciation rate
% Delta = (1-(1-delta)^10);               %Decadal depreciation rate
% Delta1 = 1;                             %Decadal 100% depreciation rate
% K0 = (alpha*Y2009*10)/(r2009d+Delta1);  %Base year capital stock in billions of USD
 
% %Depreciation OPTION 3: delta = 65%, with recalibration:
% delta = 0.1;                            %Annual depreciation rate
% Delta = (1-(1-delta)^10);               %Decadal depreciation rate
% K0 = (alpha*Y2009*10)/(r2009d+Delta);   %Base year capital stock in billions of USD
 
 pi00 = 1;               %Base period share of labor devoted to final goods production
 E1_2008 = 3.43+1.68;    %GtC per annum
 E2_2008 = 3.75;         %GtC per annum
 E3_2008 = 1.95;         %GtC-eq per annum
 E0_2008 = ((kappa1*E1_2008^rho)+(kappa2*E2_2008^rho)+(kappa3*E3_2008^rho))^(1/rho);
 E0 = E0_2008*10;        %GtC per decade
 A0 = (Y2009*10)/((exp((-gamma(1))*((S1_2000+S2_2000)-Sbar)))*((K0^alpha)*((N*pi00)^(1-alpha-v))*(E0^v)));  %Initial TFP based on Decadal production function


%%%Productivity Growth Rates%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Energy Sector%%%
gZa_en = 0.02;                                         %Annual labor productivity growth rate (energy sectors)
gZ_en = ((1+gZa_en)^10)-1;                             %Decadal labor productivity growth rate (energy sectors)

%%%Final Goods Sector OPTION 1: Specify Labor Productivity Growth%%%
%           gZa_y = 0.02;                               %Annual labor productivity growth rate in final goods sector
%           gAa_y = (1+gZa_y)^(1-alpha-v);              %Corresponding TFP growth
%           gZd_y = ones(T+n,1)*(((1+gZa_y)^10)-1);     %Decadal labor productivity growth rate (all sectors)
%  
%%%Final Goods Sector OPTION 2: Specify TFP Growth%%%
%            gAa_y = 0.02;                            %Annual TFP growth rate (final output sector)
             gAa_y = 0;                               %Alt. Annual TFP growth ate (final output sector)
             gZa_y = ((1+gAa_y)^(1/(1-alpha-v)))-1;   %Corresponding annual labor productivity growth rate (final output sector)
             gAd_y = ((1+gAa_y)^10)-1;                %Decadal TFP growth rate (final output sector)
             gZd_y = ones(T+n,1)*(((1+gZa_y)^10)-1);  %Decadal labor productivity growth rate (final output sector)
 
%%%Final Goods Sector OPTION 3: DICE Model TFP Growth%%%
%     gANH0 = 0.160023196685654;                   %Initial decade (2005-2015) TFP growth rate
%     gammaNH0 = 0.00942588385340332;              %Rate of decline in productivity growth rate (percent per year)
%     gammaNH1 = 0.00192375245926376;              %Rate of decline of decline in productivity growth rate (percent per year)
%     gANH_y = zeros(T,1);
%     for i = 1:1:T;
%              gANH_y(i) = gANH0*exp(((-gammaNH0)*10*(i))*exp((-gammaNH1)*10*(i)));
%     end
%     for j = 1:1:n,
%         gANH_y(T+j) = gANH_y(T);
%     end
%     gANHa = zeros(T+n,1);
%     gANHa_y = ((1+gANH_y(T))^(1/10))-1;         %Annual long-run TFP growth rate
%     gZd_y = zeros(T+n,1);                      %Decadal labor productivity growth rate
%     for i = 1:1:T+n,
%         gZd_y(i) = ((1+gANH_y(i))^(1/(1-alpha-v)))-1;
%         gANHa(i) = ((1+gANH_y(i))^(1/10))-1;
%     end
%     z = 35;
%     plot(y2(1:z),(gANHa(1:z)*100))
%     xlabel('Year','FontSize',11)
%     ylabel('gTFP in Percent per Year','FontSize',11)
%     title('2010-DICE Model Annual TFP Growth','FontSize',13)
  

%%Final Good Sector TFP Levels%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
At = zeros(T,1);
At(1) = A0;                 
for i = 1:1:T-1;
   At(i+1) = At(i)*(1+gZd_y(i))^(1-alpha-v);     
end

%%Long-run Output Growth Rate on BGP%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gZBGP = gZd_y(T);             
% gZBGP = gZ_en;      %Alternative possible value for gTFP=1.5% to roughly account for declining oil output   

%%Utility%%
%%%%%%%%%%%
% sigma = 0.5;      
 sigma = 1;         %Logarithmic preferences
% sigma = 1.5;
% sigma = 2 ;

%%Beta OPTION 1: Specify exogenously%%%
beta = (.985)^10;  
% beta = (.999)^10;

%%Beta OPTION 2: Calibrate to maintain effective discount factor = .985%%%
% beta_hat = ((.985)^10)/((1+gZd_y(1))^(1-sigma))
% beta = beta_hat;
    
  
%%Coal production%%
%%%%%%%%%%%%%%%%%%%
A2t = zeros(T,1);
A2t(1) = 7693;          
for i = 1:1:T-1;
    A2t(i+1) = A2t(i)*(1+gZ_en);
end

%%Coal Emissions%%
%%%%%%%%%%%%%%%%%%
ypsilon = zeros(T,1);   %Coal carbon emissions coefficient
a_yps = 8;              %Logistic curve coefficient
b_yps = -0.05;          %Logistic curve coefficient
for i = 1:1:T+n;
     ypsilon(i) = 1/(1+exp((-1)*(a_yps+b_yps*(i-1)*10)));
end

%%Graph for Figure S.1%%
% plot(y,ypsilon,'-o');
% xlabel('Year','FontSize',11)
% ylabel('Coal Emissions Coefficient','FontSize',11)
% title('Coal Emissions Coefficient','FontSize',13)

%%Wind production%%
%%%%%%%%%%%%%%%%%%%
A3t = zeros(T,1);
A3t(1) = 1311;
for i = 1:1:T-1;
    A3t(i+1) = A3t(i)*(1+gZ_en);
end

%%Oil%%
%%%%%%%
R0 = 253.8;     %GtC


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 2: Solve for Optimal Choice Variables X        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vars = 2*T+2*(T-1);     %Number of variables

%%Define upper and lower bounds%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lb = zeros(vars,1);
ub = ones(vars,1);
for i = 1:1:T-1;
    ub(i) = 1;              %For savings rate
    lb(i) = 0.00001;        %For savings rate
    ub((T-1)+i) = R0;       %For oil stock remaining Rt
    lb((T-1)+i) = 0.00001;  %For oil stock remaining Rt
end
for i = 1:1:2*T;
    ub(2*(T-1)+i) = 1;        %For coal and wind labor shares 
    lb(2*(T-1)+i) = 0.00001;  %For coal and wind labor shares
end


%%Make Initial Guess x0%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%%% OPTION 1: USE PREVIOUS RESULTS %%

%%Note: The best x0 can be found by loading the saved output below
%%for the scenario that corresponds most closly to the one being run, and
%%then setting x0 = x. All file names indicate the parameters assumed,
%%e.g.: 'x_sig1_g0_b985_d1' is the optimal allocation for sigma=1 (sig1), 
%%annual TFP growth of 0% (g0), an annual discount factor of beta=0.985
%%(b985), and a decadal depreciation rate of Delta=100% (d1).

%%Sigma=1%%
%load('x_sig1_g0_b985_d1','x')
% load('x_sig1_g0_b99_d1','x')
% load('x_sig1_g0_b995_d1','x')
% load('x_sig1_g0_b999_d1','x')
% load('x_sig1_g0_b985_d65_NOrecalK0','x')
% load('x_sig1_g0_b985_d65_recalK0','x')
% load('x_sig1_g13_b985_d1','x')
% load('x_sig1_g13_b99_d1','x')
% load('x_sig1_g13_b995_d1','x') 
% load('x_sig1_g13_b999_d1','x') 
% load('x_sig1_g15_b985_d1','x')
% load('x_sig1_g15_b985_d65_recalK0','x')
% load('x_sig1_g15_b985_d65_NOrecalK0','x')
% load('x_sig1_gNH_b985_d1','x')
% load('x_sig1_gNH_b985_d65_NOrecalK0','x')
% load('x_sig1_g1_b985_d1','x')
% save('x_sig1_g2_b985_d1','x')
% 
% %%Sigma=1.5%%
% load('x_sig15_g0_b985_d1','x')
% load('x_sig15_g0_b99_d1','x')
% load('x_sig15_g0_b995_d1','x')
% load('x_sig15_g0_b999_d1','x')
% load('x_sig15_g0_b985_d65_NOrecalK0','x')
% load('x_sig15_g0_b985_d65_recalK0','x')
% load('x_sig15_g13_b985_d1','x')
% load('x_sig15_g13_b99_d1','x')
% load('x_sig15_g13_b995_d1','x')
% load('x_sig15_g13_b999_d1','x') 
% load('x_sig15_g15_b985_d1','x')
% load('x_sig15_g15_b985_d65_recalK0','x') %%
% load('x_sig15_g15_b985_d65_NOrecalK0','x')
% load('x_sig15_gNH_b985_d1','x')
% load('x_sig15_gNH_b985_d65_NOrecalK0','x')
% load('x_sig15_g13_b9948_d1','x')
% load('x_sig15_g1_b9925_d1','x')
% load('x_sig15_g15_b9962_d1','x')
% load('x_sig15_g2_b9999_d1','x')
% 
% %%Sigma=2%%
% load('x_sig2_g0_b985_d1','x')
% load('x_sig2_g0_b99_d1','x')
% load('x_sig2_g0_b995_d1','x')
% load('x_sig2_g0_b999_d1','x')
% load('x_sig2_g0_b985_d65_NOrecalK0','x')
% load('x_sig2_g0_b985_d65_recalK0','x')
% load('x_sig2_g13_b985_d1','x')
% load('x_sig2_g13_b99_d1','x') 
% load('x_sig2_g13_b995_d1','x')
% load('x_sig2_g13_b999_d1','x')
% load('x_sig2_g15_b985_d1','x')
% load('x_sig2_g15_b985_d65_recalK0','x')
% load('x_sig2_g15_b985_d65_NOrecalK0','x')
% load('x_sig2_gNH_b985_d1','x')
% load('x_sig2_gNH_b985_d65_NOrecalK0','x')
% load('x_sig2_g1_b1_d1','x')
% 
% %%Sigma=0.5%%
% load('x_sig05_g0_b985_d1','x')
% load('x_sig05_g13_b985_d1','x')
% load('x_sig05_g13_b9753_d1','x')
% load('x_sig05_g1_b9776_d1','x')
% load('x_sig05_g15_b974_d1','x')
% load('x_sig05_g2_b9703_d1','x')

%x0 = x;

%% OPTION 2: NEUTRAL STARTING POINT %%

x0 = zeros(vars,1);
for i = 1:1:T-1;
    x0(i) = 0.25;
    x0((T-1)+i) = R0-((R0/1.1)/T)*i;
    x0(2*(T-1)+i) = 0.002;
    x0(2*(T-1)+T+i) = 0.01;
end
x0(2*(T-1)+T) = 0.002;
x0(2*(T-1)+T+T) = 0.01;


%%Check Constraints and Objective Function Value at x0%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = GHKT_Objective(x0,A2t,A3t,At,Delta,K0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_en,gZd_y,gZBGP,gamma,kappa1,kappa2,kappa3,phi,phi0,phiL,rho,sigma,v,ypsilon)
[c, ceq] = GHKT_Constraints(x0,A2t,A3t,At,Delta,K0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_en,gZd_y,gZBGP,gamma,kappa1,kappa2,kappa3,phi,phi0,phiL,rho,sigma,v,ypsilon)


%%%%%%%%%%%
%%%SOLVE%%%
%%%%%%%%%%%
options = optimoptions(@fmincon,'Tolfun',1e-12,'TolCon',1e-12,'MaxFunEvals',500000,'MaxIter',6200,'Display','iter','MaxSQPIter',10000,'Algorithm','active-set');
[x, fval,exitflag] = fmincon(@(x)GHKT_Objective(x,A2t,A3t,At,Delta,K0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_en,gZd_y,gZBGP,gamma,kappa1,kappa2,kappa3,phi,phi0,phiL,rho,sigma,v,ypsilon), x0, [], [], [], [], lb, ub, @(x)GHKT_Constraints(x,A2t,A3t,At,Delta,K0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_en,gZd_y,gZBGP,gamma,kappa1,kappa2,kappa3,phi,phi0,phiL,rho,sigma,v,ypsilon), options);


%%Save Output%%
%%%%%%%%%%%%%%%
%File name structure:
%Version#_sigma_gTFP_beta_delta_notes

save('x_sig1_g0_b985_d1_LF','x')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 3: Compute Allocations and Carbon Taxes  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%
%%Energy%%
%%%%%%%%%%
oil = zeros(T,1);
    oil(1) = R0-x(T);
for i = 1:1:T-2;
    oil(1+i) = x(T+i-1)-x(T+i);
end
    ex_Oil = (x(T-1+T-2)-x(T-1+T-1))/(x(T-1+T-2));    %Fraction of oil left extracted in period T-1
    oil(T) = x(T-1+T-1)*ex_Oil;
ex_rates = zeros(T-1,1);
for i = 1:1:T-1;
    ex_rates(i) = oil(i)/x(T+i-1);
end
coal = zeros(T,1);
for i = 1:1:T;
    coal(i) = x(2*(T-1)+i)*A2t(i)*N;
end
wind = zeros(T,1);
for i = 1:1:T;
    wind(i) = x(2*(T-1)+T+i)*(A3t(i)*N);
end
energy = zeros(T,1);
for i = 1:1:T; 
    energy(i) = ((kappa1*oil(i)^rho)+(kappa2*coal(i)^rho)+(kappa3*wind(i)^rho))^(1/rho);
end

%%%%%%%%%%%%%
%%Emissions%%
%%%%%%%%%%%%%
emiss = zeros(T,1);
for i = 1:1:T;
    emiss(i) = oil(i)+ypsilon(i)*coal(i);
end

S1t = zeros(T,1);        %Non-depreciating carbon stock
S2t_Sbar = zeros(T,1);   %Depreciating carbon stock (S2t-Sbar)
St = zeros(T,1);         %Total carbon concentrations

S1t(1) = S1_2000+phiL*emiss(1);
S2t_Sbar(1) = (1-phi)*(S2_2000-Sbar)+phi0*(1-phiL)*emiss(1);
St(1) = Sbar+S1t(1)+S2t_Sbar(1);
for i = 1:1:T-1;
    S1t(1+i) = S1t(i)+phiL*emiss(1+i);
    S2t_Sbar(1+i) = (1-phi)*S2t_Sbar(i)+phi0*(1-phiL)*emiss(1+i);
    St(1+i) = Sbar+S1t(1+i)+S2t_Sbar(1+i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Output and Consumption through T%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For LF Removed: At(1)*(exp((-gamma(1))*

Yt = zeros(T,1);
Ct = zeros(T,1);
Kt1 = zeros(T,1);
Yt(1) = (K0^alpha)*(((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha-v))*(energy(1)^v);
Ct(1) = (1-x(1))*Yt(1);
Kt1(1) = x(1)*Yt(1)+(1-Delta)*K0;
for i = 1:1:T-2;
    Yt(1+i) = (Kt1(i)^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha-v))*(energy(1+i)^v);
    Kt1(1+i) = x(1+i)*Yt(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*Yt(1+i); 
end
Yt(T) = (Kt1(T-1)^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha-v))*(energy(T)^v);
theta = x(T-1);
Ct(T) = Yt(T)*(1-theta);
Kt1(T) = theta*Yt(T)+(1-Delta)*Kt1(T-1);

%Compare savings rate theta to predicted BGP savings rate:
%theta_BGP = alpha*(((((1+gZBGP)^sigma)/beta)-(1-Delta))^(-1))*(1+gZBGP-1+Delta)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Output and Consumption past T to T+n%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ktn = zeros(n+1,1);
Ytn = zeros(n,1);
Ktn(1) = Kt1(T); 
oiln = zeros(n,1);
En = zeros(n,1);

for i = 1:1:n;
    At(T+i) = At(T+i-1)*(1+gZd_y(T))^(1-alpha-v);   %Assumes productivity growth stays at period-T levels
    oiln(i) = ex_Oil*x(2*(T-1))*((1-ex_Oil)^i);     %Oil continues to be extracted at rate from period T-1
    En(i) = ((kappa1*oiln(i)^rho)+(kappa2*(coal(T)*(1+gZ_en)^i)^rho)+(kappa3*(wind(T)*(1+gZ_en)^i)^rho))^(1/rho);
    Ytn(i) = At(T+i)*(exp((-gamma(T))*(St(T)-Sbar)))*(Ktn(i)^alpha)*(((1-x(2*(T-1)+2*T)-x(2*(T-1)+T))*N)^(1-alpha-v))*(En(i)^v);
    Ct(T+i) = (1-theta)*Ytn(i);
    Ktn(i+1) = theta*Ytn(i)+(1-Delta)*Ktn(i);
    Yt(T+i) = Ytn(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%Optimal Carbon Taxes%%
%%%%%%%%%%%%%%%%%%%%%%%%

%%Goal: Plug allocations into optimal tax formula (paper equation (9))%%

%%Step 1: Compute vectors of marginal utilities and marginal emissions impacts {dSt+j/dEt}%%
MU = zeros(T+n,1);        %Marginal utility
MD = zeros(T+n,1);        %Marginal emissions impact on St {dSt+j/dEt}
for i = 1:1:T+n;
    MU(i) = Ct(i)^(-sigma);
    MD(i) = phiL+(1-phiL)*phi0*(1-phi)^(i-1);
end

%%Step 2: Compute Tax Path%%%
carbon_tax = zeros(T,1);    %Carbon tax level in $/mtC [since Yt is in $ billions and Et is in GtC]
lambda_hat = zeros(T,1);    %Carbon tax/GDP ratio

for i = 1:1:T+n;
    temp2 = zeros(T+n-i+1,1);
        for j = 1:1:T+n-i+1;
            temp2(j) = (beta^(j-1))*(MU(i+j-1)/MU(i))*(-gamma(T))*Yt(i+j-1)*MD(j);
        end
     carbon_tax(i) = sum(temp2)*(-1);
     lambda_hat(i) = carbon_tax(i)/Yt(i);
end

%%Diagnostic plot preview:
% z = 30;
% plot(y2(1:z),lambda_hat(1:z))
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP','FontSize',13)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 4: Save Allocations and Carbon Taxes  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Note: Only save for appropriate model scenario

oil_V13_sig1_g0_b985_d1 = oil;
save('oil_V13_sig1_g0_b985_d1','oil_V13_sig1_g0_b985_d1')
coal_V13_sig1_g0_b985_d1 = coal;
save('coal_V13_sig1_g0_b985_d1','coal_V13_sig1_g0_b985_d1')
wind_V13_sig1_g0_b985_d1 = wind;
save('wind_V13_sig1_g0_b985_d1','wind_V13_sig1_g0_b985_d1')
lambda_hat_V13_sig1_g0_b985_d1 = lambda_hat;
save('lambda_hat_V13_sig1_g0_b985_d1','lambda_hat_V13_sig1_g0_b985_d1')
carbon_tax_V13_sig1_g0_b985_d1 = carbon_tax;
save('carbon_tax_V13_sig1_g0_b985_d1','carbon_tax_V13_sig1_g0_b985_d1')
Yt_V13_sig1_g0_b985_d1 = Yt;
save('Yt_V13_sig1_g0_b985_d1','Yt_V13_sig1_g0_b985_d1')
Ct_V13_sig1_g0_b985_d1 = Ct;
save('Ct_V13_sig1_g0_b985_d1','Ct_V13_sig1_g0_b985_d1')
% 
% oil_V13_sig1_g0_b99_d1 = oil;
% save('oil_V13_sig1_g0_b99_d1','oil_V13_sig1_g0_b99_d1')
% coal_V13_sig1_g0_b99_d1 = coal;
% save('coal_V13_sig1_g0_b99_d1','coal_V13_sig1_g0_b99_d1')
% wind_V13_sig1_g0_b99_d1 = wind;
% save('wind_V13_sig1_g0_b99_d1','wind_V13_sig1_g0_b99_d1')
% lambda_hat_V13_sig1_g0_b99_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g0_b99_d1','lambda_hat_V13_sig1_g0_b99_d1')
% carbon_tax_V13_sig1_g0_b99_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g0_b99_d1','carbon_tax_V13_sig1_g0_b99_d1')
% Yt_V13_sig1_g0_b99_d1 = Yt;
% save('Yt_V13_sig1_g0_b99_d1','Yt_V13_sig1_g0_b99_d1')
% Ct_V13_sig1_g0_b99_d1 = Ct;
% save('Ct_V13_sig1_g0_b99_d1','Ct_V13_sig1_g0_b99_d1')
% 
% oil_V13_sig1_g0_b995_d1 = oil;
% save('oil_V13_sig1_g0_b995_d1','oil_V13_sig1_g0_b995_d1')
% coal_V13_sig1_g0_b995_d1 = coal;
% save('coal_V13_sig1_g0_b995_d1','coal_V13_sig1_g0_b995_d1')
% wind_V13_sig1_g0_b995_d1 = wind;
% save('wind_V13_sig1_g0_b995_d1','wind_V13_sig1_g0_b995_d1')
% lambda_hat_V13_sig1_g0_b995_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g0_b995_d1','lambda_hat_V13_sig1_g0_b995_d1')
% carbon_tax_V13_sig1_g0_b995_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g0_b995_d1','carbon_tax_V13_sig1_g0_b995_d1')
% Yt_V13_sig1_g0_b995_d1 = Yt;
% save('Yt_V13_sig1_g0_b995_d1','Yt_V13_sig1_g0_b995_d1')
% Ct_V13_sig1_g0_b995_d1 = Ct;
% save('Ct_V13_sig1_g0_b995_d1','Ct_V13_sig1_g0_b995_d1')
% 
% oil_V13_sig1_g0_b999_d1 = oil;
% save('oil_V13_sig1_g0_b999_d1','oil_V13_sig1_g0_b999_d1')
% coal_V13_sig1_g0_b999_d1 = coal;
% save('coal_V13_sig1_g0_b999_d1','coal_V13_sig1_g0_b999_d1')
% wind_V13_sig1_g0_b999_d1 = wind;
% save('wind_V13_sig1_g0_b999_d1','wind_V13_sig1_g0_b999_d1')
% lambda_hat_V13_sig1_g0_b999_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g0_b999_d1','lambda_hat_V13_sig1_g0_b999_d1')
% carbon_tax_V13_sig1_g0_b999_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g0_b999_d1','carbon_tax_V13_sig1_g0_b999_d1')
% Yt_V13_sig1_g0_b999_d1 = Yt;
% save('Yt_V13_sig1_g0_b999_d1','Yt_V13_sig1_g0_b999_d1')
% Ct_V13_sig1_g0_b999_d1 = Ct;
% save('Ct_V13_sig1_g0_b999_d1','Ct_V13_sig1_g0_b999_d1')
% 
% oil_V13_sig1_g0_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig1_g0_b985_d65_NOrecalK0','oil_V13_sig1_g0_b985_d65_NOrecalK0')
% coal_V13_sig1_g0_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig1_g0_b985_d65_NOrecalK0','coal_V13_sig1_g0_b985_d65_NOrecalK0')
% wind_V13_sig1_g0_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig1_g0_b985_d65_NOrecalK0','wind_V13_sig1_g0_b985_d65_NOrecalK0')
% lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0')
% carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0')
% Yt_V13_sig1_g0_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig1_g0_b985_d65_NOrecalK0','Yt_V13_sig1_g0_b985_d65_NOrecalK0')
% Ct_V13_sig1_g0_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig1_g0_b985_d65_NOrecalK0','Ct_V13_sig1_g0_b985_d65_NOrecalK0')
% 
% oil_V13_sig1_g0_b985_d65_recalK0 = oil;
% save('oil_V13_sig1_g0_b985_d65_recalK0','oil_V13_sig1_g0_b985_d65_recalK0')
% coal_V13_sig1_g0_b985_d65_recalK0 = coal;
% save('coal_V13_sig1_g0_b985_d65_recalK0','coal_V13_sig1_g0_b985_d65_recalK0')
% wind_V13_sig1_g0_b985_d65_recalK0 = wind;
% save('wind_V13_sig1_g0_b985_d65_recalK0','wind_V13_sig1_g0_b985_d65_recalK0')
% lambda_hat_V13_sig1_g0_b985_d65_recalK0 = lambda_hat;
% save('lambda_hat_V13_sig1_g0_b985_d65_recalK0','lambda_hat_V13_sig1_g0_b985_d65_recalK0')
% carbon_tax_V13_sig1_g0_b985_d65_recalK0 = carbon_tax;
% save('carbon_tax_V13_sig1_g0_b985_d65_recalK0','carbon_tax_V13_sig1_g0_b985_d65_recalK0')
% Yt_V13_sig1_g0_b985_d65_recalK0 = Yt;
% save('Yt_V13_sig1_g0_b985_d65_recalK0','Yt_V13_sig1_g0_b985_d65_recalK0')
% Ct_V13_sig1_g0_b985_d65_recalK0 = Ct;
% save('Ct_V13_sig1_g0_b985_d65_recalK0','Ct_V13_sig1_g0_b985_d65_recalK0')
% 
% oil_V13_sig1_g13_b985_d1 = oil;
% save('oil_V13_sig1_g13_b985_d1','oil_V13_sig1_g13_b985_d1')
% coal_V13_sig1_g13_b985_d1 = coal;
% save('coal_V13_sig1_g13_b985_d1','coal_V13_sig1_g13_b985_d1')
% wind_V13_sig1_g13_b985_d1 = wind;
% save('wind_V13_sig1_g13_b985_d1','wind_V13_sig1_g13_b985_d1')
% lambda_hat_V13_sig1_g13_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g13_b985_d1','lambda_hat_V13_sig1_g13_b985_d1')
% carbon_tax_V13_sig1_g13_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g13_b985_d1','carbon_tax_V13_sig1_g13_b985_d1')
% Yt_V13_sig1_g13_b985_d1 = Yt;
% save('Yt_V13_sig1_g13_b985_d1','Yt_V13_sig1_g13_b985_d1')
% Ct_V13_sig1_g13_b985_d1 = Ct;
% save('Ct_V13_sig1_g13_b985_d1','Ct_V13_sig1_g13_b985_d1')
% 
% oil_V13_sig1_g13_b99_d1 = oil;
% save('oil_V13_sig1_g13_b99_d1','oil_V13_sig1_g13_b99_d1')
% coal_V13_sig1_g13_b99_d1 = coal;
% save('coal_V13_sig1_g13_b99_d1','coal_V13_sig1_g13_b99_d1')
% wind_V13_sig1_g13_b99_d1 = wind;
% save('wind_V13_sig1_g13_b99_d1','wind_V13_sig1_g13_b99_d1')
% lambda_hat_V13_sig1_g13_b99_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g13_b99_d1','lambda_hat_V13_sig1_g13_b99_d1')
% carbon_tax_V13_sig1_g13_b99_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g13_b99_d1','carbon_tax_V13_sig1_g13_b99_d1')
% Yt_V13_sig1_g13_b99_d1 = Yt;
% save('Yt_V13_sig1_g13_b99_d1','Yt_V13_sig1_g13_b99_d1')
% Ct_V13_sig1_g13_b99_d1 = Ct;
% save('Ct_V13_sig1_g13_b99_d1','Ct_V13_sig1_g13_b99_d1')
% 
% oil_V13_sig1_g13_b995_d1 = oil;
% save('oil_V13_sig1_g13_b995_d1','oil_V13_sig1_g13_b995_d1')
% coal_V13_sig1_g13_b995_d1 = coal;
% save('coal_V13_sig1_g13_b995_d1','coal_V13_sig1_g13_b995_d1')
% wind_V13_sig1_g13_b995_d1 = wind;
% save('wind_V13_sig1_g13_b995_d1','wind_V13_sig1_g13_b995_d1')
% lambda_hat_V13_sig1_g13_b995_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g13_b995_d1','lambda_hat_V13_sig1_g13_b995_d1')
% carbon_tax_V13_sig1_g13_b995_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g13_b995_d1','carbon_tax_V13_sig1_g13_b995_d1')
% Yt_V13_sig1_g13_b995_d1 = Yt;
% save('Yt_V13_sig1_g13_b995_d1','Yt_V13_sig1_g13_b995_d1')
% Ct_V13_sig1_g13_b995_d1 = Ct;
% save('Ct_V13_sig1_g13_b995_d1','Ct_V13_sig1_g13_b995_d1')
% 
% oil_V13_sig1_g13_b999_d1 = oil;
% save('oil_V13_sig1_g13_b999_d1','oil_V13_sig1_g13_b999_d1')
% coal_V13_sig1_g13_b999_d1 = coal;
% save('coal_V13_sig1_g13_b999_d1','coal_V13_sig1_g13_b999_d1')
% wind_V13_sig1_g13_b999_d1 = wind;
% save('wind_V13_sig1_g13_b999_d1','wind_V13_sig1_g13_b999_d1')
% lambda_hat_V13_sig1_g13_b999_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g13_b999_d1','lambda_hat_V13_sig1_g13_b999_d1')
% carbon_tax_V13_sig1_g13_b999_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g13_b999_d1','carbon_tax_V13_sig1_g13_b999_d1')
% Yt_V13_sig1_g13_b999_d1 = Yt;
% save('Yt_V13_sig1_g13_b999_d1','Yt_V13_sig1_g13_b999_d1')
% Ct_V13_sig1_g13_b999_d1 = Ct;
% save('Ct_V13_sig1_g13_b999_d1','Ct_V13_sig1_g13_b999_d1')
% 
% oil_V13_sig1_g15_b985_d1 = oil;
% save('oil_V13_sig1_g15_b985_d1','oil_V13_sig1_g15_b985_d1')
% coal_V13_sig1_g15_b985_d1 = coal;
% save('coal_V13_sig1_g15_b985_d1','coal_V13_sig1_g15_b985_d1')
% wind_V13_sig1_g15_b985_d1 = wind;
% save('wind_V13_sig1_g15_b985_d1','wind_V13_sig1_g15_b985_d1')
% lambda_hat_V13_sig1_g15_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g15_b985_d1','lambda_hat_V13_sig1_g15_b985_d1')
% carbon_tax_V13_sig1_g15_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g15_b985_d1','carbon_tax_V13_sig1_g15_b985_d1')
% Yt_V13_sig1_g15_b985_d1 = Yt;
% save('Yt_V13_sig1_g15_b985_d1','Yt_V13_sig1_g15_b985_d1')
% Ct_V13_sig1_g15_b985_d1 = Ct;
% save('Ct_V13_sig1_g15_b985_d1','Ct_V13_sig1_g15_b985_d1')
% 
% oil_V13_sig1_g15_b985_d65_recalK0 = oil;
% save('oil_V13_sig1_g15_b985_d65_recalK0','oil_V13_sig1_g15_b985_d65_recalK0')
% coal_V13_sig1_g15_b985_d65_recalK0 = coal;
% save('coal_V13_sig1_g15_b985_d65_recalK0','coal_V13_sig1_g15_b985_d65_recalK0')
% wind_V13_sig1_g15_b985_d65_recalK0 = wind;
% save('wind_V13_sig1_g15_b985_d65_recalK0','wind_V13_sig1_g15_b985_d65_recalK0')
% lambda_hat_V13_sig1_g15_b985_d65_recalK0 = lambda_hat;
% save('lambda_hat_V13_sig1_g15_b985_d65_recalK0','lambda_hat_V13_sig1_g15_b985_d65_recalK0')
% carbon_tax_V13_sig1_g15_b985_d65_recalK0 = carbon_tax;
% save('carbon_tax_V13_sig1_g15_b985_d65_recalK0','carbon_tax_V13_sig1_g15_b985_d65_recalK0')
% Yt_V13_sig1_g15_b985_d65_recalK0 = Yt;
% save('Yt_V13_sig1_g15_b985_d65_recalK0','Yt_V13_sig1_g15_b985_d65_recalK0')
% Ct_V13_sig1_g15_b985_d65_recalK0 = Ct;
% save('Ct_V13_sig1_g15_b985_d65_recalK0','Ct_V13_sig1_g15_b985_d65_recalK0')
% 
% oil_V13_sig1_g15_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig1_g15_b985_d65_NOrecalK0','oil_V13_sig1_g15_b985_d65_NOrecalK0')
% coal_V13_sig1_g15_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig1_g15_b985_d65_NOrecalK0','coal_V13_sig1_g15_b985_d65_NOrecalK0')
% wind_V13_sig1_g15_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig1_g15_b985_d65_NOrecalK0','wind_V13_sig1_g15_b985_d65_NOrecalK0')
% lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0')
% carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0')
% Yt_V13_sig1_g15_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig1_g15_b985_d65_NOrecalK0','Yt_V13_sig1_g15_b985_d65_NOrecalK0')
% Ct_V13_sig1_g15_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig1_g15_b985_d65_NOrecalK0','Ct_V13_sig1_g15_b985_d65_NOrecalK0')
% 
% oil_V13_sig1_gNH_b985_d1 = oil;
% save('oil_V13_sig1_gNH_b985_d1','oil_V13_sig1_gNH_b985_d1')
% coal_V13_sig1_gNH_b985_d1 = coal;
% save('coal_V13_sig1_gNH_b985_d1','coal_V13_sig1_gNH_b985_d1')
% wind_V13_sig1_gNH_b985_d1 = wind;
% save('wind_V13_sig1_gNH_b985_d1','wind_V13_sig1_gNH_b985_d1')
% lambda_hat_V13_sig1_gNH_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_gNH_b985_d1','lambda_hat_V13_sig1_gNH_b985_d1')
% carbon_tax_V13_sig1_gNH_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_gNH_b985_d1','carbon_tax_V13_sig1_gNH_b985_d1')
% Yt_V13_sig1_gNH_b985_d1 = Yt;
% save('Yt_V13_sig1_gNH_b985_d1','Yt_V13_sig1_gNH_b985_d1')
% Ct_V13_sig1_gNH_b985_d1 = Ct;
% save('Ct_V13_sig1_gNH_b985_d1','Ct_V13_sig1_gNH_b985_d1')
% 
% oil_V13_sig1_gNH_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig1_gNH_b985_d65_NOrecalK0','oil_V13_sig1_gNH_b985_d65_NOrecalK0')
% coal_V13_sig1_gNH_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig1_gNH_b985_d65_NOrecalK0','coal_V13_sig1_gNH_b985_d65_NOrecalK0')
% wind_V13_sig1_gNH_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig1_gNH_b985_d65_NOrecalK0','wind_V13_sig1_gNH_b985_d65_NOrecalK0')
% lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0')
% carbon_tax_V13_sig1_gNH_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig1_gNH_b985_d65_NOrecalK0','carbon_tax_V13_sig1_gNH_b985_d65_NOrecalK0')
% Yt_V13_sig1_gNH_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig1_gNH_b985_d65_NOrecalK0','Yt_V13_sig1_gNH_b985_d65_NOrecalK0')
% Ct_V13_sig1_gNH_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig1_gNH_b985_d65_NOrecalK0','Ct_V13_sig1_gNH_b985_d65_NOrecalK0')
% 
% oil_V13_sig1_g1_b985_d1 = oil;
% save('oil_V13_sig1_g1_b985_d1','oil_V13_sig1_g1_b985_d1')
% coal_V13_sig1_g1_b985_d1 = coal;
% save('coal_V13_sig1_g1_b985_d1','coal_V13_sig1_g1_b985_d1')
% wind_V13_sig1_g1_b985_d1 = wind;
% save('wind_V13_sig1_g1_b985_d1','wind_V13_sig1_g1_b985_d1')
% lambda_hat_V13_sig1_g1_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig1_g1_b985_d1','lambda_hat_V13_sig1_g1_b985_d1')
% carbon_tax_V13_sig1_g1_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig1_g1_b985_d1','carbon_tax_V13_sig1_g1_b985_d1')
% Yt_V13_sig1_g1_b985_d1 = Yt;
% save('Yt_V13_sig1_g1_b985_d1','Yt_V13_sig1_g1_b985_d1')
% Ct_V13_sig1_g1_b985_d1 = Ct;
% save('Ct_V13_sig1_g1_b985_d1','Ct_V13_sig1_g1_b985_d1')
% 
% oil_V13_sig15_g0_b985_d1 = oil;
% save('oil_V13_sig15_g0_b985_d1','oil_V13_sig15_g0_b985_d1')
% coal_V13_sig15_g0_b985_d1 = coal;
% save('coal_V13_sig15_g0_b985_d1','coal_V13_sig15_g0_b985_d1')
% wind_V13_sig15_g0_b985_d1 = wind;
% save('wind_V13_sig15_g0_b985_d1','wind_V13_sig15_g0_b985_d1')
% lambda_hat_V13_sig15_g0_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g0_b985_d1','lambda_hat_V13_sig15_g0_b985_d1')
% carbon_tax_V13_sig15_g0_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g0_b985_d1','carbon_tax_V13_sig15_g0_b985_d1')
% Yt_V13_sig15_g0_b985_d1 = Yt;
% save('Yt_V13_sig15_g0_b985_d1','Yt_V13_sig15_g0_b985_d1')
% Ct_V13_sig15_g0_b985_d1 = Ct;
% save('Ct_V13_sig15_g0_b985_d1','Ct_V13_sig15_g0_b985_d1')
% 
% oil_V13_sig15_g0_b99_d1 = oil;
% save('oil_V13_sig15_g0_b99_d1','oil_V13_sig15_g0_b99_d1')
% coal_V13_sig15_g0_b99_d1 = coal;
% save('coal_V13_sig15_g0_b99_d1','coal_V13_sig15_g0_b99_d1')
% wind_V13_sig15_g0_b99_d1 = wind;
% save('wind_V13_sig15_g0_b99_d1','wind_V13_sig15_g0_b99_d1')
% lambda_hat_V13_sig15_g0_b99_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g0_b99_d1','lambda_hat_V13_sig15_g0_b99_d1')
% carbon_tax_V13_sig15_g0_b99_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g0_b99_d1','carbon_tax_V13_sig15_g0_b99_d1')
% Yt_V13_sig15_g0_b99_d1 = Yt;
% save('Yt_V13_sig15_g0_b99_d1','Yt_V13_sig15_g0_b99_d1')
% Ct_V13_sig15_g0_b99_d1 = Ct;
% save('Ct_V13_sig15_g0_b99_d1','Ct_V13_sig15_g0_b99_d1')
% 
% oil_V13_sig15_g0_b995_d1 = oil;
% save('oil_V13_sig15_g0_b995_d1','oil_V13_sig15_g0_b995_d1')
% coal_V13_sig15_g0_b995_d1 = coal;
% save('coal_V13_sig15_g0_b995_d1','coal_V13_sig15_g0_b995_d1')
% wind_V13_sig15_g0_b995_d1 = wind;
% save('wind_V13_sig15_g0_b995_d1','wind_V13_sig15_g0_b995_d1')
% lambda_hat_V13_sig15_g0_b995_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g0_b995_d1','lambda_hat_V13_sig15_g0_b995_d1')
% carbon_tax_V13_sig15_g0_b995_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g0_b995_d1','carbon_tax_V13_sig15_g0_b995_d1')
% Yt_V13_sig15_g0_b995_d1 = Yt;
% save('Yt_V13_sig15_g0_b995_d1','Yt_V13_sig15_g0_b995_d1')
% Ct_V13_sig15_g0_b995_d1 = Ct;
% save('Ct_V13_sig15_g0_b995_d1','Ct_V13_sig15_g0_b995_d1')
% 
% oil_V13_sig15_g0_b999_d1 = oil;
% save('oil_V13_sig15_g0_b999_d1','oil_V13_sig15_g0_b999_d1')
% coal_V13_sig15_g0_b999_d1 = coal;
% save('coal_V13_sig15_g0_b999_d1','coal_V13_sig15_g0_b999_d1')
% wind_V13_sig15_g0_b999_d1 = wind;
% save('wind_V13_sig15_g0_b999_d1','wind_V13_sig15_g0_b999_d1')
% lambda_hat_V13_sig15_g0_b999_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g0_b999_d1','lambda_hat_V13_sig15_g0_b999_d1')
% carbon_tax_V13_sig15_g0_b999_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g0_b999_d1','carbon_tax_V13_sig15_g0_b999_d1')
% Yt_V13_sig15_g0_b999_d1 = Yt;
% save('Yt_V13_sig15_g0_b999_d1','Yt_V13_sig15_g0_b999_d1')
% Ct_V13_sig15_g0_b999_d1 = Ct;
% save('Ct_V13_sig15_g0_b999_d1','Ct_V13_sig15_g0_b999_d1')
% 
% oil_V13_sig15_g0_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig15_g0_b985_d65_NOrecalK0','oil_V13_sig15_g0_b985_d65_NOrecalK0')
% coal_V13_sig15_g0_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig15_g0_b985_d65_NOrecalK0','coal_V13_sig15_g0_b985_d65_NOrecalK0')
% wind_V13_sig15_g0_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig15_g0_b985_d65_NOrecalK0','wind_V13_sig15_g0_b985_d65_NOrecalK0')
% lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0')
% carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0')
% Yt_V13_sig15_g0_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig15_g0_b985_d65_NOrecalK0','Yt_V13_sig15_g0_b985_d65_NOrecalK0')
% Ct_V13_sig15_g0_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig15_g0_b985_d65_NOrecalK0','Ct_V13_sig15_g0_b985_d65_NOrecalK0')
% 
% oil_V13_sig15_g0_b985_d65_recalK0 = oil;
% save('oil_V13_sig15_g0_b985_d65_recalK0','oil_V13_sig15_g0_b985_d65_recalK0')
% coal_V13_sig15_g0_b985_d65_recalK0 = coal;
% save('coal_V13_sig15_g0_b985_d65_recalK0','coal_V13_sig15_g0_b985_d65_recalK0')
% wind_V13_sig15_g0_b985_d65_recalK0 = wind;
% save('wind_V13_sig15_g0_b985_d65_recalK0','wind_V13_sig15_g0_b985_d65_recalK0')
% lambda_hat_V13_sig15_g0_b985_d65_recalK0 = lambda_hat;
% save('lambda_hat_V13_sig15_g0_b985_d65_recalK0','lambda_hat_V13_sig15_g0_b985_d65_recalK0')
% carbon_tax_V13_sig15_g0_b985_d65_recalK0 = carbon_tax;
% save('carbon_tax_V13_sig15_g0_b985_d65_recalK0','carbon_tax_V13_sig15_g0_b985_d65_recalK0')
% Yt_V13_sig15_g0_b985_d65_recalK0 = Yt;
% save('Yt_V13_sig15_g0_b985_d65_recalK0','Yt_V13_sig15_g0_b985_d65_recalK0')
% Ct_V13_sig15_g0_b985_d65_recalK0 = Ct;
% save('Ct_V13_sig15_g0_b985_d65_recalK0','Ct_V13_sig15_g0_b985_d65_recalK0')
% 
% oil_V13_sig15_g13_b985_d1 = oil;
% save('oil_V13_sig15_g13_b985_d1','oil_V13_sig15_g13_b985_d1')
% coal_V13_sig15_g13_b985_d1 = coal;
% save('coal_V13_sig15_g13_b985_d1','coal_V13_sig15_g13_b985_d1')
% wind_V13_sig15_g13_b985_d1 = wind;
% save('wind_V13_sig15_g13_b985_d1','wind_V13_sig15_g13_b985_d1')
% lambda_hat_V13_sig15_g13_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g13_b985_d1','lambda_hat_V13_sig15_g13_b985_d1')
% carbon_tax_V13_sig15_g13_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g13_b985_d1','carbon_tax_V13_sig15_g13_b985_d1')
% Yt_V13_sig15_g13_b985_d1 = Yt;
% save('Yt_V13_sig15_g13_b985_d1','Yt_V13_sig15_g13_b985_d1')
% Ct_V13_sig15_g13_b985_d1 = Ct;
% save('Ct_V13_sig15_g13_b985_d1','Ct_V13_sig15_g13_b985_d1')
% 
% oil_V13_sig15_g13_b99_d1 = oil;
% save('oil_V13_sig15_g13_b99_d1','oil_V13_sig15_g13_b99_d1')
% coal_V13_sig15_g13_b99_d1 = coal;
% save('coal_V13_sig15_g13_b99_d1','coal_V13_sig15_g13_b99_d1')
% wind_V13_sig15_g13_b99_d1 = wind;
% save('wind_V13_sig15_g13_b99_d1','wind_V13_sig15_g13_b99_d1')
% lambda_hat_V13_sig15_g13_b99_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g13_b99_d1','lambda_hat_V13_sig15_g13_b99_d1')
% carbon_tax_V13_sig15_g13_b99_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g13_b99_d1','carbon_tax_V13_sig15_g13_b99_d1')
% Yt_V13_sig15_g13_b99_d1 = Yt;
% save('Yt_V13_sig15_g13_b99_d1','Yt_V13_sig15_g13_b99_d1')
% Ct_V13_sig15_g13_b99_d1 = Ct;
% save('Ct_V13_sig15_g13_b99_d1','Ct_V13_sig15_g13_b99_d1')
% 
% oil_V13_sig15_g13_b995_d1 = oil;
% save('oil_V13_sig15_g13_b995_d1','oil_V13_sig15_g13_b995_d1')
% coal_V13_sig15_g13_b995_d1 = coal;
% save('coal_V13_sig15_g13_b995_d1','coal_V13_sig15_g13_b995_d1')
% wind_V13_sig15_g13_b995_d1 = wind;
% save('wind_V13_sig15_g13_b995_d1','wind_V13_sig15_g13_b995_d1')
% lambda_hat_V13_sig15_g13_b995_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g13_b995_d1','lambda_hat_V13_sig15_g13_b995_d1')
% carbon_tax_V13_sig15_g13_b995_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g13_b995_d1','carbon_tax_V13_sig15_g13_b995_d1')
% Yt_V13_sig15_g13_b995_d1 = Yt;
% save('Yt_V13_sig15_g13_b995_d1','Yt_V13_sig15_g13_b995_d1')
% Ct_V13_sig15_g13_b995_d1 = Ct;
% save('Ct_V13_sig15_g13_b995_d1','Ct_V13_sig15_g13_b995_d1')
% 
% oil_V13_sig15_g13_b999_d1 = oil;
% save('oil_V13_sig15_g13_b999_d1','oil_V13_sig15_g13_b999_d1')
% coal_V13_sig15_g13_b999_d1 = coal;
% save('coal_V13_sig15_g13_b999_d1','coal_V13_sig15_g13_b999_d1')
% wind_V13_sig15_g13_b999_d1 = wind;
% save('wind_V13_sig15_g13_b999_d1','wind_V13_sig15_g13_b999_d1')
% lambda_hat_V13_sig15_g13_b999_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g13_b999_d1','lambda_hat_V13_sig15_g13_b999_d1')
% carbon_tax_V13_sig15_g13_b999_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g13_b999_d1','carbon_tax_V13_sig15_g13_b999_d1')
% Yt_V13_sig15_g13_b999_d1 = Yt;
% save('Yt_V13_sig15_g13_b999_d1','Yt_V13_sig15_g13_b999_d1')
% Ct_V13_sig15_g13_b999_d1 = Ct;
% save('Ct_V13_sig15_g13_b999_d1','Ct_V13_sig15_g13_b999_d1')
% 
% oil_V13_sig15_g15_b985_d1 = oil;
% save('oil_V13_sig15_g15_b985_d1','oil_V13_sig15_g15_b985_d1')
% coal_V13_sig15_g15_b985_d1 = coal;
% save('coal_V13_sig15_g15_b985_d1','coal_V13_sig15_g15_b985_d1')
% wind_V13_sig15_g15_b985_d1 = wind;
% save('wind_V13_sig15_g15_b985_d1','wind_V13_sig15_g15_b985_d1')
% lambda_hat_V13_sig15_g15_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g15_b985_d1','lambda_hat_V13_sig15_g15_b985_d1')
% carbon_tax_V13_sig15_g15_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g15_b985_d1','carbon_tax_V13_sig15_g15_b985_d1')
% Yt_V13_sig15_g15_b985_d1 = Yt;
% save('Yt_V13_sig15_g15_b985_d1','Yt_V13_sig15_g15_b985_d1')
% Ct_V13_sig15_g15_b985_d1 = Ct;
% save('Ct_V13_sig15_g15_b985_d1','Ct_V13_sig15_g15_b985_d1')
% 
% oil_V13_sig15_g15_b985_d65_recalK0 = oil;
% save('oil_V13_sig15_g15_b985_d65_recalK0','oil_V13_sig15_g15_b985_d65_recalK0')
% coal_V13_sig15_g15_b985_d65_recalK0 = coal;
% save('coal_V13_sig15_g15_b985_d65_recalK0','coal_V13_sig15_g15_b985_d65_recalK0')
% wind_V13_sig15_g15_b985_d65_recalK0 = wind;
% save('wind_V13_sig15_g15_b985_d65_recalK0','wind_V13_sig15_g15_b985_d65_recalK0')
% lambda_hat_V13_sig15_g15_b985_d65_recalK0 = lambda_hat;
% save('lambda_hat_V13_sig15_g15_b985_d65_recalK0','lambda_hat_V13_sig15_g15_b985_d65_recalK0')
% carbon_tax_V13_sig15_g15_b985_d65_recalK0 = carbon_tax;
% save('carbon_tax_V13_sig15_g15_b985_d65_recalK0','carbon_tax_V13_sig15_g15_b985_d65_recalK0')
% Yt_V13_sig15_g15_b985_d65_recalK0 = Yt;
% save('Yt_V13_sig15_g15_b985_d65_recalK0','Yt_V13_sig15_g15_b985_d65_recalK0')
% Ct_V13_sig15_g15_b985_d65_recalK0 = Ct;
% save('Ct_V13_sig15_g15_b985_d65_recalK0','Ct_V13_sig15_g15_b985_d65_recalK0')
% 
% oil_V13_sig15_g15_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig15_g15_b985_d65_NOrecalK0','oil_V13_sig15_g15_b985_d65_NOrecalK0')
% coal_V13_sig15_g15_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig15_g15_b985_d65_NOrecalK0','coal_V13_sig15_g15_b985_d65_NOrecalK0')
% wind_V13_sig15_g15_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig15_g15_b985_d65_NOrecalK0','wind_V13_sig15_g15_b985_d65_NOrecalK0')
% lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0')
% carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0')
% Yt_V13_sig15_g15_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig15_g15_b985_d65_NOrecalK0','Yt_V13_sig15_g15_b985_d65_NOrecalK0')
% Ct_V13_sig15_g15_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig15_g15_b985_d65_NOrecalK0','Ct_V13_sig15_g15_b985_d65_NOrecalK0')
% 
% oil_V13_sig15_gNH_b985_d1 = oil;
% save('oil_V13_sig15_gNH_b985_d1','oil_V13_sig15_gNH_b985_d1')
% coal_V13_sig15_gNH_b985_d1 = coal;
% save('coal_V13_sig15_gNH_b985_d1','coal_V13_sig15_gNH_b985_d1')
% wind_V13_sig15_gNH_b985_d1 = wind;
% save('wind_V13_sig15_gNH_b985_d1','wind_V13_sig15_gNH_b985_d1')
% lambda_hat_V13_sig15_gNH_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_gNH_b985_d1','lambda_hat_V13_sig15_gNH_b985_d1')
% carbon_tax_V13_sig15_gNH_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_gNH_b985_d1','carbon_tax_V13_sig15_gNH_b985_d1')
% Yt_V13_sig15_gNH_b985_d1 = Yt;
% save('Yt_V13_sig15_gNH_b985_d1','Yt_V13_sig15_gNH_b985_d1')
% Ct_V13_sig15_gNH_b985_d1 = Ct;
% save('Ct_V13_sig15_gNH_b985_d1','Ct_V13_sig15_gNH_b985_d1')
% 
% oil_V13_sig15_gNH_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig15_gNH_b985_d65_NOrecalK0','oil_V13_sig15_gNH_b985_d65_NOrecalK0')
% coal_V13_sig15_gNH_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig15_gNH_b985_d65_NOrecalK0','coal_V13_sig15_gNH_b985_d65_NOrecalK0')
% wind_V13_sig15_gNH_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig15_gNH_b985_d65_NOrecalK0','wind_V13_sig15_gNH_b985_d65_NOrecalK0')
% lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0')
% carbon_tax_V13_sig15_gNH_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig15_gNH_b985_d65_NOrecalK0','carbon_tax_V13_sig15_gNH_b985_d65_NOrecalK0')
% Yt_V13_sig15_gNH_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig15_gNH_b985_d65_NOrecalK0','Yt_V13_sig15_gNH_b985_d65_NOrecalK0')
% Ct_V13_sig15_gNH_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig15_gNH_b985_d65_NOrecalK0','Ct_V13_sig15_gNH_b985_d65_NOrecalK0')
% 
% oil_V13_sig15_g13_b9948_d1 = oil;
% save('oil_V13_sig15_g13_b9948_d1','oil_V13_sig15_g13_b9948_d1')
% coal_V13_sig15_g13_b9948_d1 = coal;
% save('coal_V13_sig15_g13_b9948_d1','coal_V13_sig15_g13_b9948_d1')
% wind_V13_sig15_g13_b9948_d1 = wind;
% save('wind_V13_sig15_g13_b9948_d1','wind_V13_sig15_g13_b9948_d1')
% lambda_hat_V13_sig15_g13_b9948_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g13_b9948_d1','lambda_hat_V13_sig15_g13_b9948_d1')
% carbon_tax_V13_sig15_g13_b9948_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g13_b9948_d1','carbon_tax_V13_sig15_g13_b9948_d1')
% Yt_V13_sig15_g13_b9948_d1 = Yt;
% save('Yt_V13_sig15_g13_b9948_d1','Yt_V13_sig15_g13_b9948_d1')
% Ct_V13_sig15_g13_b9948_d1 = Ct;
% save('Ct_V13_sig15_g13_b9948_d1','Ct_V13_sig15_g13_b9948_d1')
% 
% oil_V13_sig15_g1_b9925_d1 = oil;
% save('oil_V13_sig15_g1_b9925_d1','oil_V13_sig15_g1_b9925_d1')
% coal_V13_sig15_g1_b9925_d1 = coal;
% save('coal_V13_sig15_g1_b9925_d1','coal_V13_sig15_g1_b9925_d1')
% wind_V13_sig15_g1_b9925_d1 = wind;
% save('wind_V13_sig15_g1_b9925_d1','wind_V13_sig15_g1_b9925_d1')
% lambda_hat_V13_sig15_g1_b9925_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g1_b9925_d1','lambda_hat_V13_sig15_g1_b9925_d1')
% carbon_tax_V13_sig15_g1_b9925_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g1_b9925_d1','carbon_tax_V13_sig15_g1_b9925_d1')
% Yt_V13_sig15_g1_b9925_d1 = Yt;
% save('Yt_V13_sig15_g1_b9925_d1','Yt_V13_sig15_g1_b9925_d1')
% Ct_V13_sig15_g1_b9925_d1 = Ct;
% save('Ct_V13_sig15_g1_b9925_d1','Ct_V13_sig15_g1_b9925_d1')
% 
% oil_V13_sig15_g15_b9962_d1 = oil;
% save('oil_V13_sig15_g15_b9962_d1','oil_V13_sig15_g15_b9962_d1')
% coal_V13_sig15_g15_b9962_d1 = coal;
% save('coal_V13_sig15_g15_b9962_d1','coal_V13_sig15_g15_b9962_d1')
% wind_V13_sig15_g15_b9962_d1 = wind;
% save('wind_V13_sig15_g15_b9962_d1','wind_V13_sig15_g15_b9962_d1')
% lambda_hat_V13_sig15_g15_b9962_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g15_b9962_d1','lambda_hat_V13_sig15_g15_b9962_d1')
% carbon_tax_V13_sig15_g15_b9962_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g15_b9962_d1','carbon_tax_V13_sig15_g15_b9962_d1')
% Yt_V13_sig15_g15_b9962_d1 = Yt;
% save('Yt_V13_sig15_g15_b9962_d1','Yt_V13_sig15_g15_b9962_d1')
% Ct_V13_sig15_g15_b9962_d1 = Ct;
% save('Ct_V13_sig15_g15_b9962_d1','Ct_V13_sig15_g15_b9962_d1')
% 
% oil_V13_sig15_g2_b9999_d1 = oil;
% save('oil_V13_sig15_g2_b9999_d1','oil_V13_sig15_g2_b9999_d1')
% coal_V13_sig15_g2_b9999_d1 = coal;
% save('coal_V13_sig15_g2_b9999_d1','coal_V13_sig15_g2_b9999_d1')
% wind_V13_sig15_g2_b9999_d1 = wind;
% save('wind_V13_sig15_g2_b9999_d1','wind_V13_sig15_g2_b9999_d1')
% lambda_hat_V13_sig15_g2_b9999_d1 = lambda_hat;
% save('lambda_hat_V13_sig15_g2_b9999_d1','lambda_hat_V13_sig15_g2_b9999_d1')
% carbon_tax_V13_sig15_g2_b9999_d1 = carbon_tax;
% save('carbon_tax_V13_sig15_g2_b9999_d1','carbon_tax_V13_sig15_g2_b9999_d1')
% Yt_V13_sig15_g2_b9999_d1 = Yt;
% save('Yt_V13_sig15_g2_b9999_d1','Yt_V13_sig15_g2_b9999_d1')
% Ct_V13_sig15_g2_b9999_d1 = Ct;
% save('Ct_V13_sig15_g2_b9999_d1','Ct_V13_sig15_g2_b9999_d1')
% 
% oil_V13_sig2_g0_b985_d1 = oil;
% save('oil_V13_sig2_g0_b985_d1','oil_V13_sig2_g0_b985_d1')
% coal_V13_sig2_g0_b985_d1 = coal;
% save('coal_V13_sig2_g0_b985_d1','coal_V13_sig2_g0_b985_d1')
% wind_V13_sig2_g0_b985_d1 = wind;
% save('wind_V13_sig2_g0_b985_d1','wind_V13_sig2_g0_b985_d1')
% lambda_hat_V13_sig2_g0_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g0_b985_d1','lambda_hat_V13_sig2_g0_b985_d1')
% carbon_tax_V13_sig2_g0_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g0_b985_d1','carbon_tax_V13_sig2_g0_b985_d1')
% Yt_V13_sig2_g0_b985_d1 = Yt;
% save('Yt_V13_sig2_g0_b985_d1','Yt_V13_sig2_g0_b985_d1')
% Ct_V13_sig2_g0_b985_d1 = Ct;
% save('Ct_V13_sig2_g0_b985_d1','Ct_V13_sig2_g0_b985_d1')
% 
% oil_V13_sig2_g0_b99_d1 = oil;
% save('oil_V13_sig2_g0_b99_d1','oil_V13_sig2_g0_b99_d1')
% coal_V13_sig2_g0_b99_d1 = coal;
% save('coal_V13_sig2_g0_b99_d1','coal_V13_sig2_g0_b99_d1')
% wind_V13_sig2_g0_b99_d1 = wind;
% save('wind_V13_sig2_g0_b99_d1','wind_V13_sig2_g0_b99_d1')
% lambda_hat_V13_sig2_g0_b99_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g0_b99_d1','lambda_hat_V13_sig2_g0_b99_d1')
% carbon_tax_V13_sig2_g0_b99_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g0_b99_d1','carbon_tax_V13_sig2_g0_b99_d1')
% Yt_V13_sig2_g0_b99_d1 = Yt;
% save('Yt_V13_sig2_g0_b99_d1','Yt_V13_sig2_g0_b99_d1')
% Ct_V13_sig2_g0_b99_d1 = Ct;
% save('Ct_V13_sig2_g0_b99_d1','Ct_V13_sig2_g0_b99_d1')
% 
% oil_V13_sig2_g0_b995_d1 = oil;
% save('oil_V13_sig2_g0_b995_d1','oil_V13_sig2_g0_b995_d1')
% coal_V13_sig2_g0_b995_d1 = coal;
% save('coal_V13_sig2_g0_b995_d1','coal_V13_sig2_g0_b995_d1')
% wind_V13_sig2_g0_b995_d1 = wind;
% save('wind_V13_sig2_g0_b995_d1','wind_V13_sig2_g0_b995_d1')
% lambda_hat_V13_sig2_g0_b995_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g0_b995_d1','lambda_hat_V13_sig2_g0_b995_d1')
% carbon_tax_V13_sig2_g0_b995_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g0_b995_d1','carbon_tax_V13_sig2_g0_b995_d1')
% Yt_V13_sig2_g0_b995_d1 = Yt;
% save('Yt_V13_sig2_g0_b995_d1','Yt_V13_sig2_g0_b995_d1')
% Ct_V13_sig2_g0_b995_d1 = Ct;
% save('Ct_V13_sig2_g0_b995_d1','Ct_V13_sig2_g0_b995_d1')
% 
% oil_V13_sig2_g0_b999_d1 = oil;
% save('oil_V13_sig2_g0_b999_d1','oil_V13_sig2_g0_b999_d1')
% coal_V13_sig2_g0_b999_d1 = coal;
% save('coal_V13_sig2_g0_b999_d1','coal_V13_sig2_g0_b999_d1')
% wind_V13_sig2_g0_b999_d1 = wind;
% save('wind_V13_sig2_g0_b999_d1','wind_V13_sig2_g0_b999_d1')
% lambda_hat_V13_sig2_g0_b999_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g0_b999_d1','lambda_hat_V13_sig2_g0_b999_d1')
% carbon_tax_V13_sig2_g0_b999_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g0_b999_d1','carbon_tax_V13_sig2_g0_b999_d1')
% Yt_V13_sig2_g0_b999_d1 = Yt;
% save('Yt_V13_sig2_g0_b999_d1','Yt_V13_sig2_g0_b999_d1')
% Ct_V13_sig2_g0_b999_d1 = Ct;
% save('Ct_V13_sig2_g0_b999_d1','Ct_V13_sig2_g0_b999_d1')
% 
% oil_V13_sig2_g0_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig2_g0_b985_d65_NOrecalK0','oil_V13_sig2_g0_b985_d65_NOrecalK0')
% coal_V13_sig2_g0_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig2_g0_b985_d65_NOrecalK0','coal_V13_sig2_g0_b985_d65_NOrecalK0')
% wind_V13_sig2_g0_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig2_g0_b985_d65_NOrecalK0','wind_V13_sig2_g0_b985_d65_NOrecalK0')
% lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0')
% carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0')
% Yt_V13_sig2_g0_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig2_g0_b985_d65_NOrecalK0','Yt_V13_sig2_g0_b985_d65_NOrecalK0')
% Ct_V13_sig2_g0_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig2_g0_b985_d65_NOrecalK0','Ct_V13_sig2_g0_b985_d65_NOrecalK0')
% 
% oil_V13_sig2_g0_b985_d65_recalK0 = oil;
% save('oil_V13_sig2_g0_b985_d65_recalK0','oil_V13_sig2_g0_b985_d65_recalK0')
% coal_V13_sig2_g0_b985_d65_recalK0 = coal;
% save('coal_V13_sig2_g0_b985_d65_recalK0','coal_V13_sig2_g0_b985_d65_recalK0')
% wind_V13_sig2_g0_b985_d65_recalK0 = wind;
% save('wind_V13_sig2_g0_b985_d65_recalK0','wind_V13_sig2_g0_b985_d65_recalK0')
% lambda_hat_V13_sig2_g0_b985_d65_recalK0 = lambda_hat;
% save('lambda_hat_V13_sig2_g0_b985_d65_recalK0','lambda_hat_V13_sig2_g0_b985_d65_recalK0')
% carbon_tax_V13_sig2_g0_b985_d65_recalK0 = carbon_tax;
% save('carbon_tax_V13_sig2_g0_b985_d65_recalK0','carbon_tax_V13_sig2_g0_b985_d65_recalK0')
% Yt_V13_sig2_g0_b985_d65_recalK0 = Yt;
% save('Yt_V13_sig2_g0_b985_d65_recalK0','Yt_V13_sig2_g0_b985_d65_recalK0')
% Ct_V13_sig2_g0_b985_d65_recalK0 = Ct;
% save('Ct_V13_sig2_g0_b985_d65_recalK0','Ct_V13_sig2_g0_b985_d65_recalK0')
% 
% oil_V13_sig2_g13_b985_d1 = oil;
% save('oil_V13_sig2_g13_b985_d1','oil_V13_sig2_g13_b985_d1')
% coal_V13_sig2_g13_b985_d1 = coal;
% save('coal_V13_sig2_g13_b985_d1','coal_V13_sig2_g13_b985_d1')
% wind_V13_sig2_g13_b985_d1 = wind;
% save('wind_V13_sig2_g13_b985_d1','wind_V13_sig2_g13_b985_d1')
% lambda_hat_V13_sig2_g13_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g13_b985_d1','lambda_hat_V13_sig2_g13_b985_d1')
% carbon_tax_V13_sig2_g13_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g13_b985_d1','carbon_tax_V13_sig2_g13_b985_d1')
% Yt_V13_sig2_g13_b985_d1 = Yt;
% save('Yt_V13_sig2_g13_b985_d1','Yt_V13_sig2_g13_b985_d1')
% Ct_V13_sig2_g13_b985_d1 = Ct;
% save('Ct_V13_sig2_g13_b985_d1','Ct_V13_sig2_g13_b985_d1')
% 
% oil_V13_sig2_g13_b99_d1 = oil;
% save('oil_V13_sig2_g13_b99_d1','oil_V13_sig2_g13_b99_d1')
% coal_V13_sig2_g13_b99_d1 = coal;
% save('coal_V13_sig2_g13_b99_d1','coal_V13_sig2_g13_b99_d1')
% wind_V13_sig2_g13_b99_d1 = wind;
% save('wind_V13_sig2_g13_b99_d1','wind_V13_sig2_g13_b99_d1')
% lambda_hat_V13_sig2_g13_b99_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g13_b99_d1','lambda_hat_V13_sig2_g13_b99_d1')
% carbon_tax_V13_sig2_g13_b99_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g13_b99_d1','carbon_tax_V13_sig2_g13_b99_d1')
% Yt_V13_sig2_g13_b99_d1 = Yt;
% save('Yt_V13_sig2_g13_b99_d1','Yt_V13_sig2_g13_b99_d1')
% Ct_V13_sig2_g13_b99_d1 = Ct;
% save('Ct_V13_sig2_g13_b99_d1','Ct_V13_sig2_g13_b99_d1')
% 
% oil_V13_sig2_g13_b995_d1 = oil;
% save('oil_V13_sig2_g13_b995_d1','oil_V13_sig2_g13_b995_d1')
% coal_V13_sig2_g13_b995_d1 = coal;
% save('coal_V13_sig2_g13_b995_d1','coal_V13_sig2_g13_b995_d1')
% wind_V13_sig2_g13_b995_d1 = wind;
% save('wind_V13_sig2_g13_b995_d1','wind_V13_sig2_g13_b995_d1')
% lambda_hat_V13_sig2_g13_b995_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g13_b995_d1','lambda_hat_V13_sig2_g13_b995_d1')
% carbon_tax_V13_sig2_g13_b995_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g13_b995_d1','carbon_tax_V13_sig2_g13_b995_d1')
% Yt_V13_sig2_g13_b995_d1 = Yt;
% save('Yt_V13_sig2_g13_b995_d1','Yt_V13_sig2_g13_b995_d1')
% Ct_V13_sig2_g13_b995_d1 = Ct;
% save('Ct_V13_sig2_g13_b995_d1','Ct_V13_sig2_g13_b995_d1')
% 
% oil_V13_sig2_g13_b999_d1 = oil;
% save('oil_V13_sig2_g13_b999_d1','oil_V13_sig2_g13_b999_d1')
% coal_V13_sig2_g13_b999_d1 = coal;
% save('coal_V13_sig2_g13_b999_d1','coal_V13_sig2_g13_b999_d1')
% wind_V13_sig2_g13_b999_d1 = wind;
% save('wind_V13_sig2_g13_b999_d1','wind_V13_sig2_g13_b999_d1')
% lambda_hat_V13_sig2_g13_b999_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g13_b999_d1','lambda_hat_V13_sig2_g13_b999_d1')
% carbon_tax_V13_sig2_g13_b999_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g13_b999_d1','carbon_tax_V13_sig2_g13_b999_d1')
% Yt_V13_sig2_g13_b999_d1 = Yt;
% save('Yt_V13_sig2_g13_b999_d1','Yt_V13_sig2_g13_b999_d1')
% Ct_V13_sig2_g13_b999_d1 = Ct;
% save('Ct_V13_sig2_g13_b999_d1','Ct_V13_sig2_g13_b999_d1')
% 
% oil_V13_sig2_g15_b985_d1 = oil;
% save('oil_V13_sig2_g15_b985_d1','oil_V13_sig2_g15_b985_d1')
% coal_V13_sig2_g15_b985_d1 = coal;
% save('coal_V13_sig2_g15_b985_d1','coal_V13_sig2_g15_b985_d1')
% wind_V13_sig2_g15_b985_d1 = wind;
% save('wind_V13_sig2_g15_b985_d1','wind_V13_sig2_g15_b985_d1')
% lambda_hat_V13_sig2_g15_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g15_b985_d1','lambda_hat_V13_sig2_g15_b985_d1')
% carbon_tax_V13_sig2_g15_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g15_b985_d1','carbon_tax_V13_sig2_g15_b985_d1')
% Yt_V13_sig2_g15_b985_d1 = Yt;
% save('Yt_V13_sig2_g15_b985_d1','Yt_V13_sig2_g15_b985_d1')
% Ct_V13_sig2_g15_b985_d1 = Ct;
% save('Ct_V13_sig2_g15_b985_d1','Ct_V13_sig2_g15_b985_d1')
% 
% oil_V13_sig2_g15_b985_d65_recalK0 = oil;
% save('oil_V13_sig2_g15_b985_d65_recalK0','oil_V13_sig2_g15_b985_d65_recalK0')
% coal_V13_sig2_g15_b985_d65_recalK0 = coal;
% save('coal_V13_sig2_g15_b985_d65_recalK0','coal_V13_sig2_g15_b985_d65_recalK0')
% wind_V13_sig2_g15_b985_d65_recalK0 = wind;
% save('wind_V13_sig2_g15_b985_d65_recalK0','wind_V13_sig2_g15_b985_d65_recalK0')
% lambda_hat_V13_sig2_g15_b985_d65_recalK0 = lambda_hat;
% save('lambda_hat_V13_sig2_g15_b985_d65_recalK0','lambda_hat_V13_sig2_g15_b985_d65_recalK0')
% carbon_tax_V13_sig2_g15_b985_d65_recalK0 = carbon_tax;
% save('carbon_tax_V13_sig2_g15_b985_d65_recalK0','carbon_tax_V13_sig2_g15_b985_d65_recalK0')
% Yt_V13_sig2_g15_b985_d65_recalK0 = Yt;
% save('Yt_V13_sig2_g15_b985_d65_recalK0','Yt_V13_sig2_g15_b985_d65_recalK0')
% Ct_V13_sig2_g15_b985_d65_recalK0 = Ct;
% save('Ct_V13_sig2_g15_b985_d65_recalK0','Ct_V13_sig2_g15_b985_d65_recalK0')
% 
% oil_V13_sig2_g15_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig2_g15_b985_d65_NOrecalK0','oil_V13_sig2_g15_b985_d65_NOrecalK0')
% coal_V13_sig2_g15_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig2_g15_b985_d65_NOrecalK0','coal_V13_sig2_g15_b985_d65_NOrecalK0')
% wind_V13_sig2_g15_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig2_g15_b985_d65_NOrecalK0','wind_V13_sig2_g15_b985_d65_NOrecalK0')
% lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0')
% carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0')
% Yt_V13_sig2_g15_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig2_g15_b985_d65_NOrecalK0','Yt_V13_sig2_g15_b985_d65_NOrecalK0')
% Ct_V13_sig2_g15_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig2_g15_b985_d65_NOrecalK0','Ct_V13_sig2_g15_b985_d65_NOrecalK0')
% 
% oil_V13_sig2_gNH_b985_d1 = oil;
% save('oil_V13_sig2_gNH_b985_d1','oil_V13_sig2_gNH_b985_d1')
% coal_V13_sig2_gNH_b985_d1 = coal;
% save('coal_V13_sig2_gNH_b985_d1','coal_V13_sig2_gNH_b985_d1')
% wind_V13_sig2_gNH_b985_d1 = wind;
% save('wind_V13_sig2_gNH_b985_d1','wind_V13_sig2_gNH_b985_d1')
% lambda_hat_V13_sig2_gNH_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_gNH_b985_d1','lambda_hat_V13_sig2_gNH_b985_d1')
% carbon_tax_V13_sig2_gNH_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_gNH_b985_d1','carbon_tax_V13_sig2_gNH_b985_d1')
% Yt_V13_sig2_gNH_b985_d1 = Yt;
% save('Yt_V13_sig2_gNH_b985_d1','Yt_V13_sig2_gNH_b985_d1')
% Ct_V13_sig2_gNH_b985_d1 = Ct;
% save('Ct_V13_sig2_gNH_b985_d1','Ct_V13_sig2_gNH_b985_d1')
% 
% oil_V13_sig2_gNH_b985_d65_NOrecalK0 = oil;
% save('oil_V13_sig2_gNH_b985_d65_NOrecalK0','oil_V13_sig2_gNH_b985_d65_NOrecalK0')
% coal_V13_sig2_gNH_b985_d65_NOrecalK0 = coal;
% save('coal_V13_sig2_gNH_b985_d65_NOrecalK0','coal_V13_sig2_gNH_b985_d65_NOrecalK0')
% wind_V13_sig2_gNH_b985_d65_NOrecalK0 = wind;
% save('wind_V13_sig2_gNH_b985_d65_NOrecalK0','wind_V13_sig2_gNH_b985_d65_NOrecalK0')
% lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0 = lambda_hat;
% save('lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0')
% carbon_tax_V13_sig2_gNH_b985_d65_NOrecalK0 = carbon_tax;
% save('carbon_tax_V13_sig2_gNH_b985_d65_NOrecalK0','carbon_tax_V13_sig2_gNH_b985_d65_NOrecalK0')
% Yt_V13_sig2_gNH_b985_d65_NOrecalK0 = Yt;
% save('Yt_V13_sig2_gNH_b985_d65_NOrecalK0','Yt_V13_sig2_gNH_b985_d65_NOrecalK0')
% Ct_V13_sig2_gNH_b985_d65_NOrecalK0 = Ct;
% save('Ct_V13_sig2_gNH_b985_d65_NOrecalK0','Ct_V13_sig2_gNH_b985_d65_NOrecalK0')
% 
% oil_V13_sig2_g1_b1_d1 = oil;
% save('oil_V13_sig2_g1_b1_d1','oil_V13_sig2_g1_b1_d1')
% coal_V13_sig2_g1_b1_d1 = coal;
% save('coal_V13_sig2_g1_b1_d1','coal_V13_sig2_g1_b1_d1')
% wind_V13_sig2_g1_b1_d1 = wind;
% save('wind_V13_sig2_g1_b1_d1','wind_V13_sig2_g1_b1_d1')
% lambda_hat_V13_sig2_g1_b1_d1 = lambda_hat;
% save('lambda_hat_V13_sig2_g1_b1_d1','lambda_hat_V13_sig2_g1_b1_d1')
% carbon_tax_V13_sig2_g1_b1_d1 = carbon_tax;
% save('carbon_tax_V13_sig2_g1_b1_d1','carbon_tax_V13_sig2_g1_b1_d1')
% Yt_V13_sig2_g1_b1_d1 = Yt;
% save('Yt_V13_sig2_g1_b1_d1','Yt_V13_sig2_g1_b1_d1')
% Ct_V13_sig2_g1_b1_d1 = Ct;
% save('Ct_V13_sig2_g1_b1_d1','Ct_V13_sig2_g1_b1_d1')
% 
% oil_V13_sig05_g1_b9776_d1 = oil;
% save('oil_V13_sig05_g1_b9776_d1','oil_V13_sig05_g1_b9776_d1')
% coal_V13_sig05_g1_b9776_d1 = coal;
% save('coal_V13_sig05_g1_b9776_d1','coal_V13_sig05_g1_b9776_d1')
% wind_V13_sig05_g1_b9776_d1 = wind;
% save('wind_V13_sig05_g1_b9776_d1','wind_V13_sig05_g1_b9776_d1')
% lambda_hat_V13_sig05_g1_b9776_d1 = lambda_hat;
% save('lambda_hat_V13_sig05_g1_b9776_d1','lambda_hat_V13_sig05_g1_b9776_d1')
% carbon_tax_V13_sig05_g1_b9776_d1 = carbon_tax;
% save('carbon_tax_V13_sig05_g1_b9776_d1','carbon_tax_V13_sig05_g1_b9776_d1')
% Yt_V13_sig05_g1_b9776_d1 = Yt;
% save('Yt_V13_sig05_g1_b9776_d1','Yt_V13_sig05_g1_b9776_d1')
% Ct_V13_sig05_g1_b9776_d1 = Ct;
% save('Ct_V13_sig05_g1_b9776_d1','Ct_V13_sig05_g1_b9776_d1')
% 
% oil_V13_sig05_g0_b985_d1 = oil;
% save('oil_V13_sig05_g0_b985_d1','oil_V13_sig05_g0_b985_d1')
% coal_V13_sig05_g0_b985_d1 = coal;
% save('coal_V13_sig05_g0_b985_d1','coal_V13_sig05_g0_b985_d1')
% wind_V13_sig05_g0_b985_d1 = wind;
% save('wind_V13_sig05_g0_b985_d1','wind_V13_sig05_g0_b985_d1')
% lambda_hat_V13_sig05_g0_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig05_g0_b985_d1','lambda_hat_V13_sig05_g0_b985_d1')
% carbon_tax_V13_sig05_g0_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig05_g0_b985_d1','carbon_tax_V13_sig05_g0_b985_d1')
% Yt_V13_sig05_g0_b985_d1 = Yt;
% save('Yt_V13_sig05_g0_b985_d1','Yt_V13_sig05_g0_b985_d1')
% Ct_V13_sig05_g0_b985_d1 = Ct;
% save('Ct_V13_sig05_g0_b985_d1','Ct_V13_sig05_g0_b985_d1')
% 
% oil_V13_sig05_g13_b985_d1 = oil;
% save('oil_V13_sig05_g13_b985_d1','oil_V13_sig05_g13_b985_d1')
% coal_V13_sig05_g13_b985_d1 = coal;
% save('coal_V13_sig05_g13_b985_d1','coal_V13_sig05_g13_b985_d1')
% wind_V13_sig05_g13_b985_d1 = wind;
% save('wind_V13_sig05_g13_b985_d1','wind_V13_sig05_g13_b985_d1')
% lambda_hat_V13_sig05_g13_b985_d1 = lambda_hat;
% save('lambda_hat_V13_sig05_g13_b985_d1','lambda_hat_V13_sig05_g13_b985_d1')
% carbon_tax_V13_sig05_g13_b985_d1 = carbon_tax;
% save('carbon_tax_V13_sig05_g13_b985_d1','carbon_tax_V13_sig05_g13_b985_d1')
% Yt_V13_sig05_g13_b985_d1 = Yt;
% save('Yt_V13_sig05_g13_b985_d1','Yt_V13_sig05_g13_b985_d1')
% Ct_V13_sig05_g13_b985_d1 = Ct;
% save('Ct_V13_sig05_g13_b985_d1','Ct_V13_sig05_g13_b985_d1')
% 
% oil_V13_sig05_g13_b9753_d1 = oil;
% save('oil_V13_sig05_g13_b9753_d1','oil_V13_sig05_g13_b9753_d1')
% coal_V13_sig05_g13_b9753_d1 = coal;
% save('coal_V13_sig05_g13_b9753_d1','coal_V13_sig05_g13_b9753_d1')
% wind_V13_sig05_g13_b9753_d1 = wind;
% save('wind_V13_sig05_g13_b9753_d1','wind_V13_sig05_g13_b9753_d1')
% lambda_hat_V13_sig05_g13_b9753_d1 = lambda_hat;
% save('lambda_hat_V13_sig05_g13_b9753_d1','lambda_hat_V13_sig05_g13_b9753_d1')
% carbon_tax_V13_sig05_g13_b9753_d1 = carbon_tax;
% save('carbon_tax_V13_sig05_g13_b9753_d1','carbon_tax_V13_sig05_g13_b9753_d1')
% Yt_V13_sig05_g13_b9753_d1 = Yt;
% save('Yt_V13_sig05_g13_b9753_d1','Yt_V13_sig05_g13_b9753_d1')
% Ct_V13_sig05_g13_b9753_d1 = Ct;
% save('Ct_V13_sig05_g13_b9753_d1','Ct_V13_sig05_g13_b9753_d1')
% 
% oil_V13_sig05_g15_b974_d1 = oil;
% save('oil_V13_sig05_g15_b974_d1','oil_V13_sig05_g15_b974_d1')
% coal_V13_sig05_g15_b974_d1 = coal;
% save('coal_V13_sig05_g15_b974_d1','coal_V13_sig05_g15_b974_d1')
% wind_V13_sig05_g15_b974_d1 = wind;
% save('wind_V13_sig05_g15_b974_d1','wind_V13_sig05_g15_b974_d1')
% lambda_hat_V13_sig05_g15_b974_d1 = lambda_hat;
% save('lambda_hat_V13_sig05_g15_b974_d1','lambda_hat_V13_sig05_g15_b974_d1')
% carbon_tax_V13_sig05_g15_b974_d1 = carbon_tax;
% save('carbon_tax_V13_sig05_g15_b974_d1','carbon_tax_V13_sig05_g15_b974_d1')
% Yt_V13_sig05_g15_b974_d1 = Yt;
% save('Yt_V13_sig05_g15_b974_d1','Yt_V13_sig05_g15_b974_d1')
% Ct_V13_sig05_g15_b974_d1 = Ct;
% save('Ct_V13_sig05_g15_b974_d1','Ct_V13_sig05_g15_b974_d1')
% 
% oil_V13_sig05_g2_b9703_d1 = oil;
% save('oil_V13_sig05_g2_b9703_d1','oil_V13_sig05_g2_b9703_d1')
% coal_V13_sig05_g2_b9703_d1 = coal;
% save('coal_V13_sig05_g2_b9703_d1','coal_V13_sig05_g2_b9703_d1')
% wind_V13_sig05_g2_b9703_d1 = wind;
% save('wind_V13_sig05_g2_b9703_d1','wind_V13_sig05_g2_b9703_d1')
% lambda_hat_V13_sig05_g2_b9703_d1 = lambda_hat;
% save('lambda_hat_V13_sig05_g2_b9703_d1','lambda_hat_V13_sig05_g2_b9703_d1')
% carbon_tax_V13_sig05_g2_b9703_d1 = carbon_tax;
% save('carbon_tax_V13_sig05_g2_b9703_d1','carbon_tax_V13_sig05_g2_b9703_d1')
% Yt_V13_sig05_g2_b9703_d1 = Yt;
% save('Yt_V13_sig05_g2_b9703_d1','Yt_V13_sig05_g2_b9703_d1')
% Ct_V13_sig05_g2_b9703_d1 = Ct;
% save('Ct_V13_sig05_g2_b9703_d1','Ct_V13_sig05_g2_b9703_d1')
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 5: Graph Optimal Carbon Taxes     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Graph Carbon Tax-GDP Ratio%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('lambda_hat_V13_sig1_g0_b985_d1','lambda_hat_V13_sig1_g0_b985_d1')
% load('lambda_hat_V13_sig1_g0_b99_d1','lambda_hat_V13_sig1_g0_b99_d1')
% load('lambda_hat_V13_sig1_g0_b995_d1','lambda_hat_V13_sig1_g0_b995_d1')
% load('lambda_hat_V13_sig1_g0_b999_d1','lambda_hat_V13_sig1_g0_b999_d1')
% load('lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig1_g0_b985_d65_recalK0','lambda_hat_V13_sig1_g0_b985_d65_recalK0')
% load('lambda_hat_V13_sig1_g13_b985_d1','lambda_hat_V13_sig1_g13_b985_d1')
% load('lambda_hat_V13_sig1_g13_b99_d1','lambda_hat_V13_sig1_g13_b99_d1')
% load('lambda_hat_V13_sig1_g13_b995_d1','lambda_hat_V13_sig1_g13_b995_d1') 
% load('lambda_hat_V13_sig1_g13_b999_d1','lambda_hat_V13_sig1_g13_b999_d1') 
% load('lambda_hat_V13_sig1_g15_b985_d1','lambda_hat_V13_sig1_g15_b985_d1')
% load('lambda_hat_V13_sig1_g15_b985_d65_recalK0','lambda_hat_V13_sig1_g15_b985_d65_recalK0')
% load('lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig1_gNH_b985_d1','lambda_hat_V13_sig1_gNH_b985_d1')
% load('lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig15_g0_b985_d1','lambda_hat_V13_sig15_g0_b985_d1')
% load('lambda_hat_V13_sig15_g0_b99_d1','lambda_hat_V13_sig15_g0_b99_d1')
% load('lambda_hat_V13_sig15_g0_b995_d1','lambda_hat_V13_sig15_g0_b995_d1')
% load('lambda_hat_V13_sig15_g0_b999_d1','lambda_hat_V13_sig15_g0_b999_d1')
% load('lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig15_g0_b985_d65_recalK0','lambda_hat_V13_sig15_g0_b985_d65_recalK0')
% load('lambda_hat_V13_sig15_g13_b985_d1','lambda_hat_V13_sig15_g13_b985_d1')
% load('lambda_hat_V13_sig15_g13_b99_d1','lambda_hat_V13_sig15_g13_b99_d1')
% load('lambda_hat_V13_sig15_g13_b995_d1','lambda_hat_V13_sig15_g13_b995_d1')
% load('lambda_hat_V13_sig15_g13_b999_d1','lambda_hat_V13_sig15_g13_b999_d1') 
% load('lambda_hat_V13_sig15_g15_b985_d1','lambda_hat_V13_sig15_g15_b985_d1')
% load('lambda_hat_V13_sig15_g15_b985_d65_recalK0','lambda_hat_V13_sig15_g15_b985_d65_recalK0')
% load('lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig15_gNH_b985_d1','lambda_hat_V13_sig15_gNH_b985_d1')
% load('lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig2_g0_b985_d1','lambda_hat_V13_sig2_g0_b985_d1')
% load('lambda_hat_V13_sig2_g0_b99_d1','lambda_hat_V13_sig2_g0_b99_d1')
% load('lambda_hat_V13_sig2_g0_b995_d1','lambda_hat_V13_sig2_g0_b995_d1')
% load('lambda_hat_V13_sig2_g0_b999_d1','lambda_hat_V13_sig2_g0_b999_d1')
% load('lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig2_g0_b985_d65_recalK0','lambda_hat_V13_sig2_g0_b985_d65_recalK0')
% load('lambda_hat_V13_sig2_g13_b985_d1','lambda_hat_V13_sig2_g13_b985_d1')
% load('lambda_hat_V13_sig2_g13_b99_d1','lambda_hat_V13_sig2_g13_b99_d1') 
% load('lambda_hat_V13_sig2_g13_b995_d1','lambda_hat_V13_sig2_g13_b995_d1')
% load('lambda_hat_V13_sig2_g13_b999_d1','lambda_hat_V13_sig2_g13_b999_d1')
% load('lambda_hat_V13_sig2_g15_b985_d1','lambda_hat_V13_sig2_g15_b985_d1')
% load('lambda_hat_V13_sig2_g15_b985_d65_recalK0','lambda_hat_V13_sig2_g15_b985_d65_recalK0')
% load('lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig2_gNH_b985_d1','lambda_hat_V13_sig2_gNH_b985_d1')
% load('lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0')
% load('lambda_hat_V13_sig05_g0_b985_d1','lambda_hat_V13_sig05_g0_b985_d1')
% load('lambda_hat_V13_sig05_g13_b985_d1','lambda_hat_V13_sig05_g13_b985_d1')
% 
% %%Graph All%%
% %%%%%%%%%%%%%
% z = 30;
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig1_g13_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig1_g15_b985_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0(1:z),'-^',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_recalK0(1:z),'->',y2(1:z),lambda_hat_V13_sig1_g0_b99_d1(1:z),'-<',y2(1:z),lambda_hat_V13_sig1_g0_b995_d1(1:z),'-p',y2(1:z),lambda_hat_V13_sig1_g0_b999_d1(1:z),'-h',y2(1:z),lambda_hat_V13_sig1_g13_b99_d1(1:z),'-.x',y2(1:z),lambda_hat_V13_sig1_g13_b995_d1(1:z),'-.o',y2(1:z),lambda_hat_V13_sig1_g13_b999_d1(1:z),'-.+',y2(1:z),lambda_hat_V13_sig15_g0_b985_d1(1:z),':*',y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),':o',y2(1:z),lambda_hat_V13_sig15_g15_b985_d1(1:z),':+',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d1(1:z),':x',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0(1:z),':s',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0(1:z),':d',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0(1:z),':^',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_recalK0(1:z),':v',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_recalK0(1:z),':>',y2(1:z),lambda_hat_V13_sig15_g0_b99_d1(1:z),':<',y2(1:z),lambda_hat_V13_sig15_g0_b995_d1(1:z),':p',y2(1:z),lambda_hat_V13_sig15_g0_b999_d1(1:z),':h',y2(1:z),lambda_hat_V13_sig15_g13_b99_d1(1:z),'-.d',y2(1:z),lambda_hat_V13_sig15_g13_b995_d1(1:z),'-.v',y2(1:z),lambda_hat_V13_sig15_g13_b999_d1(1:z),'-.s',y2(1:z),lambda_hat_V13_sig2_g0_b985_d1(1:z),'--*',y2(1:z),lambda_hat_V13_sig2_g13_b985_d1(1:z),'--o',y2(1:z),lambda_hat_V13_sig2_g15_b985_d1(1:z),'--+',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d1(1:z),'--x',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'--s',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'--d',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0(1:z),'--^',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_recalK0(1:z),'--v',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_recalK0(1:z),'-->',y2(1:z),lambda_hat_V13_sig2_g0_b99_d1(1:z),'--<',y2(1:z),lambda_hat_V13_sig2_g0_b995_d1(1:z),'--p',y2(1:z),lambda_hat_V13_sig2_g0_b999_d1(1:z),'--h',y2(1:z),lambda_hat_V13_sig2_g13_b99_d1(1:z),'-.<',y2(1:z),lambda_hat_V13_sig2_g13_b995_d1(1:z),'-.p',y2(1:z),lambda_hat_V13_sig2_g13_b999_d1(1:z),'-.h',y2(1:z),lambda_hat_V13_sig05_g0_b985_d1(1:z),':',y2(1:z),lambda_hat_V13_sig05_g13_b985_d1(1:z),'-.')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.990','\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.995','\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.999','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.990','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.995','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.999','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.990','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.995','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.999','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.990','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.995','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.999','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.990','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.995','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.999','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.990','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.995','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.999','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio','FontSize',13)
% 
% %%Graph for Beta=.985 Only%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z = 30;
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig1_g13_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig1_g15_b985_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0(1:z),'-^',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_recalK0(1:z),'->',y2(1:z),lambda_hat_V13_sig15_g0_b985_d1(1:z),':*',y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),':o',y2(1:z),lambda_hat_V13_sig15_g15_b985_d1(1:z),':+',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d1(1:z),':x',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0(1:z),':s',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0(1:z),':d',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0(1:z),':^',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_recalK0(1:z),':v',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_recalK0(1:z),':>',y2(1:z),lambda_hat_V13_sig2_g0_b985_d1(1:z),'--*',y2(1:z),lambda_hat_V13_sig2_g13_b985_d1(1:z),'--o',y2(1:z),lambda_hat_V13_sig2_g15_b985_d1(1:z),'--+',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d1(1:z),'--x',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'--s',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'--d',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0(1:z),'--^',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_recalK0(1:z),'--v',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_recalK0(1:z),'-->',y2(1:z),lambda_hat_V13_sig05_g0_b985_d1(1:z),':',y2(1:z),lambda_hat_V13_sig05_g13_b985_d1(1:z),'-.')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=0.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=0.5, gTFP=1.3%, \delta=100%, \beta=.985','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio with \sigma=0.5','FontSize',13)
% 
% %%Graph for Beta=.985 without Sigma=0.5%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z = 30;
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig1_g13_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig1_g15_b985_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0(1:z),'-^',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_recalK0(1:z),'->',y2(1:z),lambda_hat_V13_sig15_g0_b985_d1(1:z),':*',y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),':o',y2(1:z),lambda_hat_V13_sig15_g15_b985_d1(1:z),':+',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d1(1:z),':x',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0(1:z),':s',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0(1:z),':d',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0(1:z),':^',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_recalK0(1:z),':v',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_recalK0(1:z),':>',y2(1:z),lambda_hat_V13_sig2_g0_b985_d1(1:z),'--*',y2(1:z),lambda_hat_V13_sig2_g13_b985_d1(1:z),'--o',y2(1:z),lambda_hat_V13_sig2_g15_b985_d1(1:z),'--+',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d1(1:z),'--x',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'--s',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'--d',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0(1:z),'--^',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_recalK0(1:z),'--v',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_recalK0(1:z),'-->',y2(1:z),lambda_hat_V13_sig05_g0_b985_d1(1:z),':',y2(1:z),lambda_hat_V13_sig05_g13_b985_d1(1:z),'-.')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio','FontSize',13)
% 
% %%Sigma=1 and Beta=.985 Only%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig1_g13_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig1_g15_b985_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0(1:z),'-^',y2(1:z),lambda_hat_V13_sig1_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),lambda_hat_V13_sig1_g15_b985_d65_recalK0(1:z),'->')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio, \sigma=1','FontSize',13)
% 
% %%Sigma=1.5 and Beta=.985 Only%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot(y2(1:z),lambda_hat_V13_sig15_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig15_g15_b985_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0(1:z),'-^',y2(1:z),lambda_hat_V13_sig15_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),lambda_hat_V13_sig15_g15_b985_d65_recalK0(1:z),'->')
% legend('\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio, \sigma=1.5','FontSize',13)
% 
% %%Sigma=2 and Beta=.985 Only%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot(y2(1:z),lambda_hat_V13_sig2_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig2_g13_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig2_g15_b985_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0(1:z),'-^',y2(1:z),lambda_hat_V13_sig2_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),lambda_hat_V13_sig2_g15_b985_d65_recalK0(1:z),'->')
% legend('\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=DICE, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio, \sigma=2','FontSize',13)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Graph Lambda-Hat as a Function of Beta for 2010%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beta_axis = [.985, .990, .995, .999];
% 
% %%Set up Lines%%
% sig1_g0_d1 = zeros(betas,1);
% sig15_g0_d1 = zeros(betas,1);
% sig2_g0_d1 = zeros(betas,1);
% sig1_g13_d1 = zeros(betas,1);
% sig15_g13_d1 = zeros(betas,1);
% sig2_g13_d1 = zeros(betas,1);
% 
% %%Fill in Values%%
% sig1_g0_d1(1) = lambda_hat_V13_sig1_g0_b985_d1(1);
% sig1_g0_d1(2) = lambda_hat_V13_sig1_g0_b99_d1(1);
% sig1_g0_d1(3) = lambda_hat_V13_sig1_g0_b995_d1(1);
% sig1_g0_d1(4) = lambda_hat_V13_sig1_g0_b999_d1(1);
% sig15_g0_d1(1) = lambda_hat_V13_sig15_g0_b985_d1(1);
% sig15_g0_d1(2) = lambda_hat_V13_sig15_g0_b99_d1(1);
% sig15_g0_d1(3) = lambda_hat_V13_sig15_g0_b995_d1(1);
% sig15_g0_d1(4) = lambda_hat_V13_sig15_g0_b999_d1(1);
% sig2_g0_d1(1) = lambda_hat_V13_sig2_g0_b985_d1(1);
% sig2_g0_d1(2) = lambda_hat_V13_sig2_g0_b99_d1(1);
% sig2_g0_d1(3) = lambda_hat_V13_sig2_g0_b995_d1(1);
% sig2_g0_d1(4) = lambda_hat_V13_sig2_g0_b999_d1(1);
% sig1_g13_d1(1) = lambda_hat_V13_sig1_g13_b985_d1(1);
% sig1_g13_d1(2) = lambda_hat_V13_sig1_g13_b99_d1(1);
% sig1_g13_d1(3) = lambda_hat_V13_sig1_g13_b995_d1(1);
% sig1_g13_d1(4) = lambda_hat_V13_sig1_g13_b999_d1(1);
% sig15_g13_d1(1) = lambda_hat_V13_sig15_g13_b985_d1(1);
% sig15_g13_d1(2) = lambda_hat_V13_sig15_g13_b99_d1(1);
% sig15_g13_d1(3) = lambda_hat_V13_sig15_g13_b995_d1(1);
% sig15_g13_d1(4) = lambda_hat_V13_sig15_g13_b999_d1(1);
% sig2_g13_d1(1) = lambda_hat_V13_sig2_g13_b985_d1(1);
% sig2_g13_d1(2) = lambda_hat_V13_sig2_g13_b99_d1(1);
% sig2_g13_d1(3) = lambda_hat_V13_sig2_g13_b995_d1(1);
% sig2_g13_d1(4) = lambda_hat_V13_sig2_g13_b999_d1(1);
% 
% %%Graph%%
% plot(beta_axis,sig1_g0_d1,'-*',beta_axis,sig15_g0_d1,'-o',beta_axis,sig2_g0_d1,'-x',beta_axis,sig1_g13_d1,'-s',beta_axis,sig15_g13_d1,'-h',beta_axis,sig2_g13_d1,'-+')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%','\sigma=1.5, gTFP=0.0%, \delta=100%','\sigma=2.0, gTFP=0.0%, \delta=100%','\sigma=1.0, gTFP=1.3%, \delta=100%','\sigma=1.5, gTFP=1.3%, \delta=100%','\sigma=2.0, gTFP=1.3%, \delta=100%','Location','Best')
% xlabel('Beta','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('2010 Carbon Tax/GDP Ratio and Discount Factor','FontSize',12)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Graph Lambda-Hat as a Function of Sigma for 2010%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigma_axis = [1, 1.5, 2];
% 
% %%Set up Lines%%
% g0_d1_b985 = zeros(sigmas,1);
% g0_d1_b985_d10 = zeros(sigmas,1);
% g0_d1_b985_d10_recal = zeros(sigmas,1);
% g13_d1_b985 = zeros(sigmas,1);
% g15_d1_b985 = zeros(sigmas,1);
% g15_d1_b985_d10 = zeros(sigmas,1);
% g15_d1_b985_d10_recal = zeros(sigmas,1);
% gNH_d1_b985 = zeros(sigmas,1);
% gNH_d1_b985_d10 = zeros(sigmas,1);
% 
% %%Fill in values:%%
% g0_d1_b985(1) = lambda_hat_V13_sig1_g0_b985_d1(1);
% g0_d1_b985(2) = lambda_hat_V13_sig15_g0_b985_d1(1);
% g0_d1_b985(3) = lambda_hat_V13_sig2_g0_b985_d1(1);
% g0_d1_b985_d10(1) = lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0(1);
% g0_d1_b985_d10(2) = lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0(1);
% g0_d1_b985_d10(3) = lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0(1);
% g0_d1_b985_d10_recal(1) = lambda_hat_V13_sig1_g0_b985_d65_recalK0(1);
% g0_d1_b985_d10_recal(2) = lambda_hat_V13_sig15_g0_b985_d65_recalK0(1);
% g0_d1_b985_d10_recal(3) = lambda_hat_V13_sig2_g0_b985_d65_recalK0(1);
% g13_d1_b985(1) = lambda_hat_V13_sig1_g13_b985_d1(1);
% g13_d1_b985(2) = lambda_hat_V13_sig15_g13_b985_d1(1);
% g13_d1_b985(3) = lambda_hat_V13_sig2_g13_b985_d1(1);
% gNH_d1_b985(1) = lambda_hat_V13_sig1_gNH_b985_d1(1);
% gNH_d1_b985(2) = lambda_hat_V13_sig15_gNH_b985_d1(1);
% gNH_d1_b985(3) = lambda_hat_V13_sig2_gNH_b985_d1(1);
% gNH_d1_b985_d10(1) = lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0(1);
% gNH_d1_b985_d10(2) = lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0(1);
% gNH_d1_b985_d10(3) = lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0(1);
% g15_d1_b985(1) = lambda_hat_V13_sig1_g15_b985_d1(1);
% g15_d1_b985(2) = lambda_hat_V13_sig15_g15_b985_d1(1);
% g15_d1_b985(3) = lambda_hat_V13_sig2_g15_b985_d1(1);
% g15_d1_b985_d10(1) = lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0(1);
% g15_d1_b985_d10(2) = lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0(1);
% g15_d1_b985_d10(3) = lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0(1);
% g15_d1_b985_d10_recal(1) = lambda_hat_V13_sig1_g15_b985_d65_recalK0(1);
% g15_d1_b985_d10_recal(2) = lambda_hat_V13_sig15_g15_b985_d65_recalK0(1);
% g15_d1_b985_d10_recal(3) = lambda_hat_V13_sig2_g15_b985_d65_recalK0(1);
% 
% %%Graph%%
% plot(sigma_axis,g0_d1_b985,'-o',sigma_axis,g0_d1_b985_d10,'-*',sigma_axis,g0_d1_b985_d10_recal,'-v',sigma_axis,g13_d1_b985,'-x',sigma_axis,g15_d1_b985,'-s',sigma_axis,g15_d1_b985_d10,'-+',sigma_axis,g15_d1_b985_d10_recal,'-p',sigma_axis,gNH_d1_b985,'-h',sigma_axis,gNH_d1_b985_d10,'-<')
% legend('gTFP=0.0%, \beta=.985, \delta=100%','gTFP=0.0%, \beta=.985, \delta=65%','gTFP=0.0%, \beta=.985, \delta=65%, recal.','gTFP=1.3%, \beta=.985, \delta=100%','gTFP=1.5%, \beta=.985, \delta=100%','gTFP=1.5%, \beta=.985, \delta=65%','gTFP=1.5%, \beta=.985, \delta=65%, recal.','gTFP=DICE, \beta=.985, \delta=100%','gTFP=DICE, \beta=.985, \delta=65%','Location','EastOutside')
% xlabel('Sigma','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('2010 Carbon Tax/GDP Ratio and Sigma','FontSize',12)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%Graphs Carbon Tax Levels%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('carbon_tax_V13_sig1_g0_b985_d1','carbon_tax_V13_sig1_g0_b985_d1')
% load('carbon_tax_V13_sig1_g0_b99_d1','carbon_tax_V13_sig1_g0_b99_d1')
% load('carbon_tax_V13_sig1_g0_b995_d1','carbon_tax_V13_sig1_g0_b995_d1')
% load('carbon_tax_V13_sig1_g0_b999_d1','carbon_tax_V13_sig1_g0_b999_d1')
% load('carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0')
% load('carbon_tax_V13_sig1_g0_b985_d65_recalK0','carbon_tax_V13_sig1_g0_b985_d65_recalK0')
% load('carbon_tax_V13_sig1_g13_b985_d1','carbon_tax_V13_sig1_g13_b985_d1')
% load('carbon_tax_V13_sig1_g13_b99_d1','carbon_tax_V13_sig1_g13_b99_d1')
% load('carbon_tax_V13_sig1_g13_b995_d1','carbon_tax_V13_sig1_g13_b995_d1') 
% load('carbon_tax_V13_sig1_g13_b999_d1','carbon_tax_V13_sig1_g13_b999_d1') 
% load('carbon_tax_V13_sig1_g15_b985_d1','carbon_tax_V13_sig1_g15_b985_d1')
% load('carbon_tax_V13_sig1_g15_b985_d65_recalK0','carbon_tax_V13_sig1_g15_b985_d65_recalK0')
% load('carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0')
% load('carbon_tax_V13_sig1_gNH_b985_d1','carbon_tax_V13_sig1_gNH_b985_d1')
% load('carbon_tax_V13_sig15_g0_b985_d1','carbon_tax_V13_sig15_g0_b985_d1')
% load('carbon_tax_V13_sig15_g0_b99_d1','carbon_tax_V13_sig15_g0_b99_d1')
% load('carbon_tax_V13_sig15_g0_b995_d1','carbon_tax_V13_sig15_g0_b995_d1')
% load('carbon_tax_V13_sig15_g0_b999_d1','carbon_tax_V13_sig15_g0_b999_d1')
% load('carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0')
% load('carbon_tax_V13_sig15_g0_b985_d65_recalK0','carbon_tax_V13_sig15_g0_b985_d65_recalK0')
% load('carbon_tax_V13_sig15_g13_b985_d1','carbon_tax_V13_sig15_g13_b985_d1')
% load('carbon_tax_V13_sig15_g13_b99_d1','carbon_tax_V13_sig15_g13_b99_d1')
% load('carbon_tax_V13_sig15_g13_b995_d1','carbon_tax_V13_sig15_g13_b995_d1')
% load('carbon_tax_V13_sig15_g13_b999_d1','carbon_tax_V13_sig15_g13_b999_d1') 
% load('carbon_tax_V13_sig15_g15_b985_d1','carbon_tax_V13_sig15_g15_b985_d1')
% load('carbon_tax_V13_sig15_g15_b985_d65_recalK0','carbon_tax_V13_sig15_g15_b985_d65_recalK0')
% load('carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0')
% load('carbon_tax_V13_sig15_gNH_b985_d1','carbon_tax_V13_sig15_gNH_b985_d1')
% load('carbon_tax_V13_sig2_g0_b985_d1','carbon_tax_V13_sig2_g0_b985_d1')
% load('carbon_tax_V13_sig2_g0_b99_d1','carbon_tax_V13_sig2_g0_b99_d1')
% load('carbon_tax_V13_sig2_g0_b995_d1','carbon_tax_V13_sig2_g0_b995_d1')
% load('carbon_tax_V13_sig2_g0_b999_d1','carbon_tax_V13_sig2_g0_b999_d1')
% load('carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0')
% load('carbon_tax_V13_sig2_g0_b985_d65_recalK0','carbon_tax_V13_sig2_g0_b985_d65_recalK0')
% load('carbon_tax_V13_sig2_g13_b985_d1','carbon_tax_V13_sig2_g13_b985_d1')
% load('carbon_tax_V13_sig2_g13_b99_d1','carbon_tax_V13_sig2_g13_b99_d1') 
% load('carbon_tax_V13_sig2_g13_b995_d1','carbon_tax_V13_sig2_g13_b995_d1')
% load('carbon_tax_V13_sig2_g13_b999_d1','carbon_tax_V13_sig2_g13_b999_d1')
% load('carbon_tax_V13_sig2_g15_b985_d1','carbon_tax_V13_sig2_g15_b985_d1')
% load('carbon_tax_V13_sig2_g15_b985_d65_recalK0','carbon_tax_V13_sig2_g15_b985_d65_recalK0')
% load('carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0')
% load('carbon_tax_V13_sig2_gNH_b985_d1','carbon_tax_V13_sig2_gNH_b985_d1')
% load('carbon_tax_V13_sig05_g0_b985_d1','carbon_tax_V13_sig05_g0_b985_d1')
% load('carbon_tax_V13_sig05_g13_b985_d1','carbon_tax_V13_sig05_g13_b985_d1')
% 
% %%Graph All for Beta=.985%%
% z = 10;
% plot(y2(1:z),carbon_tax_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),carbon_tax_V13_sig1_g13_b985_d1(1:z),'-o',y2(1:z),carbon_tax_V13_sig1_g15_b985_d1(1:z),'-+',y2(1:z),carbon_tax_V13_sig1_gNH_b985_d1(1:z),'-x',y2(1:z),carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),carbon_tax_V13_sig1_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),carbon_tax_V13_sig1_g15_b985_d65_recalK0(1:z),'->',y2(1:z),carbon_tax_V13_sig15_g0_b985_d1(1:z),':*',y2(1:z),carbon_tax_V13_sig15_g13_b985_d1(1:z),':o',y2(1:z),carbon_tax_V13_sig15_g15_b985_d1(1:z),':+',y2(1:z),carbon_tax_V13_sig15_gNH_b985_d1(1:z),':x',y2(1:z),carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0(1:z),':s',y2(1:z),carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0(1:z),':d',y2(1:z),carbon_tax_V13_sig15_g0_b985_d65_recalK0(1:z),':v',y2(1:z),carbon_tax_V13_sig15_g15_b985_d65_recalK0(1:z),':>',y2(1:z),carbon_tax_V13_sig2_g0_b985_d1(1:z),'--*',y2(1:z),carbon_tax_V13_sig2_g13_b985_d1(1:z),'--o',y2(1:z),carbon_tax_V13_sig2_g15_b985_d1(1:z),'--+',y2(1:z),carbon_tax_V13_sig2_gNH_b985_d1(1:z),'--x',y2(1:z),carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'--s',y2(1:z),carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'--d',y2(1:z),carbon_tax_V13_sig2_g0_b985_d65_recalK0(1:z),'--v',y2(1:z),carbon_tax_V13_sig2_g15_b985_d65_recalK0(1:z),'-->',y2(1:z),carbon_tax_V13_sig05_g0_b985_d1(1:z),':',y2(1:z),carbon_tax_V13_sig05_g13_b985_d1(1:z),'--')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=0.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=0.5, gTFP=1.3%, \delta=100%, \beta=.985','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax ($/mtC)','FontSize',11)
% title('Optimal Carbon Tax Levels','FontSize',13)
% 
% %%All for Beta=.985 without Sigma=0.5%%
% plot(y2(1:z),carbon_tax_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),carbon_tax_V13_sig1_g13_b985_d1(1:z),'-o',y2(1:z),carbon_tax_V13_sig1_g15_b985_d1(1:z),'-+',y2(1:z),carbon_tax_V13_sig1_gNH_b985_d1(1:z),'-x',y2(1:z),carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),carbon_tax_V13_sig1_g0_b985_d65_recalK0(1:z),'-v',y2(1:z),carbon_tax_V13_sig1_g15_b985_d65_recalK0(1:z),'->',y2(1:z),carbon_tax_V13_sig15_g0_b985_d1(1:z),':*',y2(1:z),carbon_tax_V13_sig15_g13_b985_d1(1:z),':o',y2(1:z),carbon_tax_V13_sig15_g15_b985_d1(1:z),':+',y2(1:z),carbon_tax_V13_sig15_gNH_b985_d1(1:z),':x',y2(1:z),carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0(1:z),':s',y2(1:z),carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0(1:z),':d',y2(1:z),carbon_tax_V13_sig15_g0_b985_d65_recalK0(1:z),':v',y2(1:z),carbon_tax_V13_sig15_g15_b985_d65_recalK0(1:z),':>',y2(1:z),carbon_tax_V13_sig2_g0_b985_d1(1:z),'--*',y2(1:z),carbon_tax_V13_sig2_g13_b985_d1(1:z),'--o',y2(1:z),carbon_tax_V13_sig2_g15_b985_d1(1:z),'--+',y2(1:z),carbon_tax_V13_sig2_gNH_b985_d1(1:z),'--x',y2(1:z),carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'--s',y2(1:z),carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'--d',y2(1:z),carbon_tax_V13_sig2_g0_b985_d65_recalK0(1:z),'--v',y2(1:z),carbon_tax_V13_sig2_g15_b985_d65_recalK0(1:z),'-->')
% legend('\sigma=1.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,   \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,   \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,   \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,   \beta=.985, recalib.','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=1.5, gTFP=DICE, \delta=100%, \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,   \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,   \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,   \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.3%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=100%, \beta=.985','\sigma=2.0, gTFP=DICE, \delta=100%, \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,   \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,   \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,   \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,   \beta=.985, recalib.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax ($/mtC)','FontSize',11)
% title('Optimal Carbon Tax Levels','FontSize',13)
% 
% %%Importance of Recalibration with Beta=.985%%
% plot(y2(1:z),carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0(1:z),'-s',y2(1:z),carbon_tax_V13_sig1_g0_b985_d65_recalK0(1:z),':s',y2(1:z),carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0(1:z),'-d',y2(1:z),carbon_tax_V13_sig1_g15_b985_d65_recalK0(1:z),':d',y2(1:z),carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0(1:z),'-v',y2(1:z),carbon_tax_V13_sig15_g0_b985_d65_recalK0(1:z),':v',y2(1:z),carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0(1:z),'-*',y2(1:z),carbon_tax_V13_sig15_g15_b985_d65_recalK0(1:z),':*',y2(1:z),carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0(1:z),'-o',y2(1:z),carbon_tax_V13_sig2_g0_b985_d65_recalK0(1:z),':o',y2(1:z),carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0(1:z),'-x',y2(1:z),carbon_tax_V13_sig2_g15_b985_d65_recalK0(1:z),':x')
% legend('\sigma=1.0, gTFP=0.0%, \delta=65%,   \beta=.985','\sigma=1.0, gTFP=0.0%, \delta=65%,   \beta=.985, recalib.','\sigma=1.0, gTFP=1.5%, \delta=65%,   \beta=.985','\sigma=1.0, gTFP=1.5%, \delta=65%,   \beta=.985, recalib.','\sigma=1.5, gTFP=0.0%, \delta=65%,   \beta=.985','\sigma=1.5, gTFP=0.0%, \delta=65%,   \beta=.985, recalib.','\sigma=1.5, gTFP=1.5%, \delta=65%,   \beta=.985','\sigma=1.5, gTFP=1.5%, \delta=65%,  \beta=.985, recalib.','\sigma=2.0, gTFP=0.0%, \delta=65%,   \beta=.985','\sigma=2.0, gTFP=0.0%, \delta=65%,   \beta=.985, recalib.','\sigma=2.0, gTFP=1.5%, \delta=65%,   \beta=.985','\sigma=2.0, gTFP=1.5%, \delta=65%,   \beta=.985, recalib.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax ($/mtC)','FontSize',11)
% title('Optimal Carbon Tax Levels','FontSize',13)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Compare Full Allocations in Benchmark%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('oil_V13_sig1_g0_b985_d1','oil_V13_sig1_g0_b985_d1')
% load('coal_V13_sig1_g0_b985_d1','coal_V13_sig1_g0_b985_d1')
% load('wind_V13_sig1_g0_b985_d1','wind_V13_sig1_g0_b985_d1')
% load('lambda_hat_V13_sig1_g0_b985_d1','lambda_hat_V13_sig1_g0_b985_d1')
% load('ghkt_excel_T30_newkappa_oil','ghkt_excel_T30_newkappa_oil')
% load('ghkt_excel_T30_newkappa_wind','ghkt_excel_T30_newkappa_wind')
% load('ghkt_excel_T30_newkappa_coal','ghkt_excel_T30_newkappa_coal')
% 
% %%Oil%%
% z = T-1;
% plot(y2(1:z),ghkt_excel_T30_newkappa_oil(1:z),'--*',y2(1:z),oil_V13_sig1_g0_b985_d1(1:z),'-d')
% legend('GHKT Benchmark','Alternative Model')
% xlabel('Year','FontSize',11)
% ylabel('Oil Use','FontSize',11)
% title('Oil Use Comparison: GHKT Benchmark vs. Alternative Model','FontSize',13)
% 
% %%Coal%%
% plot(y2(1:z),ghkt_excel_T30_newkappa_coal(1:z),'--*',y2(1:z),coal_V13_sig1_g0_b985_d1(1:z),'-d')
% legend('GHKT Benchmark','Alternative Model','Location','Best')
% xlabel('Year','FontSize',11)
% ylabel('Coal Use','FontSize',11)
% title('Coal Use Comparison: GHKT Benchmark vs. Alternative Model','FontSize',13)
% 
% %%Wind%%
% plot(y2(1:z),ghkt_excel_T30_newkappa_wind(1:z),'--*',y2(1:z),wind_V13_sig1_g0_b985_d1(1:z),'-d')
% legend('GHKT Benchmark','Alternative Model','Location','Best')
% xlabel('Year','FontSize',11)
% ylabel('Wind Use','FontSize',11)
% title('Wind Use Comparison: GHKT Benchmark vs. Alternative Model','FontSize',13)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%   Section 6: Compute and Compare Approximations        %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Benchmark Approximation%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigmas = [1, 1.5, 2];
% %Base guess for gY on labor productivity growth rate gZ (as would be appropriate on BGP):
% temp_gZa_y = ((1+0.015)^(1/(1-alpha-v)))-1;
% gZs = [0, ((1+0.02)^10)-1, ((1+temp_gZa_y)^10)-1];
% betas = [(.985)^10, (.990)^10, (.995)^10];
% 
% beta_tilde = zeros(3,3,3);
% lambda_hat_approx = zeros(3,3,3);
% for s = 1:1:3;
%     for gz = 1:1:3;
%         for b = 1:1:3;
%             beta_tilde(s,gz,b) = betas(b)*(1+gZs(gz))^(1-sigmas(s));
%             lambda_hat_approx(s,gz,b) = gamma(T)*((phiL/(1-beta_tilde(s,gz,b)))+(((1-phiL)*phi0)/(1-(1-phi)*beta_tilde(s,gz,b))));
%         end
%     end
% end
% 
% lambda_temp_s15_g13 = ones(T+n,1)*lambda_hat_approx(2,2,1);
% lambda_temp_s15_g15 = ones(T+n,1)*lambda_hat_approx(2,3,1);
% lambda_temp_s2_g13 = ones(T+n,1)*lambda_hat_approx(3,2,1);
% lambda_temp_s2_g15 = ones(T+n,1)*lambda_hat_approx(3,3,1);
% 
% 
% %%%Graph All for Beta=.985:%%%
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),'-s',y2(1:z),lambda_temp_s15_g13(1:z),':s',y2(1:z),lambda_hat_V13_sig15_g15_b985_d1(1:z),'-v',y2(1:z),lambda_temp_s15_g15(1:z),':v',y2(1:z),lambda_hat_V13_sig2_g13_b985_d1(1:z),'-x',y2(1:z),lambda_temp_s2_g13(1:z),':x',y2(1:z),lambda_hat_V13_sig2_g15_b985_d1(1:z),'-h',y2(1:z),lambda_temp_s2_g15(1:z),':h')
% legend('\sigma=1, Benchmark','\sigma=1.5, gTFP=1.3%, Actual','\sigma=1.5, gTFP=1.3%, Approx.','\sigma=1.5, gTFP=1.5%, Actual','\sigma=1.5, gTFP=1.5%, Approx.','\sigma=2.0, gTFP=1.3%, Actual','\sigma=2.0, gTFP=1.3%, Approx.','\sigma=2.0, gTFP=1.5%, Actual','\sigma=2.0, gTFP=1.5%, Approx.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio Approximation','FontSize',13)
% 
% %%%Graph for Beta=.985, Sigma=1.5, TFP=1.3%%%
% plot(y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),'-s',y2(1:z),lambda_temp_s15_g13(1:z),':s')
% h1leg = legend('\sigma=1.5, gTFP=1.3%, Actual','\sigma=1.5, gTFP=1.3%, Approx.','Location','Best');
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio Approximation','FontSize',13)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Approximation with Adjusted Betas%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('lambda_hat_V13_sig1_g0_b985_d1','lambda_hat_V13_sig1_g0_b985_d1')
% load('lambda_hat_V13_sig05_g0_b985_d1','lambda_hat_V13_sig05_g0_b985_d1')
% load('lambda_hat_V13_sig05_g1_b9776_d1','lambda_hat_V13_sig05_g1_b9776_d1')
% load('lambda_hat_V13_sig05_g13_b9753_d1','lambda_hat_V13_sig05_g13_b9753_d1')
% load('lambda_hat_V13_sig05_g15_b974_d1','lambda_hat_V13_sig05_g15_b974_d1')
% load('lambda_hat_V13_sig05_g2_b9703_d1','lambda_hat_V13_sig05_g2_b9703_d1')
% load('lambda_hat_V13_sig15_g0_b985_d1','lambda_hat_V13_sig15_g0_b985_d1')
% load('lambda_hat_V13_sig15_g1_b9925_d1','lambda_hat_V13_sig15_g1_b9925_d1')
% load('lambda_hat_V13_sig15_g13_b9948_d1','lambda_hat_V13_sig15_g13_b9948_d1') 
% load('lambda_hat_V13_sig15_g15_b9962_d1','lambda_hat_V13_sig15_g15_b9962_d1')
% load('lambda_hat_V13_sig15_g2_b9999_d1','lambda_hat_V13_sig15_g2_b9999_d1')
% load('lambda_hat_V13_sig2_g0_b985_d1','lambda_hat_V13_sig2_g0_b985_d1')
% load('lambda_hat_V13_sig2_g1_b1_d1','lambda_hat_V13_sig2_g1_b1_d1')
% 
% %%Plot All%%%
% z = 20;
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),'-','LineWidth',3)
% hold on
% plot(y2(1:z),lambda_hat_V13_sig05_g0_b985_d1(1:z),'-v',y2(1:z),lambda_hat_V13_sig05_g1_b9776_d1(1:z),'-<',y2(1:z),lambda_hat_V13_sig05_g13_b9753_d1(1:z),'->',y2(1:z),lambda_hat_V13_sig05_g15_b974_d1(1:z),'-^',y2(1:z),lambda_hat_V13_sig05_g2_b9703_d1(1:z),'-d',y2(1:z),lambda_hat_V13_sig15_g0_b985_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig15_g1_b9925_d1(1:z),'-s',y2(1:z),lambda_hat_V13_sig15_g13_b9948_d1(1:z),'-x',y2(1:z),lambda_hat_V13_sig15_g15_b9962_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig15_g2_b9999_d1(1:z),'-.',y2(1:z),lambda_hat_V13_sig2_g0_b985_d1(1:z),'-*',y2(1:z),lambda_hat_V13_sig2_g1_b1_d1(1:z),'-p')
% hold off
% legend('Benchmark (\sigma=1, \beta=.9850) = Approx.','\sigma=0.5, gTFP=0.0%, \delta=100%, \beta=.9850','\sigma=0.5, gTFP=1.0%, \delta=100%, \beta=.9776','\sigma=0.5, gTFP=1.3%, \delta=100%, \beta=.9753','\sigma=0.5, gTFP=1.5%, \delta=100%, \beta=.9740','\sigma=0.5, gTFP=2.0%, \delta=100%, \beta=.9703','\sigma=1.5, gTFP=0.0%, \delta=100%, \beta=.9850','\sigma=1.5, gTFP=1.0%, \delta=100%, \beta=.9925','\sigma=1.5, gTFP=1.3%, \delta=100%, \beta=.9948','\sigma=1.5, gTFP=1.5%, \delta=100%, \beta=.9962','\sigma=1.5, gTFP=2.0%, \delta=100%, \beta=.9999','\sigma=2.0, gTFP=0.0%, \delta=100%, \beta=.9850','\sigma=2.0, gTFP=1.0%, \delta=100%, \beta=1.000','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio Approximation','FontSize',13)
% 
% 
% %%%Approximation with and without Adjusted Betas%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%Plot for Sigma=1.5%%%
% plot(y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),':s',y2(1:z),lambda_hat_V13_sig15_g13_b985_d1(1:z),'-*',y2(1:z),lambda_temp_s15_g13(1:z),':*',y2(1:z),lambda_hat_V13_sig15_g13_b9948_d1(1:z),'-o',y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),':o',y2(1:z),lambda_hat_V13_sig15_g15_b985_d1(1:z),'-v',y2(1:z),lambda_temp_s15_g15(1:z),':v',y2(1:z),lambda_hat_V13_sig15_g15_b9962_d1(1:z),'-+',y2(1:z),lambda_hat_V13_sig1_g0_b985_d1(1:z),':+')
% legend('\sigma=1.0, \beta=.9850, Benchmark','\sigma=1.5, gTFP=1.3%, \beta=.9850, Actual','\sigma=1.5, gTFP=1.3%, \beta=.9850, Approx.','\sigma=1.5, gTFP=1.3%, \beta=.9948, Actual','\sigma=1.5, gTFP=1.3%, \beta=.9948, Approx.','\sigma=1.5, gTFP=1.5%, \beta=.9850, Actual','\sigma=1.5, gTFP=1.5%, \beta=.9850, Approx.','\sigma=1.5, gTFP=1.5%, \beta=.9962, Actual','\sigma=1.5, gTFP=1.5%, \beta=.9962, Approx.','Location','EastOutside')
% xlabel('Year','FontSize',11)
% ylabel('Carbon Tax/GDP','FontSize',11)
% title('Carbon Tax/GDP Ratio Approximation for \sigma=1.5','FontSize',13)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Betas Required to maintain Lambda-Hat = Benchmark%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigmas = [0.5, 1.5, 2];
% gTFPs =  [0, 0.5, 1, 1.5, 2];
% beta_hats = zeros(3,5);
% beta_hats_annual = zeros(3,5);
% for i = 1:1:3;
%     for j = 1:1:5;
%         temp1 = ((1+(gTFPs(j)/100))^(1/(1-alpha-v)))-1;   %Annual gZ corresponding to gTFP
%         temp2 = ((1+temp1)^10)-1;                         %Decadal gZ corresponding to gTFP
%         beta_hats(i,j) = ((.985)^10)/((1+temp2)^(1-sigmas(i)));
%         beta_hats_annual(i,j) = beta_hats(i,j)^(1/10);
%     end
% end
% 
% %%Graph Necessary Betas%%
% %%%%%%%%%%%%%%%%%%%%%%%%%
% beta_hats_annual_sig05 = beta_hats_annual(1,:);
% beta_hats_annual_sig15 = beta_hats_annual(2,:);
% beta_hats_annual_sig2 = beta_hats_annual(3,:);
% beta_hats_annual_sig1 = ones(1,5)*(.985);
% plot(gTFPs,beta_hats_annual_sig05,'-x',gTFPs,beta_hats_annual_sig1,'-d',gTFPs,beta_hats_annual_sig15,'-o',gTFPs,beta_hats_annual_sig2,'-v')
% legend('\sigma=0.5','\sigma=1.0','\sigma=1.5','\sigma=2.0')
% xlabel('Annual TFP Growth Rate','FontSize',11)
% ylabel('Annual Discount Factor (Beta)','FontSize',11)
% title('Annual Discount Factor for Benchmark Carbon Tax/GDP Approximation','FontSize',13)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%Compare actual GDP growth with gZ%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
load('Yt_V13_sig1_g0_b985_d1','Yt_V13_sig1_g0_b985_d1')
Yar{1} = Yt_V13_sig1_g0_b985_d1;
% load('Yt_V13_sig1_g0_b99_d1','Yt_V13_sig1_g0_b99_d1')
% Yar{2} = Yt_V13_sig1_g0_b99_d1;
% load('Yt_V13_sig1_g0_b995_d1','Yt_V13_sig1_g0_b995_d1')
% Yar{3} = Yt_V13_sig1_g0_b995_d1;
% load('Yt_V13_sig1_g0_b999_d1','Yt_V13_sig1_g0_b999_d1')
% Yar{4} = Yt_V13_sig1_g0_b999_d1;
% load('Yt_V13_sig1_g0_b985_d65_NOrecalK0','Yt_V13_sig1_g0_b985_d65_NOrecalK0')
% Yar{5} = Yt_V13_sig1_g0_b985_d65_NOrecalK0;
% load('Yt_V13_sig1_g0_b985_d65_recalK0','Yt_V13_sig1_g0_b985_d65_recalK0')
% Yar{6} = Yt_V13_sig1_g0_b985_d65_recalK0;
% load('Yt_V13_sig1_g13_b985_d1','Yt_V13_sig1_g13_b985_d1')
% Yar{7} = Yt_V13_sig1_g13_b985_d1;
% load('Yt_V13_sig1_g13_b99_d1','Yt_V13_sig1_g13_b99_d1')
% Yar{8} = Yt_V13_sig1_g13_b99_d1;
% load('Yt_V13_sig1_g13_b995_d1','Yt_V13_sig1_g13_b995_d1') 
% Yar{9} = Yt_V13_sig1_g13_b995_d1;
% load('Yt_V13_sig1_g13_b999_d1','Yt_V13_sig1_g13_b999_d1') 
% Yar{10} = Yt_V13_sig1_g13_b999_d1;
% load('Yt_V13_sig1_g15_b985_d1','Yt_V13_sig1_g15_b985_d1')
% Yar{11} = Yt_V13_sig1_g15_b985_d1;
% load('Yt_V13_sig1_g15_b985_d65_recalK0','Yt_V13_sig1_g15_b985_d65_recalK0')
% Yar{12} = Yt_V13_sig1_g15_b985_d65_recalK0;
% load('Yt_V13_sig1_g15_b985_d65_NOrecalK0','Yt_V13_sig1_g15_b985_d65_NOrecalK0')
% Yar{13} = Yt_V13_sig1_g15_b985_d65_NOrecalK0;
% load('Yt_V13_sig1_gNH_b985_d1','Yt_V13_sig1_gNH_b985_d1')
% Yar{14} = Yt_V13_sig1_gNH_b985_d1;
% load('Yt_V13_sig1_gNH_b985_d65_NOrecalK0','Yt_V13_sig1_gNH_b985_d65_NOrecalK0')
% Yar{15} = Yt_V13_sig1_gNH_b985_d65_NOrecalK0;
% load('Yt_V13_sig15_g0_b985_d1','Yt_V13_sig15_g0_b985_d1')
% Yar{16} = Yt_V13_sig15_g0_b985_d1;
% load('Yt_V13_sig15_g0_b99_d1','Yt_V13_sig15_g0_b99_d1')
% Yar{17} = Yt_V13_sig15_g0_b99_d1;
% load('Yt_V13_sig15_g0_b995_d1','Yt_V13_sig15_g0_b995_d1')
% Yar{18} = Yt_V13_sig15_g0_b995_d1;
% load('Yt_V13_sig15_g0_b999_d1','Yt_V13_sig15_g0_b999_d1')
% Yar{19} = Yt_V13_sig15_g0_b999_d1;
% load('Yt_V13_sig15_g0_b985_d65_NOrecalK0','Yt_V13_sig15_g0_b985_d65_NOrecalK0')
% Yar{20} = Yt_V13_sig15_g0_b985_d65_NOrecalK0;
% load('Yt_V13_sig15_g0_b985_d65_recalK0','Yt_V13_sig15_g0_b985_d65_recalK0')
% Yar{21} = Yt_V13_sig15_g0_b985_d65_recalK0;
% load('Yt_V13_sig15_g13_b985_d1','Yt_V13_sig15_g13_b985_d1')
% Yar{22} = Yt_V13_sig15_g13_b985_d1;
% load('Yt_V13_sig15_g13_b99_d1','Yt_V13_sig15_g13_b99_d1')
% Yar{23} = Yt_V13_sig15_g13_b99_d1;
% load('Yt_V13_sig15_g13_b995_d1','Yt_V13_sig15_g13_b995_d1')
% Yar{24} = Yt_V13_sig15_g13_b995_d1;
% load('Yt_V13_sig15_g13_b999_d1','Yt_V13_sig15_g13_b999_d1') 
% Yar{25} = Yt_V13_sig15_g13_b999_d1;
% load('Yt_V13_sig15_g15_b985_d1','Yt_V13_sig15_g15_b985_d1')
% Yar{26} = Yt_V13_sig15_g15_b985_d1;
% load('Yt_V13_sig15_g15_b985_d65_recalK0','Yt_V13_sig15_g15_b985_d65_recalK0')
% Yar{27} = Yt_V13_sig15_g15_b985_d65_recalK0;
% load('Yt_V13_sig15_g15_b985_d65_NOrecalK0','Yt_V13_sig15_g15_b985_d65_NOrecalK0')
% Yar{28} = Yt_V13_sig15_g15_b985_d65_NOrecalK0;
% load('Yt_V13_sig15_gNH_b985_d1','Yt_V13_sig15_gNH_b985_d1')
% Yar{29} = Yt_V13_sig15_gNH_b985_d1;
% load('Yt_V13_sig15_gNH_b985_d65_NOrecalK0','Yt_V13_sig15_gNH_b985_d65_NOrecalK0')
% Yar{30} = Yt_V13_sig15_gNH_b985_d65_NOrecalK0;
% load('Yt_V13_sig2_g0_b985_d1','Yt_V13_sig2_g0_b985_d1')
% Yar{31} = Yt_V13_sig2_g0_b985_d1;
% load('Yt_V13_sig2_g0_b99_d1','Yt_V13_sig2_g0_b99_d1')
% Yar{32} = Yt_V13_sig2_g0_b99_d1;
% load('Yt_V13_sig2_g0_b995_d1','Yt_V13_sig2_g0_b995_d1')
% Yar{33} = Yt_V13_sig2_g0_b995_d1;
% load('Yt_V13_sig2_g0_b999_d1','Yt_V13_sig2_g0_b999_d1')
% Yar{34} = Yt_V13_sig2_g0_b999_d1;
% load('Yt_V13_sig2_g0_b985_d65_NOrecalK0','Yt_V13_sig2_g0_b985_d65_NOrecalK0')
% Yar{35} = Yt_V13_sig2_g0_b985_d65_NOrecalK0;
% load('Yt_V13_sig2_g0_b985_d65_recalK0','Yt_V13_sig2_g0_b985_d65_recalK0')
% Yar{36} = Yt_V13_sig2_g0_b985_d65_recalK0;
% load('Yt_V13_sig2_g13_b985_d1','Yt_V13_sig2_g13_b985_d1')
% Yar{37} = Yt_V13_sig2_g13_b985_d1;
% load('Yt_V13_sig2_g13_b99_d1','Yt_V13_sig2_g13_b99_d1')
% Yar{38} = Yt_V13_sig2_g13_b99_d1;
% load('Yt_V13_sig2_g13_b995_d1','Yt_V13_sig2_g13_b995_d1')
% Yar{39} = Yt_V13_sig2_g13_b995_d1;
% load('Yt_V13_sig2_g13_b999_d1','Yt_V13_sig2_g13_b999_d1')
% Yar{40} = Yt_V13_sig2_g13_b999_d1;
% load('Yt_V13_sig2_g15_b985_d1','Yt_V13_sig2_g15_b985_d1')
% Yar{41} = Yt_V13_sig2_g15_b985_d1;
% load('Yt_V13_sig2_g15_b985_d65_recalK0','Yt_V13_sig2_g15_b985_d65_recalK0')
% Yar{42} = Yt_V13_sig2_g15_b985_d65_recalK0;
% load('Yt_V13_sig2_g15_b985_d65_NOrecalK0','Yt_V13_sig2_g15_b985_d65_NOrecalK0')
% Yar{43} = Yt_V13_sig2_g15_b985_d65_NOrecalK0;
% load('Yt_V13_sig2_gNH_b985_d1','Yt_V13_sig2_gNH_b985_d1')
% Yar{44} = Yt_V13_sig2_gNH_b985_d1;
% load('Yt_V13_sig2_gNH_b985_d65_NOrecalK0','Yt_V13_sig2_gNH_b985_d65_NOrecalK0')
% Yar{45} = Yt_V13_sig2_gNH_b985_d65_NOrecalK0;
% load('Yt_V13_sig05_g0_b985_d1','Yt_V13_sig05_g0_b985_d1')
% Yar{46} = Yt_V13_sig05_g0_b985_d1;
% load('Yt_V13_sig05_g13_b985_d1','Yt_V13_sig05_g13_b985_d1')
% Yar{47} = Yt_V13_sig05_g13_b985_d1;
% load('Yt_V13_sig05_g0_b985_d1','Yt_V13_sig05_g0_b985_d1')
% Yar{48} = Yt_V13_sig05_g0_b985_d1;
% load('Yt_V13_sig05_g1_b9776_d1','Yt_V13_sig05_g1_b9776_d1')
% Yar{49} = Yt_V13_sig05_g1_b9776_d1;
% load('Yt_V13_sig05_g13_b9753_d1','Yt_V13_sig05_g13_b9753_d1')
% Yar{50} = Yt_V13_sig05_g13_b9753_d1;
% load('Yt_V13_sig05_g15_b974_d1','Yt_V13_sig05_g15_b974_d1')
% Yar{51} = Yt_V13_sig05_g15_b974_d1;
% load('Yt_V13_sig05_g2_b9703_d1','Yt_V13_sig05_g2_b9703_d1')
% Yar{52} = Yt_V13_sig05_g2_b9703_d1;
% load('Yt_V13_sig15_g1_b9925_d1','Yt_V13_sig15_g1_b9925_d1')
% Yar{53} = Yt_V13_sig15_g1_b9925_d1;
% load('Yt_V13_sig15_g13_b9948_d1','Yt_V13_sig15_g13_b9948_d1')
% Yar{54} = Yt_V13_sig15_g13_b9948_d1;
% load('Yt_V13_sig15_g15_b9962_d1','Yt_V13_sig15_g15_b9962_d1')
% Yar{55} = Yt_V13_sig15_g15_b9962_d1;
% load('Yt_V13_sig15_g2_b9999_d1','Yt_V13_sig15_g2_b9999_d1')
% Yar{56} = Yt_V13_sig15_g2_b9999_d1;
% load('Yt_V13_sig2_g1_b1_d1','Yt_V13_sig2_g1_b1_d1')
% Yar{57} = Yt_V13_sig2_g1_b1_d1;
% 
% gy = zeros(T+10-1,57);
% for i = 1:1:57;
%     for j = 1:1:T+10;
%         temp = Yar{i}
%         gy(j,i) = temp(1+j)/temp(j);
%     end
% end
% 
% 
% %%Average over 400 years:
% %gY in 2050, 2100, 2150
% %%Average over 300 years:
% 
% gy_400 = mean(gy(:,56))
% gy_50_400 = mean(gy(5:40,56))
% gy_100 = gy(10,56)
% 
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%      Section 7: Save Output in Excel           %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% filename = 'Sensitivity_Output.xlsx';
% 
% %%%%%%%%%%%%%%%%
% %%Save Outputs%%
% %%%%%%%%%%%%%%%%%
% 
% sheet = 2;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g0_b985_d1','Yt_V13_sig1_g0_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g0_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g0_b985_d1','carbon_tax_V13_sig1_g0_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g0_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g0_b985_d1','Yt_V13_sig1_g0_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g0_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g0_b985_d1','Ct_V13_sig1_g0_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g0_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g0_b985_d1','oil_V13_sig1_g0_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g0_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g0_b985_d1','coal_V13_sig1_g0_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g0_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g0_b985_d1','wind_V13_sig1_g0_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g0_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 3;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g0_b985_d1','lambda_hat_V13_sig15_g0_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g0_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g0_b985_d1','carbon_tax_V13_sig15_g0_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g0_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g0_b985_d1','Yt_V13_sig15_g0_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g0_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g0_b985_d1','Ct_V13_sig15_g0_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g0_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g0_b985_d1','oil_V13_sig15_g0_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g0_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g0_b985_d1','coal_V13_sig15_g0_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g0_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g0_b985_d1','wind_V13_sig15_g0_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g0_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 4;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g0_b985_d1','lambda_hat_V13_sig2_g0_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g0_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g0_b985_d1','carbon_tax_V13_sig2_g0_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g0_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g0_b985_d1','Yt_V13_sig2_g0_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g0_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g0_b985_d1','Ct_V13_sig2_g0_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g0_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g0_b985_d1','oil_V13_sig2_g0_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g0_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g0_b985_d1','coal_V13_sig2_g0_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g0_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g0_b985_d1','wind_V13_sig2_g0_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g0_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 5;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=1.3%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g13_b985_d1','lambda_hat_V13_sig1_g13_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g13_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g13_b985_d1','carbon_tax_V13_sig1_g13_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g13_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g13_b985_d1','Yt_V13_sig1_g13_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g13_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g13_b985_d1','Ct_V13_sig1_g13_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g13_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g13_b985_d1','oil_V13_sig1_g13_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g13_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g13_b985_d1','coal_V13_sig1_g13_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g13_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g13_b985_d1','wind_V13_sig1_g13_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g13_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 6;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g13_b985_d1','lambda_hat_V13_sig15_g13_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g13_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g13_b985_d1','carbon_tax_V13_sig15_g13_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g13_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g13_b985_d1','Yt_V13_sig15_g13_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g13_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g13_b985_d1','Ct_V13_sig15_g13_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g13_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g13_b985_d1','oil_V13_sig15_g13_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g13_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g13_b985_d1','coal_V13_sig15_g13_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g13_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g13_b985_d1','wind_V13_sig15_g13_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g13_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 7;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g13_b985_d1','lambda_hat_V13_sig2_g13_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g13_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g13_b985_d1','carbon_tax_V13_sig2_g13_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g13_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g13_b985_d1','Yt_V13_sig2_g13_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g13_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g13_b985_d1','Ct_V13_sig2_g13_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g13_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g13_b985_d1','oil_V13_sig2_g13_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g13_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g13_b985_d1','coal_V13_sig2_g13_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g13_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g13_b985_d1','wind_V13_sig2_g13_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g13_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 8;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=1.5%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g15_b985_d1','lambda_hat_V13_sig1_g15_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g15_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g15_b985_d1','carbon_tax_V13_sig1_g15_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g15_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g15_b985_d1','Yt_V13_sig1_g15_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g15_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g15_b985_d1','Ct_V13_sig1_g15_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g15_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g15_b985_d1','oil_V13_sig1_g15_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g15_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g15_b985_d1','coal_V13_sig1_g15_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g15_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g15_b985_d1','wind_V13_sig1_g15_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g15_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 9;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g15_b985_d1','lambda_hat_V13_sig15_g15_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g15_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g15_b985_d1','carbon_tax_V13_sig15_g15_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g15_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g15_b985_d1','Yt_V13_sig15_g15_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g15_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g15_b985_d1','Ct_V13_sig15_g15_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g15_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g15_b985_d1','oil_V13_sig15_g15_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g15_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g15_b985_d1','coal_V13_sig15_g15_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g15_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g15_b985_d1','wind_V13_sig15_g15_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g15_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 10;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g15_b985_d1','lambda_hat_V13_sig2_g15_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g15_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g15_b985_d1','carbon_tax_V13_sig2_g15_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g15_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g15_b985_d1','Yt_V13_sig2_g15_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g15_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g15_b985_d1','Ct_V13_sig2_g15_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g15_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g15_b985_d1','oil_V13_sig2_g15_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g15_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g15_b985_d1','coal_V13_sig2_g15_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g15_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g15_b985_d1','wind_V13_sig2_g15_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g13_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 11;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g0_b985_d65_NOrecalK0','Yt_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g0_b985_d65_NOrecalK0','Ct_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g0_b985_d65_NOrecalK0','oil_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g0_b985_d65_NOrecalK0','coal_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g0_b985_d65_NOrecalK0','wind_V13_sig1_g0_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g0_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 12;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g0_b985_d65_NOrecalK0','Yt_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g0_b985_d65_NOrecalK0','Ct_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g0_b985_d65_NOrecalK0','oil_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g0_b985_d65_NOrecalK0','coal_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g0_b985_d65_NOrecalK0','wind_V13_sig15_g0_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g0_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 13;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0','lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0','carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g0_b985_d65_NOrecalK0','Yt_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g0_b985_d65_NOrecalK0','Ct_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g0_b985_d65_NOrecalK0','oil_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g0_b985_d65_NOrecalK0','coal_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g0_b985_d65_NOrecalK0','wind_V13_sig2_g0_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g0_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 14;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.985, Delta=65%, recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g0_b985_d65_recalK0','lambda_hat_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g0_b985_d65_recalK0','carbon_tax_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g0_b985_d65_recalK0','Yt_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g0_b985_d65_recalK0','Ct_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g0_b985_d65_recalK0','oil_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g0_b985_d65_recalK0','coal_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g0_b985_d65_recalK0','wind_V13_sig1_g0_b985_d65_recalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g0_b985_d65_recalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 15;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.985, Delta=65%, recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g0_b985_d65_recalK0','lambda_hat_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g0_b985_d65_recalK0','carbon_tax_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g0_b985_d65_recalK0','Yt_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g0_b985_d65_recalK0','Ct_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g0_b985_d65_recalK0','oil_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g0_b985_d65_recalK0','coal_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g0_b985_d65_recalK0','wind_V13_sig15_g0_b985_d65_recalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g0_b985_d65_recalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 16;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.985, Delta=65%, recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g0_b985_d65_recalK0','lambda_hat_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g0_b985_d65_recalK0','carbon_tax_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g0_b985_d65_recalK0','Yt_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g0_b985_d65_recalK0','Ct_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g0_b985_d65_recalK0','oil_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g0_b985_d65_recalK0','coal_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g0_b985_d65_recalK0','wind_V13_sig2_g0_b985_d65_recalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g0_b985_d65_recalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 17;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=1.5%, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g15_b985_d65_NOrecalK0','Yt_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g15_b985_d65_NOrecalK0','Ct_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g15_b985_d65_NOrecalK0','oil_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g15_b985_d65_NOrecalK0','coal_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g15_b985_d65_NOrecalK0','wind_V13_sig1_g15_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g15_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 18;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g15_b985_d65_NOrecalK0','Yt_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g15_b985_d65_NOrecalK0','Ct_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g15_b985_d65_NOrecalK0','oil_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g15_b985_d65_NOrecalK0','coal_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g15_b985_d65_NOrecalK0','wind_V13_sig15_g15_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g15_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 19;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=1.5%, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0','lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0','carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g15_b985_d65_NOrecalK0','Yt_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g15_b985_d65_NOrecalK0','Ct_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g15_b985_d65_NOrecalK0','oil_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g15_b985_d65_NOrecalK0','coal_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g15_b985_d65_NOrecalK0','wind_V13_sig2_g15_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g15_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 20;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.985, Delta=65%, recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g15_b985_d65_recalK0','lambda_hat_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g15_b985_d65_recalK0','carbon_tax_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g15_b985_d65_recalK0','Yt_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g15_b985_d65_recalK0','Ct_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g15_b985_d65_recalK0','oil_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g15_b985_d65_recalK0','coal_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g15_b985_d65_recalK0','wind_V13_sig1_g15_b985_d65_recalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g15_b985_d65_recalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 21;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1.5%, Beta=.985, Delta=65, recal.%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g15_b985_d65_recalK0','lambda_hat_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g15_b985_d65_recalK0','carbon_tax_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g15_b985_d65_recalK0','Yt_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g15_b985_d65_recalK0','Ct_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g15_b985_d65_recalK0','oil_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g15_b985_d65_recalK0','coal_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g15_b985_d65_recalK0','wind_V13_sig15_g15_b985_d65_recalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g15_b985_d65_recalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 22;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=1.5%, Beta=.985, Delta=65, recal.%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g15_b985_d65_recalK0','lambda_hat_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g15_b985_d65_recalK0','carbon_tax_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g15_b985_d65_recalK0','Yt_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g15_b985_d65_recalK0','Ct_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g15_b985_d65_recalK0','oil_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g15_b985_d65_recalK0','coal_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g15_b985_d65_recalK0','wind_V13_sig2_g15_b985_d65_recalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g15_b985_d65_recalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 23;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.99, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g0_b99_d1','lambda_hat_V13_sig1_g0_b99_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g0_b99_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g0_b99_d1','carbon_tax_V13_sig1_g0_b99_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g0_b99_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g0_b99_d1','Yt_V13_sig1_g0_b99_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g0_b99_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g0_b99_d1','Ct_V13_sig1_g0_b99_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g0_b99_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g0_b99_d1','oil_V13_sig1_g0_b99_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g0_b99_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g0_b99_d1','coal_V13_sig1_g0_b99_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g0_b99_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g0_b99_d1','wind_V13_sig1_g0_b99_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g0_b99_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 24;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.99, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g0_b99_d1','lambda_hat_V13_sig15_g0_b99_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g0_b99_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g0_b99_d1','carbon_tax_V13_sig15_g0_b99_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g0_b99_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g0_b99_d1','Yt_V13_sig15_g0_b99_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g0_b99_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g0_b99_d1','Ct_V13_sig15_g0_b99_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g0_b99_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g0_b99_d1','oil_V13_sig15_g0_b99_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g0_b99_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g0_b99_d1','coal_V13_sig15_g0_b99_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g0_b99_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g0_b99_d1','wind_V13_sig15_g0_b99_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g0_b99_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 25;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.99, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g0_b99_d1','lambda_hat_V13_sig2_g0_b99_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g0_b99_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g0_b99_d1','carbon_tax_V13_sig2_g0_b99_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g0_b99_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g0_b99_d1','Yt_V13_sig2_g0_b99_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g0_b99_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g0_b99_d1','Ct_V13_sig2_g0_b99_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g0_b99_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g0_b99_d1','oil_V13_sig2_g0_b99_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g0_b99_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g0_b99_d1','coal_V13_sig2_g0_b99_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g0_b99_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g0_b99_d1','wind_V13_sig2_g0_b99_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g0_b99_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 26;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.995, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g0_b995_d1','lambda_hat_V13_sig1_g0_b995_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g0_b995_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g0_b995_d1','carbon_tax_V13_sig1_g0_b995_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g0_b995_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g0_b995_d1','Yt_V13_sig1_g0_b995_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g0_b995_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g0_b995_d1','Ct_V13_sig1_g0_b995_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g0_b995_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g0_b995_d1','oil_V13_sig1_g0_b995_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g0_b995_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g0_b995_d1','coal_V13_sig1_g0_b995_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g0_b995_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g0_b995_d1','wind_V13_sig1_g0_b995_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g0_b995_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 27;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.995, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g0_b995_d1','lambda_hat_V13_sig15_g0_b995_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g0_b995_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g0_b995_d1','carbon_tax_V13_sig15_g0_b995_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g0_b995_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g0_b995_d1','Yt_V13_sig15_g0_b995_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g0_b995_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g0_b995_d1','Ct_V13_sig15_g0_b995_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g0_b995_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g0_b995_d1','oil_V13_sig15_g0_b995_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g0_b995_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g0_b995_d1','coal_V13_sig15_g0_b995_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g0_b995_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g0_b995_d1','wind_V13_sig15_g0_b995_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g0_b995_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 28;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.995, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g0_b995_d1','lambda_hat_V13_sig2_g0_b995_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g0_b995_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g0_b995_d1','carbon_tax_V13_sig2_g0_b995_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g0_b995_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g0_b995_d1','Yt_V13_sig2_g0_b995_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g0_b995_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g0_b995_d1','Ct_V13_sig2_g0_b995_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g0_b995_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g0_b995_d1','oil_V13_sig2_g0_b995_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g0_b995_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g0_b995_d1','coal_V13_sig2_g0_b995_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g0_b995_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g0_b995_d1','wind_V13_sig2_g0_b995_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g0_b995_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 29;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=0%, Beta=.999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g0_b999_d1','lambda_hat_V13_sig1_g0_b999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g0_b999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g0_b999_d1','carbon_tax_V13_sig1_g0_b999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g0_b999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g0_b999_d1','Yt_V13_sig1_g0_b999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g0_b999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g0_b999_d1','Ct_V13_sig1_g0_b999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g0_b999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g0_b999_d1','oil_V13_sig1_g0_b999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g0_b999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g0_b999_d1','coal_V13_sig1_g0_b999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g0_b999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g0_b999_d1','wind_V13_sig1_g0_b999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g0_b999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 30;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=0%, Beta=.999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g0_b999_d1','lambda_hat_V13_sig15_g0_b999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g0_b999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g0_b999_d1','carbon_tax_V13_sig15_g0_b999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g0_b999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g0_b999_d1','Yt_V13_sig15_g0_b999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g0_b999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g0_b999_d1','Ct_V13_sig15_g0_b999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g0_b999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g0_b999_d1','oil_V13_sig15_g0_b999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g0_b999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g0_b999_d1','coal_V13_sig15_g0_b999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g0_b999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g0_b999_d1','wind_V13_sig15_g0_b999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g0_b999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 31;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=0%, Beta=.999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g0_b999_d1','lambda_hat_V13_sig2_g0_b999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g0_b999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g0_b999_d1','carbon_tax_V13_sig2_g0_b999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g0_b999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g0_b999_d1','Yt_V13_sig2_g0_b999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g0_b999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g0_b999_d1','Ct_V13_sig2_g0_b999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g0_b999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g0_b999_d1','oil_V13_sig2_g0_b999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g0_b999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g0_b999_d1','coal_V13_sig2_g0_b999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g0_b999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g0_b999_d1','wind_V13_sig2_g0_b999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g0_b999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 32;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=1.3%, Beta=.99, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g13_b99_d1','lambda_hat_V13_sig1_g13_b99_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g13_b99_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g13_b99_d1','carbon_tax_V13_sig1_g13_b99_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g13_b99_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g13_b99_d1','Yt_V13_sig1_g13_b99_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g13_b99_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g13_b99_d1','Ct_V13_sig1_g13_b99_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g13_b99_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g13_b99_d1','oil_V13_sig1_g13_b99_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g13_b99_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g13_b99_d1','coal_V13_sig1_g13_b99_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g13_b99_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g13_b99_d1','wind_V13_sig1_g13_b99_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g13_b99_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 33;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1.3%, Beta=.99, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g13_b99_d1','lambda_hat_V13_sig15_g13_b99_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g13_b99_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g13_b99_d1','carbon_tax_V13_sig15_g13_b99_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g13_b99_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g13_b99_d1','Yt_V13_sig15_g13_b99_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g13_b99_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g13_b99_d1','Ct_V13_sig15_g13_b99_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g13_b99_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g13_b99_d1','oil_V13_sig15_g13_b99_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g13_b99_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g13_b99_d1','coal_V13_sig15_g13_b99_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g13_b99_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g13_b99_d1','wind_V13_sig15_g13_b99_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g13_b99_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 34;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=1.3%, Beta=.99, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g13_b99_d1','lambda_hat_V13_sig2_g13_b99_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g13_b99_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g13_b99_d1','carbon_tax_V13_sig2_g13_b99_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g13_b99_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g13_b99_d1','Yt_V13_sig2_g13_b99_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g13_b99_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g13_b99_d1','Ct_V13_sig2_g13_b99_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g13_b99_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g13_b99_d1','oil_V13_sig2_g13_b99_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g13_b99_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g13_b99_d1','coal_V13_sig2_g13_b99_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g13_b99_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g13_b99_d1','wind_V13_sig2_g13_b99_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g13_b99_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 35;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=1.3%, Beta=.995, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g13_b995_d1','lambda_hat_V13_sig1_g13_b995_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g13_b995_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g13_b995_d1','carbon_tax_V13_sig1_g13_b995_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g13_b995_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g13_b995_d1','Yt_V13_sig1_g13_b995_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g13_b995_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g13_b995_d1','Ct_V13_sig1_g13_b995_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g13_b995_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g13_b995_d1','oil_V13_sig1_g13_b995_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g13_b995_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g13_b995_d1','coal_V13_sig1_g13_b995_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g13_b995_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g13_b995_d1','wind_V13_sig1_g13_b995_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g13_b995_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 36;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1.3%, Beta=.995, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g13_b995_d1','lambda_hat_V13_sig15_g13_b995_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g13_b995_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g13_b995_d1','carbon_tax_V13_sig15_g13_b995_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g13_b995_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g13_b995_d1','Yt_V13_sig15_g13_b995_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g13_b995_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g13_b995_d1','Ct_V13_sig15_g13_b995_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g13_b995_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g13_b995_d1','oil_V13_sig15_g13_b995_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g13_b995_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g13_b995_d1','coal_V13_sig15_g13_b995_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g13_b995_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g13_b995_d1','wind_V13_sig15_g13_b995_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g13_b995_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 37;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=1.3%, Beta=.995, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g13_b995_d1','lambda_hat_V13_sig2_g13_b995_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g13_b995_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g13_b995_d1','carbon_tax_V13_sig2_g13_b995_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g13_b995_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g13_b995_d1','Yt_V13_sig2_g13_b995_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g13_b995_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g13_b995_d1','Ct_V13_sig2_g13_b995_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g13_b995_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g13_b995_d1','oil_V13_sig2_g13_b995_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g13_b995_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g13_b995_d1','coal_V13_sig2_g13_b995_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g13_b995_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g13_b995_d1','wind_V13_sig2_g13_b995_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g13_b995_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 38;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=1.3%, Beta=.999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_g13_b999_d1','lambda_hat_V13_sig1_g13_b999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_g13_b999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_g13_b999_d1','carbon_tax_V13_sig1_g13_b999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_g13_b999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_g13_b999_d1','Yt_V13_sig1_g13_b999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_g13_b999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_g13_b999_d1','Ct_V13_sig1_g13_b999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_g13_b999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_g13_b999_d1','oil_V13_sig1_g13_b999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_g13_b999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_g13_b999_d1','coal_V13_sig1_g13_b999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_g13_b999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_g13_b999_d1','wind_V13_sig1_g13_b999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_g13_b999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 39;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1.3%, Beta=.999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g13_b999_d1','lambda_hat_V13_sig15_g13_b999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g13_b999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g13_b999_d1','carbon_tax_V13_sig15_g13_b999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g13_b999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g13_b999_d1','Yt_V13_sig15_g13_b999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g13_b999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g13_b999_d1','Ct_V13_sig15_g13_b999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g13_b999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g13_b999_d1','oil_V13_sig15_g13_b999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g13_b999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g13_b999_d1','coal_V13_sig15_g13_b999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g13_b999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g13_b999_d1','wind_V13_sig15_g13_b999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g13_b999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 40;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=1.3%, Beta=.999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g13_b999_d1','lambda_hat_V13_sig2_g13_b999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g13_b999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g13_b999_d1','carbon_tax_V13_sig2_g13_b999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g13_b999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g13_b999_d1','Yt_V13_sig2_g13_b999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g13_b999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g13_b999_d1','Ct_V13_sig2_g13_b999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g13_b999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g13_b999_d1','oil_V13_sig2_g13_b999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g13_b999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g13_b999_d1','coal_V13_sig2_g13_b999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g13_b999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g13_b999_d1','wind_V13_sig2_g13_b999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g13_b999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 41;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=DICE, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_gNH_b985_d1','lambda_hat_V13_sig1_gNH_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_gNH_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_gNH_b985_d1','carbon_tax_V13_sig1_gNH_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_gNH_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_gNH_b985_d1','Yt_V13_sig1_gNH_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_gNH_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_gNH_b985_d1','Ct_V13_sig1_gNH_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_gNH_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_gNH_b985_d1','oil_V13_sig1_gNH_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_gNH_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_gNH_b985_d1','coal_V13_sig1_gNH_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_gNH_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_gNH_b985_d1','wind_V13_sig1_gNH_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_gNH_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 42;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=DICE, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_gNH_b985_d1','lambda_hat_V13_sig15_gNH_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_gNH_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_gNH_b985_d1','carbon_tax_V13_sig15_gNH_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_gNH_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_gNH_b985_d1','Yt_V13_sig15_gNH_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_gNH_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_gNH_b985_d1','Ct_V13_sig15_gNH_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_gNH_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_gNH_b985_d1','oil_V13_sig15_gNH_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_gNH_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_gNH_b985_d1','coal_V13_sig15_gNH_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_gNH_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_gNH_b985_d1','wind_V13_sig15_gNH_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_gNH_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 43;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=DICE, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_gNH_b985_d1','lambda_hat_V13_sig2_gNH_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_gNH_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_gNH_b985_d1','carbon_tax_V13_sig2_gNH_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_gNH_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_gNH_b985_d1','Yt_V13_sig2_gNH_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_gNH_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_gNH_b985_d1','Ct_V13_sig2_gNH_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_gNH_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_gNH_b985_d1','oil_V13_sig2_gNH_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_gNH_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_gNH_b985_d1','coal_V13_sig2_gNH_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_gNH_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_gNH_b985_d1','wind_V13_sig2_gNH_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_gNH_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 44;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1, gTFP=DICE, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig1_gNH_b985_d65_NOrecalK0','carbon_tax_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig1_gNH_b985_d65_NOrecalK0','Yt_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig1_gNH_b985_d65_NOrecalK0','Ct_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig1_gNH_b985_d65_NOrecalK0','oil_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig1_gNH_b985_d65_NOrecalK0','coal_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig1_gNH_b985_d65_NOrecalK0','wind_V13_sig1_gNH_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig1_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 45;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=DICE, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_gNH_b985_d65_NOrecalK0','carbon_tax_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_gNH_b985_d65_NOrecalK0','Yt_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_gNH_b985_d65_NOrecalK0','Ct_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_gNH_b985_d65_NOrecalK0','oil_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_gNH_b985_d65_NOrecalK0','coal_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_gNH_b985_d65_NOrecalK0','wind_V13_sig15_gNH_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 46;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=DICE, Beta=.985, Delta=65%, no recal.'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0','lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_gNH_b985_d65_NOrecalK0','carbon_tax_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_gNH_b985_d65_NOrecalK0','Yt_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_gNH_b985_d65_NOrecalK0','Ct_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_gNH_b985_d65_NOrecalK0','oil_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_gNH_b985_d65_NOrecalK0','coal_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_gNH_b985_d65_NOrecalK0','wind_V13_sig2_gNH_b985_d65_NOrecalK0')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_gNH_b985_d65_NOrecalK0;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 47;
% xlRange1 = 'A1';
% temp1 = {'Sigma=0.5, gTFP=0%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig05_g0_b985_d1','lambda_hat_V13_sig05_g0_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig05_g0_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig05_g0_b985_d1','carbon_tax_V13_sig05_g0_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig05_g0_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig05_g0_b985_d1','Yt_V13_sig05_g0_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig05_g0_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig05_g0_b985_d1','Ct_V13_sig05_g0_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig05_g0_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig05_g0_b985_d1','oil_V13_sig05_g0_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig05_g0_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig05_g0_b985_d1','coal_V13_sig05_g0_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig05_g0_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig05_g0_b985_d1','wind_V13_sig05_g0_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig05_g0_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 48;
% xlRange1 = 'A1';
% temp1 = {'Sigma=0.5, gTFP=1%, Beta=.9776, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig05_g1_b9776_d1','lambda_hat_V13_sig05_g1_b9776_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig05_g1_b9776_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig05_g1_b9776_d1','carbon_tax_V13_sig05_g1_b9776_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig05_g1_b9776_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig05_g1_b9776_d1','Yt_V13_sig05_g1_b9776_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig05_g1_b9776_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig05_g1_b9776_d1','Ct_V13_sig05_g1_b9776_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig05_g1_b9776_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig05_g1_b9776_d1','oil_V13_sig05_g1_b9776_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig05_g1_b9776_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig05_g1_b9776_d1','coal_V13_sig05_g1_b9776_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig05_g1_b9776_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig05_g1_b9776_d1','wind_V13_sig05_g1_b9776_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig05_g1_b9776_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 49;
% xlRange1 = 'A1';
% temp1 = {'Sigma=0.5, gTFP=1.3%, Beta=.9753, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig05_g13_b9753_d1','lambda_hat_V13_sig05_g13_b9753_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig05_g13_b9753_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig05_g13_b9753_d1','carbon_tax_V13_sig05_g13_b9753_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig05_g13_b9753_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig05_g13_b9753_d1','Yt_V13_sig05_g13_b9753_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig05_g13_b9753_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig05_g13_b9753_d1','Ct_V13_sig05_g13_b9753_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig05_g13_b9753_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig05_g13_b9753_d1','oil_V13_sig05_g13_b9753_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig05_g13_b9753_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig05_g13_b9753_d1','coal_V13_sig05_g13_b9753_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig05_g13_b9753_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig05_g13_b9753_d1','wind_V13_sig05_g13_b9753_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig05_g13_b9753_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 50;
% xlRange1 = 'A1';
% temp1 = {'Sigma=0.5, gTFP=1.5%, Beta=.974, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig05_g15_b974_d1','lambda_hat_V13_sig05_g15_b974_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig05_g15_b974_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig05_g15_b974_d1','carbon_tax_V13_sig05_g15_b974_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig05_g15_b974_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig05_g15_b974_d1','Yt_V13_sig05_g15_b974_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig05_g15_b974_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig05_g15_b974_d1','Ct_V13_sig05_g15_b974_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig05_g15_b974_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig05_g15_b974_d1','oil_V13_sig05_g15_b974_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig05_g15_b974_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig05_g15_b974_d1','coal_V13_sig05_g15_b974_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig05_g15_b974_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig05_g15_b974_d1','wind_V13_sig05_g15_b974_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig05_g15_b974_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 51;
% xlRange1 = 'A1';
% temp1 = {'Sigma=0.5, gTFP=2%, Beta=.9703, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig05_g2_b9703_d1','lambda_hat_V13_sig05_g2_b9703_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig05_g2_b9703_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig05_g2_b9703_d1','carbon_tax_V13_sig05_g2_b9703_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig05_g2_b9703_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig05_g2_b9703_d1','Yt_V13_sig05_g2_b9703_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig05_g2_b9703_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig05_g2_b9703_d1','Ct_V13_sig05_g2_b9703_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig05_g2_b9703_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig05_g2_b9703_d1','oil_V13_sig05_g2_b9703_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig05_g2_b9703_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig05_g2_b9703_d1','coal_V13_sig05_g2_b9703_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig05_g2_b9703_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig05_g2_b9703_d1','wind_V13_sig05_g2_b9703_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig05_g2_b9703_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 52;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1%, Beta=.9925, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g1_b9925_d1','lambda_hat_V13_sig15_g1_b9925_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g1_b9925_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g1_b9925_d1','carbon_tax_V13_sig15_g1_b9925_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g1_b9925_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g1_b9925_d1','Yt_V13_sig15_g1_b9925_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g1_b9925_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g1_b9925_d1','Ct_V13_sig15_g1_b9925_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g1_b9925_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g1_b9925_d1','oil_V13_sig15_g1_b9925_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g1_b9925_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g1_b9925_d1','coal_V13_sig15_g1_b9925_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g1_b9925_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g1_b9925_d1','wind_V13_sig15_g1_b9925_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g1_b9925_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 53;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1.3%, Beta=.9948, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g13_b9948_d1','lambda_hat_V13_sig15_g13_b9948_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g13_b9948_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g13_b9948_d1','carbon_tax_V13_sig15_g13_b9948_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g13_b9948_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g13_b9948_d1','Yt_V13_sig15_g13_b9948_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g13_b9948_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g13_b9948_d1','Ct_V13_sig15_g13_b9948_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g13_b9948_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g13_b9948_d1','oil_V13_sig15_g13_b9948_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g13_b9948_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g13_b9948_d1','coal_V13_sig15_g13_b9948_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g13_b9948_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g13_b9948_d1','wind_V13_sig15_g13_b9948_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g13_b9948_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 54;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=1.5%, Beta=.9962, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g15_b9962_d1','lambda_hat_V13_sig15_g15_b9962_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g15_b9962_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g15_b9962_d1','carbon_tax_V13_sig15_g15_b9962_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g15_b9962_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g15_b9962_d1','Yt_V13_sig15_g15_b9962_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g15_b9962_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g15_b9962_d1','Ct_V13_sig15_g15_b9962_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g15_b9962_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g15_b9962_d1','oil_V13_sig15_g15_b9962_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g15_b9962_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g15_b9962_d1','coal_V13_sig15_g15_b9962_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g15_b9962_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g15_b9962_d1','wind_V13_sig15_g15_b9962_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g15_b9962_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 55;
% xlRange1 = 'A1';
% temp1 = {'Sigma=1.5, gTFP=2%, Beta=.9999, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig15_g2_b9999_d1','lambda_hat_V13_sig15_g2_b9999_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig15_g2_b9999_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig15_g2_b9999_d1','carbon_tax_V13_sig15_g2_b9999_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig15_g2_b9999_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig15_g2_b9999_d1','Yt_V13_sig15_g2_b9999_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig15_g2_b9999_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig15_g2_b9999_d1','Ct_V13_sig15_g2_b9999_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig15_g2_b9999_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig15_g2_b9999_d1','oil_V13_sig15_g2_b9999_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig15_g2_b9999_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig15_g2_b9999_d1','coal_V13_sig15_g2_b9999_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig15_g2_b9999_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig15_g2_b9999_d1','wind_V13_sig15_g2_b9999_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig15_g2_b9999_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 56;
% xlRange1 = 'A1';
% temp1 = {'Sigma=2, gTFP=1%, Beta=1, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig2_g1_b1_d1','lambda_hat_V13_sig2_g1_b1_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig2_g1_b1_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig2_g1_b1_d1','carbon_tax_V13_sig2_g1_b1_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig2_g1_b1_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig2_g1_b1_d1','Yt_V13_sig2_g1_b1_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig2_g1_b1_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig2_g1_b1_d1','Ct_V13_sig2_g1_b1_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig2_g1_b1_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig2_g1_b1_d1','oil_V13_sig2_g1_b1_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig2_g1_b1_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig2_g1_b1_d1','coal_V13_sig2_g1_b1_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig2_g1_b1_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig2_g1_b1_d1','wind_V13_sig2_g1_b1_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig2_g1_b1_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% sheet = 57;
% xlRange1 = 'A1';
% temp1 = {'Sigma=0.5, gTFP=1.3%, Beta=.985, Delta=100%'}; 
% xlswrite(filename,temp1,sheet,xlRange1)
% load('lambda_hat_V13_sig05_g13_b985_d1','lambda_hat_V13_sig05_g13_b985_d1')
% temp2 = {'Lambda Hat'};
% xlRange2 = 'A2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = lambda_hat_V13_sig05_g13_b985_d1;
% xlRange3 = 'A3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('carbon_tax_V13_sig05_g13_b985_d1','carbon_tax_V13_sig05_g13_b985_d1')
% temp2 = {'Carbon Tax'};
% xlRange2 = 'B2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = carbon_tax_V13_sig05_g13_b985_d1;
% xlRange3 = 'B3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Yt_V13_sig05_g13_b985_d1','Yt_V13_sig05_g13_b985_d1')
% temp2 = {'Yt'};
% xlRange2 = 'C2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Yt_V13_sig05_g13_b985_d1;
% xlRange3 = 'C3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('Ct_V13_sig05_g13_b985_d1','Ct_V13_sig05_g13_b985_d1')
% temp2 = {'Ct'};
% xlRange2 = 'D2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = Ct_V13_sig05_g13_b985_d1;
% xlRange3 = 'D3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('oil_V13_sig05_g13_b985_d1','oil_V13_sig05_g13_b985_d1')
% temp2 = {'Oil'};
% xlRange2 = 'E2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = oil_V13_sig05_g13_b985_d1;
% xlRange3 = 'E3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('coal_V13_sig05_g13_b985_d1','coal_V13_sig05_g13_b985_d1')
% temp2 = {'Coal'};
% xlRange2 = 'F2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = coal_V13_sig05_g13_b985_d1;
% xlRange3 = 'F3';
% xlswrite(filename,temp3,sheet,xlRange3)
% load('wind_V13_sig05_g13_b985_d1','wind_V13_sig05_g13_b985_d1')
% temp2 = {'Wind'};
% xlRange2 = 'G2';
% xlswrite(filename,temp2,sheet,xlRange2)
% temp3 = wind_V13_sig05_g13_b985_d1;
% xlRange3 = 'G3';
% xlswrite(filename,temp3,sheet,xlRange3)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%Rename Sheets%%
% %%%%%%%%%%%%%%%%%
% e = actxserver ('Excel.Application'); 
% ewb = e.Workbooks.Open('C:\Users\Owner\Desktop\GHKT_Work\Sensitivity_Output.xlsx');
% %Sheet 1 is Table of Contents
% ewb.Worksheets.Item(2).Name = 's1_gA0_b985_d100'; 
% ewb.Worksheets.Item(3).Name = 's15_gA0_b985_d100'; 
% ewb.Worksheets.Item(4).Name = 's2_gA0_b985_d100'; 
% ewb.Worksheets.Item(5).Name = 's1_gA13_b985_d100'; 
% ewb.Worksheets.Item(6).Name = 's15_gA13_b985_d100'; 
% ewb.Worksheets.Item(7).Name = 's2_gA13_b985_d100'; 
% ewb.Worksheets.Item(8).Name = 's1_gA15_b985_d100'; 
% ewb.Worksheets.Item(9).Name = 's15_gA15_b985_d100'; 
% ewb.Worksheets.Item(10).Name = 's2_gA15_b985_d100'; 
% ewb.Worksheets.Item(11).Name = 's1_gA0_b985_d65_NoRec'; 
% ewb.Worksheets.Item(12).Name = 's15_gA0_b985_d65_NoRec'; 
% ewb.Worksheets.Item(13).Name = 's2_gA0_b985_d65_NoRec'; 
% ewb.Worksheets.Item(14).Name = 's1_gA0_b985_d65_Rec'; 
% ewb.Worksheets.Item(15).Name = 's15_gA0_b985_d65_Rec'; 
% ewb.Worksheets.Item(16).Name = 's2_gA0_b985_d65_Rec'; 
% ewb.Worksheets.Item(17).Name = 's1_gA15_b985_d65_NoRec'; 
% ewb.Worksheets.Item(18).Name = 's15_gA15_b985_d65_NoRec'; 
% ewb.Worksheets.Item(19).Name = 's2_gA15_b985_d65_NoRec'; 
% ewb.Worksheets.Item(20).Name = 's1_gA15_b985_d65_Rec'; 
% ewb.Worksheets.Item(21).Name = 's15_gA15_b985_d65_Rec'; 
% ewb.Worksheets.Item(22).Name = 's2_gA15_b985_d65_Rec'; 
% ewb.Worksheets.Item(23).Name = 's1_gA0_b99_d100'; 
% ewb.Worksheets.Item(24).Name = 's15_gA0_b99_d100'; 
% ewb.Worksheets.Item(25).Name = 's2_gA0_b99_d100'; 
% ewb.Worksheets.Item(26).Name = 's1_gA0_b995_d100'; 
% ewb.Worksheets.Item(27).Name = 's15_gA0_b995_d100'; 
% ewb.Worksheets.Item(28).Name = 's2_gA0_b995_d100'; 
% ewb.Worksheets.Item(29).Name = 's1_gA0_b999_d100'; 
% ewb.Worksheets.Item(30).Name = 's15_gA0_b999_d100'; 
% ewb.Worksheets.Item(31).Name = 's2_gA0_b999_d100'; 
% ewb.Worksheets.Item(32).Name = 's1_gA13_b99_d100'; 
% ewb.Worksheets.Item(33).Name = 's15_g13_b99_d100'; 
% ewb.Worksheets.Item(34).Name = 's2_gA13_b99_d100'; 
% ewb.Worksheets.Item(35).Name = 's1_gA13_b995_d100'; 
% ewb.Worksheets.Item(36).Name = 's15_gA13_b995_d100'; 
% ewb.Worksheets.Item(37).Name = 's2_gA13_b995_d100'; 
% ewb.Worksheets.Item(38).Name = 's1_gA13_b999_d100'; 
% ewb.Worksheets.Item(39).Name = 's15_gA13_b999_d100'; 
% ewb.Worksheets.Item(40).Name = 's2_gA13_b999_d100'; 
% ewb.Worksheets.Item(41).Name = 's1_gAN_b985_d100'; 
% ewb.Worksheets.Item(42).Name = 's15_gAN_b985_d100'; 
% ewb.Worksheets.Item(43).Name = 's2_gAN_b985_d100'; 
% ewb.Worksheets.Item(44).Name = 's1_gAN_b985_d65_NoRec'; 
% ewb.Worksheets.Item(45).Name = 's15_gAN_b985_d65_NoRec'; 
% ewb.Worksheets.Item(46).Name = 's2_gAN_b985_d65_NoRec'; 
% ewb.Worksheets.Item(47).Name = 's05_g0_b985_d100'; 
% ewb.Worksheets.Item(48).Name = 's05_g1_b9776_d100'; 
% ewb.Worksheets.Item(49).Name = 's05_g13_b9753_d100'; 
% ewb.Worksheets.Item(50).Name = 's05_g15_b974_d100'; 
% ewb.Worksheets.Item(51).Name = 's05_g2_b9703_d100'; 
% ewb.Worksheets.Item(52).Name = 's15_g1_b9925_d100'; 
% ewb.Worksheets.Item(53).Name = 's15_g13_b9948_d100'; 
% ewb.Worksheets.Item(54).Name = 's15_g15_b9962_d100'; 
% ewb.Worksheets.Item(55).Name = 's15_g2_b9999_d100'; 
% ewb.Worksheets.Item(56).Name = 's2_g1_b1_d100'; 
% ewb.Worksheets.Item(57).Name = 's05_g13_b985_d100'; 
% ewb.Save 
% ewb.Close(false)
% e.Quit
