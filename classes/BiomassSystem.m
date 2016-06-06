classdef BiomassSystem
    %BIOSYSTEMSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    enumeration
       IDLE (1)
       RUNNING (2)
       RUNNING_PREEMPTIVELY (3)
       STARTING_UP (4)
       WAITING_TO_RETRY (5)
       INSUFFICIENT_BIOMASS (6)
    end
    
end

