function varargout = blank(varargin)
% BLANK MATLAB code for blank.fig
%      BLANK, by itself, creates a new BLANK or raises the existing
%      singleton*.
%
%      H = BLANK returns the handle to a new BLANK or the handle to
%      the existing singleton*.
%
%      BLANK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLANK.M with the given input arguments.
%
%      BLANK('Property','Value',...) creates a new BLANK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before blank_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to blank_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help blank

% Last Modified by GUIDE v2.5 04-Mar-2016 15:31:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blank_OpeningFcn, ...
                   'gui_OutputFcn',  @blank_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before blank is made visible.
function blank_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to blank (see VARARGIN)

% Choose default command line output for blank
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes blank wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = blank_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
