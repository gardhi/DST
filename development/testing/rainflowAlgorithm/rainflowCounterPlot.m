
% this script is for scrutinizing the rainflow counter function of stefano
% mandelli, found in the sapv_plant_simulation function.

nHoursInYear = 60*24*365;

periodOfDodOccurence = 24;
nMaxPossibleDodOccurences = nHoursInYear/periodOfDodOccurence;
nTests = 10;

minStateOfCharge = 0.4;
maxStateOfCharge = 1;

batteryLifespansHours = zeros(nTests,1);

for iTest = 1:nTests

    for dodOccurance = 1:nMaxPossibleDodOccurences

        dod = (maxStateOfCharge-minStateOfCharge)*rand() + minStateOfCharge;
        cycleFraction = rainflow_counter_cycles(dod);
        rainflowCounter = 1/cycleFraction;

    end

    batteryLifespansHours(iTest) = 1/rainflowCounter;
end

batteriesPrYear = nHoursInYear./batteryLifespansHours;

