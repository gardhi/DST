function [ ecoOutput ] = economic_analysis( SimParam, BattParam, InvParam, InData, EcoParam, SimOutput)
%ECONOMICANALYSIS The economic implications for every simulated solution
%   O(n^2) loops through every solution of the simulation to make an
%   economic solution space. Changing the SimPar will be sufficient to
%   calculate a different scope of solutions

[nBattEmployed, investmentCost, operationMaintenanceReplacementCost, installBalanceOfSystemTotCost,...
battCostTot, pvCostTot, inverterCostTot, netPresentCost, levelizedCostOfEnergy]...
= deal(zeros(SimParam.nPvSteps, SimParam.nBattSteps));

capitalRecoveryFactor = (EcoParam.interestRate...
      * ((1 + EcoParam.interestRate)...
      ^ EcoParam.plantLifetimeYears))...
      / (((1 + EcoParam.interestRate)...
      ^ EcoParam.plantLifetimeYears) - 1);

for iPv = 1 : SimParam.nPvSteps 
    
    iPvKw = SimParam.pv_step_to_kw(iPv - 1);
    
    for iBatt = 1 : SimParam.nBattSteps
        
        jBattKwh = SimParam.batt_step_to_kwh(iBatt - 1);

        battCostTot(iPv, iBatt) = EcoParam.battCostKwh * jBattKwh...
                                    + EcoParam.battCostFixed;            

        loadPeakKw = max(InData.load);                                   
        
        %inverter is designed on the peak power value
        inverterCostTot(iPv, iBatt) = (loadPeakKw/InvParam.efficiency)...
                                        * EcoParam.inverterCostKw;                                       

        pvCostTot(iPv, iBatt) = EcoParam.pvCostKw...
                                  * iPvKw;
        
        % cost of Balance of System (BoS) and Installation
        installBalanceOfSystemTotCost(iPv, iBatt) = EcoParam.installBalanceOfSystemCost...
                                        * (battCostTot(iPv, iBatt)...
                                        + inverterCostTot(iPv, iBatt)...
                                        + pvCostTot(iPv, iBatt));              

        investmentCost(iPv,iBatt) = pvCostTot(iPv, iBatt) ...
                                  + battCostTot(iPv, iBatt) ...
                                  + inverterCostTot(iPv, iBatt) ...
                                  + installBalanceOfSystemTotCost(iPv, iBatt);    
        
        operationMaintenanceCost = EcoParam.operationMaintenanceCostKw...
                                   * iPvKw;
                            
        % batteries should be replaced after this number of years
        battOperationalYears = 1/SimOutput.sumPartialCyclesUsed(iPv,iBatt)...
                             * InData.nYears; 
        
        if battOperationalYears > BattParam.maxOperationalYears;
           battOperationalYears = BattParam.maxOperationalYears;
        end
        
        nBattEmployed(iPv,iBatt) = ceil(EcoParam.plantLifetimeYears ...
                                  / battOperationalYears);

        nextBatteryReplacementYear = battOperationalYears;
        for k = 1 : EcoParam.plantLifetimeYears
            if k > nextBatteryReplacementYear
                
                operationMaintenanceReplacementCost(iPv,iBatt)...
                                    = operationMaintenanceReplacementCost(iPv,iBatt)...
                                    + battCostTot(iPv, iBatt)...
                                    / ((1 + EcoParam.interestRate)...
                                    ^ battOperationalYears);      
                                    % computing present values of battery
                                    
                % batteries are replaced and new replacement year is set
                nextBatteryReplacementYear = nextBatteryReplacementYear ...
                                           + battOperationalYears;         
            end
            
            % computing present values of Operations & Maintenance
            operationMaintenanceReplacementCost(iPv,iBatt) ...
                                    = operationMaintenanceReplacementCost(iPv,iBatt)...
                                    + operationMaintenanceCost ...
                                    / ((1 + EcoParam.interestRate)^k);     
        end
        operationMaintenanceReplacementCost(iPv,iBatt) ...
                                = operationMaintenanceReplacementCost(iPv,iBatt)...
                                - battCostTot(iPv, iBatt)...
                                * ( (nextBatteryReplacementYear ...
                                - EcoParam.plantLifetimeYears)...
                                / battOperationalYears ) ...
                                / (1 + EcoParam.interestRate)...
                                ^ (EcoParam.plantLifetimeYears);
                                % salvage due to battery life i.e. estimating
                                % how much the batteries are worth after the
                                % lifetime of the system
                            
        % Adding inverter net present cost
        operationMaintenanceReplacementCost(iPv,iBatt) ...
                                = operationMaintenanceReplacementCost(iPv,iBatt)...
                                + inverterCostTot(iPv, iBatt)... 
                                / ((1 + EcoParam.interestRate)...
                                ^ (EcoParam.plantLifetimeYears / 2));          
        
        
netPresentCost(iPv, iBatt) = investmentCost(iPv, iBatt)...
                           + operationMaintenanceReplacementCost(iPv, iBatt);                               

levelizedCostOfEnergy(iPv, iBatt) = (netPresentCost(iPv, iBatt) ...
                   * capitalRecoveryFactor)...
                   ./ (sum(InData.load, 2)...
                   - SimOutput.lossOfLoadTot(iPv, iBatt));                   
 
    end
end

% Levelized Cost of Energy i.e. cost per kWh of building and operating the 
% plant over an assumed life cycle. This is important as we want it to be competitive
% with the grid LCoE. See eqn. (7.6) in thesis Stefano Mandelli.

ecoOutput = EconomicAnalysisOutputs(investmentCost,... 
                                      netPresentCost,... 
                                      levelizedCostOfEnergy,...
                                      battCostTot,...
                                      inverterCostTot,...
                                      pvCostTot,...
                                      installBalanceOfSystemTotCost,...
                                      operationMaintenanceReplacementCost,...     
                                      capitalRecoveryFactor,...
                                      nBattEmployed,0,0);


end

