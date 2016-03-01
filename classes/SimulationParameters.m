classdef SimulationParameters
    %SIMPARAM Defines the simulation input parameters
    %   Implemented in class in order to get dependent variables calculated
    %   by default initiation
    
    % these could all be dependent on budget
    properties           
        pvStartKw               % Min PV power simulated [kW]
        pvStopKw                % Max PV power simulated [kW]
        pvStepKw                % PV power simulation step [kW]
        battStartKwh            % Min Battery capacity simulated [kWh]
        battStopKwh             % Max Battery capacity simulated [kWh]
        battStepKwh             % Battery capacity simulation step [kWh]
        llpSearchAcceptance     % Acceptence error when searching a spesific LLP value
        llpSearchTargets        % LLP range that one want to find optimal solutions within.
        nBattSteps
        nPvSteps
    end
    
        
    methods
        function obj = SimulationParameters(...        
            pvStartKw,...               % Min PV power simulated [kW]
            pvStopKw,...                % Max PV power simulated [kW]
            pvStepKw,...                % PV power simulation step [kW]
            battStartKwh,...            % Min Battery capacity simulated [kWh]
            battStopKwh,...             % Max Battery capacity simulated [kWh]
            battStepKwh,...             % Battery capacity simulation step [kWh]
            llpSearchAcceptance,...     % Acceptence error when searching a spesific LLP value
            llpSearchTargets)           % LLP range that one want to find optimal solutions within.)
            
            obj.pvStartKw = pvStartKw;
            obj.pvStopKw = pvStopKw;
            obj.pvStepKw = pvStepKw;
            obj.battStartKwh = battStartKwh;
            obj.battStopKwh = battStopKwh;
            obj.battStepKwh = battStepKwh;
            obj.llpSearchAcceptance = llpSearchAcceptance;
            obj.llpSearchTargets = llpSearchTargets;
            
            obj.nBattSteps = ((obj.battStopKwh - obj.battStartKwh)/ obj.battStepKwh) + 1;
            obj.nPvSteps = ((obj.pvStopKw - obj.pvStartKw)/ obj.pvStepKw) + 1;
        end
        
        function pvKw = pv_step_to_kw(obj, stepNo)
            pvKw = (stepNo*obj.pvStepKw) + obj.pvStartKw;
        end
        
        function battkwh = batt_step_to_kwh(obj, stepNo)
            battkwh = (stepNo*obj.battStepKwh) + obj.battStartKwh;
        end
    end
    
end