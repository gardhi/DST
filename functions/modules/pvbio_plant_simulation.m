function [ simOutput ] = pvbio_plant_simulation( SimParam, PvParam, BattParam, InvParam, SimData, BiomParam)
%SAPVPLANTSIMULATION Simulates the Battery and PV dynamics based on load
%and pv simulation input. SAPV stands for stand-alone PV
%   for each pair of battery size and pv size, the simulation runs the
%   entire span of hours in the inputData struct. These are assumeed
%   synchronized (they represent the data at same times, no time offset).

% Declaration of simulation variables
[pvPowerAbsorbedUnused, lossOfLoad, stateOfCharge,...
 battOutputKw, biomassGeneratorOutputKw]...
= deal(zeros(SimData.nHours, SimParam.nPvSteps, SimParam.nBattSteps));

[sumPartialCyclesUsed, lossOfLoadTot, lossOfLoadProbability]...
 = deal(zeros( SimParam.nPvSteps, SimParam.nBattSteps)); 

[pvPowerAbsorbedKw, neededBattOutputKw] ...
 = deal(zeros(SimData.nHours,SimParam.nPvSteps));

peakPvPowerAbsorbed = zeros(SimParam.nPvSteps);

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
                      
    % Reference for the preemptive biomass generator
    peakPvPowerAbsorbedKw = max(pvPowerAbsorbedKw);

    % The demand from the grid that is not met by the PV output.
    % if negative, the battery can charge
    neededBattOutputKw(:,iPv) = SimData.load ...
                              / InvParam.efficiency...
                              - pvPowerAbsorbedKw(:,iPv)';        

    % iterate over all battery capacities from min_batt to max_batt
    for jBatt = 1 : SimParam.nBattSteps
        
        % the battery kwh capacity of this battery step
        jBattKwh = SimParam.batt_step_to_kwh(jBatt - 1);  
        
        stateOfCharge(1,iPv,jBatt) = BattParam.initialStateOfCharge;            
        
        battMaxPowerFlow = BattParam.powerEnergyRatio...
                           * jBattKwh;     
                       
        % Initialize biomass generator.
        % The generator is initially off.
        biomassGeneratorIsOn = false;
        % The available biomass is initially zero, filled at t=0.
        availableBiomassKw = 0;
                                                                                                             
        % iterate through the timesteps of one year
        for t = 1 : SimData.nHours                                    
            if t > 8 
                if neededBattOutputKw(t-1,iPv) > 0 ...
                && neededBattOutputKw(t-2,iPv) > 0 ...
                && neededBattOutputKw(t-3,iPv) > 0 ...
                && neededBattOutputKw(t-4,iPv) > 0 ...
                && neededBattOutputKw(t-5,iPv) > 0 ...
                && neededBattOutputKw(t-6,iPv) > 0 ...
                && neededBattOutputKw(t-7,iPv) > 0 ...
                && neededBattOutputKw(t-8,iPv) > 0 ...
                && neededBattOutputKw(t,iPv) < 0
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
            
            % BIOMASS GENERATION ==========================================
            % add to biomass storage whenever a week starts 
            % (written by Gard)
            if mod(t,168) == 0
                availableBiomassKw = availableBiomassKw ...
                                   + BiomParam.biomassWeeklySupplyKw;
            end
            
            % PREEMPTIVE biomass generation check. If the pvPowerPeak this
            % day is below a certain treshold, we assume that it can be
            % predicted and that the generator wil contribute to charging
            % the battery this day.
            if BiomParam.isPreemptive
                if mod(t,24) == 0 && t < SimData.nHours - 24

                    peakPowerNextDay = max(pvPowerAbsorbedKw(t:t+23,iPv));

                    if peakPowerNextDay/peakPvPowerAbsorbed(iPv) ...
                     < BiomParam.nomPeakPvPowerTreshold

                        biomassGeneratorIsOn = true;

                    else

                        biomassGeneratorIsOn = false;

                    end 
                end

            end

           % the generator is on and will stay on untill battery is full,
           % biomass supply runs out or there is a new day with sufficient
           % irradiation
           if biomassGeneratorIsOn ...
           
               if availableBiomassKw > BiomParam.generatorOutputKw
 
                   biomassGeneratorOutputKw(t,iPv,jBatt) ...
                                             = BiomParam.generatorOutputKw;

                   neededBattOutputKw(t,iPv) = neededBattOutputKw(t,iPv) ...
                                              - BiomParam.generatorOutputKw;

                   availableBiomassKw = availableBiomassKw ...
                                     - BiomParam.generatorOutputKw;

               else
                   
                   biomassGeneratorIsOn = false;
                   
               end
                   
           end
            

            % BATTERY OPERATION ===========================================
            % CHARGING the battery
            % PV-production is larger than Load. Battery will be charged
            if neededBattOutputKw(t,iPv) < 0   
                
                % energy flow that will be stored in the battery i.e. 
                % including losses in charging [kWh]   
                battOutputKw(t, iPv, jBatt) = neededBattOutputKw(t,iPv) ...
                                            * BattParam.chargingEfficiency;    
               
                % in-flow exceeds the battery power limit
                if (abs(neededBattOutputKw(t,iPv))) > battMaxPowerFlow...
                && stateOfCharge(t,iPv,jBatt) < 1                          
                    
                    battOutputKw(t, iPv, jBatt) = battMaxPowerFlow ...
                                * BattParam.chargingEfficiency;

                    pvPowerAbsorbedUnused(t,iPv, jBatt) ...
                                    = pvPowerAbsorbedUnused(t,iPv, jBatt) ...
                                    + (abs(neededBattOutputKw(t,iPv))...
                                    - battMaxPowerFlow);
                end

                stateOfCharge(t+1,iPv,jBatt) = stateOfCharge(t,iPv,jBatt) ...
                                             + abs(battOutputKw(t, iPv, jBatt)) ...
                                             / jBattKwh;
                
                % The battery is fully charged.
                if stateOfCharge(t+1,iPv,jBatt) > 1

                    biomassGeneratorIsOn = false;
                    
                    pvPowerAbsorbedUnused(t,iPv, jBatt) ...
                                        = pvPowerAbsorbedUnused(t,iPv, jBatt)...
                                        + (stateOfCharge(t+1,iPv,jBatt) - 1) ...
                                        * jBattKwh ...
                                        / BattParam.chargingEfficiency;
                    
                    stateOfCharge(t+1,iPv,jBatt) = 1;
                  
                end
            
            else
                % DISCHARGING the battery
                battOutputKw(t, iPv, jBatt) = neededBattOutputKw(t,iPv) ...
                            / BattParam.dischargingEfficiency; 
                % total energy flow from the battery i.e. including losses 
                % in charging (positive number since discharging) [kWh]  
                
                % checking the battery kw output limit
                if neededBattOutputKw(t,iPv) > battMaxPowerFlow ...
                && stateOfCharge(t,iPv,jBatt) > BattParam.minStateOfCharge;         
                    
                    battOutputKw(t, iPv, jBatt) = battMaxPowerFlow ...
                                    / BattParam.dischargingEfficiency;
                    
                    % Adding the part to lostLoad due to exceeding the 
                    % battery discharging speed
                    lossOfLoad(t,iPv, jBatt) = lossOfLoad(t,iPv, jBatt)...
                                         + (neededBattOutputKw(t,iPv) ...
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
                    
                    % we want the biomass generator to be turned on when we
                    % have an min state of charge occurence and following
                    % loss of load. The loss of load will likely
                    % occur earlier due to lacking power-energy ratio to
                    % output enough energy
                    biomassGeneratorIsOn = true;
                    
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
            pvPowerAbsorbedUnused,...
            stateOfCharge,...
            sumPartialCyclesUsed,...
            peakPvPowerAbsorbedKw,...
            biomassGeneratorOutputKw);

end

