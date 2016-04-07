function plot_average_state_of_charge( SimParam, BattParam, SimOutput, iPv, jBatt )
%PLOT_STATE_OF_CHARGE Plots average daily state of charge and more
%   plots loss of load and power absorbed but unused as red and green
%   respectively

for i = 1:length(iPv)
    
    jBattKwh = SimParam.batt_step_to_kwh(jBatt(i));
    
    averageNominalPowerUnused = get_daily_average(SimOutput.inputPowerUnusedKw(:,iPv(i), jBatt(i))...
        ./ jBattKwh) + 1;
    
    
    averageNominalStateOfCharge = get_daily_average(SimOutput.stateOfCharge(:,iPv(i), jBatt(i)));
    
    averageNominalLossOfLoad = -get_daily_average(SimOutput.lossOfLoad(:,iPv(i), jBatt(i))...
        ./ jBattKwh) + BattParam.minStateOfCharge;
    

    
    figure; hold on
    plot(averageNominalPowerUnused,'Color',[142 178 68] / 255)
    plot(averageNominalStateOfCharge,'Color',[64 127 255] / 255)
    plot(averageNominalLossOfLoad, 'Color',[255 91 60] / 255)
    hold off
    
    axis([0 24 0.2 1.3])
    xlabel('Hour of the day')
    ylabel('Power refered to State of Charge of the battery')
    legend('Overproduction, not utilized', 'Loss of power', 'State of charge',...
        'Location','northwest')

end

