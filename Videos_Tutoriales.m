function varargout = Videos_Tutoriales(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Videos_Tutoriales_OpeningFcn, ...
                   'gui_OutputFcn',  @Videos_Tutoriales_OutputFcn, ...
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

function Videos_Tutoriales_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = Videos_Tutoriales_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function t1_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_1.mp4');catch;implay('Videos\Video_1.mp4');end;   % Video 1
function t2_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_2.mp4');catch;implay('Videos\Video_2.mp4');end;   % Video 2
function t3_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_3.mp4');catch;implay('Videos\Video_3.mp4');end;   % Video 3
function t4_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_4.mp4');catch;implay('Videos\Video_4.mp4');end;   % Video 4
function t5_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_5.mp4');catch;implay('Videos\Video_5.mp4');end;   % Video 5
function t6_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_6.mp4');catch;implay('Videos\Video_6.mp4');end;   % Video 6
function t7_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_7.mp4');catch;implay('Videos\Video_7.mp4');end;   % Video 7
function t8_ButtonDownFcn(hObject, eventdata, handles)

function t9_ButtonDownFcn(hObject, eventdata, handles)
