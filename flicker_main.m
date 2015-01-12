% ------------------------INSTRUCTIONS-------------------------------
%*PREPARE DATA FOR PROCESSING
%   *DATA WITHOUT DIMMING
%       *All flicker data must be placed in folders that contain all of the dim levels for each test
%       *Point this tool to the folder one directory above, it will analyze all of the data for each
%           product, and group all of the dim levels for that product. (reference example below, where
%           "all data to be processed" is the folder that should be pointed to.
%
%           ...\all data to be processed\all dim levels for product A
%           ...\all data to be processed\all dim levels for product B

%   *DATA WITH DIMMING
%       *Place all files to be processed in one folder
%       *Point this tool at that folder to process data

% *Do not nest folders and data at more levels than described above
% *Processed data will be placed in the directory pointed to



function varargout = flicker_main(varargin)
% FLICKER_MAIN MATLAB code for flicker_main.fig
%      FLICKER_MAIN, by itself, creates a new FLICKER_MAIN or raises the existing
%      singleton*.
%
%      H = FLICKER_MAIN returns the handle to a new FLICKER_MAIN or the handle to
%      the existing singleton*.
%
%      FLICKER_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLICKER_MAIN.M with the given input arguments.
%
%      FLICKER_MAIN('Property','Value',...) creates a new FLICKER_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before flicker_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to flicker_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help flicker_main

% Last Modified by GUIDE v2.5 28-Apr-2014 10:35:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @flicker_main_OpeningFcn, ...
                   'gui_OutputFcn',  @flicker_main_OutputFcn, ...
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


% --- Executes just before flicker_main is made visible.
function flicker_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to flicker_main (see VARARGIN)

% Choose default command line output for flicker_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes flicker_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = flicker_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_withDimming.
function pushbutton_withDimming_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_withDimming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_path = pwd;
addpath([pwd '/func']);
addpath([pwd '/lib']);
addpath([pwd '/lib/export_fig']);
flicker_process_data(1)


% --- Executes on button press in pushbutton_withoutDimming.
function pushbutton_withoutDimming_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_withoutDimming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_path = pwd;
addpath([pwd '/func']);
addpath([pwd '/lib']);
addpath([pwd '/lib/export_fig']);
flicker_process_data(0)
