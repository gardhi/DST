

SimParameters = SimulationParameters;
SimParameters.pvStartKw = 230;                      % Min PV power simulated [kW]
SimParameters.pvStopKw = 235;                       % Max PV power simulated [kW]
SimParameters.pvStepKw = 1;                     % PV power simulation step [kW]
SimParameters.battStartKwh = 1200;                  % Min Battery capacity simulated [kWh]
SimParameters.battStopKwh = 1205;                   % Max Battery capacity simulated [kWh]
SimParameters.battStepKwh = 1;                   % Battery capacity simulation step [kWh]
SimParameters.llpSearchAcceptance = 0.005;          % Acceptence error when searching a spesific LLP value.
SimParameters.llpSearchTargets = 0.01:0.005:0.05;   % LLP range that one want to find optimal solutions within


disp((2*SimParameters.pvStepKw) + SimParameters.pvStartKw)
disp(SimParameters.sim_step_to_pv_kw(2))