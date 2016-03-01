classdef EconomicAnalysisOutputs
    %ECOOUTPUT The output class from Economic Analysis
        % all variables are m*n except CRF which is scalar. m and n are the
        % pv step and the battery step respectively.
    % - levelizedCostOfEnergy : Levelized Cost of Energy i.e. cost per kWh of building and 
        % operating the plant over an assumed life cycle. This is important
        % as we want it to be competitive with the grid levelizedCostOfEnergy. See eqn. 
        % (7.6) in thesis Stefano Mandelli.
    % Balance of system : Balance of system describes the percentage in 
        % loss (dirtying, wiring loss, snow etc) and installation cost on
        % PV
    
    properties (SetAccess = private)
        % all are nPv nBatt matrices or scalar
        investmentCost         
        netPresentCost         
        levelizedCostOfEnergy       
        battCostTot                    
        inverterCostTot        
        pvCostTot
        installBalanceOfSystemTotCost           
        operationsMaintenanceReplacementTotCost 
        capitalRecoveryFactor % see wikipedia
        nBattEmployed    
    end
    
    methods
    function ecoOutput = EconomicAnalysisOutputs(investment_cost,... 
            netPresentCost,... 
            levelizedCostOfEnergy,...
            battCostTot,...
            inverterCostTot,...
            pvCostTot,...
            installBalanceOfSystemTotCost,...
            operationsMaintenanceReplacementTotCost,...     
            capitalRecoveryFactor,...
            nBattEmployed)

        ecoOutput.investmentCost = investment_cost;          
        ecoOutput.netPresentCost = netPresentCost;
        ecoOutput.levelizedCostOfEnergy = levelizedCostOfEnergy;

        ecoOutput.battCostTot = battCostTot;
        ecoOutput.inverterCostTot = inverterCostTot;
        ecoOutput.pvCostTot = pvCostTot;

        ecoOutput.installBalanceOfSystemTotCost = installBalanceOfSystemTotCost;
        ecoOutput.operationsMaintenanceReplacementTotCost ...
                        = operationsMaintenanceReplacementTotCost ;
        ecoOutput.capitalRecoveryFactor = capitalRecoveryFactor ;
        ecoOutput.nBattEmployed = nBattEmployed ;
    end
    end
    
end

