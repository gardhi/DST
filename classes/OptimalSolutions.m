classdef OptimalSolutions
    %OPTOUTPUT Output from Optimization functions
    %   From the LLPOptS
    
    properties
        % these are the pairs of indexes corresponding to optimal solutions
        % they can be used in the matrices with nPv and nBatt spaces
        pvIndexes      
        battIndexes
        % these are the corresponding sizes of the components
        pvKw                           
        battKwh
        % these describe the optimal solutions
        lossOfLoadProbabilities
        levelizedCostsOfEnergy
        investmentCosts
    end
    
    methods 
        function obj = OptimalSolutions(pvIndexes, battIndexes, pvKw, battKwh,...
                                   lossOfLoadProbabilities,...
                                   levelizedCostsOfEnergy,...
                                   investmentCosts)
            if nargin > 0
                obj.pvIndexes = pvIndexes;
                obj.battIndexes = battIndexes;
                obj.pvKw = pvKw;
                obj.battKwh = battKwh;
                obj.lossOfLoadProbabilities = lossOfLoadProbabilities;
                obj.levelizedCostsOfEnergy = levelizedCostsOfEnergy;
                obj.investmentCosts = investmentCosts;
            end
        end
    end
    
end

