function [ pvKw, battKwh ] = get_most_expensive_solution(load, EcoPar, BattPar, InvPar,...
                            operationMatinenanceReplacementCost, investmentCost)
%GET_MOST EXPENSIVE SOLUTION Summary of this function goes here
%   Detailed explanation goes here
                                        
[nBattEmployed, yearsBattOperational] = get_worst_case_batt_use(load,...
                                        BattPar.minStateOfCharge,...
                                        EcoPar.plantLifetimeYears );

loadPeakKw = max(load);
%inverter is designed on the peak power value
inverterCostTot = (loadPeakKw/InvPar.efficiency)...
                * EcoPar.inverterCostKw;

yearsBattRemaining = yearsBattOperational ...
               - mod(EcoPar.plantLifetimeYears,  yearsBattOperational);


interestFactorLastYear = 1/(1+EcoPar.interestRate)^EcoPar.plantLifetimeYears;
interestFactorSumHalfTime = 1/(1+EcoPar.interestRate)^(EcoPar.plantLifetimeYears/2);
interestFactorSum = 0;
interestFactorReplacementYears = 0;

for t = 1:EcoPar.plantLifetimeYears
    
    interestFactorSum = interestFactorSum...
                           + 1/(1+EcoPar.interestRate)^t;
                       
    if mod(t, yearsBattOperational) == 0
        interestFactorReplacementYears = interestFactorReplacementYears...
                                      + 1/(1+EcoPar.interestRate)^t;
    end
    
end


battKwh = (operationMatinenanceReplacementCost ...
        + (EcoPar.operationMaintenanceCostKw / EcoPar.pvCostKw) ...
        * interestFactorSum ...
        * (inverterCostTot - investmentCost/(1+ EcoPar.installBalanceOfSystemCost)) ...
        - inverterCostTot * interestFactorSumHalfTime) ...
        / (EcoPar.battCostKwh*(interestFactorReplacementYears ...
        - yearsBattRemaining*interestFactorLastYear ...
        - EcoPar.operationMaintenanceCostKw / EcoPar.pvCostKw ...
        * interestFactorSum));
    
pvKw = investmentCost/(EcoPar.pvCostKw*(1+EcoPar.installBalanceOfSystemCost)) ...
     - (EcoPar.battCostKwh*battKwh + inverterCostTot)/EcoPar.pvCostKw;
     
 
end
