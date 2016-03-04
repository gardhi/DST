function programatically

lFigWidth = 500; lFigHeight = 900;
f = figure('Visible','off','Units','pixels',...
           'Position',[340,80,lFigWidth,lFigHeight],'menubar','none');

    
% DEFAULT values 
% Simulation Default Parameters:
set.pvStartKw = '100';
set.pvStopKw = '200';
set.pvStepKw = '10';
set.battStartKwh = '1200';
set.battStopKwh = '1300';
set.battStepKwh = '10';
set.llpAccept = '5';
set.llpStart = '1';
set.llpStop = '80';
set.llpStep = '5';
  
% Economic Default Parameters
set.budget = '1500000';
set.pvCostKw = '1000';
set.battCostKwh = '140';              
set.battCostFixed = '0';             
set.inverterCostKw = '500';          
set.operationMaintenanceCostKw = '50';
set.installBalanceOfSystemCost = '2';%
set.plantLifetime = '20';           
set.interestRate = '6';%  

%PV Default Parameters
set.balanceOfSystem = '85';  %             
set.nominalAmbientTemperatureC = '20';    % Nominal ambient test-temperature of the panels [C]
set.nominalCellTemperatureC = '47';        % Nominal Operating Cell Temperature [C]
set.nominalIrradiation = '0.8';           % Irradiation at nominal operation [kW / m^2]
set.powerDerateDueTemperature = '0.004';  % Derating of panel's power due to temperature [/C]

% Battery Default Parameters
set.minStateOfCharge = '40'; %            
set.initialStateOfCharge = '100'; %;             
set.chargingEfficiency = '85'; % 
set.dischargingEfficiency = '90'; %
set.powerEnergyRatio = '0.5'; 
set.maxOperationalYears = '5';  

% Inverter Default Parameters
set.invEfficiency = '90';



% Margin metric
lMargin = 10;
lAlignEditText = 22;

% Title
lTitleHeight = 30;
lTitleWidth = 300;
lTitleStartY = lFigHeight - lMargin- lTitleHeight;
uicontrol(f,'Style','text','String','Parameter Input',...
           'Units','pixels','HorizontalAlignment','Left',...
           'FontSize',16,...
           'Position', [lMargin, lTitleStartY,...
            lTitleWidth, lTitleHeight]);

% Panel Metrics
lNextRow = 45;
lMultiLineAdjust3 = 10;
lMultiLineAdjust2 = 5;
lPanelEdge = 70;
lPanelWidth = lFigWidth*0.35;

% Text metrics
lTextWidth = 80;
lTextHeight = 40;

% Presets
lPresetX = lPanelWidth*2+lMargin*1.7;
lPresetWidth = lPanelWidth*0.7;
lPresetTitleHeight = 0.7*lTitleHeight;
lPresetTitleY = lTitleStartY - lMargin- lPresetTitleHeight;

uicontrol(f, 'Style','text','String','Presets:',...
             'Units','pixels',...
             'HorizontalAlignment','Left',...
             'Fontsize',14,...
             'Position',[lPresetX,lPresetTitleY,...
             lPresetWidth,lPresetTitleHeight]);

lPresetMenuHeight = 18;
lPresetsMenuY = lPresetTitleY - lMargin - lPresetMenuHeight;

% Put presets from presets directory into presetList
newPresetName = 'default';
presetFiles = '';
presetList = '';
update_presets_menu

h.PresetsMenu = uicontrol(f, 'Style','popup',...
                         'String',presetList,...
                         'Units','pixels',...
                         'Position',[lPresetX,...
                         lPresetsMenuY, ...
                         lPresetWidth, lPresetMenuHeight],...
                         'Callback', @presetsMenu_Callback);

lNewPresetHeaderY = lPresetsMenuY - lMargin*1.5 - lPresetMenuHeight;
uicontrol(f, 'Style','text','String','New Preset:',...
             'Units','pixels',...
             'HorizontalAlignment','Left',...
             'Fontsize',12,...
             'Position',[lPresetX,lNewPresetHeaderY,...
             lPresetWidth,lPresetTitleHeight]);                     

