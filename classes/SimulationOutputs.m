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
                            sumPartialCyclesUsed)
                        
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
           end
        end

    end
    
end

