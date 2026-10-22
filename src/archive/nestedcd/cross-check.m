%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 1: Parameters        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Time%%
%%%%%%%%
T = 30;             %Number of direct optimization periods T
y = (1:1:T);        %Corresponding calendar years    
y(1) = 2025;
for i = 1:1:T-1
    y(1+i) = 2025+((i)*10);
end
n = 100;            %Number of pre-balanced growth path simulation periods after T
y2 = (1:1:T+n);     %Corresponding calendar years   
y2(1) = 2025;
   for i = 1:1:T-1+n
       y2(1+i) = 2025+((i)*10);
   end

%%Climate and Damages%%
%%%%%%%%%%%%%%%%%%%%%%%
phi = 0.0228;       %Carbon depreciation per annum (remaining share)
phiL = 0.2;         %Carbon emitted to the atmosphere staying there forever
phi0 = 0.393;       %Share of remaining emissions exiting atmosphere immediately
Sbar = 581;         %Pre-industrial atmospheric GtC
S1_2000 = 103;      %GtC
S2_2000 = 699;      %GtC

%% Climate damage parameter %%
gamma = zeros(T,1); 
for i = 1:1:T
    gamma(i) = 0.000023793; %Damage elasticity
end
 
%%Energy Aggregation%%
%%%%%%%%%%%%%%%%%%%%%%

% %% Option 1 (GHKT) 
% rho = -0.058;               %Elasticity of substitution = 0.945
% kappa1 = 0.5429;            %Relative efficiency of oil
% kappa2 = 0.1015;            %Relative efficiency of coal
% kappa3 = 1-kappa1-kappa2;   %Relative efficiency of low-carbon technologies

% %% Option 2 (Based on change in TWh 2014-2024)
rho = -0.058;
kappa1 = 0.455;
kappa2 = 0.078;
kappa3 = 1 - kappa1 - kappa2; 


%%Final Goods Production%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 1;                      %Normalize population
alpha = 0.33;               %Capital output share
%alpha = 0.66;
Y2024 = 110000;             %Base year (2024) annual GDP in billions of USD
r2024 = 0.05;               %Base year annual net rate of return 
r2024d = ((1+r2024)^10)-1;  %Base yer decadal net rate of return

%%%Depreciation OPTION 1: delta = 100%
delta = 1;                              %Annual depreciation rate
Delta = (1-(1-delta)^10);               %Decadal depreciation rate
K0 = (alpha*Y2024*10)/(r2024d+Delta);   %GHKT Base year capital stock in billions of USD

% %%%Depreciation OPTION 2: delta = 65%, no recalibration:
% delta = 0.1;                            %Annual depreciation rate
% Delta = (1-(1-delta)^10);               %Decadal depreciation rate
% Delta1 = 1;                             %Decadal 100% depreciation rate
% K0 = (alpha*Y2024*10)/(r2024d+Delta1);  %Base year capital stock in billions of USD

% %Depreciation OPTION 3: delta = 65%, with recalibration:
% delta = 0.1;                            %Annual depreciation rate
% Delta = (1-(1-delta)^10);               %Decadal depreciation rate
% K0 = (alpha*Y2024*10)/(r2024d+Delta);   %Base year capital stock in billions of USD

%Energy & TFP Calibration GHKT: 
 % pi00 = 1;               %Base period share of labor devoted to final goods production
 % E1_2008 = 3.43+1.68;    %GtC per annum
 % E2_2008 = 3.75;         %GtC per annum
 % E3_2008 = 1.95;         %GtC-eq per annum 
 % E0_2008 = ((kappa1*E1_2008^rho)+(kappa2*E2_2008^rho)+(kappa3*E3_2008^rho))^(1/rho);
 % E0 = E0_2008*10;        %GtC per decade
 % A0 = (Y2009*10)/((exp((-gamma(1))*((S1_2000+S2_2000)-Sbar)))*((K0^alpha)*((N*pi00)^(1-alpha-v))*(E0^v)));  %Initial TFP based on Decadal production function

 %NEW (Using IEA data):
 pi00 = 1;               %Base period share of labor devoted to final goods production
 E1_2024 = 55.292;       %x1000 TWh per year
 E2_2024 = 45.851;       %x1000 TWh per year
 E3_2024 = 9.225;        %x1000 TWh per year
 E0_2024 = ((kappa1*E1_2024^rho)+(kappa2*E2_2024^rho)+(kappa3*E3_2024^rho))^(1/rho);
 E0 = E0_2024*10;        %x1000 TWh per decade

%%%Productivity Growth Rates%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Energy Sector GHKT %%%
% gZa_en = 0.02;                                         %Annual labor productivity growth rate (energy sectors)
% gZ_en = ((1+gZa_en)^10)-1;                             %Decadal labor productivity growth rate (energy sectors)

%%%Energy Sector Productivities%%%
gZa_coal = 0.01;                                         %Annual labor productivity growth rate (coal sectors)
gZ_coal = ((1+gZa_coal)^10)-1;                           %Decadal labor productivity growth rate (coal sectors)

gZa_green = 0.02;                                         %Annual labor productivity growth rate (E3 sectors)
gZ_green = ((1+gZa_green)^10)-1;                          %Decadal labor productivity growth rate (E3 sectors)

%%%Productivity growth of capital in final goods production%%%
gKa_y = 0.02;                       % annual
gKd_y = ((1+gKa_y)^10)-1;           % decadal 

%%%Final Goods Sector OPTION 1: Specify Labor Productivity Growth%%%
%           gZa_y = 0.02;                               %Annual labor productivity growth rate in final goods sector
%           gAa_y = (1+gZa_y)^(1-alpha-v);              %Corresponding TFP growth
%           gZd_y = ones(T+n,1)*(((1+gZa_y)^10)-1);     %Decadal labor productivity growth rate (all sectors)
%  
%%%Final Goods Sector OPTION 2: Specify TFP Growth%%%
%            gAa_y = 0.02;                            %Annual TFP growth rate (final output sector)
             gAa_y = 0;                               %Alt. Annual TFP growth rate (final output sector)
             %Commented out for new PF: gZa_y = ((1+gAa_y)^(1/(1-alpha-v)))-1;   %Corresponding annual labor productivity growth rate (final output sector)
             gZa_y = 0;
             gAd_y = ((1+gAa_y)^10)-1;                %Decadal TFP growth rate (final output sector)
             gZd_y = ones(T+n,1)*(((1+gZa_y)^10)-1);  %Decadal labor productivity growth rate (final output sector)
 

%%Final Good Sector TFP Levels%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%COMMENTED OUT FOR NEW PF
% At = zeros(T,1);
% At(1) = A0;                 
% for i = 1:1:T-1;
%   At(i+1) = At(i)*(1+gZd_y(i))^(1-alpha-v);     
% end

%%Long-run Output Growth Rate on BGP%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gZBGP = gZd_y(T);             
% gZBGP = gZ_en;      %Alternative possible value for gTFP=1.5% to roughly account for declining oil output   

%%Utility%%
%%%%%%%%%%%  
sigma = 1;         %Logarithmic preferences


%%Beta OPTION 1: Specify exogenously%%%
beta = (.985)^10;  
%beta = (.999)^10;


