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

%%% Option 1 (GHKT) 
% rho = -0.058;               %Elasticity of substitution = 0.945
% kappa1 = 0.5429;            %Relative efficiency of oil
% kappa2 = 0.1015;            %Relative efficiency of coal
% kappa3 = 1-kappa1-kappa2;   %Relative efficiency of low-carbon technologies

%%% Option 2 (Based on change in TWh 2014-2024)
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
r2024 = 0.05;               %GHKT: Base year annual net rate of return 
r2024d = ((1+r2024)^10)-1;  %GHKT: Base yer decadal net rate of return

%%Depreciation OPTION 1: delta = 100%
delta = 1;                              %Annual depreciation rate
Delta = (1-(1-delta)^10);               %Decadal depreciation rate
K0 = (alpha*Y2024*10)/(r2024d+Delta);   %GHKT Base year capital stock in billions of USD

%%Depreciation OPTION 2: delta = 65%, no recalibration:
% delta = 0.1;                            %Annual depreciation rate
% Delta = (1-(1-delta)^10);               %Decadal depreciation rate
% Delta1 = 1;                             %Decadal 100% depreciation rate
% K0 = (alpha*Y2024*10)/(r2024d+Delta1);  %Base year capital stock in billions of USD

%%Depreciation OPTION 3: delta = 65%, with recalibration:
% delta = 0.1;                            %Annual depreciation rate
% Delta = (1-(1-delta)^10);               %Decadal depreciation rate
% K0 = (alpha*Y2024*10)/(r2024d+Delta);   %Base year capital stock in billions of USD

%Recalibrated Energy (Using IEA data):
 pi00 = 1;               %Base period share of labor devoted to final goods production
 E1_2024 = 55.292;  %x1000 TWh per year
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
%A2t(1) = 7693;             % GHKT 
A2t(1) = 11169.231;         % x1000 TWh 
for i = 1:1:T-1
    A2t(i+1) = A2t(i)*(1+gZ_coal);
end

%%Coal Emissions%%
%%%%%%%%%%%%%%%%%%%
ypsilon = zeros(T,1);   %Coal carbon emissions coefficient
a_yps = 8;              %Logistic curve coefficient
b_yps = -0.05;          %Logistic curve coefficient
for i = 1:1:T+n
     ypsilon(i) = 1/(1+exp((-1)*(a_yps+b_yps*(i-1)*10)));
     %ypsilon(i) = 1;
end


%%Low Carbon Energy Production%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A3t = zeros(T,1);
%A3t(1) = 1311;             % GHKT
A3t(1) = 3399.331;          % x1000 TWh
for i = 1:1:T-1
    A3t(i+1) = A3t(i)*(1+gZ_green); 
end

%%Oil%%
%%%%%%%
%R0 = 253.8;                % GHKT
R0 = 2720;                  % x1000 TWh


%%Energy in Final Goods Production%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
en_K = zeros(T,1);
eff_E = zeros(T,1);

eff_E(1) = 0.33;                        % initial energy-to-exergy efficiency
%en_K(1) = (eff_E(1) * E0)/(K0);      % initial usable energy throughput of capital (x1000 TWh per decade per billion)

%Test 1:
en_K(1) = (Y2024*10)/(exp((-gamma(1))*((S1_2000+S2_2000)-Sbar)))*(((eff_E(1)*E0)/(K0))^alpha);

%Test 2:
%en_K(1) = (exp((-gamma(1))*((S1_2000+S2_2000)-Sbar)))*((eff_E(1) * E0)/(K0));  
 


%%%Decadal growth rates
gEk = 0.00;                             % growth in energy throughput of capital
gEff = 0.00;                            % growth in energy-to-exergy efficiency
%gEk = 0.01;    
%gEff = 0.02;     

for i = 1:1:T-1
    en_K(i+1) = en_K(i)*(1+gEk)^10;    
    eff_E(i+1) = eff_E(i)*(1+gEff);  
end

%%%%%%   Mineral Parameters  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Initial mineral stock (MtCu)
M0 = 2000;    
%M0 = 1000;
%M0 = 500;

%%% Initial green capital stock (MtCu)
G0 = 53.8;                                             % MtCu Based on annual demand for clean tech in 2021 * 10
%G0 = 5.38;

