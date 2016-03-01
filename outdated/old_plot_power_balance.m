function old_plot_power_balance( SimInputData, SimOutput, iPv, jBatt )
%OLD_PLOT_POWER_BALANCE Summary of this function goes here

    neededBattOutputKwPositive = subplus(SimOutput.neededBattOutputKw(:,iPv));
    figure
    plot(SimInputData.load,'Color',[72 122 255] / 255)
    hold on
    plot(SimOutput.pvPowerAbsorbed(:,iPv),'Color',[255 192 33] / 255)
    hold on
    plot(neededBattOutputKwPositive,'Color',[178 147 68] / 255)
    hold off
    xlabel('Time over the year [hour]')
    ylabel('Energy [kWh]')
    title('Energy produced and estimated load profile over the year (2nd steps PV and Batt)')
    legend('Load profile','Energy from PV', 'Energy flow from battery')



end

