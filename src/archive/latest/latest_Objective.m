
function f = nestedcd_Objective(x,A2t,A3t,Delta,Delta_G,en_K,eff_E,G0,eta_GDP,K0,M0,N,R0,S1_2000,S2_2000,Sbar,T,alpha,beta,gZ_coal,gZ_green,gZd_y,gZBGP,gamma,kappaL,kappaM,kappa1,kappa2,kappa3,phi,phi0,phiL,phi_m,psi,rho,rho_E3,sigma,ypsilon) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 3: Objective function                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Compute consumption based on x = [{Kt+1},{Rt+1},{pi0t},{pi2t}]:
%Step 1: Compute implied energy inputs
%Step 2: Compute carbon emissions and concentrations
%Step 3: Compute output and consumption

%%Step 4: Evaluate objective function at {Ct}

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 1: Energy Inputs%%
%%%%%%%%%%%%%%%%%%%%%%%%%

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

% E3 = zeros(T,1);
% for i = 1:1:T;
%     E3(i) = x(2*(T-1)+T+i)*(A3t(i)*N);
% end


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

energy = zeros(T,1);
for i = 1:1:T 
    energy(i) = ((kappa1*oil(i)^rho)+(kappa2*coal(i)^rho)+(kappa3*E3(i)^rho))^(1/rho);
end


%% compute fossil fuel use
fossil_fuel = zeros(T,1);
for i = 1:1:T
    fossil_fuel(i) = oil(i) + coal(i);
end

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
    minbgp(i) = ex_Min*x(2*(T-1)+2*T+(T-1))*((1-ex_Min)^i);
    greenbgp(i) = ((kappaL(T)*(x(2*(T-1)+2*T)*(A3t(T)*(1+gZ_green)^i)^rho_E3)+(kappaM(T)*minbgp(i))^(rho_E3)))^(1/rho_E3);
    Gtn(i+1) = greenbgp(i) + (1-Delta_G)*Gtn(i);
    E3bgp(i) = psi*Gtn(i);
    En(i) = ((kappa1*oiln(i)^rho)+(kappa2*(coal(T)*(1+gZ_coal)^i)^rho)+(kappa3*E3bgp(i)^rho))^(1/rho);
        % En(i) = ((kappa1*oiln(i)^rho)+(kappa2*(coal(T)*(1+gZ_coal)^i)^rho)+(kappa3*E3(T)*(1+gZ_green)^rho))^(1/rho);
    Ytn(i) =  (exp((-gamma(T))*(St(T)-Sbar)))*(min(en_K(T)*Ktn(i),eff_E(T)*En(i))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));    
        %Ytn(i) = (min(en_K(T)*Ktn(i),eff_E(T)*En(i))^alpha)*(((1-x(2*(T-1)+T)-x(2*(T-1)+2*T))*N)^(1-alpha));     
    GDPn(i) = Ytn(i)/eta_GDP;
    Ct(T+i) = (1-theta)*GDPn(i);
    Ktn(i+1) = theta*GDPn(i)+(1-Delta)*Ktn(i);
    Yt(T+i) = Ytn(i);
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Step 4: Compute Utility%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ct = zeros(T+n,1);
for i = 1:1:T+n
    ct(i) = Ct(i)/1000000;  %Re-scale units
end

U = zeros(T+n,1);

for i = 1:1:T+n-1
    if Ct(i)<0
        U(i) = -99;
    else
        if sigma~=1
             U(i) =(beta^(i-1))*(((ct(i))^(1-sigma))-1)/(1-sigma);
        else
            U(i) = (beta^(i-1))*log(ct(i));
        end
    end
end

   if Ct(T+n)<0
       Ucont = -99;
   else
       if sigma~=1
            Ucont = (beta^(T+n-1))*(((ct(T+n)^(1-sigma))-1)/(1-sigma))*(1/(1-beta*((1+gZBGP)^(1-sigma))));
       else
            Ucont = (beta^(T+n-1))*log(ct(T+n))*(1/(1-beta*((1+gZBGP)^(1-sigma))));
       end
   end
  

 f = (-1)*(sum(U)+Ucont);
end