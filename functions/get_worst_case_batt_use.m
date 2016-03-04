function [nBattEmployed, yearsBattOperational] = get_worst_case_batt_use( load, minSoc, plantLifetime )
%GET_WORST_CASE_BATTERY_WEAR Summary of this function goes here
%   Detailed explanation goes here


nHours = length(load);
smootLoad = smooth(load,30);
dSmoothLoad = diff(smootLoad);

peakCount = 0;

for t = 3: nHours
    if dSmoothLoad(t-1) > 0 ...
    && dSmoothLoad(t) < 0 ...
    && smootLoad(t-2) < smootLoad(t) ...
    && smootLoad(t-1) < smootLoad(t)
        
        peakCount = peakCount +1;

    end
    
end

hoursInYear = 8760;

yearsBattOperational = (nHours/hoursInYear)/(peakCount/cycles_to_failure(1-minSoc));
nBattEmployed = ceil(plantLifetime / yearsBattOperational);

end

