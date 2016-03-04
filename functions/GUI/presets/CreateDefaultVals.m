
clear all;

% DEFAULT values 
% Simulation Default Parameters:
pvStartKw = '100';
pvStopKw = '200';
pvStepKw = '10';
battStartKwh = '1200';
battStopKwh = '1300';
battStepKwh = '10';
llpAccept = '5';
llpStart = '1';
llpStop = '80';
llpStep = '5';
  
% Economic Default Parameters
budget = '200000';
pvCostKw = '1000';
battCostKwh = '140';              
battCostFixed = '0';             
inverterCostKw = '500';          
operationMaintenanceCostKw = '50';
installBalanceOfSystemCost = '2';%
plantLifetime = '20';           
interestRate = '6';%  

%PV Default Parameters
balanceOfSystem = '85';  %             
nominalAmbientTemperatureC = '20';    % Nominal ambient test-temperature of the panels [C]
nominalCellTemperatureC = '47';        % Nominal Operating Cell Temperature [C]
nominalIrradiation = '0.8';           % Irradiation at nominal operation [kW / m^2]
powerDerateDueTemperature = '0.004';  % Derating of panel's power due to temperature [/C]

% Battery Default Parameters
minStateOfCharge = '40'; %            
initialStateOfCharge = '100'; %;             
chargingEfficiency = '85'; % 
dischargingEfficiency = '90'; %
powerEnergyRatio = '0.5'; 
maxOperationalYears = '5';  

% Inverter Default Parameters
invEfficiency = '90';

save('functions/GUI/presets/xenia')