%%% Green capital depreciation 
%delta_G = 0.088;                                      % Annual depreciation rate of green capital 
%delta_G = 0.1;                                        % Annual depreciation rate of green capital 
delta_G = 1; 
Delta_G = (1-(1-delta_G)^10);                          % Decadal depreciation rate

%%% Other
rho_E3 = -3;                                           % Parameter of substitution E3
%psi = 1.462;                                          % Energy obtained from given amount of green capital, in x1000TWh/MtCu
psi = 1;
phi_m = 1.462;
%phi_m = 1;                                            % Efficiency of minerals in producing green capital

%%% Relative efficiencies
kappaM = zeros(T,1);                                   % Relative efficiency of minerals in the production of green capital
kappaL = zeros(T,1);                                   % Relative efficiency of labour in the production of green capital
dkM = 0.00; 
%dkM = 0.002;                                          % Annual decline in relative efficiency of minerals for green capital

kappaM(1) = 0.75;   
kappaL(1) = 1-kappaM(1);
for i = 1:1:T-1
    % kappaM(1+i) = kappaM(1);
    % kappaL(1+i) = 1-kappaM(1);
    kappaM(1+i) = kappaM(i)*(1-dkM)^10;
    kappaL(1+i) = 1-kappaM(1+i);
end                                 


%%% Calibrating eta_GDP
u1_cap = en_K(1) * (K0*10);            % capital-side usable energy at T=1 in x1000TWh per decade 
u1_energy = eff_E(1) * E0;             % energy-side usable energy at T=1 in x1000TWh per decade
usable1 = min(u1_cap, u1_energy); 
Yt1_model = (exp((-gamma(1))*((S1_2000+S2_2000)-Sbar)))*(usable1.^alpha);       
eta_GDP = Yt1_model/ (Y2024*10);       % output to GDP conversion (x1000TWh usable energy per 1 billion dollars)       




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 2: Solve for Optimal Choice Variables X        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vars = 2*T+2*(T-1);         %Number of variables = 147

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

%load('x_nomin_optimum','x')


%TO ENSURE X0 LOAD PREVIOUS RESULTS X
%x0 = x;


%%% OPTION 2: NEUTRAL STARTING POINT %%

x0 = zeros(vars,1);
for i = 1:1:T-1
     x0(i) = 0.25;                       %savings rate
     x0((T-1)+i) = R0-((R0/1.1)/T)*i;    %oil stock remaining
     x0(2*(T-1)+i) = 0.002;              %labour share coal
     x0(2*(T-1)+T+i) = 0.01;             %labour share green capital
end
x0(2*(T-1)+T) = 0.002;
x0(2*(T-1)+T+T) = 0.01;

%%Check Constraints and Objective Function Value at x0%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = nestedcdnomin_Objective(x0,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,eta_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon);
[c, ceq] = nestedcdnomin_Constraints(x0,A2t,A3t,Delta_G,Delta,en_K,eff_E,G0,eta_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon);

%%%%%%%%%%%
%%%SOLVE%%%
%%%%%%%%%%%

% Algorithm changed from interior-point (GHKT) to active-set (current);
options = optimoptions(@fmincon,'Tolfun',1e-12,'TolCon',1e-12,'MaxFunEvals',500000,'MaxIter',6200,'Display','iter','MaxSQPIter',10000,'Algorithm','interior-point');
[x, fval,exitflag] = fmincon(@(x)nestedcdnomin_Objective(x,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,eta_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon), x0, [], [], [], [], lb, ub, @(x)nestedcdnomin_Constraints(x,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,eta_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon), options);


%%Save Output%%
%%%%%%%%%%%%%%%
%File name structure:
%x_scenario_version

%save('x_nomin_optimum_lf','x')
save('x_nomin_optimum','x')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 3: Compute Allocations and Carbon Taxes  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Energy Production   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Oil in x1000 TWh 
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

%%% Coal in x1000 TWh 
coal = zeros(T,1);
for i = 1:1:T
    coal(i) = x(2*(T-1)+i)*A2t(i)*N;
end

%%% Low carbon energy in x1000TWH
E3 = zeros(T,1);
for i = 1:1:T
    E3(i) = (x(2*(T-1)+T+i))*A3t(i)*N;
end

