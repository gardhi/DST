function simulation_overview( SimOut, EcoOut )
%SIMULATION_OVERVIEW Plots the simulation-space of important values
% for more details refer to online documentation.

    dim = size(SimOut.lossOfLoadProbability);

    f = figure;
    f.Visible = 'off';
    
    subplot(2,2,1)
    surf(SimOut.lossOfLoadProbability)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('loss of load probability')
    xlabel('jBatt')
    ylabel('iPv')
    LlpBar = colorbar('Position',[0.47 0.6024 0.01 0.3143]);

    subplot(2,2,2)
    surf(EcoOut.levelizedCostOfEnergy)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('levelized cost of energy')
    xlabel('jBatt')
    ylabel('iPv')
    LcoeBar = colorbar('Position', [0.91 0.6024 0.01 0.3143]);

    subplot(2,2,3)
    surf(EcoOut.nBattEmployed)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('number of batteries employed')
    xlabel('jBatt')
    ylabel('iPv')
    Nbattbar = colorbar('Position',[0.47 0.1286 0.01 0.3143]);

    subplot(2,2,4)
    surf(EcoOut.netPresentCost)
    view(0,90)
    axis([1, dim(2), 1, dim(1)])
    title('net present cost')
    xlabel('jBatt')
    ylabel('iPv')
    NpcBar = colorbar('Position',[0.91 0.1286 0.01 0.3143]);
    
    
    f.Visible = 'on';
    
end