lNewPresetNameY = lNewPresetHeaderY - lPresetMenuHeight - lMargin;
h.NewPresetName = uicontrol(f,'Style','edit','String','default',...
                           'Units','pixels',...
                           'Position',[lPresetX,lNewPresetNameY,...
                           lPresetWidth,lPresetMenuHeight],...
                           'HorizontalAlignment','Left',...
                           'Callback', @newPresetName_Callback);
                       
lSavePresetBtnY = lNewPresetNameY - lPresetMenuHeight - lMargin;
h.SavePresetBtn = uicontrol(f, 'Style', 'pushbutton', 'String' , 'Save',...
                              'Units', 'pixels',...
                              'Position', [lPresetX, lSavePresetBtnY,...
                              lPresetWidth, lPresetMenuHeight],...
                              'Callback', @savePresetBtn_Callback);
  
        
% SimPar Panel
lNumberOfSimPar = 8;
lSimParPanelHeight = lNextRow*(lNumberOfSimPar)+lPanelEdge;
lSimParPanelY = lTitleStartY - lMargin- lSimParPanelHeight;

h.SimParamPanel = uipanel(f,'Title','Sim Parameters',...
                'Units','pixels',...
                'Position',[lMargin,lSimParPanelY ,lPanelWidth,lSimParPanelHeight]);

lTextY = lSimParPanelHeight-lPanelEdge;
lTextX = lMargin;

lEditWidth = 0.3*lPanelWidth;
lEditHeight = 18;
lEditX = lPanelWidth-lMargin-lEditWidth;
lEditY = lTextY+lAlignEditText;

