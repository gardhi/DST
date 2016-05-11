function [ averageDay ] = get_average_day( input )
    %GET_AVERAGE_DAY Finds the hourly averages of input.
    %   input an array with hourly values and the output will be an array
    %   of 24 hours with the average of every hour of a day. i.e average
    %   value at 8pm etc.

averageDay = zeros(1,24);

for t = 1:length(input)
    dayHour = mod(t,24);
    if dayHour == 0
        dayHour = dayHour + 24;
    end
    averageDay(dayHour) = averageDay(dayHour)...
                        + input(t);
end

averageDay = averageDay ./ (length(input)/ 24);
    
end

