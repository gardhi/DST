function plot_power_balance_biomass( SimParam, BattParam,InvParam, SimData, SimOut, iPv, jBatt )
   %PLOT_POWER_BALANCE compare sources of load served
    % The power balance is created to track the sources of power serving
    % the load, and compare it in scale to where the power arrives from.
    % The purpose of the function is to be able to understand the pattern 
    % of use of the batteries and PV and to vizualise margins.

% -------------------------------------------------------------------------
% Calculations
% -------------------------------------------------------------------------

% 
% % irradiationUtilized is the irradiation that serves load or battery
inputPowerUtilized = SimOut.pvPowerAbsorbed(:,iPv) ...
                    - SimOut.inputPowerUnusedKw(:,iPv,jBatt);

% discharged is the amount of discharged power from the battery
discharged = subplus(SimOut.battOutputKw(:,iPv,jBatt))';

% battNetLoadSupply is the net power supply from battery to load without
% accounting for the loss 'on the way' to the load
battNetLoadSupply = discharged...
                  * BattParam.dischargingEfficiency...
                  * InvParam.efficiency;

% pvNetLoadSupply is the net power supply from the pv to load without
% accounting for the loss 'on the way' to the load.
pvNetLoadSupply = zeros(1,SimData.nHours);
% if the needed batt output is less than 0 all the load is covered by pv
pvNetLoadSupply(SimOut.neededBattOutputKw(:,iPv)<0) = ...
    SimData.load( SimOut.neededBattOutputKw(:,iPv)<0 );
% if the needed batt output is more than 0, all the pv power absorbed
% covers goes to cover the load.
pvNetLoadSupply(SimOut.neededBattOutputKw(:,iPv)>0) = ...
    SimOut.pvPowerAbsorbed( SimOut.neededBattOutputKw(:,iPv) > 0 );

% netLoadSupply shows follows the load as long as the system provides
% enough power.
netLoadSupply = battNetLoadSupply + pvNetLoadSupply;

% -------------------------------------------------------------------------
% Plotting
% -------------------------------------------------------------------------

figure; hold on
plot(inputPowerUtilized,'Color',[200,200,20]/255)
plot(SimData.load, 'Color', [255,1,1]/255 )
plot(netLoadSupply, 'Color', [1,1,255]/255)
stairs(SimOut.biomassGeneratorOutputKw(:,iPv,jBatt),'Color',[77 182 73]/255)


xlabel('Time [hours]')
ylabel('Energy [kW]')
title('The simulated supply of energy together with the demand')
legend('InputPowerUtilized [kW]','Load Demand [kW]', 'System Load Supply [kW]',...
       'Generator Output [kW]')
hold off

end

% ,'Color',[72 122 255] / 255 blue
% ,'Color',[255 192 33] / 255 yellow
% ,'Color',[178 147 68] / 255 brown