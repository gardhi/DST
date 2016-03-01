function old_plot_average_power_balance( SimInputData, SimOutput, iPv)
    %OLD_PLOT_AVGERAGE_POWER_BALANCE Summary of this function goes here
    %   Detailed explanation goes here
    
    batt_balance_pos = subplus(SimOutput.neededBattOutputKw(:,iPv));
    nr_days = length(SimInputData.irradiation) / 24;                    
    Load_av = zeros(1,24);                              % vector for average daily Load
    P_pv_av = zeros(1,24);                              % vector for average daily P_pv
    batt_balance_pos_av = zeros(1,24);                  % vector for average daily batt_balance_pos. This is misleading since it is influenced by state of charge of previous days.
    for hour = 1:24                                     % iterate over all times 1:00, 2:00 etc.
    hours_i = hour : 24 : (nr_days - 1) * 24 + hour;    % range to pick the i-th hour of each day throughout the yearly data, i.e. 1:00 of 1 January, 1:00 of 2 January etc.
        for k = hours_i
            Load_av(hour) = Load_av(hour) + SimInputData.load(k);
            P_pv_av(hour) = P_pv_av(hour) + SimOutput.pvPowerAbsorbed(k, iPv);
            batt_balance_pos_av(hour) = batt_balance_pos_av(hour) + batt_balance_pos(k);
        end
        Load_av(hour) = Load_av(hour) / nr_days;
        P_pv_av(hour) = P_pv_av(hour) / nr_days;
        batt_balance_pos_av(hour) = batt_balance_pos_av(hour) / nr_days;
    end

    figure(2)
    plot(Load_av,'Color',[72 122 255] / 255)
    hold on
    plot(P_pv_av,'Color',[255 192 33] / 255)
    hold on
    plot(batt_balance_pos_av,'Color',[178 147 68] / 255)
    hold off
    xlabel('Time over the day [hour]')
    ylabel('Energy [kWh]')
    title('Energy produced and estimated load profile of an average day')
    legend('Load profile','Energy from PV', 'Energy flow in battery')

end

