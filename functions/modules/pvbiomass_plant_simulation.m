function [ SimOut ] = pvbiomass_plant_simulation( SimParam, PvParam, BattParam, InvParam, SimData, BiomParam)
%SAPVPLANTSIMULATION Simulates the Battery and PV dynamics based on load
%and pv simulation input. SAPV stands for stand-alone PV
%   for each pair of battery size and pv size, the simulation runs the
%   entire span of hours in the inputData struct. These are assumeed
%   synchronized (they represent the data at same times, no time offset).



% Declaration of simulation variables
[inputPowerUnused,...
lossOfLoad, stateOfCharge,...
battOutputKw,...
biomassGeneratorOutputKw,...
neededBattOutputKw]...
= deal(zeros(SimData.nHours, SimParam.nPvSteps, SimParam.nBattSteps));

[sumPartialCyclesUsed,...
lossOfLoadTot,...
lossOfLoadProbability]...
 = deal(zeros( SimParam.nPvSteps, SimParam.nBattSteps)); 

[pvPowerAbsorbedKw] ...
 = deal(zeros(SimData.nHours,SimParam.nPvSteps));

% the occurrence counter of the biomass system
[BiomOccurrences.startupTime,...
BiomOccurrences.runningPreemptively,...
BiomOccurrences.runningPreemptivelyTime,...
BiomOccurrences.waitingToRetry,...
BiomOccurrences.waitingToRetryTime,...
BiomOccurrences.waitingForBiomass,...
BiomOccurrences.waitingForBiomassTime] ...
= deal(zeros(SimParam.nPvSteps, SimParam.nBattSteps));

% Cell temperature as function of ambient temperature [C]
pvTemperatureC = SimData.temperatureC...
               + SimData.irradiation ...
               .* (PvParam.nominalCellTemperatureC ...
               - PvParam.nominalAmbientTemperatureC)...
               / PvParam.nominalIrradiation;                          

