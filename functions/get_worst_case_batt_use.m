function [nBattEmployed, yearsBattOperational] = get_worst_case_batt_use( load, minSoc, plantLifetimeYears )
%GET_WORST_CASE_BATTERY_WEAR A function for counting discharge cycles
%   Assume each discharge cycle is at maximum depth of discharge to see how
%   the worst case use affects the battary replacement frequency. Th

% preprocess the data sets
nHours = length(load);
smootLoad = smooth(load,30);
dSmoothLoad = diff(smootLoad);

peakCount = 0;

% "trained" part of the algorithm, this section will have to be adjusted to
% each data set to count the valleys properly
for t = 3: nHours
    if dSmoothLoad(t-1) > 0 ...
    && dSmoothLoad(t) < 0 ...
    && smootLoad(t-2) < smootLoad(t) ...
    && smootLoad(t-1) < smootLoad(t)
        
        peakCount = peakCount +1;

    end
    
end

hoursInYear = 8760;

% how many years each battery can operate
yearsBattOperational = (nHours/hoursInYear)/(peakCount/cycles_to_failure(1-minSoc));

% how many batteries will be uilized based on the plant lifetime.
nBattEmployed = ceil(plantLifetimeYears / yearsBattOperational);

end

