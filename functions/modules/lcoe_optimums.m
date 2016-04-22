function [ OptSol ] = lcoe_optimums( SimPar, SimOut, EcoOut )
%LCOE_OPTIMUMS Summary of this function goes here
%   Detailed explanation goes here

    dim = size(EcoOut.levelizedCostOfEnergy);
    nPv = dim(1);
    nBatt = dim(2);
    
    minLcoe = min(min(EcoOut.levelizedCostOfEnergy));
    [iPv, jBatt] = find(EcoOut.levelizedCostOfEnergy == minLcoe);
    
    boundFound = false;
    
    for i = -1:1
        for j = -1:1
            % staying within bounds
            if (iPv + i > 0 && iPv + i <= nPv)...
            && (jBatt + i > 0 && jBatt + i <= nBatt)
        
                OptSol = OptimalSolutions(iPv,jBatt,...
                                          SimPar.pv_step_to_kw(iPv - 1),...
                                          SimPar.batt_step_to_kwh(jBatt - 1),...
                                          SimOut.lossOfLoadProbability(iPv,jBatt),...
                                          EcoOut.levelizedCostOfEnergy(iPv,jBatt),...
                                          EcoOut.investmentCost(iPv,jBatt));
                
            else
                
                boundFound = true;
                
            end
            
            
        end
    end
    
    if boundFound
        
        warning(['There might be lower LCoE (levelized cost of energy) ' ...
        'values if you extend your sim parameter range, see the sim overview plot!'])
    end
    
    if isempty(OptSol.pvIndexes)
        disp('NO solutions found, expand search perimeter')
    end
    
end