% %%% Minerals in MtCu 
% mineral = zeros(T,1);
%     mineral(1) = M0-x(2*(T-1)+2*T+1);
% for i = 1:1:T-2
%     mineral(1+i) = x(2*(T-1)+2*T+i)-x(2*(T-1)+2*T+i+1);
% end
%     ex_Min = (x(2*(T-1)+2*T+(T-3))-x(2*(T-1)+2*T+(T-2)))/(x(2*(T-1)+2*T+(T-3)));    %Fraction of minerals left extracted in period T-1
%     mineral(T) = x(2*(T-1)+2*T+(T-2))*ex_Min;
% 
% %%% Green capital (flow) in x1000TWh 
% green = zeros(T,1);
% for i = 1:1:T
%      green(i) = (((kappaL(i)*(x(2*(T-1)+T+i)*A3t(i)*N)^rho_E3)+(kappaM(i)*(phi_m*mineral(i))^rho_E3)))^(1/rho_E3);
% end
% 
% %%% Green capital (stock) in x1000TWh
% Gt1 = zeros(T,1);
% Gt1(1) = green(1)+(1-Delta_G)*G0;
% for i = 1:1:T-2
%     Gt1(1+i) = green(1+i)+(1-Delta_G)*Gt1(i);
% end
%  Gt1(T) = green(T)+(1-Delta_G)*Gt1(T-1);
% 
% %%% Low carbon energy production in x1000 TWh
% E3 = zeros(T,1);
% for i = 1:1:T
%        E3(i) = psi*Gt1(i);
% end

%%% Total Energy in x1000 TWh
energy = zeros(T,1);
for i = 1:1:T
    energy(i) = ((kappa1*oil(i)^rho)+(kappa2*coal(i)^rho)+(kappa3*E3(i)^rho))^(1/rho);
end


%%% Diagnostic plots

%%%% compute fossil fuel use
fossil_fuel = zeros(T,1);
for i = 1:1:T
    fossil_fuel(i) = oil(i) + coal(i);
end

%%% compute energy shares
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

%%% FIGURE 3: The energy mix
z = 30;
figure;
hold on;
plot(y2(1:z),share_E3(1:z),'Color',[0.2 0.7 0.3], 'LineWidth', 1.5);
plot(y2(1:z), share_coal(1:z),'Color',[0.55 0.27 0.07], 'LineWidth', 1.5);
plot(y2(1:z),share_oil(1:z),'Color',[0.95 0.65 0.2], 'LineWidth', 1.5);
ylabel('Energy Share');
xlabel('Year')
title('Figure 3: Energy mix')
legend('Low Carbon Energy','Coal', 'Oil');
grid off;
xlim([2025 2250]);

%% Diagnostic plot energy sources over time
z = 20;
figure;
hold on;
plot(y2(1:z),oil(1:z), '-b', 'LineWidth', 2);
plot(y2(1:z),E3(1:z), '-g', 'LineWidth', 2);
plot(y2(1:z),coal(1:z), '-r', 'LineWidth', 2); 
ylabel('Energy (x1000 TWh)')
xlabel('Year');
ylabel('Energy production (TWh)');
title('Energy production from Coal, Oil, and Renewables');
legend({'Oil', 'Low-carbon', 'Coal'}, 'Location', 'best');
grid off;
xlim([2020 2200])


%%%%%%%%%%%%%
%%Emissions%%
%%%%%%%%%%%%%
emiss = zeros(T,1);
emiss_coal = zeros(T,1);
emiss_oil = zeros(T,1); 
for i = 1:1:T
    emiss_coal(i) = ypsilon(i)*coal(i)*0.1008;   % Based on conversion of 1000 TWh to GtC for coal
    emiss_oil(i) = oil(i)*0.0676;                % Based on conversion of 1000 TWh to GtC for oil
    emiss(i) = emiss_coal(i)+emiss_oil(i);
end

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
    GDP(1) = Yt(1)/(eta_GDP);
Ct(1) = (1-x(1))*GDP(1);
Kt1(1) = x(1)*GDP(1)+(1-Delta)*K0;
for i = 1:1:T-2
    Yt(1+i) = (exp((-gamma(1+i))*(St(1+i)-Sbar)))*(min(en_K(1+i)*Kt1(i),eff_E(1+i)*energy(1+i))^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha));
          %Yt(1+i) = (min(en_K(1+i)*Kt1(i),eff_E(1+i)*energy(1+i))^alpha)*(((1-x(2*(T-1)+1+i)-x(2*(T-1)+T+1+i))*N)^(1-alpha));
    GDP(1+i) = Yt(1+i)/(eta_GDP);  %in billion dollars
    Kt1(1+i) = x(1+i)*GDP(1+i)+(1-Delta)*Kt1(i);
    Ct(1+i) = (1-x(i+1))*GDP(1+i); 
