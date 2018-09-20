function varargout = bayes(varargin)
% BAYES M-file for bayes.fig
%      BAYES, by itself, creates a new BAYES or raises the existing
%      singleton*.
%
%      H = BAYES returns the handle to a new BAYES or the handle to
%      the existing singleton*.
%
%      BAYES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BAYES.M with the given input arguments.
%
%      BAYES('Property','Value',...) creates a new BAYES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bayes_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bayes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bayes

% Last Modified by GUIDE v2.5 06-May-2005 15:48:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bayes_OpeningFcn, ...
                   'gui_OutputFcn',  @bayes_OutputFcn, ...
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


% --- Executes just before bayes is made visible.
function bayes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bayes (see VARARGIN)

% Choose default command line output for bayes
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bayes wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bayes_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
child = get(hObject,'Value');
if isempty(handles)
    disp('You must run the program first!');
else
    t = handles.tables(child).cpt;
    parents = find(handles.S(child,:));
    tablegui(child,parents,t,handles.type);
end

% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Load_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Load_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)]
cla;
set(handles.listbox1,'Value',1);
set(handles.listbox1,'String','Empty');
cd data;
[filename, pathname] = uigetfile('Select a file');
cd('..');
if filename~=0
    data = importdata([pathname,filename]);
    handles.data = data;
    [row,col] = size(data);
    t1 = ['variables:  ',num2str(col)];
    t2 = ['samples:   ',num2str(row)];
    set(handles.data_info_text, 'String',strvcat(t1,t2));
    col = 1:col; col = col';
    set(handles.listbox1,'String',num2str(col));
    guidata(hObject, handles);
end
% --------------------------------------------------------------------
function Save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd data;
[filename, pathname] = uiputfile('filename.mat');
data = handles.data
if filename~=0
    save(filename, 'data');
end
cd ..

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
k = get(handles.k_edit,'String');
[S,tables,type] = bn(handles.data,str2num(k));
handles.S = S;
handles.tables = tables;
handles.type = type;
guidata(hObject, handles);


% --------------------------------------------------------------------
function network_menu_Callback(hObject, eventdata, handles)
% hObject    handle to network_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_network_Callback(hObject, eventdata, handles)
% hObject    handle to load_network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd network;
[filename, pathname] = uigetfile('Select a file');
cd('..');
if filename~=0
    set(handles.listbox1,'Value',1);
    set(handles.listbox1,'String','Empty');
    t1 = ['variables:  '];
    t2 = ['samples:   '];
    set(handles.data_info_text, 'String',strvcat(t1,t2));
    cla;
    load([pathname,filename])
    draw_graph(S');
    handles.S = S;
    handles.tables = tables;
    handles.type = typ;
    s = 1:length(S);
    set(handles.listbox1,'String',num2str(s'));
    guidata(hObject, handles);
end
% --------------------------------------------------------------------
function save_network_Callback(hObject, eventdata, handles)
% hObject    handle to save_network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd network;
filename = [];
[filename, pathname] = uiputfile('filename.mat');
S = handles.S;
tables = handles.tables;
typ = handles.type;
if filename~=0
    save(filename, 'S','tables','typ');
end
cd ..


% --- Executes during object creation, after setting all properties.
function sample_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sample_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_edit as text
%        str2double(get(hObject,'String')) returns contents of sample_edit as a double


% --- Executes on button press in sample_button.
function sample_button_Callback(hObject, eventdata, handles)
% hObject    handle to sample_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s = get(handles.sample_edit,'String');
data = netsample(handles.S,str2num(s),handles.tables,handles.type)
handles.data = data;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function k_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function k_edit_Callback(hObject, eventdata, handles)
% hObject    handle to k_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k_edit as text
%        str2double(get(hObject,'String')) returns contents of k_edit as a double

