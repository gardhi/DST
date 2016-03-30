classdef SimulationOutputs
    %SIMOUTPUT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess='private')
        pvPowerAbsorbed
        neededBattOutputKw
        battOutputKw
        lossOfLoad
        lossOfLoadTot
        lossOfLoadProbability
        pvPowerAbsorbedUnused
        stateOfCharge
        sumPartialCyclesUsed
        peakPvPowerAbsorbedKw
        biomassGeneratorOutputKw
        % battOutputKw
    end


       


    methods
        function obj = SimulationOutputs(pvPowerAbsorbed,...
                            neededBattOutputKw,...
                            battOutputKw,...
                            lossOfLoad,...
                            lossOfLoadTot,...
                            lossOfLoadProbability,...
                            pvPowerAbsorbedUnused,...
                            stateOfCharge,...
                            sumPartialCyclesUsed, ...
                            peakPvPowerAbsorbedKw, ...
                            biomassGeneratorOutputKw)
                        
           if nargin > 0
                obj.pvPowerAbsorbed = pvPowerAbsorbed; 
                obj.neededBattOutputKw = neededBattOutputKw;
                obj.battOutputKw = battOutputKw;
                obj.lossOfLoad = lossOfLoad;
                obj.lossOfLoadTot = lossOfLoadTot;
                obj.lossOfLoadProbability = lossOfLoadProbability;
                obj.pvPowerAbsorbedUnused = pvPowerAbsorbedUnused;
                obj.stateOfCharge = stateOfCharge;
                obj.sumPartialCyclesUsed = sumPartialCyclesUsed;
                obj.peakPvPowerAbsorbedKw = peakPvPowerAbsorbedKw;
                obj.biomassGeneratorOutputKw = biomassGeneratorOutputKw;
           end
        end

    end
    
end

