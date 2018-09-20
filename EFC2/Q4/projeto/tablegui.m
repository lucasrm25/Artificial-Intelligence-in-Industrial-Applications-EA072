function varargout = tablegui(varargin)
% TABLEGUI M-file for tablegui.fig
%      TABLEGUI, by itself, creates a new TABLEGUI or raises the existing
%      singleton*.
%
%      H = TABLEGUI returns the handle to a new TABLEGUI or the handle to
%      the existing singleton*.
%
%      TABLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLEGUI.M with the given input arguments.
%
%      TABLEGUI('Property','Value',...) creates a new TABLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tablegui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tablegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tablegui

% Last Modified by GUIDE v2.5 06-May-2005 13:57:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tablegui_OpeningFcn, ...
                   'gui_OutputFcn',  @tablegui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before tablegui is made visible.
function tablegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tablegui (see VARARGIN)

% Choose default command line output for tablegui
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

handles.child = varargin{1};
handles.parents = varargin{2};
handles.t = varargin{3};
handles.type = varargin{4};
guidata(hObject,handles);


% UIWAIT makes tablegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
width = handles.type(handles.child);
height = cumprod(handles.type(handles.parents));
string1 = num2str(1:handles.type(handles.child),'\t%6.0f');
string2 = num2str(handles.t,'\t%1.3f\f');
state = [];
if ~isempty(handles.parents)
    for i=1:prod(handles.type(handles.parents))
        state = [state;retindex(handles.type(handles.parents),i)];
    end
else
    state = '   ';
end
state = num2str(state);
state = [state(1,:);state];
state(1,1:end) = ' ';
S = [string1;string2];
S = [state,S];
s = ['CPT of variable ',num2str(handles.child)];
S = strvcat(' ',S,' ');
set(handles.figure1,'Name',s);
set(handles.text1,'String',S);
width = size(S,2)*2;
if width<45
    width = 45;
end
set(hObject,'Position',[20,2,width,size(S,1)]);
movegui(hObject, 'center');


% --- Outputs from this function are returned to the command line.
function varargout = tablegui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