end
Yt(T) =  (exp((-gamma(T))*(St(T)-Sbar)))*(min(en_K(T)*Kt1(T-1),eff_E(T)*energy(T))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));
    %Yt(T) =  (min(en_K(T)*Kt1(T-1),eff_E(T)*energy(T))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));
GDP(T) = Yt(T)/eta_GDP;
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
    %minbgp(i) = ex_Min*x(2*(T-1)+2*T+(T-1))*((1-ex_Min)^i);
    %greenbgp(i) = ((kappaL(T)*(x(2*(T-1)+2*T)*(A3t(T)*(1+gZ_green)^i)^rho_E3)+(kappaM(T)*minbgp(i))^(rho_E3)))^(1/rho_E3);
    %Gtn(i+1) = greenbgp(i) + (1-Delta_G)*Gtn(i);
    %E3bgp(i) = psi*Gtn(i);
    En(i) = ((kappa1*oiln(i)^rho)+(kappa2*(coal(T)*(1+gZ_coal)^i)^rho)+(kappa3*E3bgp(i)^rho))^(1/rho);
    Ytn(i) =  (exp((-gamma(T))*(St(T)-Sbar)))*(min(en_K(T)*Ktn(i),eff_E(T)*En(i))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));    
        %Ytn(i) = (min(en_K(T)*Ktn(i),eff_E(T)*En(i))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));     
    GDPn(i) = Ytn(i)/eta_GDP;
    Ct(T+i) = (1-theta)*GDPn(i);
    Ktn(i+1) = theta*GDPn(i)+(1-Delta)*Ktn(i);
    Yt(T+i) = Ytn(i);
    GDP(T+i) = GDPn(i);
end

%%% Diagnostic plot: Ratio of capital capacity versus energy supply
capacity_k = zeros(T,1);
supply_e = zeros(T,1);
ratio = zeros(T,1);

capacity_k(1) = en_K(1)*K0;
supply_e(1) = eff_E(1)*energy(1);
ratio(1) = capacity_k(1)/supply_e(1);
for i = 1:1:T-1
capacity_k(1+i) = en_K(i+1)*Kt1(i);
supply_e(1+i) = eff_E(i)*energy(i);
ratio(1+i) = capacity_k(1+i)/supply_e(1+i);
end

figure;
hold on;
plot(1:T,ratio,'-o');
xlabel('period');
ylabel('Ratio');
grid off;
title('Figure A8: Energy-Capacity versus Energy Supply');


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
            temp2(j) = (beta^(j-1))*(MU(i+j-1)/MU(i))*(-gamma(T))*GDP(i+j-1)*MD(j);
        end
     carbon_tax(i) = sum(temp2)*(-1);
     lambda_hat(i) = carbon_tax(i)/GDP(i);
end


%%Temperature%%
%%%%%%%%%%%%%%%%%
lambda = 3.0;               % Climate sensitivity parameter
temp = zeros(T,1);          % Initialize the temperature vector
for i = 1:1:T
    temp(i) = lambda * log2(St(i)/Sbar);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 4: Save Allocations and Carbon Taxes  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%       FOR OPTIMAL SCENARIO    %%%%%%%%%%%%%%%%%%

%% Extract from x-vector
r_nomin_optimum = x(1:T-1);
save('r_nomin_optimum','r_nomin_optimum');
oil_stock_nomin_optimum = x(T:2*(T-1));
save('oil_stock_nomin_optimum','oil_stock_nomin_optimum');
N2_nomin_optimum = x(2*(T-1)+1:3*(T-1));
save('N2_nomin_optimum', 'N2_nomin_optimum');
N3_nomin_optimum = x(2*(T-1)+T+1:2*(T-1)+2*T);
save('N3_nomin_optimum','N3_nomin_optimum');
%shareK_nomin_optimum = x(2*(T-1)+2*T+1 : 2*(T-1)+2*T-1); 
%save('shareK_nomin_optimum','shareK_nomin_optimum');
%mineral_stock_newpf_cal = x(4*T-1:5*T-3);
%save('mineral_stock_newpf_cal','mineral_stock_newpf_cal');

