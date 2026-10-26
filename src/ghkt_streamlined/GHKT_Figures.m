% GHKT_FIGURES Make the baseline GHKT figures from saved results.
% Run GHKT_Main first (it saves the results). Then run one section at a
% time with Ctrl+Enter. Nothing needs to be commented out.

p = LoadParams();
y2 = p.y2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Section 5: Graph Optimal Carbon Taxes     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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