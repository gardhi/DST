classdef SimulationOutputs
    %SIMOUTPUT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pvPowerAbsorbed
        neededBattOutputKw
        battOutputKw
        lossOfLoad
        lossOfLoadTot
        lossOfLoadProbability
        inputPowerUnusedKw
        stateOfCharge
        sumPartialCyclesUsed
        biomassGeneratorOutputKw
        biomassGeneratorOutputUnusedKw
        BiomassOccurrences
        % battOutputKw
    end


       


    methods
        function obj = SimulationOutputs(pvPowerAbsorbed,...
                            neededBattOutputKw,...
                            battOutputKw,...
                            lossOfLoad,...
                            lossOfLoadTot,...
                            lossOfLoadProbability,...
                            inputPowerUnusedKw,...
                            stateOfCharge,...
                            sumPartialCyclesUsed, ...
                            biomassGeneratorOutputKw,...
                            biomassGeneratorOutputUnusedKw,...
                            BiomassOccurrences)
                        
           if nargin > 0
                obj.pvPowerAbsorbed = pvPowerAbsorbed; 
                obj.neededBattOutputKw = neededBattOutputKw;
                obj.battOutputKw = battOutputKw;
                obj.lossOfLoad = lossOfLoad;
                obj.lossOfLoadTot = lossOfLoadTot;
                obj.lossOfLoadProbability = lossOfLoadProbability;
                obj.inputPowerUnusedKw = inputPowerUnusedKw;
                obj.stateOfCharge = stateOfCharge;
                obj.sumPartialCyclesUsed = sumPartialCyclesUsed;
                obj.biomassGeneratorOutputKw = biomassGeneratorOutputKw;
                obj.biomassGeneratorOutputUnusedKw = biomassGeneratorOutputUnusedKw;
                obj.BiomassOccurrences = BiomassOccurrences;
           end
        end

    end
    
end