% Save
energy_nomin_optimum = energy;
save('energy_nomin_optimum','energy_nomin_optimum')
fossil_fuel_nomin_optimum = fossil_fuel;
save('fossil_fuel_nomin_optimum','fossil_fuel_nomin_optimum')
oil_nomin_optimum = oil;
save('oil_nomin_optimum','oil_nomin_optimum')
ex_rates_nomin_optimum = ex_rates;
save('ex_rates_nomin_optimum','ex_rates_nomin_optimum')
coal_nomin_optimum = coal;
save('coal_nomin_optimum','coal_nomin_optimum')
E3_nomin_optimum = E3;
save('E3_nomin_optimum','E3_nomin_optimum')
lambda_hat_nomin_optimum = lambda_hat;
save('lambda_hat_nomin_optimum','lambda_hat_nomin_optimum')
carbon_tax_nomin_optimum = carbon_tax;
save('carbon_tax_nomin_optimum','carbon_tax_nomin_optimum')
Yt_nomin_optimum = Yt;
save('Yt_nomin_optimum','Yt_nomin_optimum')
Ct_nomin_optimum = Ct;
save('Ct_nomin_optimum','Ct_nomin_optimum')
temp_nomin_optimum = temp;
save('temp_nomin_optimum','temp_nomin_optimum');
carbon_nomin_optimum = emiss;
save('carbon_nomin_optimum','carbon_nomin_optimum');
carbon_nomin_optimum = emiss;
save('carbon_nomin_optimum','carbon_nomin_optimum');
% mineral_newpf_cal = mineral;
% save('mineral_newpf_cal','mineral_newpf_cal');
% green_newpf_cal = green;
% save('green_newpf_cal','green_newpf_cal');
gdp_nomin_optimum = GDP; 
save('gdp_nomin_optimum', 'gdp_nomin_optimum');
% Gt1_newpf_cal = Gt1;
% save('Gt1_newpf_cal','Gt1_newpf_cal');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 5: Graph Optimal Carbon Taxes     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Graph Carbon Tax    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Carbon Tax per Unit of GDP
load('lambda_hat_nomin_optimum','lambda_hat_nomin_optimum')

