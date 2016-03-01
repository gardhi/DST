
% this function simply initiate parameters to workspace for testing
clear variables

% Paramaters for Sismulation Solution Space
% Physical
SimPar = SimulationParameters( 10,... pvStartKw                  : Min PV power simulated [kW]
                               300,... pvStopKw                  : Max PV power simulated [kW]
                               10,...  pvStepKw                  : PV power simulation step [kW]
                               10,...battStartKwh                : Min Battery capacity simulated [kWh]
                               1400,...battStopKwh               : Max Battery capacity simulated [kWh]
                               10,...  battStepKwh               : Battery capacity simulation step [kWh]
                               0.005,...llpSearchAcceptance      : Acceptence error when searching a spesific LLP value.
                               0.01:0.01:1);% llpSearchTargets   : LLP range that one want to find optimal solutions within

% Economics
EcoPar = EconomicParameters;
EcoPar.budget = 1500000;               % Budget in EUR
EcoPar.pvCostKw = 1000;                % PV panel cost [/kW] (source: Uganda data)
EcoPar.battCostKwh = 140;              % variable cost [per kWh]  %132.78;
EcoPar.battCostFixed = 0;              % fixed cost
EcoPar.inverterCostKw = 500;           % Inverter cost [/kW] (source: MCM_Energy Lab + prof. Silva exercise, POLIMI)
EcoPar.operationMaintenanceCostKw = 50;% Operations & Maintenance cost for the overall plant [/kW*year] (source: MCM_Energy Lab)
EcoPar.installBalanceOfSystemCost = 0.2;% Installation (I) and BoS cost as % of cost of PV+battery+Inv [% of Investment cost] (source: Masters, Renewable and Efficient Electric Power Systems,)
EcoPar.plantLifetime = 20;            % plant LifeTime [year] 
EcoPar.interestRate = 0.06;           % rate of interest defined as (HOMER) = nominal rate - inflation
% Battery cost defined as:
%costBatt_tot = costBatt_coef_a * battery_capacity [kWh] + costBatt_coef_b (source: Uganda data)


% System components 
% System details and input variables are as follows

% Balance Of System: account for such factors as soiling of the panels, 
% wiring losses, shading, snow cover, aging, and so on
PvPar.balanceOfSystem = 0.85;               
PvPar.nominalAmbientTemperatureC = 20;    % Nominal ambient test-temperature of the panels [C]
PvPar.nominalCellTemperatureC = 47;        % Nominal Operating Cell Temperature [C]
PvPar.nominalIrradiation = 0.8;           % Irradiation at nominal operation [kW / m^2]
PvPar.powerDerateDueTemperature = 0.004;  % Derating of panel's power due to temperature [/C]

% Battery
BattPar.minStateOfCharge = 0.4;            

BattPar.initialStateOfCharge = 1;             
BattPar.chargingEfficiency = 0.85; 
BattPar.dischargingEfficiency = 0.9;
% ratio power / energy of the battery (a measure for how fast battery
% can be charged and discharged depending on current Kwh level
BattPar.powerEnergyRatio = 0.5; 
BattPar.maxOperationalYears = 5;    % maximum years before battery replacement


% Inverter
InvPar.efficiency = 0.9;


% Loading input data : (load-filename, irradiaton-filename, temperature-filename)
SimIn = SimulationInputData('LoadCurve_normalized_single_3percent_100.mat',...
                            'solar_data_Phuntsholing_baseline.mat',...
                            'surface_temp_phuent_2004_hour.mat',...
                            'bhutan');