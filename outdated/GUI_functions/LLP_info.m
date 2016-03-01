function varargout = LLP_info(varargin)
%LLP_INFO M-file for LLP_info.fig
%      LLP_INFO, by itself, creates a new LLP_INFO or raises the existing
%      singleton*.
%
%      H = LLP_INFO returns the handle to a new LLP_INFO or the handle to
%      the existing singleton*.
%
%      LLP_INFO('Property','Value',...) creates a new LLP_INFO using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to LLP_info_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LLP_INFO('CALLBACK') and LLP_INFO('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LLP_INFO.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LLP_info

% Last Modified by GUIDE v2.5 22-Jan-2016 20:50:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LLP_info_OpeningFcn, ...
                   'gui_OutputFcn',  @LLP_info_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LLP_info is made visible.
function LLP_info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

info_str = ['LLP is a measure of quality defined by the ratio of unmet '...
    'load to total load during simulation. '...
    ' LLP = $\frac{\Sigma^T_{t=1} LL(t)}{E_{D,T}}$ \\'...
    'Where LL(t) is the lost load at time t and $E_{D,T}$ is the '...
    'total demand during the period T. One should note that this measure'...
    ' should be accompanied by study of graphs and consideration to when '...
    'you need a running system'];
LLP_info_text = annotation('textbox','String',info_str,'interpreter','latex');
LLP_info_text.Units = 'pixels';
LLP_info_text.Position=[0 65 301 236];
LLP_info_text.FontSize = 10;



% Choose default command line output for LLP_info
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LLP_info wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LLP_info_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.output)
