function [ output_args ] = simulation_overview( SimOut, EcoOut )
%SIMULATION_OVERVIEW Summary of this function goes here
%   Detailed explanation goes here

    dim = size(SimOut.lossOfLoadProbability);

    figure
    subplot(2,2,1)
    surf(SimOut.lossOfLoadProbability)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('loss of load probability')
    xlabel('jBatt')
    ylabel('iPv')

    subplot(2,2,2)
    surf(EcoOut.levelizedCostOfEnergy)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('levelized cost of energy')
    xlabel('jBatt')
    ylabel('iPv')

    subplot(2,2,3)
    surf(EcoOut.nBattEmployed)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('number of batteries employed')
    xlabel('jBatt')
    ylabel('iPv')

    subplot(2,2,4)
    surf(EcoOut.netPresentCost)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('net present cost')
    xlabel('jBatt')
    ylabel('iPv')

end

