function hourArray = get_hour_resolution( inArray, pointsHourly )
%GET_HOUR_RESOLUTION Summary of this function goes here
%   Detailed explanation goes here

span = round(length(inArray)/pointsHourly);
hourArray = zeros(1, span);

for i = 1:span-1

    hourArray(i) = inArray(i*pointsHourly);

end

