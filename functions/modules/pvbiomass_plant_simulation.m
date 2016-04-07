function [ simOutput ] = pvbiomass_plant_simulation( SimParam, PvParam, BattParam, InvParam, SimData, BiomParam)
%SAPVPLANTSIMULATION Simulates the Battery and PV dynamics based on load
%and pv simulation input. SAPV stands for stand-alone PV
%   for each pair of battery size and pv size, the simulation runs the
%   entire span of hours in the inputData struct. These are assumeed
%   synchronized (they represent the data at same times, no time offset).



% Declaration of simulation variables
[inputPowerUnused, lossOfLoad, stateOfCharge,...
 battOutputKw, biomassGeneratorOutputKw, neededBattOutputKw]...
= deal(zeros(SimData.nHours, SimParam.nPvSteps, SimParam.nBattSteps));

[sumPartialCyclesUsed, lossOfLoadTot, lossOfLoadProbability]...
 = deal(zeros( SimParam.nPvSteps, SimParam.nBattSteps)); 

[pvPowerAbsorbedKw] ...
 = deal(zeros(SimData.nHours,SimParam.nPvSteps));

% Cell temperature as function of ambient temperature [C]
PvTemperature = SimData.temperature...
            + SimData.irradiation ...
            .* (PvParam.nominalCellTemperatureC ...
            - PvParam.nominalAmbientTemperatureC)...
            / PvParam.nominalIrradiation;                          

% cell efficiency as function of temperature
cellEfficiency = 1 - PvParam.powerDerateDueTemperature ...
                 .* (PvTemperature - PvParam.nominalAmbientTemperatureC);   

