function [ Set ] = get_set_default_dst_gui()
%GET_SET_DEFAULT_DST_GUI Summary of this function goes here
%   Detailed explanation goes here
        % DEFAULT values 
        % Simulation Default Parameters:
        Set.pvStartKw = '100';
        Set.pvStopKw = '200';
        Set.pvStepKw = '10';
        Set.battStartKwh = '1200';
        Set.battStopKwh = '1300';
        Set.battStepKwh = '10';
        Set.llpAccept = '0.5';
        Set.llpStart = '1';
        Set.llpStop = '80';
        Set.llpStep = '5';
        Set.npcAccept = '1000';
        Set.npcStart = '900000';
        Set.npcStop = '1400000';
        Set.npcStep = '20000';

        % Economic Default Parameters
        Set.budget = '1500000';
        Set.pvCostKw = '1000';
        Set.battCostKwh = '140';              
        Set.battCostFixed = '0';             
        Set.inverterCostKw = '500';          
        Set.operationMaintenanceCostKw = '50';
        Set.installBalanceOfSystemCost = '2';%
        Set.plantLifetime = '20';           
        Set.interestRate = '6';% 
        Set.biomassCostKw = '0';
        Set.biomassSystemInvestmentCost = '20000';
        Set.biomassSystemOperationCost = '100';
        

        %PV Default Parameters
        Set.balanceOfSystem = '85';  %             
        Set.nominalAmbientTemperatureC = '20';    % Nominal ambient test-temperature of the panels [C]
        Set.nominalCellTemperatureC = '47';        % Nominal Operating Cell Temperature [C]
        Set.nominalIrradiation = '0.8';           % Irradiation at nominal operation [kW / m^2]
        Set.powerDerateDueTemperature = '0.004';  % Derating of panel's power due to temperature [/C]

        % Battery Default Parameters
        Set.minStateOfCharge = '40'; %            
        Set.initialStateOfCharge = '100'; %;             
        Set.chargingEfficiency = '85'; % 
        Set.dischargingEfficiency = '90'; %
        Set.powerEnergyRatio = '0.5'; 
        Set.maxOperationalYears = '5';  

        % Inverter Default Parameters
        Set.invEfficiency = '90';
        
        % Indata Filenames
        Set.loadProfileData = 'LoadCurve_normalized_single_3percent_100.mat';
        Set.irradiationData = 'solar_data_Phuntsholing_baseline.mat';
        Set.temperatureData = 'surface_temp_phuent_2004_hour.mat';
        Set.dataSetFolderName = 'bhutan';
        
        % biomas
        Set.checkBoxBiomass = '1';
        
        Set.isPreemptive = '1';
        Set.powerTreshold = '0.6';
        Set.biomassDeliveredKw = '100';
        Set.biomassDeliveryIntervalDays = '7';
        Set.generatorOutputKw = '15';
        Set.startupDelayHours = '0.5';
        Set.retryDelayHours = '5';



end

