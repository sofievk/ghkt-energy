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
phi = 0.0228;       %Carbon depreciation per annum (remaining share)
phiL = 0.2;         %Carbon emitted to the atmosphere staying there forever
phi0 = 0.393;       %Share of remaining emissions exiting atmosphere immediately
Sbar = 581;         %Pre-industrial atmospheric GtC
S1_2000 = 103;      %GtC
S2_2000 = 699;      %GtC
gamma = zeros(T,1); 
for i = 1:1:T;
    gamma(i) = 0.000023793; %Damage elasticity
end
 
%%Energy Aggregation%%
%%%%%%%%%%%%%%%%%%%%%%

%% OPTION 1 (GHKT)
rho = -0.058;      %Elasticity of substitution between energy sources
kappa1 = 0.5429;   %Relative efficiency of oil
kappa2 = 0.1015;   %Relative efficiency of coal
kappa3 = 1-kappa1-kappa2; %Relative efficiency of low-carbon technologies

%% Option 2 (Based on change in TWh 2014-2024)
% rho = -0.058;
% kappa1 = 0.455;
% kappa2 = 0.078;
% kappa3 = 1 - kappa1 - kappa2; 


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
figure;
%the original line -plot(y,ypsilon,'-o')- gave an x-axis until 3400 therefore changed to below 
plot(y,ypsilon(1:T),'-o')
xlabel('Year','FontSize',11)
ylabel('Coal Emissions Coefficient','FontSize',11)
title('Coal Emissions Coefficient','FontSize',13)


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
%COMMENTED IN (TO LOAD PREVIOUS RESULT) 

load('x_ghkt_v1.mat','x')

%COMMENTED IN TO ENSURE X0 LOAD PREVIOUS RESULTS X
x0 = x;

%COMMENTED OUT (WAS ORIGINALLY COMMENTED IN)
%%% OPTION 2: NEUTRAL STARTING POINT %%

% x0 = zeros(vars,1);
% for i = 1:1:T-1;
%      x0(i) = 0.25;
%      x0((T-1)+i) = R0-((R0/1.1)/T)*i;
%      x0(2*(T-1)+i) = 0.002;
%      x0(2*(T-1)+T+i) = 0.01;
%  end
%  x0(2*(T-1)+T) = 0.002;
%  x0(2*(T-1)+T+T) = 0.01;

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

% save('x_ghkt_v1','x')

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

%%Self added: Compute fossil fuel usage in GtC
fossil_fuel = zeros(T,1);
for i = 1:1:T;
    fossil_fuel(i) = oil(i) + coal(i);
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

%% compute energy shares (self-added)
total_energy = zeros(T,1);
share_coal = zeros(T,1);
share_oil = zeros(T,1);
share_wind = zeros(T,1);
for i = 1:1:T;
    total_energy(i) = coal(i) + oil(i) + wind(i);
    share_coal(i) = coal(i) / total_energy(i);
    share_oil(i) = oil(i) / total_energy(i);
    share_wind(i) = wind(i) / total_energy(i);
end

%%% Diagnostic plot preview
z = 30;
figure;
hold on;
plot(y2(1:z),share_wind(1:z),'Color',[0.2 0.7 0.3], 'LineWidth', 1.5);
plot(y2(1:z), share_coal(1:z),'Color',[0.55 0.27 0.07], 'LineWidth', 1.5);
plot(y2(1:z),share_oil(1:z),'Color',[0.95 0.65 0.2], 'LineWidth', 1.5);
ylabel('Energy Share');
legend('Low Carbon Energy','Coal', 'Oil');
grid off;
xlim([2025 2250])
ylim([0 1])
title('Energy Mix');