%%Coal production%%
%%%%%%%%%%%%%%%%%%%
A2t = zeros(T,1);
%A2t(1) = 7693; %v1;GHKT 
A2t(1) = 11169.231; %v3; x1000 TWh 
%A2t(1) = 18340.4; %v4; x1000 TWh
for i = 1:1:T-1
    A2t(i+1) = A2t(i)*(1+gZ_coal);
end

%%Coal Emissions%%
% %%%%%%%%%%%%%%%%%%
ypsilon = zeros(T,1);   %Coal carbon emissions coefficient
a_yps = 8;              %Logistic curve coefficient
b_yps = -0.05;          %Logistic curve coefficient
for i = 1:1:T+n
     ypsilon(i) = 1/(1+exp((-1)*(a_yps+b_yps*(i-1)*10)));
     %ypsilon(i) = 1;
end


%%Graph for Figure S.1%%
figure;
plot(y,ypsilon(1:T),'-o')
xlabel('Year','FontSize',11)
ylabel('Coal Emissions Coefficient','FontSize',11)
title('Coal Emissions Coefficient','FontSize',13)
grid off;

%%Low Carbon Energy Production%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A3t = zeros(T,1);
%A3t(1) = 1311;  %GHKT
%A3t(1) = 865.14; %v1; Chazels Initial labour productivity in the low carbon energy sector E3, in Gt/L
A3t(1) = 3399.331; %v3; x1000 TWh
%A3t(1) = 2306.25;  %v4; in x1000 TWh
%A3t(1) = 5581.86; %x1000 TWh (based on relative price between coal and renewables)
for i = 1:1:T-1
    A3t(i+1) = A3t(i)*(1+gZ_green); 
end

%%Oil%%
%%%%%%%

%R0 = 253.8;    %Golosov
%R0 = 1068;     %x1000 TWh lower bound guess (petrol)
R0 = 2720;      %x1000 TWh upper bound guess (crude oil)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%SELF ADDED FOR ENERGY AND EXERGY
en_K = zeros(T,1);
eff_E = zeros(T,1);

eff_E(1) = 0.33;                    % initial aggregate efficiency of energy to exergy
en_K(1) = (eff_E(1) * E0)/(K0*10);  % x1000 TWh per decade

gEk = 0.00;       % decadal growth rate of energy throughput of capital
gEff = 0.00;
% gEk = 0.02;         % decadal growth rate of energy throughput of capital
% gEff = 0.02;        % decadal growth rate of energy-to-exergy efficiency

for i = 1:1:T-1
    en_K(i+1) = en_K(i)*(1+gEk);    
    eff_E(i+1) = eff_E(i)*(1+gEff);  
end

%%%%%%%%%%%%           Self Added for Mineral Constraints          %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% !!!!!!!!! CHANGE LATER!!!!!!!!!!!!
M0 = 2000;    % Initial mineral endowment in megatonnes, Mt

%delta_G = 0.1;                                        % Annual depreciation rate of green capital (potentially change later)
delta_G = 1; 
Delta_G = (1-(1-delta_G)^10);                           % Decadal depreciation rate
G0 = 53.8;                                              % MtCu Based on annual demand for clean tech in 2021 * 10
rho_E3 = -3;                                            % Parameter of substitution E3
psi = 1.462;                                            % Energy obtained from given amount of green capital, in x1000TWh/MtCu
phi_m = 1;                                              % Efficiency of minerals in producing green capital


%% Relative efficiencies
dkM = 0.00; 
%dkM = 0.02;                                            % Annual decline in relative efficiency of minerals for green capital
kappaM = zeros(T,1);                                   % Relative efficiency of minerals in the production of green capital
kappaL = zeros(T,1);                                   % Relative efficiency of labour in the production of green capital

kappaM(1) = 0.75;   
kappaL(1) = 1-kappaM(1);
for i = 1:1:T-1
    kappaM(1+i) = kappaM(1);
    kappaL(1+i) = 1-kappaM(1);
    % kappaM(1+i) = kappaM(i)*(1-dkM)^10;
    % kappaL(1+i) = 1-kappaM(1+i);
end                                 

% in_GDP = 1.3; 
%Useful energy intensity of GDP
u1_cap = en_K(1) * (K0*10);            %capital-side usable energy at T=1 in x1000TWh per decade 
u1_energy = eff_E(1) * E0;             %energy-side usable energy at T=1 in x1000TWh per decade
usable1 = min(u1_cap, u1_energy); 
Yt1_model = usable1.^alpha;       
in_GDP = Yt1_model / (Y2024*10);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 2: Solve for Optimal Choice Variables X        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vars = 2*T+3*(T-1);         %Number of variables = 147

%%Define upper and lower bounds%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%NEW
lb = zeros(vars,1);
ub = ones(vars,1);
for i = 1:1:2*T
    ub(2*(T-1)+i) = 1;        %For coal and E3 labor shares 
    lb(2*(T-1)+i) = 0.00000001;  %For coal and E3 labor shares 
end
for i = 1:1:T-1
    ub(i) = 1;                     %For savings rate
    lb(i) = 0.00000001;            %For savings rate
    ub((T-1)+i) = R0;              %For oil stock remaining Rt
    lb((T-1)+i) = 0.00000001;      %For oil stock remaining Rt
    ub(2*(T-1)+2*T+i) = M0;        %For mineral stock remaining 
    lb(2*(T-1)+2*T+i) = 0.00000001;%For mineral stock remaining 
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
%COMMENTED OUT (TO LOAD PREVIOUS RESULT) 

%load('x_baseline','x')
%load('x_nestedcd_lf','x')


%TO ENSURE X0 LOAD PREVIOUS RESULTS X
%x0 = x;

%%% OPTION 2: NEUTRAL STARTING POINT %%

x0 = zeros(vars,1);
for i = 1:1:T-1
     x0(i) = 0.25;                       %savings rate
     x0((T-1)+i) = R0-((R0/1.1)/T)*i;    %oil stock remaining
     x0(2*(T-1)+i) = 0.002;              %labour share coal
     x0(2*(T-1)+T+i) = 0.01;             %labour share green capital
     x0(2*(T-1)+2*T+i) = M0-((M0/1.1)/T)*i; %energy share capital
end
x0(2*(T-1)+T) = 0.002;
x0(2*(T-1)+T+T) = 0.01;

%%Check Constraints and Objective Function Value at x0%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for NEW PF lf: remove gamma
f = nestedcd_Objective(x0,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,in_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gKd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon);
[c, ceq] = nestedcd_Constraints(x0,A2t,A3t,Delta_G,Delta,en_K,eff_E,G0,in_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gKd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon);

%%%%%%%%%%%
%%%SOLVE%%%
%%%%%%%%%%%

%OLD: options = optimoptions(@fmincon,'Tolfun',1e-12,'TolCon',1e-12,'MaxFunEvals',500000,'MaxIter',6200,'Display','iter','MaxSQPIter',10000,'Algorithm','active-set');
options = optimoptions(@fmincon,'Tolfun',1e-12,'TolCon',1e-12,'MaxFunEvals',500000,'MaxIter',6200,'Display','iter','MaxSQPIter',10000,'Algorithm','interior-point');
[x, fval,exitflag] = fmincon(@(x)nestedcd_Objective(x,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,in_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gKd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon), x0, [], [], [], [], lb, ub, @(x)nestedcd_Constraints(x,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,in_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gKd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon), options);


