function [ SimOut ] = apply_generator_to_simulation( ...
                           SimOut,...
                           iPv, jBatt,...
                           availableBiomassWeeklyKw,...
                           generatorOutputCapacityKw,...
                           delay)
%APPLY_GENERATOR_TO_SIMULATION Applies a generator to a solution
%   the generator is assumed only utilized when there is a loss of load,
%   this does not function the same way as the pvbiom_plant_simulation,
%   since it never charges the battery. This is mainly to see roughly if
%   the average loss of load period can be amended for using a small
%   generator.

% Spec:
% - the generator is turned on with delay when loss of load occurs
% - the generator is turned off when available biomass runs out
% - the generator is turned off after an hour when the generator is unable
% to cover the loss of load kwh.

generatorIsOn = false;
availableBiomassKw = 0;
startupDelayHours = delay;
for i = 1:SimOut.lossOfLoad(:,iPv,jBatt)
    
    if mod(t,168)
        availableBiomassKw = availableBiomassKw ...
                           + availableBiomassWeeklyKw;
    end

    % LOSS OF LOAD
    if SimOut.lossOfLoad(t,iPv,jBatt) > 0
       % if the generator is on and there is enough biomass:
       if generatorIsOn
           if SimOut.lossOfLoad(t,iPv,jBatt) > generatorOutputCapacityKw
               generatorIsOn = false;
           elseif availableBiomassKw > generatorOutputCapacityKw
           
               % eliminate loss of load.
               SimOut.lossOfLoad(t,iPv,jBatt) = ...
                                          SimOut.lossOfLoad(t,iPv,jBatt)...
                                          - generatorOutputCapacityKw;
               % decount biomass availability
               availableBiomassKw = availableBiomassKw...
                                  - generatorOutputCapacityKw;

               % keep track of generator runtime
               SimOut.biomassGeneratorOutputKw(t,iPv,jBatt) =...
                                          generatorOutputCapacityKw;
           else % if there is insufficient biomass:
               % turn off generator
               generatorIsOn = false;
           end
       % the generator has not been turned on yet, we wait for delay to run
       % out
       else
           if startupDelayHours < 1
              % the generator is turned on and the residual time of hour is
              % accounted for
              generatorIsOn = true;
              SimOut.lossOfLoad(t,iPv,jBatt) = SimOut.lossOfLoad(t,iPv,jBatt) ...
                                             - (1 - startupDelayHours) ...
                                             * generatorOutputCapacityKw;
              SimOut.biomassGeneratorOutputKw(t,iPv,jBatt)...
                                              = (1 - startupDelayHours) ...
                                              * generatorOutputCapacityKw;
              availableBiomassKw = availableBiomassKw...
                                 - (1-startupDelayHours)...
                                 * generatorOutputCapacityKw;
           else
               
              startupDelayHours = startupDelayHours - 1;
               
           end
           
       end
    
    % NO LOSS OF LOAD
    else
        % no loss of load means we reset the delay counter as we dont want
        % to turn the generator on anymore
        startupDelayHours = delay;
        generatorIsOn = false;
    end
    
   
   
   
end

end

