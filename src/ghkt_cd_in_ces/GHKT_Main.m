%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 1: Parameters        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('rp','var'), rp = -1e-6; end                  % the only thing you change between runs
if ~exist('pf','var'), pf = "CDinCES"; end
p = LoadParams(rho_prod = rp, pf_type = pf);
scenario = ['rho_' strrep(strrep(sprintf('%g',rp),'-','m'),'.','p')];
if exist('scenario_name','var'), scenario = scenario_name; end

A2t = p.A2t; A3t = p.A3t; At = p.At; Delta = p.Delta; K0 = p.K0; N = p.N; R0 = p.R0;
S1_2000 = p.S1_2000; S2_2000 = p.S2_2000; Sbar = p.Sbar; T = p.T; alpha = p.alpha; beta = p.beta;
gZBGP = p.gZBGP; gZ_en = p.gZ_en; gZd_y = p.gZd_y; gamma = p.gamma;
kappa1 = p.kappa1; kappa2 = p.kappa2; kappa3 = p.kappa3; n = p.n;
phi = p.phi; phi0 = p.phi0; phiL = p.phiL; rho = p.rho; sigma = p.sigma; v = p.v;
y = p.y; y2 = p.y2; ypsilon = p.ypsilon;


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

if ~exist('start_mode','var'), start_mode = "saved"; end
switch start_mode
    case "saved"
        s_ = load('x_ghkt_v1.mat','x'); x0 = s_.x;
    case "previous"
        x0 = x_prev;
    case "neutral"
        x0 = zeros(vars,1);
        for i = 1:1:T-1
            x0(i) = 0.25;
            x0((T-1)+i) = R0-((R0/1.1)/T)*i;
            x0(2*(T-1)+i) = 0.002;
            x0(2*(T-1)+T+i) = 0.01;
        end
        x0(2*(T-1)+T) = 0.002;
        x0(2*(T-1)+T+T) = 0.01;
end

%%Check Constraints and Objective Function Value at x0%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = GHKT_Objective(x0,p)
[c, ceq] = GHKT_Constraints(x0,p)


%%%%%%%%%%%
%%%SOLVE%%%
%%%%%%%%%%%
options = optimoptions(@fmincon,'Tolfun',1e-12,'TolCon',1e-12,'MaxFunEvals',500000,'MaxIter',6200,'Display','iter','MaxSQPIter',10000,'Algorithm','active-set');
[x, fval,exitflag] = fmincon(@(x)GHKT_Objective(x,p), x0, [], [], [], [], lb, ub, @(x)GHKT_Constraints(x,p), options);

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
Yt(1) = ProductionFunction(K0, (1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N, energy(1), exp((-gamma(1))*(St(1)-Sbar)), p);Ct(1) = (1-x(1))*Yt(1);
Kt1(1) = x(1)*Yt(1)+(1-Delta)*K0;
for i = 1:1:T-2;
    Yt(1+i) = ProductionFunction(Kt1(i), (1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N, energy(1+i), exp((-gamma(1+i))*(St(1+i)-Sbar)), p);Kt1(1+i) = x(1+i)*Yt(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*Yt(1+i); 
end
Yt(T) = ProductionFunction(Kt1(T-1), (1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N, energy(T), exp((-gamma(T))*(St(T)-Sbar)), p);theta = x(T-1);
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
    Ytn(i) = ProductionFunction(Ktn(i), (1-x(2*(T-1)+2*T)-x(2*(T-1)+T))*N, En(i), exp((-gamma(T))*(St(T)-Sbar)), p);Ct(T+i) = (1-theta)*Ytn(i);
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
% load('Yt_ghkt_lf.mat','Yt_ghkt_lf');
% load('Yt_ghkt_v1.mat','Yt_ghkt_v1');
% net_gdp = zeros(T,1);
% for i = 1:1:T;
%     net_gdp_ghkt(i) = Yt_ghkt_v1(i)/Yt_ghkt_lf(i);
% end 
% z = 25; 
% figure; 
% plot(y2(1:z), net_gdp_ghkt(1:z),": ", 'LineWidth', 1.5);
% title('Net output: optimum versus laissez-faire');
% xlim([2000 2250])    

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

%% Self added: Extract
r_ghkt_v1 = x(1:T-1);
save('r_ghkt_v1','r_ghkt_v1');
oil_stock_ghkt_v1 = x(T:2*(T-1))  ;
save('oil_stock_ghkt_v1','oil_stock_ghkt_v1');
N2_ghkt_v1 = x(2*(T-1)+1:3*(T-1)-1);
save('N2_ghkt_v1', 'N2_ghkt_v1');
N3_ghkt_v1 = x(2*(T-1)+T+1:2*(T-1)+2*T);
save('N3_ghkt_v1','N3_ghkt_v1');
 
if ~isfolder('results'), mkdir('results'); end
save(fullfile('results', ['results_' scenario '.mat']), '*_ghkt_v1', 'x', 'p', 'exitflag', 'fval');