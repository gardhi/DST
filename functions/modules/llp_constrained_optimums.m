function [ OptOut ] = llp_constrained_optimums( SimPar, SimOutput, EcoOut )
%LLPOPTIMALSOLUTION For a range of  lossOfLoadProbability, find cheapest solutions
%   Detailed explanation goes here

[iPvOpt, iBattOpt] = deal(zeros(1,length(SimPar.llpSearchTargets)));

optSolutionCounter = 0;
for i = 1 : length(SimPar.llpSearchTargets) 
    
    clear NPC_opt
    
    % Find simulations pv and batt pair with a spesific lossOfLoadProbability
    % (loss of loadpercentage)
    [pvSolutions, battSolutions] = find(...
                                    (SimPar.llpSearchTargets(i)...
                                   - SimPar.llpSearchAcceptance) ...
                                   < SimOutput.lossOfLoadProbability ...
                                   & ...
                                   SimOutput.lossOfLoadProbability ...
                                   <(SimPar.llpSearchTargets(i) ...
                                   + SimPar.llpSearchAcceptance) );    
    
    % From the different pairs above, we only want the one with the smallest NPC 
    [optimalNetPresentCost, optimalIndex] = min( diag(...
                                            EcoOut.netPresentCost(...
                                            pvSolutions, battSolutions)) );
    % finds the system within the targeted set that has the minimal NPC
    
    % if there was any lossOfLoadProbability match at all
    if optimalNetPresentCost    
        optSolutionCounter = optSolutionCounter + 1;

        % find the index of the pairs
        iPvOpt(optSolutionCounter) = pvSolutions(optimalIndex); 
        iBattOpt(optSolutionCounter) = battSolutions(optimalIndex);

    end
end

iPvOpt = iPvOpt(find(iPvOpt));
iBattOpt = iBattOpt(find(iBattOpt));



OptOut = OptimalSolutions(iPvOpt,...
                         iBattOpt,...
                         SimPar.pv_step_to_kw(iPvOpt - 1),...
                         SimPar.batt_step_to_kwh(iBattOpt - 1),...
                         diag(SimOutput.lossOfLoadProbability(iPvOpt, iBattOpt)),...
                         diag(EcoOut.levelizedCostOfEnergy(iPvOpt, iBattOpt)),...
                         diag(EcoOut.investmentCost(iPvOpt, iBattOpt)));

end

