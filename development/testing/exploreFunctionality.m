
dim = size(SimOut.lossOfLoadProbability);

figure(1);clf(1)
subplot(2,2,1)
surf(SimOut.lossOfLoadProbability)
view(0,90)
axis([1, dim(2), 1, dim(1)])
title('loss of load probability')

subplot(2,2,2)
surf(EcoOut.levelizedCostOfEnergy)
view(0,90)
axis([1, dim(2), 1, dim(1)])
title('levelized cost of energy')

subplot(2,2,3)
surf(EcoOut.nBattEmployed)
view(0,90)
axis([1, dim(2), 1, dim(1)])
title('number of batteries employed')

subplot(2,2,4)
surf(EcoOut.netPresentCost)
view(0,90)
axis([1, dim(2), 1, dim(1)])
title('net present cost')
