tic
clear variables -countingDodLog

% All economic parameters need to be updated
% FOLDER.



% Paramaters for Sismulation Solution Space
% Physical
SimParameters = SimulationParameters( 10,... pvStartKw                 : Min PV power simulated [kW]
                                      300,... pvStopKw                  : Max PV power simulated [kW]
                                      10,...  pvStepKw                  : PV power simulation step [kW]
                                      10,...battStartKwh              : Min Battery capacity simulated [kWh]
                                      1400,...battStopKwh               : Max Battery capacity simulated [kWh]
                                      10,...  battStepKwh               : Battery capacity simulation step [kWh]
                                      0.005,...llpSearchAcceptance      : Acceptence error when searching a spesific LLP value.
                                      0.01:0.01:1);% llpSearchTargets: LLP range that one want to find optimal solutions within

% Economics
EcoParameters = EconomicParameters;
EcoParameters.budget = 1500000;               % Budget in EUR
EcoParameters.pvCostKw = 1000;                % PV panel cost [/kW] (source: Uganda data)
EcoParameters.battCostKwh = 140;              % variable cost [per kWh]  %132.78;
EcoParameters.battCostFixed = 0;              % fixed cost
EcoParameters.inverterCostKw = 500;           % Inverter cost [/kW] (source: MCM_Energy Lab + prof. Silva exercise, POLIMI)
EcoParameters.operationMaintenanceCostKw = 50;% Operations & Maintenance cost for the overall plant [/kW*year] (source: MCM_Energy Lab)
EcoParameters.installBalanceOfSystemCost = 0.2;% Installation (I) and BoS cost as % of cost of PV+battery+Inv [% of Investment cost] (source: Masters, Renewable and Efficient Electric Power Systems,)
EcoParameters.plantLifetime = 20;            % plant LifeTime [year] 
EcoParameters.interestRate = 0.06;           % rate of interest defined as (HOMER) = nominal rate - inflation
% Battery cost defined as:
%costBatt_tot = costBatt_coef_a * battery_capacity [kWh] + costBatt_coef_b (source: Uganda data)


% System components 
% System details and input variables are as follows

% Balance Of System: account for such factors as soiling of the panels, 
% wiring losses, shading, snow cover, aging, and so on
PvParameters.balanceOfSystem = 0.85;               
PvParameters.nominalAmbientTemperatureC = 20;    % Nominal ambient test-temperature of the panels [C]
PvParameters.nominalCellTemperatureC = 47;        % Nominal Operating Cell Temperature [C]
PvParameters.nominalIrradiation = 0.8;           % Irradiation at nominal operation [kW / m^2]
PvParameters.powerDerateDueTemperature = 0.004;  % Derating of panel's power due to temperature [/C]

% Battery
BattParam.minStateOfCharge = 0.4;            

BattParam.initialStateOfCharge = 1;             
BattParam.chargingEfficiency = 0.85; 
BattParam.dischargingEfficiency = 0.9;
% ratio power / energy of the battery (a measure for how fast battery
% can be charged and discharged depending on current Kwh level
BattParam.powerEnergyRatio = 0.5; 
BattParam.maxOperationalYears = 5;    % maximum years before battery replacement


% Inverter
InvParam.efficiency = 0.9;


% Loading input data : (load-filename, irradiaton-filename, temperature-filename)
SimInputData = SimulationInputData('LoadCurve_normalized_single_3percent_100.mat',...
                                   'solar_data_Phuntsholing_baseline.mat',...
                                   'surface_temp_phuent_2004_hour.mat',...
                                   'bhutan');

% Control signals for script
ProgramControl.simulate = true;
ProgramControl.economicAnalysis = true;
ProgramControl.llpConstrainedOptimums = true;
ProgramControl.plotStateOfCharge = false;
ProgramControl.plotAverageStateOfCharge = false;
ProgramControl.plotPowerBalance = false;
ProgramControl.plotAveragePowerBalance = false;

                                                             
                               
%% Simulation

if ProgramControl.simulate
    
    SapvOutput = sapv_plant_simulation( SimParameters,...
                                        PvParameters,...
                                        BattParam,...
                                        InvParam,...
                                        SimInputData);

end

if ProgramControl.economicAnalysis

    EconomicOutput = economic_analysis( SimParameters,...
                                BattParam,...
                                InvParam,...
                                SimInputData,...
                                EcoParameters,...
                                SapvOutput);
end

if ProgramControl.llpConstrainedOptimums

    OptSolutions = llp_constrained_optimums(SimParameters,...
                                                SapvOutput,...
                                                EconomicOutput);
end


%% Plotting

if ProgramControl.plotStateOfCharge
    
    plot_state_of_charge( SimParameters,...
                          BattParam,...
                          SapvOutput,...
                          OptSolutions.pvIndexes(1),...
                          OptSolutions.battIndexes(1))
end

if ProgramControl.plotAverageStateOfCharge
    
    plot_average_state_of_charge( SimParameters,...
                          BattParam,...
                          SapvOutput,...
                          OptSolutions.pvIndexes(1),...
                          OptSolutions.battIndexes(1))
end


if ProgramControl.plotPowerBalance
    
    plot_power_balance( BattParam,...
                        InvParam,...
                        SimInputData,...
                        SapvOutput,...
                        OptSolutions.pvIndexes(1),...
                        OptSolutions.battIndexes(1))
end

if ProgramControl.plotAveragePowerBalance
    
    plot_average_power_balance(BattParam,...
                               InvParam,...
                               SimInputData,...
                               SapvOutput,...
                               OptSolutions.pvIndexes(1),...
                               OptSolutions.battIndexes(1))
end

if false
   
   old_plot_power_balance( SimInputData,...
                               SapvOutput,...
                               OptSolutions.pvIndexes(1),...
                               OptSolutions.battIndexes(1))
end

if false
    
    old_plot_average_power_balance( SimInputData,...
                                    SapvOutput,...
                                    OptSolutions.pvIndexes(1) )
end
toc






