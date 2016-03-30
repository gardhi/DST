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
    function obj = EconomicAnalysisOutputs(investment_cost,... 
            netPresentCost,... 
            levelizedCostOfEnergy,...
            battCostTot,...
            inverterCostTot,...
            pvCostTot,...
            installBalanceOfSystemTotCost,...
            operationsMaintenanceReplacementTotCost,...     
            capitalRecoveryFactor,...
            nBattEmployed)

        if nargin > 0
            obj.investmentCost = investment_cost;          
            obj.netPresentCost = netPresentCost;
            obj.levelizedCostOfEnergy = levelizedCostOfEnergy;

            obj.battCostTot = battCostTot;
            obj.inverterCostTot = inverterCostTot;
            obj.pvCostTot = pvCostTot;

            obj.installBalanceOfSystemTotCost = installBalanceOfSystemTotCost;
            obj.operationsMaintenanceReplacementTotCost ...
                            = operationsMaintenanceReplacementTotCost ;
            obj.capitalRecoveryFactor = capitalRecoveryFactor ;
            obj.nBattEmployed = nBattEmployed ;
        end
    end
    end
    
end