% cell efficiency as function of temperature
cellEfficiency = 1 - PvParam.powerDerateDueTemperature ...
                 .* (pvTemperatureC - PvParam.nominalAmbientTemperatureC);   

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
                       
        %BIOMASS INITIATION
        % biomass system state machine initialization
        runBiomassGeneratorHours = 0;
        biomassSystemState = 'IDLE';
        previousState = 'RUNNING';
        % remove rest of biomass from previous simulation
        availableBiomassKw = BiomParam.biomassDeliveredKw;
                                                                                                             
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

            % A new day starts
            if mod(t,24) == 0 && BiomParam.isPreemptive

                % the predicted weather is cloudy
                if strcmp(weatherPredictions{t/24 + 1}, 'cloudy')

                    isSunny = false;

                    if strcmp(biomassSystemState, 'WAITING TO RETRY')

                        previousState = 'RUNNING PREEMPTIVELY';

                    else

                        biomassSystemState = 'RUNNING PREEMPTIVELY';

                    end
                    
                    BiomOccurrences.runningPreemptively(iPv, jBatt) = ...
                    BiomOccurrences.runningPreemptively(iPv, jBatt) + 1;

                % the predicted weather is sunny
                else

                    isSunny = true; 

                end


            end

            % STATE MACHINE -----------------------------------------------
            % RUNNING PREEMPTIVELY-----------------------------------------
            if strcmp(biomassSystemState, 'RUNNING PREEMPTIVELY')

                BiomOccurrences.runningPreemptivelyTime(iPv, jBatt) = ...
                BiomOccurrences.runningPreemptivelyTime(iPv, jBatt) + 1;
                
                % the system should stop running preemptively because of
                % sunny weather or full battery
                if isSunny||(stateOfCharge(t,iPv,jBatt) == 1)

                    biomassSystemState = 'IDLE';

                % we stay in preemptive mode
                else

                    runBiomassGeneratorHours = 1;

                end

            % RUNNING------------------------------------------------------
            elseif strcmp(biomassSystemState, 'RUNNING')

                % PV can handle the supply alone
                if neededBattOutputKw(t,iPv, jBatt) < 0

                    biomassSystemState = 'IDLE';

                % we stay in running mode
                else 

                    runBiomassGeneratorHours = 1;

                end

            % IDLE---------------------------------------------------------
            elseif strcmp(biomassSystemState, 'IDLE')

                % The battery is at minimum and power is insufficient
                if (stateOfCharge(t, iPv, jBatt) == BattParam.minStateOfCharge)...
                && (neededBattOutputKw(t,iPv, jBatt) > 0);

                    biomassSystemState = 'STARTING UP';
                    startupDelayTimer = t;

                end

            % INSUFFICIENT BIOMASS-----------------------------------------
            elseif strcmp(biomassSystemState, 'INSUFFICIENT BIOMASS')

                % Count hours spent waiting for biomass
                BiomOccurrences.waitingForBiomassTime(iPv,jBatt) =...
                BiomOccurrences.waitingForBiomassTime(iPv,jBatt) + 1;

                % more biomass is available
                if availableBiomassKw > BiomParam.generatorOutputKw

                    % prepare for normal operation
                    biomassSystemState = 'IDLE';

                end


            end

            % STARTING UP--------------------------------------------------
            if strcmp(biomassSystemState, 'STARTING UP')

                % The time left
                residualTime = BiomParam.startupDelayHours...
                             - (t - startupDelayTimer);

                % The generator is not needed
                if neededBattOutputKw(t,iPv, jBatt) < 0

                    biomassSystemState = 'IDLE';

                % The timer is done
                elseif residualTime <= 1

                    % Account for time spent starting up
                    BiomOccurrences.startupTime(iPv, jBatt) = ...
                    BiomOccurrences.startupTime(iPv, jBatt) + 1;
                    
                    % run the generator 
                    runBiomassGeneratorHours = residualTime;

                    biomassSystemState = 'RUNNING';
                    
                else
                    
                    % Account for time spent starting up
                    BiomOccurrences.startupTime(iPv, jBatt) = ...
                    BiomOccurrences.startupTime(iPv, jBatt) + 1;

                end


            % WAITING TO RETRY---------------------------------------------
            elseif strcmp(biomassSystemState, 'WAITING TO RETRY')

                % The time left
                residualTime = BiomParam.retryDelayHours ...
                             - (t - waitToRetryTimer);                        

                % The timer is done
                if residualTime <= 1
                    
                    % Account for time spent waiting to retry
                    BiomOccurrences.waitingToRetryTime(iPv, jBatt) = ...
                    BiomOccurrences.waitingToRetryTime(iPv, jBatt) + residualTime; 

                    % The timer finish this hour
                    if residualTime >= 0

                        % run the generator
                        runBiomassGeneratorHours = residualTime;

                    % The timer finished last hour
                    else

                        runBiomassGeneratorHours = 1;

                    end

                    % return to previous state
                    biomassSystemState = previousState;

                else
                    
                    % Account for time spent waiting to retry
                    BiomOccurrences.waitingToRetryTime(iPv, jBatt) = ...
                    BiomOccurrences.waitingToRetryTime(iPv, jBatt) + 1; 
                    
                end

            end

            % The biomass generator should run for runBiomassGeneratorHours
            if runBiomassGeneratorHours

                    generatorOutputKw = runBiomassGeneratorHours...
                                      * BiomParam.generatorOutputKw;

                    % There is sufficient biomass
                    if availableBiomassKw > generatorOutputKw

                        % The needed output is larger than generator kw size
                        if (neededBattOutputKw(t,iPv, jBatt)...
                           * runBiomassGeneratorHours) > generatorOutputKw

                            previousState = biomassSystemState;
                            biomassSystemState = 'WAITING TO RETRY';

                            waitToRetryTimer = t;

                            BiomOccurrences.waitingToRetry(iPv,jBatt) = ...
                            BiomOccurrences.waitingToRetry(iPv,jBatt) + 1;

                            % The generator will still run the given time
                            % before the insuficient output is discovered.
                        end

                        neededBattOutputKw(t,iPv, jBatt) ...
                                         = neededBattOutputKw(t,iPv, jBatt)...
                                         - generatorOutputKw;

                        biomassGeneratorOutputKw(t,iPv,jBatt) ...
                                         = generatorOutputKw;

                        availableBiomassKw = availableBiomassKw...
                                           - generatorOutputKw;

                    else

                        biomassSystemState = 'INSUFFICIENT BIOMASS';
                        BiomOccurrences.waitingForBiomass(iPv,jBatt) = ...
                        BiomOccurrences.waitingForBiomass(iPv,jBatt) + 1;

                    end

                    % will only run what the state machine outputs.
                    runBiomassGeneratorHours = 0;

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
                % in charging (positive number when discharging) [kW]
                
                % the battery output limit is reached
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

                % the battery is at minimum capacity                 
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
                    % the minimum state of charge:
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


SimOut = SimulationOutputs(...
            pvPowerAbsorbedKw,...
            neededBattOutputKw,...
            battOutputKw,...
            lossOfLoad,...
            lossOfLoadTot,...
            lossOfLoadProbability,...
            inputPowerUnused,...
            stateOfCharge,...
            sumPartialCyclesUsed,...
            biomassGeneratorOutputKw,...
            BiomOccurrences);



end




