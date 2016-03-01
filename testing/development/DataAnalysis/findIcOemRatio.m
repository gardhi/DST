
% parameters to workspace
initiateParameters

SimInBhut = SimIn;
clear SimIn;


SimOutBhut = sapv_plant_simulation(SimPar, PvPar, BattPar, InvPar, SimInBhut);

EcoOutBhut = economic_analysis( SimPar, BattPar, InvPar, EcoPar, SimInBhut, SimOutBhut);

%%

nSolutions = size(EcoOutBhut.operationsMaintenanceReplacementTotCost);

ratiosBhut = zeros(2,nSolutions(1)*nSolutions(2));

for i = 1:nSolutions(1)
    for j = 1:nSolutions(2)
   
        ratiosBhut(1,(i-1)*nSolutions(2)+j) = EcoOutBhut.operationsMaintenanceReplacementTotCost(i,j)...
                                          / EcoOutBhut.netPresentCost(i,j);
        ratiosBhut(2,(i-1)*nSolutions(2)+j) = 1- SimOutBhut.lossOfLoadProbability(i,j);
    end
end

ratiosBhut = sortrows(ratiosBhut',1)';

figure(1); clf(1); hold on;
plot(ratiosBhut(1,:),ratiosBhut(2,:),'.')
xlabel('ratios OeMeR/NPC')
ylabel('1-LLP')
hold off
        
%%

nonZeroM = find( ratiosBhut(1,:) );
figure; hold on;
plot(ratiosBhut(1, nonZeroM), ratiosBhut(2, nonZeroM))

[a, b] = polyfit(ratiosBhut(1, nonZeroM), ratiosBhut(2, nonZeroM), 2);
plot(ratiosBhut(:, nonZeroM),ratiosBhut(:, nonZeroM)*a + b )





