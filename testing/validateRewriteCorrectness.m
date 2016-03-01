
main
save('testing/compareOutputsRewrittenDST')

logplot
load('testing/compareOutputsRewrittenDST')

%%

MA_opt_norm_bhut_jun15_20_10 = MA_opt_norm_bhut_jun15_20_10(find(MA_opt_norm_bhut_jun15_20_10(:,1)),:);

%%
compared.soc = isequal(SoC_every_scenario,SapvOutput.stateOfCharge);
compared.ll = isequal(LL,SapvOutput.lossOfLoad);
compared.npc = isequal(NPC,EconomicOutput.netPresentCost);
compared.lcoe = isequal(LCoE, EconomicOutput.levelizedCostOfEnergy);

compared.partialCycles = isequal(Den_rainflow, SapvOutput.sumPartialCyclesUsed);

compared.optLlp = isequal(MA_opt_norm_bhut_jun15_20_10(:,1),OptSolutions.lossOfLoadProbabilities);
compared.optPvKw = isequal(MA_opt_norm_bhut_jun15_20_10(:,3)',OptSolutions.pvKw);
compared.optBattKwh = isequal(MA_opt_norm_bhut_jun15_20_10(:,4)',OptSolutions.battKwh);

% %%
% save('compared1','compared')
% clear variables
% load('compared1')