%% Plant simulation
% iterate over all PV power sizes from pvStartKw to pvStopKw
for iPv = 1 : SimParam.nPvSteps

    % the output kw for this size of pv
    iPvKw = SimParam.pv_step_to_kw(iPv - 1);              

    % array with Energy from the PV for each time step throughout the year.
    % see p.191 of thesis Stefano Mandelli
    pvPowerAbsorbedKw(:,iPv) = SimData.irradiation ...
                          .* iPvKw ...
                          .* cellEfficiency ...
                          .* PvParam.balanceOfSystem;
                      
    % predicting the weather
    weatherPredictions = get_weather_predictions(pvPowerAbsorbedKw(:,iPv),...
                                                BiomParam.nomPeakPvPowerTreshold);

    % no biomass from last simulation should
    availableBiomassKw = 0;
                                                 

    % iterate over all battery capacities from min_batt to max_batt
    for jBatt = 1 : SimParam.nBattSteps
            
        % The demand from the grid that is not met by the PV output.
        % if negative, the battery can charge
        neededBattOutputKw(:,iPv, jBatt) = SimData.load ...
                                  / InvParam.efficiency...
                                  - pvPowerAbsorbedKw(:,iPv)';  

        % the battery kwh capacity of this battery step
        jBattKwh = SimParam.batt_step_to_kwh(jBatt - 1);  
        
        stateOfCharge(1,iPv,jBatt) = BattParam.initialStateOfCharge;            
        
        battMaxPowerFlow = BattParam.powerEnergyRatio...
                           * jBattKwh;     
                       
        % biomass system state machine initialization
        biomassSystemState = 'IDLE';
        previousState = 'IDLE';
                                                                                                             
        % iterate through the timesteps of one year
        for t = 1 : SimData.nHours                                    
            if t > 8 
                if neededBattOutputKw(t-1,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-2,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-3,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-4,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-5,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-6,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-7,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t-8,iPv, jBatt) > 0 ...
                && neededBattOutputKw(t,iPv, jBatt) < 0
                % battery has been discharged consistently the previous
                % 8 hours and is now charging.
                   
                   % Depth of Discharge is the opposite of State of Charge
                   depthOfDischarge = 1 - stateOfCharge(t,iPv,jBatt);            
                   
                   nMaxPartialCycles = cycles_to_failure(depthOfDischarge);
                   
                   sumPartialCyclesUsed(iPv, jBatt) ...
                                    = sumPartialCyclesUsed(iPv, jBatt)...
                                    + 1/(nMaxPartialCycles);
                end
            end
            
            % BIOMASS SYSTEM GENERATION ===================================
            % (written by Gard Hillestad)
            
            % delivering biomass
            if mod(t, BiomParam.biomassDeliveryIntervalDays*24) == 0
                
               availableBiomassKw = availableBiomassKw ...
                                  + BiomParam.biomassDeliveredKw; 
                
            end
            
            % checking if it's a new day.
            if mod(t,24) == 0
                isNewDay = true;
                day = t/24 + 1;
            else
                isNewDay = false;
            end
            
            % IDLE---------------------------------------------------------
            if strcmp(biomassSystemState, 'IDLE')
                % checking if system should run preemptively
                if isNewDay ...
                && strcmp(weatherPredictions{day},'cloudy') ...
                && BiomParam.isPreemptive
            
                    biomassSystemState = 'RUNNING PREEMPTIVELY';
                    
                % checking if grid is offline (loss of load)
                elseif stateOfCharge(t, iPv, jBatt) == BattParam.minStateOfCharge...
                && neededBattOutputKw(t,iPv, jBatt) > 0;
            
                    biomassSystemState = 'STARTING UP';
                    startupDelayTimer = t;
                end
            
            % STARTING UP--------------------------------------------------
            elseif strcmp(biomassSystemState, 'STARTING UP')
                % checking if system should run preemptively
                residualTime = BiomParam.startupDelayHours...
                             - (t - startupDelayTimer);
                if isNewDay ...
                && strcmp(weatherPredictions{day},'cloudy') ...
                && BiomParam.isPreemptive
            
                    biomassSystemState = 'RUNNING PREEMPTIVELY';
                % checking if generator is not needed.
                elseif neededBattOutputKw(t,iPv, jBatt) < 0
                    
                    biomassSystemState = 'IDLE';
                    
                % checking if countdown is over, or less than one hour
                elseif residualTime < 1
                 
                    % the generator starts, residual time accounts for
                    % either the remaining waiting time of this hour (i.e
                    % if 0.2 then 1-0.2 = 0.8, the generator should run for
                    % 0.8 of this hour. Or if -0.2, meaning that the delay 
                    % is 0.8 and that it should have started 0.2
                    % hours ago 1 -- 0.2 = 1.2 and should also run this hour)
                    partialGeneratorOutputKw = (1-residualTime)...
                                             * BiomParam.generatorOutputKw;

                    % running generator for < 1 hour                  
                    if availableBiomassKw > partialGeneratorOutputKw
                        
                        neededBattOutputKw(t, jBatt) = neededBattOutputKw(t,iPv, jBatt)...
                                                        - partialGeneratorOutputKw;
                        biomassGeneratorOutputKw(t,iPv,jBatt) = ...
                                                        partialGeneratorOutputKw;
                        availableBiomassKw = availableBiomassKw...
                                           - partialGeneratorOutputKw;
                        biomassSystemState = 'RUNNING';
                        
                    else
                        biomassSystemState = 'INSUFFICIENT BIOMASS';
                    end
                    
                end
            

            % WAITING TO RETRY---------------------------------------------
            % the biomass system will run 1 hour before shutting off and
            % starting the wait to retry state
            elseif strcmp(biomassSystemState, 'WAITING TO RETRY')
                
                residualTime = BiomParam.retryDelayHours ...
                             - (t - waitToRetryTimer);
                         
                % new forecast changes the state we want to return to         
                if isNewDay ...
                && BiomParam.isPreemptive
            
                    if strcmp(weatherPredictions{day},'cloudy')
                        
                        previousState = 'RUNNING PREEMPTIVELY';
                        
                    elseif strcmp(previousState, 'RUNNING PREEMPTIVELY')
                        
                        biomassSystemState = 'IDLE';
                        
                    end
                end
                
                if residualTime < 1
                 
                    % the generator starts, residual time accounts for
                    % either the remaining waiting time of this hour (i.e
                    % if 0.2 then 1-0.2 = 0.8, the generator should run for
                    % 0.8 of this hour. Or if -0.2, meaning that the delay 
                    % is 0.8 and that it should have started 0.2
                    % hours ago 1 -- 0.2 = 1.2 and should also run this hour)
                    partialGeneratorOutputKw = (1-residualTime)...
                                             * BiomParam.generatorOutputKw;

                    % running generator for < 1 hour                  
                    if availableBiomassKw > partialGeneratorOutputKw
                        
                        neededBattOutputKw(t,iPv, jBatt) ...
                                         = neededBattOutputKw(t,iPv, jBatt)...
                                         - partialGeneratorOutputKw;
                        biomassGeneratorOutputKw(t,iPv,jBatt) ...
                                         = partialGeneratorOutputKw;
                        availableBiomassKw = availableBiomassKw...
                                           - partialGeneratorOutputKw;
                                       
                        biomassSystemState = previousState;
                        previousState = 'WAITING TO RETRY';
                        
                    else
                        biomassSystemState = 'INSUFFICIENT BIOMASS';
                    end
                    
                end
                
                

            % INSUFFICIENT BIOMASS-----------------------------------------
            % assuming that the delivery will not be made at midnight.
            % Preemptiveness may currently only occur from the next day.
            elseif strcmp(biomassSystemState, 'INSUFFICIENT BIOMASS')
                
                if availableBiomassKw > BiomParam.generatorOutputKw
                    
                    biomassSystemState = 'IDLE';
                    
                end
            
            % RUNNING------------------------------------------------------
            elseif strcmp(biomassSystemState, 'RUNNING')
                
                % checking if the system should run preemptively will not
                % go directly to this state
                if isNewDay ...
                && strcmp(weatherPredictions{day},'cloudy') ...
                && BiomParam.isPreemptive
            
                    biomassSystemState = 'RUNNING PREEMPTIVELY';
                    
                % checking if generator is not needed.
                elseif neededBattOutputKw(t,iPv, jBatt) < 0
                    
                    biomassSystemState = 'IDLE';
                    
                % checking if there is sufficient biomass/ fuel available
                elseif availableBiomassKw >= BiomParam.generatorOutputKw


                    neededBattOutputKw(t,iPv, jBatt) ...
                                    = neededBattOutputKw(t,iPv, jBatt)...
                                    - BiomParam.generatorOutputKw;

                    biomassGeneratorOutputKw(t,iPv,jBatt)...
                                       = BiomParam.generatorOutputKw;
                    availableBiomassKw = availableBiomassKw...
                                       - BiomParam.generatorOutputKw;
                                   
                    % if there is still loss of load, the generator is
                    % turned off
                    if neededBattOutputKw(t,iPv, jBatt) > 0
                        
                        biomassSystemState = 'WAITING TO RETRY';
                        waitToRetryTimer = t;
                        previousState = 'RUNNING';
                        
                    end
                    
                else

                    biomassSystemState = 'INSUFFICIENT BIOMASS';
                end
                
            end

            % RUNNING PREEMPTIVELY-----------------------------------------
            if strcmp(biomassSystemState, 'RUNNING PREEMPTIVELY')
                % checking if the system should stop running preemptively
                % because of sunny weather prediction or full battery.
                if (isNewDay ...
                    && strcmp(weatherPredictions{day},'sunny') ...
                    && BiomParam.isPreemptive) ...
                || stateOfCharge(t,iPv,jBatt) == 1
            
                    biomassSystemState = 'IDLE';
                    
                elseif strcmp(previousState, 'WAITING TO RETRY')

                    previousState = biomassSystemState;
                    
                % checking if there is sufficient biomass/ fuel available
                elseif availableBiomassKw >= BiomParam.generatorOutputKw

                    neededBattOutputKw(t,iPv, jBatt) ...
                                    = neededBattOutputKw(t,iPv, jBatt)...
                                    - BiomParam.generatorOutputKw;

                    biomassGeneratorOutputKw(t,iPv,jBatt)...
                                       = BiomParam.generatorOutputKw;
                    availableBiomassKw = availableBiomassKw...
                                       - BiomParam.generatorOutputKw;
                                   
                    % if there is still loss of load, the generator is
                    % turned off      
                    if neededBattOutputKw(t,iPv, jBatt) > 0
                        
                        biomassSystemState = 'WAITING TO RETRY';
                        waitToRetryTimer = t;
                        previousState = 'RUNNING PREEMPTIVELY';
                        
                    end
                    
                else

                    biomassSystemState = 'INSUFFICIENT BIOMASS';
                end
                
            end

            % BATTERY OPERATION ===========================================
            % CHARGING the battery
            % PV-production is larger than Load. Battery will be charged
            if neededBattOutputKw(t,iPv, jBatt) < 0   
                
                % energy flow that will be stored in the battery i.e. 
                % including losses in charging [kWh]   
                battOutputKw(t, iPv, jBatt) = neededBattOutputKw(t,iPv, jBatt) ...
                                            * BattParam.chargingEfficiency;    
               
                % in-flow exceeds the battery power limit
                if (abs(neededBattOutputKw(t,iPv, jBatt))) > battMaxPowerFlow...
                && stateOfCharge(t,iPv,jBatt) < 1                          
                    
                    battOutputKw(t, iPv, jBatt) = battMaxPowerFlow ...
                                * BattParam.chargingEfficiency;

                    inputPowerUnused(t,iPv, jBatt) ...
                                    = inputPowerUnused(t,iPv, jBatt) ...
                                    + (abs(neededBattOutputKw(t,iPv, jBatt))...
                                    - battMaxPowerFlow);
                end

                stateOfCharge(t+1,iPv,jBatt) = stateOfCharge(t,iPv,jBatt) ...
                                             + abs(battOutputKw(t, iPv, jBatt)) ...
                                             / jBattKwh;
                
                % The battery is fully charged.
                if stateOfCharge(t+1,iPv,jBatt) > 1

                    
                    inputPowerUnused(t,iPv, jBatt) ...
                                        = inputPowerUnused(t,iPv, jBatt)...
                                        + (stateOfCharge(t+1,iPv,jBatt) - 1) ...
                                        * jBattKwh ...
                                        / BattParam.chargingEfficiency;
                    
                    stateOfCharge(t+1,iPv,jBatt) = 1;
                  
                end
            
            else
                % DISCHARGING the battery
                battOutputKw(t, iPv, jBatt) = neededBattOutputKw(t,iPv, jBatt) ...
                            / BattParam.dischargingEfficiency; 
                % total energy flow from the battery i.e. including losses 
                % in charging (positive number since discharging) [kWh]  
                
                % checking the battery kw output limit
                if neededBattOutputKw(t,iPv, jBatt) > battMaxPowerFlow ...
                && stateOfCharge(t,iPv,jBatt) > BattParam.minStateOfCharge;         
                    
                    battOutputKw(t, iPv, jBatt) = battMaxPowerFlow ...
                                    / BattParam.dischargingEfficiency;
                    
                    % Adding the part to lostLoad due to exceeding the 
                    % battery discharging speed
                    lossOfLoad(t,iPv, jBatt) = lossOfLoad(t,iPv, jBatt)...
                                         + (neededBattOutputKw(t,iPv, jBatt) ...
                                         - battMaxPowerFlow)...
                                         * InvParam.efficiency;

                end

                stateOfCharge(t+1,iPv,jBatt) = stateOfCharge(t,iPv,jBatt) ...
                                             - battOutputKw(t, iPv, jBatt) ...
                                             / jBattKwh;

                if stateOfCharge(t+1,iPv,jBatt) < BattParam.minStateOfCharge

                    % adding the part to lostLoad due to not enough energy 
                    % in battery (using that battery must stay at minStateOfCharge)
                    lossOfLoad(t,iPv, jBatt) = lossOfLoad(t,iPv, jBatt) ...
                                        + (BattParam.minStateOfCharge ...
                                        - stateOfCharge(t+1,iPv,jBatt))...
                                        * jBattKwh ...
                                        * BattParam.dischargingEfficiency...
                                        * InvParam.efficiency;     

                    % the battery does not output the amount that exceeds
                    % the minimum state of charge: (edit by Gard)
                    battOutputKw(t,iPv,jBatt) = battOutputKw(t, iPv, jBatt)...
                                              - (BattParam.minStateOfCharge ...
                                              - stateOfCharge(t+1,iPv,jBatt))...
                                              * jBattKwh;

                    stateOfCharge(t+1,iPv,jBatt) = BattParam.minStateOfCharge;
                    
                    
                end
               
                
            end
        end
        
        
        lossOfLoadTot(iPv, jBatt) = sum(lossOfLoad(:,iPv,jBatt));                                                                  
        
        % Loss of Load Probability w.r.t. total load
        lossOfLoadProbability(iPv, jBatt) = lossOfLoadTot(iPv, jBatt) ...
                          / sum(SimData.load, 2);               

    end
end


simOutput = SimulationOutputs(...
            pvPowerAbsorbedKw,...
            neededBattOutputKw,...
            battOutputKw,...
            lossOfLoad,...
            lossOfLoadTot,...
            lossOfLoadProbability,...
            inputPowerUnused,...
            stateOfCharge,...
            sumPartialCyclesUsed,...
            biomassGeneratorOutputKw);



end





