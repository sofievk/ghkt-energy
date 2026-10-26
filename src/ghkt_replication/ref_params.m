T = 30;
y = (1:1:T);
y(1) = 2010;
for i = 1:1:T-1
    y(1+i) = 2010+((i)*10);
end
n = 100;
y2 = (1:1:T+n);
y2(1) = 2010;
for i = 1:1:T-1+n
    y2(1+i) = 2010+((i)*10);
end

phi = 0.0228;
phiL = 0.2;
phi0 = 0.393;
Sbar = 581;
S1_2000 = 103;
S2_2000 = 699;
gamma = zeros(T,1);
for i = 1:1:T
    gamma(i) = 0.000023793;
end

rho = -0.058;
kappa1 = 0.5429;
kappa2 = 0.1015;
kappa3 = 1-kappa1-kappa2;

N = 1;
alpha = 0.3;
v = 0.04;
Y2009 = 70000;
r2009 = 0.05;
r2009d = ((1+r2009)^10)-1;
delta = 1;
Delta = (1-(1-delta)^10);
K0 = (alpha*Y2009*10)/(r2009d+Delta);
pi00 = 1;
E1_2008 = 3.43+1.68;
E2_2008 = 3.75;
E3_2008 = 1.95;
E0_2008 = ((kappa1*E1_2008^rho) + ...
           (kappa2*E2_2008^rho) + ...
           (kappa3*E3_2008^rho))^(1/rho);
E0 = E0_2008*10;
A0 = (Y2009*10) / ...
    ((exp((-gamma(1))*((S1_2000+S2_2000)-Sbar))) * ...
    ((K0^alpha)*((N*pi00)^(1-alpha-v))*(E0^v)));

gZa_en = 0.02;
gZ_en = ((1+gZa_en)^10)-1;
gAa_y = 0;
gZa_y = ((1+gAa_y)^(1/(1-alpha-v)))-1;
gAd_y = ((1+gAa_y)^10)-1;
gZd_y = ones(T+n,1)*(((1+gZa_y)^10)-1);

At = zeros(T,1);
At(1) = A0;
for i = 1:1:T-1
    At(i+1) = At(i)*(1+gZd_y(i))^(1-alpha-v);
end
gZBGP = gZd_y(T);

sigma = 1;
beta = (.985)^10;

A2t = zeros(T,1);
A2t(1) = 7693;
for i = 1:1:T-1
    A2t(i+1) = A2t(i)*(1+gZ_en);
end

ypsilon = zeros(T,1);
a_yps = 8;
b_yps = -0.05;
for i = 1:1:T+n
    ypsilon(i) = 1/(1+exp((-1)*(a_yps+b_yps*(i-1)*10)));
end

A3t = zeros(T,1);
A3t(1) = 1311;
for i = 1:1:T-1
    A3t(i+1) = A3t(i)*(1+gZ_en);
end

R0 = 253.8;