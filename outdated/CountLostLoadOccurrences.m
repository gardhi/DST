function [ timesLostLoad ] = CountLostLoadOccurrences( LL, pv_i, batt_i )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
prev_element_nonzero = false;

LL_kW_unmet = 0;
LL_time = 0;
LL_times_occured = 0;
LL_kW_unmet_worst = 0;
LL_longest_time = 0;

for i = 1:length(LL(:, pv_i, batt_i))
    LL_kWh = LL(i,pv_i, batt_i); 
    
    if(LL_kWh > 0)                                          % Checking whether a loss of load period is occuring
                                                            % Summing up the defaults of the ongoing period
        LL_kW_unmet = LL_kW_unmet + LL_kWh;                 % Adding to amount of default this period
        LL_time = LL_time +1;                               % Timing the duration of this period  
% Adding to the daily, weekly and monthly defaults
%         LL_daily_kWh = LL_daily_kWh +LL_kWh;       
%         LL_weekly_kWh = LL_weekly_kWh + LL_kWh;
%         LL_monthly_kWh = LL_monthly_kWh + LL_kWh;
        prev_element_nonzero = true;                        % Controlbit for checking ended period of LL   
       
    else                                                    % If no LoL is occuring.
        if prev_element_nonzero == true;                    % Checking if a period LoL has ended on this iteration          
            LL_times_occured = LL_times_occured +1;         % Counting the number of LoL periods   
            if LL_time > LL_longest_time                    % Checking if this period was the longest one
                LL_longest_time = LL_time;
                %LL_kW_unmet_longest = LL_kW_unmet;
                %time_of_longest_offline = i;                
            end
            
            if LL_kW_unmet > LL_kW_unmet_worst              % Checking if this period was the one with largest
                LL_kW_unmet_worst = LL_kW_unmet;            % total default.
                %time_of_largest_default = i;    
            end            
            
            LL_kW_unmet = 0;                                % Resetting counters for periods
            LL_time = 0;
            
        end        
        prev_element_nonzero = false;    
    end
    
    
                                                            % Segmenting the default into days, weeks, months
%     if mod(i,24)==0
%         LL_default_daily(this_day) = LL_daily_kWh;
%         this_day = this_day +1;
%         LL_daily_kWh = 0;
%     end
%     if mod(i,hours_in_one_week)==0
%         LL_default_weekly(this_week) = LL_weekly_kWh;
%         this_week = this_week +1;
%         LL_weekly_kWh = 0;
%     end
%     hours_passed_this_month = hours_passed_this_month +1;
%     if hours_passed_this_month == hours_in_months(this_month)
%         LL_default_monthly(this_month) = LL_monthly_kWh;
%         this_month = this_month +1;
%         LL_monthly_kWh = 0;
%         hours_passed_this_month = 0;
%     end
%       
end
timesLostLoad = LL_times_occured;

end