z = 20;
figure;
plot(y2(1:z), lambda_hat_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Carbon Tax/GDP', 'FontSize', 11);
ylim([7.5e-05, 30.5e-05]);
title('Carbon Tax to GDP ratio (new pf, no minerals)');


%% Carbon Tax in $/mtC
load('carbon_tax_nomin_optimum','carbon_tax_nomin_optimum')

z = 10;
figure;
plot(y2(1:z), carbon_tax_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Carbon Tax ($/mtC)', 'FontSize', 11);
title('Carbon Tax (new pf, no minerals)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Energy Use Over Time  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Energy
load('energy_nomin_optimum.mat','energy_nomin_optimum')

z = 25;
figure;
plot(y2(1:z), energy_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('x1000 TWh', 'FontSize', 11);
title('Energy Use (new pf, no minerals)');

%% Fossil Fuel
load('fossil_fuel_nomin_optimum.mat','fossil_fuel_nomin_optimum')

z = 20;
figure(Name='Fossil Fuel Use');
plot(y2(1:z), fossil_fuel_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (x1000 TWh)', 'FontSize', 11);
title('Fossil Fuel Use (new pf, no minerals)');

%% Oil
load('oil_nomin_optimum.mat','oil_nomin_optimum')

z = 25;
figure(Name = 'Oil Use');
plot(y2(1:z), oil_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (x1000 TWh)', 'FontSize', 11);
title('Oil Use (new pf, no minerals)');

%% Fraction of oil left extracted
load('ex_rates_nomin_optimum.mat','ex_rates_nomin_optimum')

z = 25;
figure;
plot(y2(1:z), ex_rates_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Rate', 'FontSize', 11);
title('Extraction rates of oil (new pf, no minerals)');

%% Coal
load('coal_nomin_optimum.mat','coal_nomin_optimum')

z = 25;
figure(Name ='Coal Use');
plot(y2(1:z), coal_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (x1000 TWh)', 'FontSize', 11);
title('Coal Use (new pf, no minerals)');

%% Low Carbon Energy
load('E3_nomin_optimum.mat','E3_nomin_optimum')

z = 25;
figure(Name = 'Low Carbon Energy');
plot(y2(1:z), E3_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Energy (x1000 TWh)', 'FontSize', 11);
title('Low Carbon Energy Use (new pf, no minerals)');

% %% Mineral Use
% load('mineral_newpf_cal', 'mineral_newpf_cal')
% 
% z = 30;
% figure(Name ='Mineral Use');
% plot(y2(1:z), mineral_newpf_cal(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Minerals (MtCu)', 'FontSize', 11);
% title('Mineral Use (new pf, no minerals)');

% %% Mineral Stock
% load('mineral_stock_newpf_cal', 'mineral_stock_newpf_cal')
% 
% z = 25;
% figure(Name ='Mineral Stock');
% plot(y2(1:z), mineral_stock_newpf_cal(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Minerals (MtCu)', 'FontSize', 11);
% title('Mineral Stock (new pf, no minerals)');

% %% Green Capital
% load('Gt1_newpf_cal', 'Gt1_newpf_cal')
% 
% z = 30;
% figure(Name ='Green Capital Stock');
% plot(y2(1:z), Gt1_newpf_cal(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Green Capital Stock (MtCu)', 'FontSize', 11);
% title('Green Capital Stock (new pf, no minerals)');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  Climate Impact        %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Emissions
load('carbon_nomin_optimum', 'carbon_nomin_optimum')

z = 25;
figure(Name='Carbon Emissions');
plot(y2(1:z), carbon_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Emissions (GtC)', 'FontSize', 11);
title('Emissions (new pf, no minerals)');

%% Temperature
load('temp_nomin_optimum', 'temp_nomin_optimum')

figure(Name='Temperature Increase');
plot(y2(1:T), temp, ' -r', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Temperature Increase (degrees C)', 'FontSize', 11);
title('Temperature Increase (new pf, no minerals)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Labour shares         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Labour share to green capital
load('N3_nomin_optimum', 'N3_nomin_optimum')

z = 25;
figure(Name='Labour Share Green Capital');
plot(y2(1:z), N3_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Share to Green Capital Production (newpf, no minerals)');

%% Labour share to coal
load('N2_nomin_optimum', 'N2_nomin_optimum')

z = 25;
figure(Name='Labour Share Coal');
plot(y2(1:z), N2_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Share', 'FontSize', 11);
title('Labour Share to Coal Production (newpf, no minerals)');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  GDP Growth Over Time  %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Output in TWh
load('Yt_nomin_optimum','Yt_nomin_optimum')

z = 25;
figure(Name='Output');
plot(y2(1:z), Yt_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('Output (Exergy x1000 TWh)', 'FontSize', 11);
title('Output (new pf, no minerals)');

%% Output in $
load('gdp_nomin_optimum','gdp_nomin_optimum')

z = 25;
figure(Name='GDP');
plot(y2(1:z), gdp_nomin_optimum(1:z), ' -b', 'LineWidth', 1.5);
xlabel('Year', 'FontSize', 11);
ylabel('$GDP (x1 billion)', 'FontSize', 11);
title('GDP (new pf, no minerals)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%       FOR LF SCENARIO      %%%%%%%%%%%%%%%%%%%
% 
% %% Extract from x-vector
% r_newpf_lf = x(1:T-1);
% save('r_newpf_lf','r_newpf_lf');
% oil_stock_newpf_lf = x(T:2*(T-1));
% save('oil_stock_newpf_lf','oil_stock_newpf_lf');
% N2_newpf_lf = x(2*(T-1)+1:3*(T-1));
% save('N2_newpf_lf', 'N2_newpf_lf');
% N3_newpf_lf = x(2*(T-1)+T+1:2*(T-1)+2*T);
% save('N3_newpf_lf','N3_newpf_lf');
% shareK_newpf_lf = x(2*(T-1)+2*T+1 : 2*(T-1)+2*T-1); 
% save('shareK_newpf_lf','shareK_newpf_lf');
% 
% %% Save
% energy_newpf_lf = energy;
% save('energy_newpf_lf','energy_newpf_lf')
% fossil_fuel_newpf_lf = fossil_fuel;
% save('fossil_fuel_newpf_lf','fossil_fuel_newpf_lf')
% oil_newpf_lf = oil;
% save('oil_newpf_lf','oil_newpf_lf')
% ex_rates_newpf_lf = ex_rates
% save('ex_rates_newpf_lf','ex_rates_newpf_lf')
% coal_newpf_lf = coal;
% save('coal_newpf_lf','coal_newpf_lf')
% E3_newpf_lf = E3;
% save('E3_newpf_lf','E3_newpf_lf')
% Yt_newpf_lf = Yt;
% save('Yt_newpf_lf','Yt_newpf_lf')
% Ct_newpf_lf = Ct;
% save('Ct_newpf_lf','Ct_newpf_lf')
% temp_newpf_lf = temp;
% save('temp_newpf_lf','temp_newpf_lf');
% carbon_newpf_lf = St;
% save('carbon_newpf_lf','carbon_newpf_lf');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%      Section 5: Graph Optimal Carbon Taxes     %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%  Energy Use Over Time  %%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Energy
% load('energy_newpf_lf.mat','energy_newpf_lf')
% 
% z = 30;
% figure;
% plot(y2(1:z), energy_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('GtC', 'FontSize', 11);
% title('Energy Use (new pf, no minerals)');
% 
% %% Fossil Fuel
% load('fossil_fuel_newpf_lf.mat','fossil_fuel_newpf_lf')
% 
% z = 30;
% figure(Name='Fossil Fuel Use');
% plot(y2(1:z), fossil_fuel_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (Gtoe)', 'FontSize', 11);
% title('Fossil Fuel Use (new pf, no minerals)');
% 
% %% Oil
% load('oil_newpf_lf.mat','oil_newpf_lf')
% 
% z = 30;
% figure(Name = 'Oil Use');
% plot(y2(1:z), oil_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (Gtoe)', 'FontSize', 11);
% title('Oil Use (new pf, no minerals)');
% 
% %% Fraction of oil left extracted
% load('ex_rates_newpf_lf.mat','ex_rates_newpf_lf')
% 
% z = 29;
% figure;
% plot(y2(1:z), ex_rates_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Rate', 'FontSize', 11);
% title('Extraction rates of oil (new pf, no minerals)');
% 
% %% Coal
% load('coal_newpf_lf.mat','coal_newpf_lf')
% 
% z = 30;
% figure(Name ='Coal Use');
% plot(y2(1:z), coal_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Energy (Gtoe)', 'FontSize', 11);
% title('Coal Use (new pf, no minerals)');
% 
% %% Wind
% load('E3_newpf_lf.mat','E3_newpf_lf')
% 
% z = 30;
% figure(Name = 'Wind');
% plot(y2(1:z), E3_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Wind Use', 'FontSize', 11);
% title('Wind Use (new pf, no minerals)');
% 
% %% Energy share to Capital
% load('shareK_newpf_lf.mat','shareK_newpf_lf')
% 
% z = 29;
% figure(Name = 'Energy Share to Capital');
% plot(y2(1:z), shareK_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Share', 'FontSize', 11);
% title('Energy Share to Capital (new pf, no minerals)');
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%  Climate Impact        %%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Emissions
% load('carbon_newpf_lf', 'carbon_newpf_lf')
% 
% z = 30;
% figure(Name='Carbon Emissions');
% plot(y2(1:z), carbon_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Emissions (GtC)', 'FontSize', 11);
% title('Emissions (new pf, no minerals)');
% 
% %% Temperature
% load('temp_newpf_lf', 'temp_newpf_lf')
% 
% figure(Name='Temperature Increase');
% plot(y2(1:T), temp, ' -r', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Temperature Increase (degrees C)', 'FontSize', 11);
% title('Temperature Increase (new pf, no minerals)');
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%  Labour shares         %%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Labour share to E3 (later: green capital)
% load('N3_newpf_lf', 'N3_newpf_lf')
% 
% z = 29;
% figure(Name='Labour Share Green Capital');
% plot(y2(1:z), N3_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Share', 'FontSize', 11);
% title('Labour Share to Green Capital Production (newpf)');
% 
% %% Labour share to coal
% load('N2_newpf_lf', 'N2_newpf_lf')
% 
% z = 29;
% figure(Name='Labour Share Coal');
% plot(y2(1:z), N2_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Share', 'FontSize', 11);
% title('Labour Share to Coal Production (newpf)');
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%  GDP Growth Over Time  %%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('Yt_newpf_lf','Yt_newpf_lf')
% 
% z = 28;
% figure(Name='GDP');
% plot(y2(1:z), Yt_newpf_lf(1:z), ' -b', 'LineWidth', 1.5);
% xlabel('Year', 'FontSize', 11);
% ylabel('Output', 'FontSize', 11);
% title('GDP (new pf, no minerals)');