%% Diagnostic plot energy sources over time
z = 20;
figure;
hold on;
plot(y2(1:z),oil(1:z), '-b', 'LineWidth', 2);
plot(y2(1:z),wind(1:z), '-g', 'LineWidth', 2);
plot(y2(1:z),coal(1:z), '-r', 'LineWidth', 2); 
ylabel('Energy (x1000 TWh)')
xlabel('Year');
ylabel('Energy production (GtC)');
title('Energy in GtC');
legend({'Oil', 'Low-carbon', 'Coal'}, 'Location', 'best');
grid off;
xlim([2020 2100])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Output and Consumption through T%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Yt = zeros(T,1);
Ct = zeros(T,1);
Kt1 = zeros(T,1);
Yt(1) = At(1)*(exp((-gamma(1))*(St(1)-Sbar)))*(K0^alpha)*(((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha-v))*(energy(1)^v);
Ct(1) = (1-x(1))*Yt(1);
Kt1(1) = x(1)*Yt(1)+(1-Delta)*K0;
for i = 1:1:T-2;
    Yt(1+i) = At(1+i)*(exp((-gamma(1+i))*(St(1+i)-Sbar)))*(Kt1(i)^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha-v))*(energy(1+i)^v);
    Kt1(1+i) = x(1+i)*Yt(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*Yt(1+i); 
end
Yt(T) = At(T)*(exp((-gamma(T))*(St(T)-Sbar)))*(Kt1(T-1)^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha-v))*(energy(T)^v);
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

%% Calculate temperature impacts
lambda = 3.0;               % Climate sensitivity parameter
temp = zeros(T,1); % Initialize the temperature vector
for i = 1:1:T;
    temp(i) = lambda * log2(St(i)/Sbar);
end

