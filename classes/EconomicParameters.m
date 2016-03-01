classdef EconomicParameters
    %ECONOMICPARAMETERS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        budget                      % Budget in EUR
        pvCostKw                    % PV panel cost [/kW] (source: Uganda data)
        battCostKwh                 % variable cost [per kWh]  %132.78;
        battCostFixed               % fixed cost
        inverterCostKw              % Inverter cost [/kW] (source: MCM_Energy Lab + prof. Silva exercise, POLIMI)
        operationMaintenanceCostKw  % Operations & Maintenance cost for the overall plant [/kW*year] (source: MCM_Energy Lab)
        installBalanceOfSystemCost  % Installation (I) and BoS cost as % of cost of PV+battery+Inv [% of Investment cost] (source: Masters, Renewable and Efficient Electric Power Systems,)
        plantLifetime               % plant LifeTime [year] 
        interestRate                % rate of interest defined as (HOMER) = nominal rate - inflation

    end
    
    methods
    end
    
end