%%Save Output%%
%%%%%%%%%%%%%%%
%File name structure:
%x_scenario_version

%save('x_nestedcd_lf','x')
save('x_baseline','x')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 3: Compute Allocations and Carbon Taxes  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%
%%Energy%%
%%%%%%%%%%
oil = zeros(T,1);
    oil(1) = R0-x(T);
for i = 1:1:T-2
    oil(1+i) = x(T+i-1)-x(T+i);
end
    ex_Oil = (x(T-1+T-2)-x(T-1+T-1))/(x(T-1+T-2));    %Fraction of oil left extracted in period T-1
    oil(T) = x(T-1+T-1)*ex_Oil;
ex_rates = zeros(T-1,1);
for i = 1:1:T-1
    ex_rates(i) = oil(i)/x(T+i-1);
end
coal = zeros(T,1);
for i = 1:1:T
    coal(i) = x(2*(T-1)+i)*A2t(i)*N;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% INDEX FOR MINERAL STOCK = x0(2*(T-1)+2*T+i)
mineral = zeros(T,1);
    mineral(1) = M0-x(2*(T-1)+2*T+1);
for i = 1:1:T-2
    mineral(1+i) = x(2*(T-1)+2*T+i)-x(2*(T-1)+2*T+i+1);
end
    ex_Min = (x(2*(T-1)+2*T+(T-3))-x(2*(T-1)+2*T+(T-2)))/(x(2*(T-1)+2*T+(T-3)));    %Fraction of minerals left extracted in period T-1
    mineral(T) = x(2*(T-1)+2*T+(T-2))*ex_Min;

%% Index for labour share Green Energy = x0(2*(T-1)+T+i)
%%Green capital production
green = zeros(T,1);
for i = 1:1:T
     green(i) = (((kappaL(i)*(x(2*(T-1)+T+i)*A3t(i)*N)^rho_E3)+(kappaM(i)*(phi_m*mineral(i))^rho_E3)))^(1/rho_E3);
end

%%Green capital stock (comment out for Delta_G = 1)
Gt1 = zeros(T,1);
Gt1(1) = green(1)+(1-Delta_G)*G0;
for i = 1:1:T-2
    Gt1(1+i) = green(1+i)+(1-Delta_G)*Gt1(i);
end
 Gt1(T) = green(T)+(1-Delta_G)*Gt1(T-1);

%%Low carbon energy production, eq (10)
E3 = zeros(T,1);
for i = 1:1:T
       E3(i) = psi*Gt1(i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

energy = zeros(T,1);
for i = 1:1:T
    energy(i) = ((kappa1*oil(i)^rho)+(kappa2*coal(i)^rho)+(kappa3*E3(i)^rho))^(1/rho);
end

%% compute fossil fuel use
fossil_fuel = zeros(T,1);
for i = 1:1:T
    fossil_fuel(i) = oil(i) + coal(i);
end

%% compute energy shares
total_energy = zeros(T,1);
share_coal = zeros(T,1);
share_oil = zeros(T,1);
share_E3 = zeros(T,1);
for i = 1:1:T
    total_energy(i) = coal(i) + oil(i) + E3(i);
    share_coal (i) = coal(i) / total_energy(i);
    share_oil (i) = oil(i) / total_energy(i);
    share_E3 (i) = E3(i) / total_energy(i);
end

%%% Plot energy shares
z = 25;
figure;
plot(y2(1:z), share_coal(1:z), 'LineWidth', 1.5);
hold on;
plot(y2(1:z),share_oil(1:z), 'LineWidth', 1.5);
plot(y2(1:z),share_E3(1:z), 'LineWidth', 1.5);
xlabel('Year');
ylabel('Energy Share');
title('Allocation of Energy Sources Over Time');
legend('Coal', 'Oil', 'Low Carbon Energy');
grid off;
hold off;

%% Plot energy sources over time
z = 25;
figure;
plot(y2(1:z),oil(1:z), '-b', 'LineWidth', 2);
hold on;
plot(y2(1:z),E3(1:z), '-g', 'LineWidth', 2);
plot(y2(1:z),coal(1:z), '-r', 'LineWidth', 2); 
ylabel('Energy (x1000 TWh)')
xlabel('Year');
ylabel('Energy production (TWh)');
title('Energy production from Coal, Oil, and Renewables');
legend({'Coal', 'Oil', 'Renewables'}, 'Location', 'best');
grid off;



%%%%%%%%%%%%%
%%Emissions%%
%%%%%%%%%%%%%
emiss = zeros(T,1);
emiss_coal = zeros(T,1);
emiss_oil = zeros(T,1); 
for i = 1:1:T
    emiss_coal(i) = ypsilon(i)*coal(i)*0.1008; 
    emiss_oil(i) = oil(i)* 0.0676; 
    emiss(i) = emiss_coal(i)+emiss_oil(i);
end

%plot coal emissions
z=25;
figure;
plot(y2(1:z),emiss_coal(1:z),"-",'LineWidth', 1);
hold on;
plot(y2(1:z),emiss_oil(1:z),"-", 'LineWidth', 1);
ylabel('Emissions');
xlabel('Time');
title('Emissions');
legend({'Coal', 'Oil'}, 'Location', 'best');



S1t = zeros(T,1);        %Non-depreciating carbon stock
S2t_Sbar = zeros(T,1);   %Depreciating carbon stock (S2t-Sbar)
St = zeros(T,1);         %Total carbon concentrations

S1t(1) = S1_2000+phiL*emiss(1);
S2t_Sbar(1) = (1-phi)*(S2_2000-Sbar)+phi0*(1-phiL)*emiss(1);
St(1) = Sbar+S1t(1)+S2t_Sbar(1);
for i = 1:1:T-1
    S1t(1+i) = S1t(i)+phiL*emiss(1+i);
    S2t_Sbar(1+i) = (1-phi)*S2t_Sbar(i)+phi0*(1-phiL)*emiss(1+i);
    St(1+i) = Sbar+S1t(1+i)+S2t_Sbar(1+i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Output and Consumption through T%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Yt = zeros(T,1);
Ct = zeros(T,1);
Kt1 = zeros(T,1);
GDP = zeros(T,1);
Yt(1) = (exp((-gamma(1))*(St(1)-Sbar)))*(min(en_K(1)*K0,eff_E(1)*energy(1))^alpha)*(((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha));
    %Yt(1) = (min(en_K(1)*K0,eff_E(1)*energy(1))^alpha)*(((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha));
GDP(1) = Yt(1)/(in_GDP);
Ct(1) = (1-x(1))*GDP(1);
Kt1(1) = x(1)*GDP(1)+(1-Delta)*K0;
for i = 1:1:T-2
    Yt(1+i) = (exp((-gamma(1+i))*(St(1+i)-Sbar)))*(min(en_K(1+i)*Kt1(i),eff_E(1+i)*energy(1+i))^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha));
          %Yt(1+i) = (min(en_K(1+i)*Kt1(i),eff_E(1+i)*energy(1+i))^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha));
    GDP(1+i) = Yt(1+i)/(in_GDP);  %in billion dollars
    Kt1(1+i) = x(1+i)*GDP(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*GDP(1+i); 
end
Yt(T) =  (exp((-gamma(T))*(St(T)-Sbar)))*(min(en_K(T)*Kt1(T-1),eff_E(T)*energy(T))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));
    %Yt(T) =  (min(en_K(T)*Kt1(T-1),eff_E(T)*energy(T))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));
GDP(T) = Yt(T)/in_GDP;
theta = x(T-1);
Ct(T) = GDP(T)*(1-theta);
Kt1(T) = theta*GDP(T)+(1-Delta)*Kt1(T-1);

%Compare savings rate theta to predicted BGP savings rate:
%theta_BGP = alpha*(((((1+gZBGP)^sigma)/beta)-(1-Delta))^(-1))*(1+gZBGP-1+Delta)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Output and Consumption past T to T+n%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 100;
Ktn = zeros(n+1,1);
Ytn = zeros(n,1);
GDPn = zeros(n,1);
Ktn(1) = Kt1(T); 
oiln = zeros(n,1);
En = zeros(n,1);
minbgp = zeros(n,1);
greenbgp = zeros(n,1);
E3bgp = zeros(n,1);
Gtn = zeros(n+1,1);
Gtn(1) = Gt1(T);


for i = 1:1:n
    oiln(i) = ex_Oil*x(2*(T-1))*((1-ex_Oil)^i);     %Oil continues to be extracted at rate from period T-1
    minbgp(i) = ex_Min*x(2*(T-1)+2*T+(T-1))*((1-ex_Min)^i);
    greenbgp(i) = ((kappaL(T)*(x(2*(T-1)+2*T)*(A3t(T)*(1+gZ_green)^i)^rho_E3)+(kappaM(T)*minbgp(i))^(rho_E3)))^(1/rho_E3);
    Gtn(i+1) = greenbgp(i) + (1-Delta_G)*Gtn(i);
    E3bgp(i) = psi*Gtn(i);
    En(i) = ((kappa1*oiln(i)^rho)+(kappa2*(coal(T)*(1+gZ_coal)^i)^rho)+(kappa3*E3bgp(i)^rho))^(1/rho);
    Ytn(i) =  (exp((-gamma(T))*(St(T)-Sbar)))*(min(en_K(T)*Ktn(i),eff_E(T)*En(i))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));    
        %Ytn(i) = (min(en_K(T)*Ktn(i),eff_E(T)*En(i))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));     
    GDPn(i) = Ytn(i)/in_GDP;
    Ct(T+i) = (1-theta)*GDPn(i);
    Ktn(i+1) = theta*GDPn(i)+(1-Delta)*Ktn(i);
    Yt(T+i) = Ytn(i);
    GDP(T+i) = GDPn(i);
