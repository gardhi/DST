
% parameters to workspace
initiateParameters

SimInBhut = SimIn;
clear SimIn;


SimOut = sapv_plant_simulation(SimPar, PvPar, BattPar, InvPar, SimInBhut);

EcoOut = economic_analysis( SimPar, BattPar, InvPar, EcoPar, SimInBhut, SimOut);

%%

[nPv, nBatt] = size(EcoOut.operationsMaintenanceReplacementTotCost);

ratios = zeros(2,nPv*nBatt);

for iPv = 1:nPv
    for jBatt = 1:nBatt
   
        ratios(1,(iPv-1)*nBatt+jBatt) = EcoOut.investmentCost(iPv,jBatt)...
                                      / EcoOut.netPresentCost(iPv,jBatt);
        ratios(2,(iPv-1)*nBatt+jBatt) = SimOut.lossOfLoadProbability(iPv,jBatt);
    end
end

ratios = sortrows(ratios',1)';

figure; hold on;
plot(ratios(1,:),ratios(2,:),'o')
xlabel('ratio IC/OeMeR')
ylabel('LLP')
title('Possiblility for analytic estimate given LLP?')
hold off
        
%%
figure; hold on;
histogram(ratios(1,:),'NumBins',50);
xlabel('ratio'); ylabel('number of simulations')
title('Distribution of IC/OeMeR ratios')

%%

nonZeroM = find( ratios(1,:) );
figure; hold on;
plot(ratios(1, nonZeroM), ratios(2, nonZeroM))
 
[a, b] = polyfit(ratios(1, nonZeroM), ratios(2, nonZeroM), 2);
plot(ratios(:, nonZeroM),ratios(:, nonZeroM)*a + b )





