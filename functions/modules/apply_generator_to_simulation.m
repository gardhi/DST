function [ SimOut ] = apply_generator_to_simulation( ...
                           SimOut,...
                           iPv, jBatt,...
                           availableBiomassWeeklyKw,...
                           generatorOutputCapacityKw,...
                           delay)
%APPLY_GENERATOR_TO_SIMULATION Applies a generator to the system
%   a one hour dela
generatorIsOn = false;
availableBiomassKw = 0;
startupDelayHours = delay;
for i = 1:SimOut.lossOfLoad(:,iPv,jBatt)
    
    if mod(t,168)
        availableBiomassKw = availableBiomassKw ...
                           + availableBiomassWeeklyKw;
    end

    if SimOut.lossOfLoad(t,iPv,jBatt) > 0
       if generatorIsOn &&...
          availableBiomassKw > generatorOutputCapacityKw
           
           SimOut.lossOfLoad(t,iPv,jBatt) = ...
                                      SimOut.lossOfLoad(t,iPv,jBatt)...
                                      + generatorOutputCapacityKw;
           
           SimOut.biomassGeneratorOutputKw(t,iPv,jBatt) =...
                                      generatorOutputCapacityKw;
           
       elseif generatorIsOn
           generatorIsOn = false;
           
       else
           if startupDelayHours < 1
               
              SimOut.generator
               
           end
           
       end
        
    end
   
   
   
end

end