end

%% Ratio of capital capacity versus energy supply
capacity_k = zeros(T,1);
supply_e = zeros(T,1);
ratio = zeros(T,1);

for i = 1:1:T
capacity_k(i) = en_K(i)*Kt1(i);
supply_e(i) = eff_E(i)*energy(i);
ratio(i) = capacity_k(i)/supply_e(i);
end

figure;
plot(1:T,ratio,'-o');
xlabel('period');
ylabel('Ratio');
title('Energy-Capacity versus Energy Supply');



%%%%%%%%%%%%%%%%%%%%%%%%
%%Optimal Carbon Taxes%%
%%%%%%%%%%%%%%%%%%%%%%%%

%%Goal: Plug allocations into optimal tax formula (paper equation (9))%%

%%Step 1: Compute vectors of marginal utilities and marginal emissions impacts {dSt+j/dEt}%%
MU = zeros(T+n,1);        %Marginal utility
MD = zeros(T+n,1);        %Marginal emissions impact on St {dSt+j/dEt}
for i = 1:1:T+n
    MU(i) = Ct(i)^(-sigma);
    MD(i) = phiL+(1-phiL)*phi0*(1-phi)^(i-1);
end

%%Step 2: Compute Tax Path%%%
%% COMMENT OUT FOR LF SCn %%%
carbon_tax = zeros(T,1);    %Carbon tax level in $/mtC [since Yt is in $ billions and Et is in GtC]
lambda_hat = zeros(T,1);    %Carbon tax/GDP ratio

for i = 1:1:T+n
    temp2 = zeros(T+n-i+1,1);
        for j = 1:1:T+n-i+1
            temp2(j) = (beta^(j-1))*(MU(i+j-1)/MU(i))*(-gamma(T))*Yt(i+j-1)*MD(j);
        end
     carbon_tax(i) = sum(temp2)*(-1);
     lambda_hat(i) = carbon_tax(i)/Yt(i);
end

%%Temperature%%
%%%%%%%%%%%%%%%%%
lambda = 3.0;               % Climate sensitivity parameter
temp = zeros(T,1);          % Initialize the temperature vector
for i = 1:1:T
    temp(i) = lambda * log2(St(i)/Sbar);
end


%%%%%%%%       SAVES FOR OPTIMAL SCENARIO    %%%%%%%%%%%%%%%%%%

%% Extract from x-vector
r_baseline = x(1:T-1);
save('r_baseline','r_baseline');
oil_stock_baseline = x(T:2*(T-1));
save('oil_stock_baseline','oil_stock_baseline');
N2_baseline = x(2*(T-1)+1:3*(T-1));
save('N2_baseline', 'N2_baseline');
N3_baseline = x(2*(T-1)+T+1:2*(T-1)+2*T);
save('N3_baseline','N3_baseline');
shareK_baseline = x(2*(T-1)+2*T+1 : 2*(T-1)+2*T-1); 
save('shareK_baseline','shareK_baseline');
mineral_stock_baseline = x(4*T-1:5*T-3);
save('mineral_stock_baseline','mineral_stock_baseline');

