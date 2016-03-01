classdef BatteryParameters
    %BATTERYPARAMETERS contains battery parameters
    % - powerEnergyRatio : ratio power / energy of the battery (a measure
        % for how fast battery can be charged and discharged depending on
        % current Kwh level
    % - minStateOfCharge : minimum allowed State Of Charge. This depends 
        % on the battery type. The choice of SoC_min influences the lifetime 
        % of the batteries.

    properties
        minStateOfCharge
        initialStateOfCharge
        chargingEfficiency
        dischargingEfficiency
        powerEnergyRatio
        maxOperationalYears
    end
    
    methods
    end
    
end

