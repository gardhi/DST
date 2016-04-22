function [longestPeriod, indexOfLongestPeriod] = get_longest_period(dataSet)
    % Will take inn a 1xn vector and return the longest period of positive
    % values in this vector and the index of the period start
     
    dLossOfLoad = diff(find(dataSet));
    longestPeriod = 0;
    counter = 0;
    for i = 1:length(dLossOfLoad)
        counter = counter + 1;
        if dLossOfLoad(i)> 1
            if longestPeriod < counter
                longestPeriod = counter;
                indexOfLongestPeriod = i;
            end
            counter = 0;
        end
    end
end
