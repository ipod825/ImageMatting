function varargout = ui(varargin)
% UI MATLAB code for ui.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui

% Last Modified by GUIDE v2.5 26-Jun-2013 13:52:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui_OpeningFcn, ...
                   'gui_OutputFcn',  @ui_OutputFcn, ...
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


% --- Executes just before ui is made visible.
function ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui (see VARARGIN)

% Choose default command line output for ui
global algorithm imgw imgh;
handles.output = hObject;
handles.paintType = 1;
handles.img = [];
handles.imgReady = false;
penwidth = round(get(handles.penwidthControl, 'Value'));
setPenWidth(penwidth);
contents = cellstr(get(handles.algorithmChooser,'String'));
algorithm = contents{get(handles.algorithmChooser,'Value')};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when selected object is changed in paintTypeBtns.
function paintTypeBtns_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in paintTypeBtns 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    if(~handles.imgReady)
        return;
    end
    paintType = get(hObject, 'String');
    switch paintType
        case 'Foreground' 
            paintType = 0;
        case 'Background'
            paintType = 1;
    end
    paintTypeChange(paintType);
    

% --- Executes on button press in refreshBtn.
function refreshBtn_Callback(hObject, eventdata, handles)
% hObject    handle to refreshBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global fgpixels bgpixels;
    main(handles, fgpixels, bgpixels);


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fgpixels bgpixels imgw imgh;
[filename,pathname] = uigetfile('images/*.*','Select image file');
if ischar(filename)
    longfilename = strcat(pathname,filename);
    img = imread(longfilename);
    [imgh, imgw, c] = size(img);
    cla;
    axis('image');axis('ij');
    axis('off');
    imshow(img);
    handles.img = img;
    handles.imgReady = true;
    guidata(hObject, handles);
    fgpixels = [];
    bgpixels = [];
    paintTypeChange(0);
end


% --- Executes on slider movement.
function penwidthControl_Callback(hObject, eventdata, handles)
% hObject    handle to penwidthControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    penwidth = round(get(hObject, 'Value'));
    setPenWidth(penwidth);
    set(handles.penwidthText, 'String', penwidth);

 function setPenWidth(penwidth)
    global penx peny;
    pen = ones(penwidth);
    [r w] = find(pen);
    peny = repmat((1:penwidth),penwidth,1);
    penx = peny';


% --- Executes during object creation, after setting all properties.
function penwidthControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to penwidthControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in algorithmChooser.
function algorithmChooser_Callback(hObject, eventdata, handles)
% hObject    handle to algorithmChooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns algorithmChooser contents as cell array
%        contents{get(hObject,'Value')} returns selected item from algorithmChooser
global algorithm
contents = cellstr(get(hObject,'String'));
algorithm = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function algorithmChooser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algorithmChooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
