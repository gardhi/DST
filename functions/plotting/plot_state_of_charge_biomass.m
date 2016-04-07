function plot_state_of_charge_biomass( SimParam, BattParam, SimOut, iPv, jBatt )
%PLOT_STATE_OF_CHARGE Plots state of charge and more
%   plots loss of load and power absorbed but unused as red and green
%   respectively

for i = 1:length(iPv)
    
    jBattKwh = SimParam.batt_step_to_kwh(jBatt(i));
    
    figure

    stairs(-SimOut.biomassGeneratorOutputKw(:,iPv,jBatt)/jBattKwh...
            + BattParam.minStateOfCharge ,...
            'Color',[77 182 73]/255); hold on
    
    plot(SimOut.inputPowerUnusedKw(:,iPv(i), jBatt(i))...
        ./ jBattKwh + 1,'Color',[142 178 68] / 255)

    plot(- SimOut.lossOfLoad(:,iPv(i), jBatt(i))...
        ./ jBattKwh + BattParam.minStateOfCharge,'Color',[255 91 60] / 255)
    hold on
    plot(SimOut.stateOfCharge(:,iPv(i), jBatt(i)),...
        'Color',[64 127 255] / 255)
    hold off
    xlabel('Time over the year [hour]')
    ylabel('Power refered to State of Charge of the battery')
    legend('Generator Output', 'Overproduction, not utilized', ...
           'Loss of power', 'State of charge')

end

