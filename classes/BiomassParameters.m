classdef BiomassParameters
    %BIOMASSPARAMETERS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isPreemptive
        nomPeakPvPowerTreshold
        biomassWeeklySupplyKw
        generatorOutputKw
    end
    
    methods
        function obj = BiomassParameters(...
                            isPreemptive,...
                            nomPeakPvPowerTreshold,...
                            biomassWeeklySupplyKw,...
                            generatorOutputKw)
            if nargin > 0
                obj.isPreemptive = isPreemptive;
                obj.nomPeakPvPowerTreshold = nomPeakPvPowerTreshold;
                obj.biomassWeeklySupplyKw = biomassWeeklySupplyKw;
                obj.generatorOutputKw = generatorOutputKw;
            end
        end
    end
    
end

