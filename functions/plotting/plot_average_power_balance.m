function plot_average_power_balance( BattParam,InvParam, SimInputData, SimOutput, iPv, jBatt )
    %PLOT_AVERAGE_POWER_BALANCE an average day of power balance.
    % The power balance is created to track the sources of power serving
    % the load, and compare it in scale to where the power arrives from.
    % The purpose of the function is to be able to understand the pattern 
    % of use of the batteries and PV and to vizualise margins.

% -------------------------------------------------------------------------
% Calculations
% -------------------------------------------------------------------------

% irradiationUtilized is the irradiation that serves load or battery
irradiationUtilized = SimOutput.pvPowerAbsorbed(:,iPv) ...
                    - SimOutput.inputPowerUnusedKw(:,iPv,jBatt);

% discharged is the amount of discharged power from the battery
discharged = subplus(SimOutput.battOutputKw(:,iPv,jBatt))';

% battNetLoadSupply is the net power supply from battery to load without
% accounting for the loss 'on the way' to the load
battNetLoadSupply = discharged...
                  * BattParam.dischargingEfficiency...
                  * InvParam.efficiency;

% pvNetLoadSupply is the net power supply from the pv to load without
% accounting for the loss 'on the way' to the load.
pvNetLoadSupply = zeros(1,SimInputData.nHours);
pvNetLoadSupply(SimOutput.neededBattOutputKw(:,iPv)<0) = ...
    SimInputData.load( SimOutput.neededBattOutputKw(:,iPv)<0 );
pvNetLoadSupply(SimOutput.neededBattOutputKw(:,iPv)>0) = ...
    SimOutput.pvPowerAbsorbed( SimOutput.neededBattOutputKw(:,iPv) > 0 );

% netLoadSupply shows follows the load as long as the system provides
% enough power.
netLoadSupply = battNetLoadSupply + pvNetLoadSupply;

% averages:
averageIrradiationUtilized = get_average_day(irradiationUtilized);
averageLoad = get_average_day(SimInputData.load);
averageNetLoadSupply = get_average_day(netLoadSupply);


% -------------------------------------------------------------------------
% Plotting
% -------------------------------------------------------------------------

figure; hold on
plot(averageIrradiationUtilized,'Color',[200,200,20]/255)
plot(averageLoad, 'Color', [255,1,1]/255 )
plot(averageNetLoadSupply, 'Color', [1,1,255]/255)
axis([0 24 0 inf])

xlabel('Time [hours]')
ylabel('Energy [kW]')
title('The simulated supply of energy together with the demand')
legend('Utilized PV Power [kW]','Load Demand [kW]', 'System Load Supply [kW]',...
    'Location','northwest')
hold off

end

% ,'Color',[72 122 255] / 255 blue
% ,'Color',[255 192 33] / 255 yellow
% ,'Color',[178 147 68] / 255 brown