% PV
uicontrol(h.SimParamPanel,'Style','text','String','PV start [kW]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.PvStart = uicontrol(h.SimParamPanel,'Style','edit','String',set.pvStartKw,...
                    'Units','pixels',...
                    'Position',[lEditX,lEditY,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                
uicontrol(h.SimParamPanel,'Style','text','String','PV stop [kW]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.PvStop = uicontrol(h.SimParamPanel,'Style','edit','String',set.pvStopKw,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                               
uicontrol(h.SimParamPanel,'Style','text','String','PV step [kW]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.PvStep = uicontrol(h.SimParamPanel,'Style','edit','String',set.pvStepKw,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*2,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');  

% Batt
uicontrol(h.SimParamPanel,'Style','text','String','Batt start [kWh]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*3,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.BattStart = uicontrol(h.SimParamPanel,'Style','edit','String',set.battStartKwh,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*3,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');  

                
uicontrol(h.SimParamPanel,'Style','text','String','Batt stop [kWh]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*4,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.BattStop = uicontrol(h.SimParamPanel,'Style','edit','String',set.battStopKwh,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*4,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.SimParamPanel,'Style','text','String','Batt step [kWh]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*5,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.BattStep = uicontrol(h.SimParamPanel,'Style','edit','String',set.battStepKwh,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*5,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

% LLP
uicontrol(h.SimParamPanel,'Style','text','String','Llp Acceptance [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*6,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.LlpAccept = uicontrol(h.SimParamPanel,'Style','edit','String',set.llpAccept,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*6,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.SimParamPanel,'Style','text','String','LLP start [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*7,...
                     lTextWidth,lTextHeight],...
                     'HorizontalAlignment', 'Left');
h.LlpStart = uicontrol(h.SimParamPanel,'Style','edit','String',set.llpStart,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*7,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
           
uicontrol(h.SimParamPanel,'Style','text','String','LLP stop [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*8,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.LlpStop = uicontrol(h.SimParamPanel,'Style','edit','String',set.llpStop,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*8,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.SimParamPanel,'Style','text','String','LLP step [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY - lNextRow*9,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');
h.LlpStep = uicontrol(h.SimParamPanel,'Style','edit','String',set.llpStep,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*9,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');


% % Battery Parameter Panel
lNumberOfBattPar = 6; 
lBattParPanelHeight = lNextRow*(lNumberOfBattPar)+20;
lBattPanelStartY = lSimParPanelY - lBattParPanelHeight;
h.BattParamPanel = uipanel(f,'Title','Battery Parameters',...
                  'Units','pixels',...
                  'Position',[lMargin,lBattPanelStartY,...
                  lPanelWidth, lBattParPanelHeight]);   
 
lTextY = lBattParPanelHeight-lPanelEdge;
lEditY = lTextY + lAlignEditText;
              
              
uicontrol(h.BattParamPanel,'Style','text','String','Min State Of Charge [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.MinStateOfCharge = uicontrol(h.BattParamPanel,'Style','edit','String',...
                    set.minStateOfCharge,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
          
uicontrol(h.BattParamPanel,'Style','text','String','Initial State Of Charge [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.InitialStateOfCharge = uicontrol(h.BattParamPanel,'Style','edit','String',...
                    set.initialStateOfCharge,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.BattParamPanel,'Style','text','String','Charging Efficiency [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*2 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.ChargingEfficiency = uicontrol(h.BattParamPanel,'Style','edit','String',...
                    set.chargingEfficiency,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*2,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.BattParamPanel,'Style','text','String','Discharging Efficiency [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*3 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.DischargingEfficiency = uicontrol(h.BattParamPanel,'Style','edit','String',...
                    set.dischargingEfficiency,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*3,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.BattParamPanel,'Style','text','String','Power-Energy Ratio',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*4 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.PowerEnergyRatio = uicontrol(h.BattParamPanel,'Style','edit','String',...
                    set.powerEnergyRatio,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*4,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                
uicontrol(h.BattParamPanel,'Style','text','String','Max Operational Years',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*5 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.MaxOperationalYears = uicontrol(h.BattParamPanel,'Style','edit','String',...
                    set.maxOperationalYears,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*5,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                


% % Economic Parameters Panel
lNumberOfEcoPar = 8;
lEcoParPanelHeight = lNextRow*(lNumberOfEcoPar)+lPanelEdge;
lEcoParPanelY = lTitleStartY - lMargin- lEcoParPanelHeight;
h.EcoParamPanel = uipanel(f,'Title','Economic Parameters',...
                  'Units','pixels',...
                  'Position',[lMargin + lPanelWidth,...
                  lEcoParPanelY,lPanelWidth, lEcoParPanelHeight]);
              
lTextY = lEcoParPanelHeight-lPanelEdge;
lEditY = lTextY + lAlignEditText;

uicontrol(h.EcoParamPanel,'Style','text','String','Budget',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.Budget= uicontrol(h.EcoParamPanel,'Style','edit','String',set.budget,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                

uicontrol(h.EcoParamPanel,'Style','text','String','PV cost [/kW]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.PvCost= uicontrol(h.EcoParamPanel,'Style','edit','String',set.pvCostKw,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                

uicontrol(h.EcoParamPanel,'Style','text','String','Batt cost [/kWh]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.BattCost= uicontrol(h.EcoParamPanel,'Style','edit','String',set.battCostKwh,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*2,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                

uicontrol(h.EcoParamPanel,'Style','text','String','Batt cost fixed',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*3,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.BattCostFix= uicontrol(h.EcoParamPanel,'Style','edit','String',set.battCostFixed,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*3,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                

uicontrol(h.EcoParamPanel,'Style','text','String','Inverter Cost [\kW]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*4 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.InverterCost= uicontrol(h.EcoParamPanel,'Style','edit',...
                    'String',set.inverterCostKw,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*4,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                

uicontrol(h.EcoParamPanel,'Style','text','String','Operation and Maintenance cost [/kW]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*5 + lMultiLineAdjust3,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.OperationMaintenanceCost= uicontrol(h.EcoParamPanel,'Style','edit',...
                    'String',set.operationMaintenanceCostKw,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*5,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                

uicontrol(h.EcoParamPanel,'Style','text','String','Installation and Balance of System [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*6 + lMultiLineAdjust3 ,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.InstallBalanceOfSystemCost= uicontrol(h.EcoParamPanel,'Style','edit',...
                    'String',set.installBalanceOfSystemCost,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*6,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                
                
uicontrol(h.EcoParamPanel,'Style','text','String','Plant Lifetime [years]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*7 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.PlantLifetime = uicontrol(h.EcoParamPanel,'Style','edit',...
                    'String',set.plantLifetime,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*7,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                
uicontrol(h.EcoParamPanel,'Style','text','String','Interest rate [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY-lNextRow*8,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.InterestRate = uicontrol(h.EcoParamPanel,'Style','edit','String',set.interestRate,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY-lNextRow*8,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                
                
                
                
% % PV Parameters Panel
lNumberOfPvPar = 5;
lPvParPanelHeight = lNextRow*(lNumberOfPvPar)+ 12;
lPvPanelStartY = lEcoParPanelY - lPvParPanelHeight;
h.PvParamPanel = uipanel(f,'Title','PV Parameters',...
                  'Units','pixels',...
                  'Position',[lMargin + lPanelWidth,...
                  lPvPanelStartY,lPanelWidth, lPvParPanelHeight]);
              
lTextY = lPvParPanelHeight-lPanelEdge;
lEditY = lTextY + lAlignEditText;

uicontrol(h.PvParamPanel,'Style','text','String','Balance Of System',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.BalanceOfSystem = uicontrol(h.PvParamPanel,'Style','edit','String',...
                    set.balanceOfSystem,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');
                
uicontrol(h.PvParamPanel,'Style','text','String','Nominal Ambient Temperature [C]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow+ lMultiLineAdjust3,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.NominalAmbientTemp = uicontrol(h.PvParamPanel,'Style','edit','String',...
                    set.nominalAmbientTemperatureC,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.PvParamPanel,'Style','text','String','Nominal Cell Temperature [C]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*2 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.NominalCellTemp = uicontrol(h.PvParamPanel,'Style','edit','String',...
                    set.nominalCellTemperatureC,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*2,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');

uicontrol(h.PvParamPanel,'Style','text','String','Nominal Irradiation [kW/m^2]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*3 + lMultiLineAdjust3,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.NominalIrradiation = uicontrol(h.PvParamPanel,'Style','edit','String',...
                    set.nominalIrradiation,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*3,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');


uicontrol(h.PvParamPanel,'Style','text','String','Power Derate Due Temp [/C]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY- lNextRow*4 + lMultiLineAdjust2,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.PowerDerateDueTemp = uicontrol(h.PvParamPanel,'Style','edit','String',...
                    set.powerDerateDueTemperature,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY - lNextRow*4,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');


% Inverter Parameter Panel
lInvParPanelHeight = lNextRow+14;
lInvPanelStartY = lPvPanelStartY - lInvParPanelHeight +5;
h.InvParamPanel = uipanel(f,'Title','Inverter Parameters',...
                  'Units','pixels',...
                  'Position',[lMargin+ lPanelWidth,lInvPanelStartY,...
                  lPanelWidth, lInvParPanelHeight]);   
 
lTextY = lInvParPanelHeight-lPanelEdge+5;
lEditY = lTextY + lAlignEditText;

uicontrol(h.InvParamPanel,'Style','text','String','Efficiency [%]',...
                    'Units','pixels',...
                    'Position',[lTextX,lTextY,...
                     lTextWidth,lTextHeight],...
                    'HorizontalAlignment', 'Left');               
h.InvEfficiency = uicontrol(h.InvParamPanel,'Style','edit','String',...
                    set.invEfficiency,...
                    'Units','pixels',...
                    'Position',[lEditX, lEditY,...
                     lEditWidth,lEditHeight],...
                    'HorizontalAlignment','Center');            
f.Visible = 'on';


    function newPresetName_Callback(src, eventdata)
       newPresetName = src.String;
    end


    function savePresetBtn_Callback(src, eventdata)
         set.pvStartKw = h.PvStart.String;
         set.pvStopKw = h.PvStop.String;
         set.pvStepKw = h.PvStep.String;
         set.battStartKwh = h.BattStart.String;
         set.battStopKwh = h.BattStop.String;
         set.battStepKwh = h.BattStep.String;
         set.llpAccept = h.LlpAccept.String;
         set.llpStart = h.LlpStart.String;
         set.llpStop = h.LlpStop.String;
         set.llpStep = h.LlpStep.String;          
         set.budget = h.Budget.String;
         set.pvCostKw = h.PvCost.String ;          
         set.battCostKwh = h.BattCost.String;             
         set.battCostFixed = h.BattCostFix.String;             
         set.inverterCostKw = h.InverterCost.String;          
         set.operationMaintenanceCostKw = h.OperationMaintenanceCost.String;           
         set.installBalanceOfSystemCost = h.InstallBalanceOfSystemCost.String;             
         set.plantLifetime = h.PlantLifetime.String;               
         set.interestRate = h.InterestRate.String;            
         set.balanceOfSystem = h.BalanceOfSystem.String;             
         set.nominalAmbientTemperatureC = h.NominalAmbientTemp.String;              
         set.nominalCellTemperatureC = h.NominalCellTemp.String;              
         set.nominalIrradiation = h.NominalIrradiation.String;             
         set.powerDerateDueTemperature = h.PowerDerateDueTemp.String;              
         set.minStateOfCharge = h.MinStateOfCharge.String;            
         set.initialStateOfCharge = h.InitialStateOfCharge.String;            
         set.chargingEfficiency = h.ChargingEfficiency.String;             
         set.dischargingEfficiency = h.DischargingEfficiency.String;             
         set.powerEnergyRatio = h.PowerEnergyRatio.String;              
         set.maxOperationalYears = h.MaxOperationalYears.String;               
         set.invEfficiency = h.InvEfficiency.String;   
       
       presetsPath = get_presets_path;
       fullpath = strcat(presetsPath, newPresetName);
       save(fullpath, 'set')
       
       update_presets_menu
       
    end
    
    function presetsMenu_Callback(src, eventdata)
       presetNames = src.String;
       preset = presetNames(src.Value);

       presetsPath = get_presets_path;
       fullpath = strcat(presetsPath, preset{1});
       set = importdata(fullpath);
       
       update_edits
    end
    
    function update_edits
        h.PvStart.String = set.pvStartKw;
        h.PvStop.String = set.pvStopKw;
        h.PvStep.String = set.pvStepKw;
        h.BattStart.String = set.battStartKwh;
        h.BattStop.String = set.battStopKwh;
        h.BattStep.String = set.battStepKwh;
        h.LlpAccept.String = set.llpAccept;
        h.LlpStart.String = set.llpStart;
        h.LlpStop.String = set.llpStop;
        h.LlpStep.String = set.llpStep;          
        h.Budget.String = set.budget;
        h.PvCost.String = set.pvCostKw;          
        h.BattCost.String = set.battCostKwh;             
        h.BattCostFix.String= set.battCostFixed;             
        h.InverterCost.String = set.inverterCostKw;          
        h.OperationMaintenanceCost.String = set.operationMaintenanceCostKw;           
        h.InstallBalanceOfSystemCos.String = set.installBalanceOfSystemCost;             
        h.PlantLifetime.String = set.plantLifetime;               
        h.InterestRate.String = set.interestRate;            
        h.BalanceOfSystem.String = set.balanceOfSystem;             
        h.NominalAmbientTemp.String = set.nominalAmbientTemperatureC;              
        h.NominalCellTemp.String = set.nominalCellTemperatureC;              
        h.NominalIrradiation.String = set.nominalIrradiation;             
        h.PowerDerateDueTemp.String = set.powerDerateDueTemperature;              
        h.MinStateOfCharge.String = set.minStateOfCharge;            
        h.InitialStateOfCharge.String = set.initialStateOfCharge;            
        h.ChargingEfficiency.String = set.chargingEfficiency;             
        h.DischargingEfficiency.String = set.dischargingEfficiency;             
        h.PowerEnergyRatio.String = set.powerEnergyRatio;              
        h.MaxOperationalYears.String = set.maxOperationalYears;               
        h.InvEfficiency.String = set.invEfficiency;        
    end
    
    function update_presets_menu
        presetFiles = dir('functions/GUI/presets/*.mat');
        presetList = cell(1,length(presetFiles));

        for j = 1:length(presetList)
            presetList{j} = presetFiles(j).name;
        end

        h.PresetsMenu.String = presetList; 
    end

end


function presetsPath = get_presets_path
       filename = mfilename();
       localPath = mfilename('fullpath');
       localPath = localPath(1:end-length(filename));
       operating_system = getenv('OS');
       if strcmp(operating_system(1:7), 'Windows')
           presetsPath = strcat(localPath, 'presets\');         
       else
           presetsPath = strcat(localPath, 'presets/');
       end
end


