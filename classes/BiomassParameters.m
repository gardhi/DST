classdef BiomassParameters
    %BIOMASSPARAMETERS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isPreemptive
        nomPeakPvPowerTreshold
        biomassDeliveredKw
        biomassDeliveryIntervalDays
        generatorOutputKw
        startupDelayHours
        retryDelayHours
    end
    
    methods
        function obj = BiomassParameters(...
                            isPreemptive,...
                            nomPeakPvPowerTreshold,...
                            biomassDeliveredKw,...
                            biomassDeliveryIntervalDays,...
                            generatorOutputKw,...
                            startupDelayHours,...
                            retryDelayHours)
            if nargin > 0
                obj.isPreemptive = isPreemptive;
                obj.nomPeakPvPowerTreshold = nomPeakPvPowerTreshold;
                obj.biomassDeliveredKw = biomassDeliveredKw;
                obj.biomassDeliveryIntervalDays = biomassDeliveryIntervalDays; 
                obj.generatorOutputKw = generatorOutputKw;
                obj.startupDelayHours = startupDelayHours;
                obj.retryDelayHours = retryDelayHours;
            end
        end
    end
    
end