% Save
energy_baseline = energy;
save('energy_baseline','energy_baseline')
fossil_fuel_baseline = fossil_fuel;
save('fossil_fuel_baseline','fossil_fuel_baseline')
oil_baseline = oil;
save('oil_baseline','oil_baseline')
ex_rates_baseline = ex_rates;
save('ex_rates_baseline','ex_rates_baseline')
coal_baseline = coal;
save('coal_baseline','coal_baseline')
E3_baseline = E3;
save('E3_baseline','E3_baseline')
lambda_hat_baseline = lambda_hat;
save('lambda_hat_baseline','lambda_hat_baseline')
carbon_tax_baseline = carbon_tax;
save('carbon_tax_baseline','carbon_tax_baseline')
Yt_baseline = Yt;
save('Yt_baseline','Yt_baseline')
Ct_baseline = Ct;
save('Ct_baseline','Ct_baseline')
temp_baseline = temp;
save('temp_baseline','temp_baseline');
carbon_baseline = emiss;
save('carbon_baseline','carbon_baseline');
cumul_emiss_baseline = St;
save('cumul_emiss_baseline','cumul_emiss_baseline');
mineral_baseline = mineral;
save('mineral_baseline','mineral_baseline');
green_baseline = green;
save('green_baseline','green_baseline');
gdp_baseline = GDP; 
save('gdp_baseline', 'gdp_baseline');
Gt1_baseline = Gt1;
save('Gt1_baseline','Gt1_baseline');
emiss_coal_baseline = emiss_coal;
save('emiss_coal_baseline','emiss_coal_baseline');
emiss_oil_baseline = emiss_oil;
save('emiss_oil_baseline','emiss_oil_baseline');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%   SAVES FOR LAISSEZ-FAIRE SCENARIO      %%%%%%%%%%%%%%%%
% 
% %Extract from x-vector
% r_nestedcd_lf = x(1:T-1);
% save('r_nestedcd_lf','r_nestedcd_lf');
% oil_stock_nestedcd_lf = x(T:2*(T-1));
% save('oil_stock_nestedcd_lf','oil_stock_nestedcd_lf');
% N2_nestedcd_lf = x(2*(T-1)+1:3*(T-1));
% save('N2_nestedcd_lf', 'N2_nestedcd_lf');
% N3_nestedcd_lf = x(2*(T-1)+T+1:2*(T-1)+2*T);
% save('N3_nestedcd_lf','N3_nestedcd_lf');
% shareK_nestedcd_lf = x(2*(T-1)+2*T+1 : 2*(T-1)+2*T-1); 
% save('shareK_nestedcd_lf','shareK_nestedcd_lf');
% mineral_stock_nestedcd_lf = x(4*T-1:5*T-3);
% save('mineral_stock_nestedcd_lf','mineral_stock_nestedcd_lf');
% 
% % Save
% energy_nestedcd_lf = energy;
% save('energy_nestedcd_lf','energy_nestedcd_lf')
% fossil_fuel_nestedcd_lf = fossil_fuel;
% save('fossil_fuel_nestedcd_lf','fossil_fuel_nestedcd_lf')
% oil_nestedcd_lf = oil;
% save('oil_nestedcd_lf','oil_nestedcd_lf')
% ex_rates_nestedcd_lf = ex_rates;
% save('ex_rates_nestedcd_lf','ex_rates_nestedcd_lf')
% coal_nestedcd_lf = coal;
% save('coal_nestedcd_lf','coal_nestedcd_lf')
% E3_nestedcd_lf = E3;
% save('E3_nestedcd_lf','E3_nestedcd_lf')
% lambda_hat_nestedcd_lf = lambda_hat;
% save('lambda_hat_nestedcd_lf','lambda_hat_nestedcd_lf')
% carbon_tax_nestedcd_lf = carbon_tax;
% save('carbon_tax_nestedcd_lf','carbon_tax_nestedcd_lf')
% Yt_nestedcd_lf = Yt;
% save('Yt_nestedcd_lf','Yt_nestedcd_lf')
% Ct_nestedcd_lf = Ct;
% save('Ct_nestedcd_lf','Ct_nestedcd_lf')
% temp_nestedcd_lf = temp;
% save('temp_nestedcd_lf','temp_nestedcd_lf');
% carbon_nestedcd_lf = emiss;
% save('carbon_nestedcd_lf','carbon_nestedcd_lf');
% cumul_emiss_nestedcd_lf = St;
% save('cumul_emiss_nestedcd_lf','cumul_emiss_nestedcd_lf');
% mineral_nestedcd_lf = mineral;
% save('mineral_nestedcd_lf','mineral_nestedcd_lf');
% green_nestedcd_lf = green;
% save('green_nestedcd_lf','green_nestedcd_lf');
% gdp_nestedcd_lf = GDP; 
% save('gdp_nestedcd_lf', 'gdp_nestedcd_lf');
% Gt1_nestedcd_lf = Gt1;
% save('Gt1_nestedcd_lf','Gt1_nestedcd_lf');
% emiss_coal_nestedcd_lf = emiss_coal;
% save('emiss_coal_nestedcd_lf','emiss_coal_nestedcd_lf');
% emiss_oil_nestedcd_lf = emiss_oil;
% save('emiss_oil_nestedcd_lf','emiss_oil_nestedcd_lf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%//////////      FIGURES PART 1: THESIS RESULTS      \\\\\\\\\\\\%%%
% terrared = [0.55 0.27 0.07];   % dark terra-like red (coal)
% paleorange = [0.95 0.65 0.2];  % pale orange/yellow (oil)
% greenlc = [0.2 0.7 0.3];       % green (low-carbon)
% 
% 
% %%// FIG 1
% 
% %% Coal production: Optimal versus LF
% load('coal_baseline.mat','coal_baseline');
% load('coal_nestedcd_lf.mat','coal_nestedcd_lf');
% z=20;
% figure;
% plot(y2(1:z),coal_baseline(1:z),"-",'Color', terrared, 'LineWidth', 1.5);
% hold on;
% plot(y2(1:z),coal_nestedcd_lf(1:z),"--",'Color', terrared, 'LineWidth', 1.5);
% ylabel('Energy (x1000 TWh)');
% xlabel('Time');
% title('Coal Production');
% legend({'Baseline', 'Laissez-faire'}, 'Location', 'northwest');
% xlim([2025 2200])
% 
% 
% %% Emissions Coal
% load('coal_ghkt_v1.mat','coal_ghkt_v1');
% load('emiss_coal_baseline.mat','emiss_coal_baseline');
% load('emiss_coal_nestedcd_lf.mat','emiss_coal_nestedcd_lf');
% z=20;
% figure;
% plot(y2(1:z),emiss_coal_baseline(1:z),"-",'Color', terrared, 'LineWidth', 1.5);
% hold on;
% plot(y2(1:z),emiss_coal_nestedcd_lf(1:z),"--",'Color', terrared, 'LineWidth', 1.5);
% plot(y2(1:z),coal_ghkt_v1(1:z),":",'Color', terrared, 'LineWidth', 1.5);
% ylabel('Emissions (GtC)');
% xlabel('Time');
% title('Emissions from coal');
% legend({'Baseline', 'Laissez-faire','GHKT'}, 'Location', 'best');
% xlim([2025 2200])
% 
% 
% %%// FIG 2: OIL PRODUCTION: OPTIMAL VS LF 
% load('oil_baseline.mat','oil_baseline');
% load('oil_nestedcd_lf.mat','oil_nestedcd_lf');
% z=20;
% figure;
% plot(y2(1:z),oil_baseline(1:z),"-",'Color', paleorange, 'LineWidth', 1.5);
% hold on;
% plot(y2(1:z),oil_nestedcd_lf(1:z),"--",'Color', paleorange, 'LineWidth', 1.5);
% ylabel('Energy (x1000 TWh)');
% xlabel('Time');
% title('Oil production');
% legend({'Baseline', 'Laissez-faire'}, 'Location', 'best');
% xlim([2025 2200])
% ylim([82 83])
% 
% %% Emissions Oil
% load('oil_ghkt_v1.mat','oil_ghkt_v1');
% load('emiss_oil_baseline.mat','emiss_oil_baseline');
% load('emiss_oil_nestedcd_lf.mat','emiss_oil_nestedcd_lf');
% z=20;
% figure;
% plot(y2(1:z),emiss_oil_baseline(1:z),"-",'Color',paleorange,'LineWidth', 1.5);
% hold on;
% plot(y2(1:z),emiss_oil_nestedcd_lf(1:z),"--",'Color',paleorange,'LineWidth', 1.5);
% plot(y2(1:z),oil_ghkt_v1(1:z),":",'Color',paleorange, 'LineWidth', 1.5);
% ylabel('Emissions');
% xlabel('Time');
% title('Emissions from oil');
% legend({'Baseline', 'Laissez-faire','GHKT'}, 'Location', 'best');
% xlim([2025 2200])

%%// FIG 3: ENERGY MIX: OPTIMAL & GHKT    



%%// FIG 4: EMISSIONS & TEMPERATURE     


% 
% 
% 
% %% Temperature
% load('temp_baseline.mat', 'temp_baseline');
% load('temp_nestedcd_lf.mat','temp_nestedcd_lf');
% load('temp_ghkt_v1.mat','temp_ghkt_v1');
% z = 20; 
% figure;
% plot(y2(1:z), temp_baseline(1:z), '-', 'LineWidth', 1.5);
% hold on
% plot(y2(1:z), temp_nestedcd_lf(1:z), '--', 'LineWidth', 1.5);
% plot(y2(1:z), temp_ghkt_v1(1:z), ':', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Temperature (°C)', 'FontSize', 11);
% title('Temperature Increase');
% legend({'Baseline', 'Laissez-faire','GHKT'}, 'Location', 'best');
% 
% 
% %%// FIG 5: GDP OPTIMAL VS GHKT           
% load('Yt_ghkt_v1.mat','Yt_ghkt_v1');
% load('gdp_baseline.mat','gdp_baseline');
% load('gdp_nestedcd_lf.mat','gdp_nestedcd_lf');
% z = 25; 
% figure; hold on;
% plot(y2(1:z), gdp_baseline(1:z),"-", 'LineWidth', 1.5);
% plot(y2(1:z), gdp_nestedcd_lf(1:z),"--",'LineWidth',1.5);
% plot(y2(1:z), Yt_ghkt_v1(1:z),": ", 'LineWidth', 1.5);
% hold off;
% xlabel('Year', 'FontSize', 11);
% ylabel('GDP (billion $)', 'FontSize', 11);
% title('GDP: Baseline vs GHKT');
% legend('Baseline','Laissez-Faire','GHKT','Location', 'best');
% 


%%%%%%%%%%%%% FIG 6: LOW CARBON ENERGY PRODUCTION %%%%%%%%%%%%%%%%%%%%
%
%E3_baseline = E3;
%save('E3_baseline','E3_baseline');
%E3_dkm_dg = E3;
%save('E3_dkm_dg','E3_dkm_dg');
%E3_dkm = E3;
%save('E3_dkm','E3_dkm');
%E3_dg = E3;
%save('E3_dg','E3_dg');
%
%%%%%%%%%%% PLOT ONCE SAVED 
% z - 20;
% figure;
% hold on; 
% plot(Z, E3_basline, 'Baseline', 'E3_basline');
% plot(Z, E3_dkm_dg, '$\delta_G$', 'E3_dKm-dG');
% plot(Z, E3_dkm, '$\kappa_M$', 'E3_dKm');
% plot(Z, E3_dg, '$\delta_G$ & $\kappa_M', 'E3_dG');
% hold off;
% xlabel('Time (T)');
% ylabel('Energy (x1000 TWh)');
% title('Low-carbon energy production');
% legend show;








%%%%%%%%%%%%%%        Figures Optimal Scenario         %%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Graph Carbon Tax    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Carbon Tax per Unit of GDP
load('lambda_hat_baseline','lambda_hat_baseline')

z = 25;
figure;
plot(y2(1:z), lambda_hat_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Carbon Tax/GDP', 'FontSize', 11);
ylim([7.5e-05, 30.5e-05]);
title('Carbon Tax to GDP ratio (new production function)');


%% Carbon Tax in $/mtC
load('carbon_tax_baseline','carbon_tax_baseline')

z = 10;
figure;
plot(y2(1:z), carbon_tax_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Carbon Tax ($/mtC)', 'FontSize', 11);
title('Carbon Tax (new production function)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Energy Use Over Time  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Energy
load('energy_baseline.mat','energy_baseline')

z = 25;
figure;
plot(y2(1:z), energy_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('TWh', 'FontSize', 11);
title('Energy Use (new production function)');

%% Fossil Fuel
load('fossil_fuel_baseline.mat','fossil_fuel_baseline')

z = 25;
figure(Name='Fossil Fuel Use');
plot(y2(1:z), fossil_fuel_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (TWh)', 'FontSize', 11);
title('Fossil Fuel Use (new production function)');

%% Oil
load('oil_baseline.mat','oil_baseline')

z = 25;
figure(Name = 'Oil Use');
plot(y2(1:z), oil_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (TWh)', 'FontSize', 11);
title('Oil Use (new production function)');

%% Fraction of oil left extracted
load('ex_rates_baseline.mat','ex_rates_baseline')

z = 25;
figure;
plot(y2(1:z), ex_rates_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Rate', 'FontSize', 11);
title('Extraction rates of oil (new production function)');

%% Coal
load('coal_baseline.mat','coal_baseline')

z = 25;
figure(Name ='Coal Use');
plot(y2(1:z), coal_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (TWh)', 'FontSize', 11);
title('Coal Use (new production function)');

%% Low Carbon Energy
load('E3_baseline.mat','E3_baseline')

z = 25;
figure(Name = 'Wind');
plot(y2(1:z), E3_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (TWh)', 'FontSize', 11);
title('Low Carbon Energy Use (new production function)');

%% Mineral Use
load('mineral_baseline', 'mineral_baseline')

z = 25;
figure(Name ='Mineral Use');
plot(y2(1:z), mineral_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Minerals (MtCu)', 'FontSize', 11);
title('Mineral Use (new production function)');

%% Mineral Stock
load('mineral_stock_baseline', 'mineral_stock_baseline')

z = 25;
figure(Name ='Mineral Stock');
plot(y2(1:z), mineral_stock_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Minerals (MtCu)', 'FontSize', 11);
title('Mineral Stock (new production function)');

%% Green Capital
load('Gt1_baseline', 'Gt1_baseline')

z = 25;
figure(Name ='Green Capital Stock');
plot(y2(1:z), Gt1_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Green Capital Stock (MtCu)', 'FontSize', 11);
title('Green Capital Stock (new production function)');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  Climate Impact        %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Emissions
load('carbon_baseline', 'carbon_baseline')

z = 25;
figure(Name='Carbon Emissions');
plot(y2(1:z), carbon_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Emissions (GtC)', 'FontSize', 11);
title('Emissions (new production function)');

%% Temperature
load('temp_baseline', 'temp_baseline')

figure(Name='Temperature Increase');
plot(y2(1:T), temp_baseline, ' -r', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Temperature Increase (degrees C)', 'FontSize', 11);
title('Temperature Increase (new production function)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Labour shares         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Labour share to green capital
load('N3_baseline', 'N3_baseline')

z = 25;
figure(Name='Labour Share Green Capital');
plot(y2(1:z), N3_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Share to Green Capital Production (newpf)');

%% Labour share to coal
load('N2_baseline', 'N2_baseline')

z = 25;
figure(Name='Labour Share Coal');
plot(y2(1:z), N2_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Share to Coal Production (newpf)');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  GDP Growth Over Time  %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Output in TWh
load('Yt_baseline','Yt_baseline')

z = 25;
figure(Name='Output');
plot(y2(1:z), Yt_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Output (TWh)', 'FontSize', 11);
title('Output (new production function)');

%% Output in $
load('gdp_baseline','gdp_baseline')

z = 25;
figure(Name='GDP');
plot(y2(1:z), gdp_baseline(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('GDP ($)', 'FontSize', 11);
title('GDP (new production function)');

%%%%%%%%%%%%%%      End Figures Optimal Scenario        %%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%       Figures Laissez-Faire Scenario     %%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%      Graph Carbon Tax    %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Carbon Tax per Unit of GDP
% load('lambda_hat_nestedcd_lf','lambda_hat_nestedcd_lf')
% 
% z = 25;
% figure;
% plot(y2(1:z), lambda_hat_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Carbon Tax/GDP', 'FontSize', 11);
% ylim([7.5e-05, 30.5e-05]);
% title('Carbon Tax to GDP ratio (new production function)');
% 
% 
% %% Carbon Tax in $/mtC
% load('carbon_tax_nestedcd_lf','carbon_tax_nestedcd_lf')
% 
% z = 25;
% figure;
% plot(y2(1:z), carbon_tax_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Carbon Tax ($/mtC)', 'FontSize', 11);
% title('Carbon Tax (new production function)');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  Energy Use Over Time  %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Energy
% load('energy_nestedcd_lf.mat','energy_nestedcd_lf')
% 
% z = 25;
% figure;
% plot(y2(1:z), energy_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('TWh', 'FontSize', 11);
% title('Energy Use (new production function)');
% 
% %% Fossil Fuel
% load('fossil_fuel_nestedcd_lf.mat','fossil_fuel_nestedcd_lf')
% 
% z = 25;
% figure(Name='Fossil Fuel Use');
% plot(y2(1:z), fossil_fuel_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (TWh)', 'FontSize', 11);
% title('Fossil Fuel Use (new production function)');
% 
% %% Oil
% load('oil_nestedcd_lf.mat','oil_nestedcd_lf')
% 
% z = 25;
% figure(Name = 'Oil Use');
% plot(y2(1:z), oil_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (TWh)', 'FontSize', 11);
% title('Oil Use (new production function)');
% 
% %% Fraction of oil left extracted
% load('ex_rates_nestedcd_lf.mat','ex_rates_nestedcd_lf')
% 
% z = 25;
% figure;
% plot(y2(1:z), ex_rates_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Rate', 'FontSize', 11);
% title('Extraction rates of oil (new production function)');
% 
% %% Coal
% load('coal_nestedcd_lf.mat','coal_nestedcd_lf')
% 
% z = 25;
% figure(Name ='Coal Use');
% plot(y2(1:z), coal_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (TWh)', 'FontSize', 11);
% title('Coal Use (new production function)');
% 
% %% Low Carbon Energy
% load('E3_nestedcd_lf.mat','E3_nestedcd_lf')
% 
% z = 25;
% figure(Name = 'Wind');
% plot(y2(1:z), E3_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (TWh)', 'FontSize', 11);
% title('Low Carbon Energy Use (new production function)');
% 
% %% Mineral Use
% load('mineral_nestedcd_lf', 'mineral_nestedcd_lf')
% 
% z = 25;
% figure(Name ='Mineral Use');
% plot(y2(1:z), mineral_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Minerals (MtCu)', 'FontSize', 11);
% title('Mineral Use (new production function)');
% 
% %% Mineral Stock
% load('mineral_stock_nestedcd_lf', 'mineral_stock_nestedcd_lf')
% 
% z = 25;
% figure(Name ='Mineral Stock');
% plot(y2(1:z), mineral_stock_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Minerals (MtCu)', 'FontSize', 11);
% title('Mineral Stock (new production function)');
% 
% %% Green Capital
% load('Gt1_nestedcd_lf', 'Gt1_nestedcd_lf')
% 
% z = 25;
% figure(Name ='Green Capital Stock');
% plot(y2(1:z), Gt1_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Green Capital Stock (MtCu)', 'FontSize', 11);
% title('Green Capital Stock (new production function)');
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%  Climate Impact        %%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Emissions
% load('carbon_nestedcd_lf', 'carbon_nestedcd_lf')
% 
% z = 25;
% figure(Name='Carbon Emissions');
% plot(y2(1:z), carbon_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Emissions (GtC)', 'FontSize', 11);
% title('Emissions (new production function)');
% 
% %% Temperature
% load('temp_nestedcd_lf', 'temp_nestedcd_lf')
% 
% figure(Name='Temperature Increase');
% plot(y2(1:T), temp, ' -r', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Temperature Increase (degrees C)', 'FontSize', 11);
% title('Temperature Increase (new production function)');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  Labour shares         %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Labour share to green capital
% load('N3_nestedcd_lf', 'N3_nestedcd_lf')
% 
% z = 25;
% figure(Name='Labour Share Green Capital');
% plot(y2(1:z), N3_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Share', 'FontSize', 11);
% title('Labour Share to Green Capital Production (newpf)');
% 
% %% Labour share to coal
% load('N2_nestedcd_lf', 'N2_nestedcd_lf')
% 
% z = 25;
% figure(Name='Labour Share Coal');
% plot(y2(1:z), N2_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Share', 'FontSize', 11);
% title('Labour Share to Coal Production (newpf)');
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%  GDP Growth Over Time  %%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Output in TWh
% load('Yt_nestedcd_lf','Yt_nestedcd_lf')
% 
% z = 25;
% figure(Name='Output');
% plot(y2(1:z), Yt_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Output (TWh)', 'FontSize', 11);
% title('Output (new production function)');
% 
% %% Output in $
% load('gdp_nestedcd_lf','gdp_nestedcd_lf')
% 
% z = 25;
% figure(Name='GDP');
% plot(y2(1:z), gdp_nestedcd_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('GDP ($)', 'FontSize', 11);
% title('GDP (new production function)');

%%%%%%%%%%%%%%%%%%    End LF Figures           %%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%    Start Sensitivity        %%%%%%%%%%%%%%%%%%%%
%
% psi_factors = [1, 0.5, 0.25];     % multiply current psi by these
% G0_factors  = [1, 0.5, 0.25];     % multiply current G0 by these
% 
% results = struct();
% idx = 0;
% 
% for pf = psi_factors
%   for gf = G0_factors
%     idx = idx + 1;
%     psi_try = psi * pf;
%     G0_try  = G0  * gf;
% 
%     % ---- recompute Gt1 and E3 forward using x (same indexing you already use) ----
%     % recreate mineral (if needed) and green using your existing code pieces:
%     % NOTE: uses 'x' and variables like kappaL,kappaM,A3t,phi_m,rho_E3,Delta_G already in workspace
%     mineral_try = zeros(T,1);
%     mineral_try(1) = M0 - x(2*(T-1)+2*T+1);
%     for i = 1:T-2
%         mineral_try(1+i) = x(2*(T-1)+2*T+i) - x(2*(T-1)+2*T+i+1);
%     end
%     ex_Min_try = ( x(2*(T-1)+2*T+(T-3)) - x(2*(T-1)+2*T+(T-2)) ) / x(2*(T-1)+2*T+(T-3));
%     mineral_try(T) = x(2*(T-1)+2*T+(T-2)) * ex_Min_try;
% 
%     green_try = zeros(T,1);
%     for i = 1:T
%       green_try(i) = (((kappaL(i)*(x(2*(T-1)+T+i)*A3t(i)*N)^rho_E3) + (kappaM(i)*(phi_m*mineral_try(i))^rho_E3)))^(1/rho_E3);
%     end
% 
%     Gt1_try = zeros(T,1);
%     Gt1_try(1) = green_try(1) + (1-Delta_G)*G0_try;
%     for i = 1:T-2
%       Gt1_try(1+i) = green_try(1+i) + (1-Delta_G)*Gt1_try(i);
%     end
%     Gt1_try(T) = green_try(T) + (1-Delta_G)*Gt1_try(T-1);
% 
%     E3_try = psi_try * Gt1_try;
% 
%     % recompute coal, oil, energy exactly as in your script (using x and A2t)
%     coal_try = zeros(T,1);
%     for i = 1:T
%       coal_try(i) = x(2*(T-1)+i)*A2t(i)*N;
%     end
%     oil_try = zeros(T,1);
%     oil_try(1) = R0 - x(T);
%     for i = 1:T-2
%       oil_try(1+i) = x(T+i-1)-x(T+i);
%     end
%     ex_Oil_try = ( x(T-1+T-2) - x(T-1+T-1) ) / x(T-1+T-2);
%     oil_try(T) = x(T-1+T-1) * ex_Oil_try;
% 
%     energy_try = zeros(T,1);
%     for i = 1:T
%       energy_try(i) = ((kappa1*oil_try(i)^rho) + (kappa2*coal_try(i)^rho) + (kappa3*E3_try(i)^rho))^(1/rho);
%     end
% 
%     % recompute Yt forward **without changing x** (so it is cheap)
%     Yt_try = zeros(T,1);
%     Kt1_try = zeros(T,1);
%     % period 1:
%     Yt_try(1) = (exp((-gamma(1))*(Sbar + 0 - Sbar))).*(min(en_K(1)*K0, eff_E(1)*energy_try(1))^alpha)*(((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha));
%     Kt1_try(1) = x(1)*Yt_try(1) + (1-Delta)*K0;
%     for i = 1:T-2
%       Yt_try(1+i) = (exp((-gamma(1+i))*(Sbar + 0 - Sbar))).*(min(en_K(1+i)*Kt1_try(i), eff_E(1+i)*energy_try(1+i))^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha));
%       Kt1_try(1+i) = x(1+i)*Yt_try(1+i) + (1-Delta)*Kt1_try(i);
%     end
%     % last period (approx):
%     Yt_try(T) = (exp((-gamma(T))*(Sbar + 0 - Sbar))).*(min(en_K(T)*Kt1_try(T-1), eff_E(T)*energy_try(T))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));
% 
%     % store core diagnostics
%     results(idx).psi_factor = pf;
%     results(idx).G0_factor = gf;
%     results(idx).E3 = E3_try;
%     results(idx).Gt1 = Gt1_try;
%     results(idx).energy = energy_try;
%     results(idx).Yt = Yt_try;
%     results(idx).maxE3 = max(E3_try);
%     results(idx).firstE3 = E3_try(1);
%     results(idx).firstY = Yt_try(1);
%   end
% end
% figure; hold on;
% for k = 1:idx
%   lab = sprintf('psi*%g G0*%g', results(k).psi_factor, results(k).G0_factor);
%   plot(results(k).E3, '-o', 'DisplayName', lab);
% end
% xlabel('Period'); ylabel('E3'); title('E3 under psi/G0 sensitivity');
% legend('show'); grid off;
% 
% figure; hold on;
% for k = 1:idx
%     lab = sprintf('psi*%g G0*%g', results(k).psi_factor, results(k).G0_factor);
%     GDP_try = results(k).Yt * 1e9 / in_GDP;  % same conversion you use at the end of nestedcd_Objective
%     plot(GDP_try, '-o', 'DisplayName', lab);
% end
% xlabel('Period');
% ylabel('GDP (billion USD equivalent)');
% title('GDP under psi/G0 sensitivity');
% legend('show');
% grid off;
% 
% 
% %% =================== Sensitivity Analysis K0 / en_K ===================
% K0_factors = [1, 0.5, 0.25];
% enK_factors = [1, 0.1, 0.01];
% 
% results_KE = struct();
% idx = 0;
% 
% for kf = K0_factors
%     for ef = enK_factors
%         idx = idx + 1;
% 
%         K0_try = K0 * kf;
%         en_K_try = en_K * ef;  % scale the energy throughput per capital
% 
%         % ---- Recompute Yt and Kt1 forward using your production function ----
%         Yt_try = zeros(T,1);
%         Kt1_try = zeros(T,1);
% 
%         % period 1
%         Yt_try(1) = (exp((-gamma(1))*(St(1)-Sbar))) * ...
%                     (min(en_K_try(1)*K0_try, eff_E(1)*energy(1))^alpha) * ...
%                     ((1-x(2*(T-1)+1)-x(2*(T-1)+T+1))*N)^(1-alpha);
%         Kt1_try(1) = x(1)*Yt_try(1) + (1-Delta)*K0_try;
% 
%         % periods 2 to T-1
%         for i = 1:T-2
%             Yt_try(1+i) = (exp((-gamma(1+i))*(St(1+i)-Sbar))) * ...
%                           (min(en_K_try(1+i)*Kt1_try(i), eff_E(1+i)*energy(1+i))^alpha) * ...
%                           ((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha);
%             Kt1_try(1+i) = x(1+i)*Yt_try(1+i) + (1-Delta)*Kt1_try(i);
%         end
% 
%         % last period
%         Yt_try(T) = (exp((-gamma(T))*(St(T)-Sbar))) * ...
%                     (min(en_K_try(T)*Kt1_try(T-1), eff_E(T)*energy(T))^alpha) * ...
%                     ((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha);
% 
%         % ---- Store results ----
%         results_KE(idx).K0_factor = kf;
%         results_KE(idx).enK_factor = ef;
%         results_KE(idx).Yt = Yt_try;
%         results_KE(idx).GDP = Yt_try*1e9/in_GDP;
%         results_KE(idx).Kt1 = Kt1_try;
%     end
% end
% 
% %% ====== Plot Capital Stock Kt1 ======
% figure; hold on;
% colors = lines(idx);
% for k = 1:idx
%     lab = sprintf('K0*%g en_K*%g', results_KE(k).K0_factor, results_KE(k).enK_factor);
%     plot(results_KE(k).Kt1,'-o','DisplayName',lab);
% end
% xlabel('Period'); ylabel('Capital Stock Kt1'); 
% title('Sensitivity of Capital Stock to K0 and en_K'); 
% legend('show'); grid off;
% 
% %% ====== Plot GDP ======
% figure; hold on;
% for k = 1:idx
%     lab = sprintf('K0*%g en_K*%g', results_KE(k).K0_factor, results_KE(k).enK_factor);
%     plot(results_KE(k).GDP,'-o','DisplayName',lab);
% end
% xlabel('Period'); ylabel('GDP (billion USD equivalent)'); 
% title('Sensitivity of GDP to K0 and en_K'); 
% legend('show'); grid off;
% 
% 

%%%%%%%%%%%%%%%%%%    End Sensitivity          %%%%%%%%%%%%%%%%%%%%%%%