%% Plot    
figure (Name='Temperature Increase');
plot(y2(1:T), temp, ' -r', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Temperature Increase (degrees C)', 'FontSize', 11);
title('Temperature Increase (GHKT baseline)'); 


%%%%%%%%%% SELF ADDED  %%%%%%%%%%%%%%%%

%%From GtC to x1000 TWh 
oil_TWh = zeros(T,1);
coal_TWh = zeros(T,1);
wind_TWh = zeros(T,1); 


GtC_to_TWh_oil = 14793.65;  % 1 GtC = 14,793.65 TWh 
GtC_to_TWh_coal = 9920.63;  % 1 GtC = 9,920.63 TWh

for i = 1:1:T;
oil_TWh(i) = oil(i) * (GtC_to_TWh_oil / 1000);   % convert to x1000 TWh
coal_TWh(i) = coal(i) * (GtC_to_TWh_coal / 1000); % convert to x1000 TWh
wind_TWh(i) = wind(i)/0.1008;
energy_TWh(i) = energy(i)/((0.1008+0.0676)/2);
end

%Save 
oil_ghkt_twh = oil_TWh; 
save ('oil_ghkt_twh','oil_ghkt_twh');
coal_ghkt_twh = coal_TWh;
save('coal_ghkt_twh','coal_ghkt_twh'); 
wind_ghkt_twh = wind_TWh;
save('wind_ghkt_twh','wind_ghkt_twh');


%% Diagnostic plot energy sources over time
z = 20;
figure;
hold on;
plot(y2(1:z),oil_ghkt_twh(1:z), '-b', 'LineWidth', 2);
plot(y2(1:z),wind_ghkt_twh(1:z), '-g', 'LineWidth', 2);
plot(y2(1:z),coal_ghkt_twh(1:z), '-r', 'LineWidth', 2); 
ylabel('Energy (x1000 TWh)')
xlabel('Year');
ylabel('Energy production (TWh)');
title('Energy in TWh Coal, Oil, and Renewables');
legend({'Oil', 'Low-carbon', 'Coal'}, 'Location', 'best');
grid off
ylim([0 1600])
xlim([2020 2100])


%%Net-of-damages GDP
load('Yt_ghkt_lf.mat','Yt_ghkt_lf');
load('Yt_ghkt_v1.mat','Yt_ghkt_v1');
net_gdp = zeros(T,1);
for i = 1:1:T;
    net_gdp_ghkt(i) = Yt_ghkt_v1(i)/Yt_ghkt_lf(i);
end 
z = 25; 
figure; 
plot(y2(1:z), net_gdp_ghkt(1:z),": ", 'LineWidth', 1.5);
title('Net output: optimum versus laissez-faire');
xlim([2000 2250])    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 4: Save Allocations and Carbon Taxes  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Note: Only save for appropriate model scenario
energy_ghkt_v1 = energy;
save('energy_ghkt_v1','energy_ghkt_v1');
oil_ghkt_v1 = oil;
save('oil_ghkt_v1','oil_ghkt_v1')
coal_ghkt_v1 = coal;
save('coal_ghkt_v1','coal_ghkt_v1')
wind_ghkt_v1 = wind;
save('wind_ghkt_v1','wind_ghkt_v1')
lambda_hat_ghkt_v1 = lambda_hat;
save('lambda_hat_ghkt_v1','lambda_hat_ghkt_v1')
carbon_tax_ghkt_v1 = carbon_tax;
save('carbon_tax_ghkt_v1','carbon_tax_ghkt_v1')
Yt_ghkt_v1 = Yt;
save('Yt_ghkt_v1','Yt_ghkt_v1')
Ct_ghkt_v1 = Ct;
save('Ct_ghkt_v1','Ct_ghkt_v1')
St_ghkt_v1 = St;
save('St_ghkt_v1', 'St_ghkt_v1')
emiss_ghkt_v1 = emiss;
save('emiss_ghkt_v1','emiss_ghkt_v1');
fossil_fuel_ghkt_v1 = fossil_fuel;
save('fossil_fuel_ghkt_v1','fossil_fuel_ghkt_v1');
temp_ghkt_v1 = temp;
save('temp_ghkt_v1','temp_ghkt_v1');
Kt1_ghkt_v1 = Kt1; 
save('Kt1_ghkt_v1', 'Kt1_ghkt_v1'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 5: Graph Optimal Carbon Taxes     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Self added: Extract
r_ghkt_v1 = x(1:T-1);
save('r_ghkt_v1','r_ghkt_v1');
oil_stock_ghkt_v1 = x(T:2*(T-1));
save('oil_stock_ghkt_v1','oil_stock_ghkt_v1');
N2_ghkt_v1 = x(2*(T-1)+1:3*(T-1)-1);
save('N2_ghkt_v1', 'N2_ghkt_v1');
N3_ghkt_v1 = x(2*(T-1)+T+1:2*(T-1)+2*T);
save('N3_ghkt_v1','N3_ghkt_v1');
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Graph Carbon Tax-GDP Ratio%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('lambda_hat_ghkt_v1','lambda_hat_ghkt_v1')

z = 30;
figure(Name = 'Carbon Tax to GDP ratio (GHKT baseline)');
plot(y2(1:z), lambda_hat_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Carbon Tax/GDP', 'FontSize', 11);
ylim([3.5e-05, 8.5e-05]);
title('Carbon Tax to GDP ratio (GHKT baseline)');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%Graph Carbon Tax Level%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('carbon_tax_ghkt_v1','carbon_tax_ghkt_v1')

z = 10;
figure(Name = 'Carbon Tax ($/mtC) (GHKT baseline)');
plot(y2(1:z), carbon_tax_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Carbon Tax ($/mtC)', 'FontSize', 11);
title('Carbon Tax ($/mtC) (GHKT baseline)');

%% Combined Temperature and Tax $ 
load('carbon_tax_ghkt_v1','carbon_tax_ghkt_v1')
load('temp_ghkt_v1','temp_ghkt_v1')

z = 30;

figure;
yyaxis left
plot(y2(1:z), carbon_tax_ghkt_v1(1:z), '-b', 'LineWidth', 1.5);
ylabel('Carbon Tax ($/mtC)', 'FontSize', 11);
ylim([40 70])

yyaxis right
plot(y2(1:z), temp_ghkt_v1(1:z), '-r', 'LineWidth', 1.5);
ylabel('Temperature Increase (degrees C)', 'FontSize', 11);
ylim([0 4])

xlabel('Year', 'FontSize', 11);
title('Carbon Tax and Temperature');
xlim([2010 2225])

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  Energy Use Over Time  %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Energy
load('energy_ghkt_v1','energy_ghkt_v1')

z = 25;
figure;
plot(y2(1:z), energy_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('GtC', 'FontSize', 11);
title('Energy Use (GHKT baseline)');
xlim([2010 2225])


%% Oil
load('oil_ghkt_v1', 'oil_ghkt_v1')

z = 30;
figure(Name ='Oil Use (GHKT baseline)');
plot(y2(1:z), oil_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Oil Use', 'FontSize', 11);
title('Oil Use (GHKT baseline)');

%% Coal
load('coal_ghkt_v1', 'coal_ghkt_v1')

z = 30;
figure(Name ='Coal Use (GHKT baseline)');
plot(y2(1:z), coal_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Coal Use', 'FontSize', 11);
title('Coal Use (GHKT baseline)');

%% Wind
load('wind_ghkt_v1.mat', 'wind_ghkt_v1');

z = 30;
figure(Name = 'Wind Use (GHKT baseline)');
plot(y2(1:z), wind_ghkt_v1(1:z), '-b', 'LineWidth', 1.5, 'DisplayName', 'Wind Use');
hold on; grid on;
xlabel('Year', 'FontSize', 11);
ylabel('Wind Use', 'FontSize', 11);
title('Wind Use (GHKT baseline)');
markX = [1, 10, 20, 30];
markYears = y2(markX);
markY = interp1(y2(1:z), wind_ghkt_v1(1:z), markYears);
plot(markYears, markY, 'ko', 'MarkerFaceColor', 'w', 'DisplayName', 'Marked Points');

for i = 1:length(markX)
    text(markYears(i), markY(i), sprintf(' %.2f', markY(i)), ...
        'VerticalAlignment', 'bottom', 'FontSize', 10);
end
grid off;
hold off;


%% Fossil Fuels
load('fossil_fuel_ghkt_v1', 'fossil_fuel_ghkt_v1')

z = 30;
figure(Name = 'Fossil Fuel Use (GHKT baseline)');
plot(y2(1:z), fossil_fuel_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (Gtoe)', 'FontSize', 11);
title('Fossil Fuel Use (GHKT baseline)');

%% Emissions
load('emiss_ghkt_v1', 'emiss_ghkt_v1')

z = 30;
figure(Name='Emissions (GHKT baseline)');
plot(y2(1:z), emiss_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Emissions (GtC)', 'FontSize', 11);
title('Emissions (GHKT baseline)');

%% Labour share to wind energy
load('N3_ghkt_v1', 'N3_ghkt_v1')

z = 30;
grid off;
figure(Name='Labour Share to Wind Energy Production (GHKT baseline)');
plot(y2(1:z), N3_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Share to Wind Energy Production (GHKT baseline)');
xlim([2020 2285]);

%% Labour share to coal
load('N2_ghkt_v1', 'N2_ghkt_v1')

z = 28;
figure(Name = 'Labour Share to Coal Production (GHKT baseline)');
plot(y2(1:z), N2_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Share to Coal Production (GHKT baseline)');

%% Labour shares combined
z = 25;
figure(Name='Labour Shares combined');
hold on;
plot(y2(1:z), N2_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
plot(y2(1:z), N3_ghkt_v1(1:z), ' -g', 'LineWidth', 1.5);
hold off; 
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Shares E2 and E3 (GHKT baseline)');
legend('coal','low-carbon');
xlim([2010 2225])

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  GDP Growth Over Time  %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Yt_ghkt_v1','Yt_ghkt_v1')

z = 10;
figure(Name='GDP (GHKT baseline)');
plot(y2(1:z), Yt_ghkt_v1(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Output', 'FontSize', 11);
title('GDP (GHKT baseline)');

%% Stacked chart r, K, C, GDP
z = length(r_ghkt_v1);

figure; hold on
yyaxis left
h = area(y2(1:z), [Ct_ghkt_v1(1:z) Kt1_ghkt_v1(1:z)], 'LineStyle','none');
h(1).FaceAlpha = .5; h(2).FaceAlpha = .5;
h(1).FaceColor = [0.2 0.6 0.8]; h(2).FaceColor = [0.8 0.4 0.4];

p = plot(y2(1:z), Yt_ghkt_v1(1:z), 'k--');
yyaxis right
plot(y2(1:z), r_ghkt_v1(1:z), '--');
ylim([0.0 0.50]) 
legend([h(1) h(2) p], 'Consumption','Capital','GDP', 'Location','southeast');
title('GDP, consumption, capital, and savings rate');
xlabel('Year')
xlim([2010 2300])

%% Load data
load('energy_ghkt_v1','energy_ghkt_v1')
load('Yt_ghkt_v1','Yt_ghkt_v1')

z = 25;   % use same horizon for both


figure;

%% Left axis: Output (blue)
yyaxis left
plot(y2(1:z), Yt_ghkt_v1(1:z), '-b', 'LineWidth', 1.5);
ylabel('GDP ($)', 'FontSize', 11);
ylim([0 850000])

%% Right axis: Energy (orange)
yyaxis right
plot(y2(1:z), energy_TWh(1:z), 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
ylabel('Energy (x1000 TWh approximation)', 'FontSize', 11);
ylim([50 400])

xlabel('Year', 'FontSize', 11);
title('GDP and Energy Use (GHKT baseline)');
xlim([2010 2225]);

legend('GDP','Energy','Location','best');
grid off;