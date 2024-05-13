function varargout = Desplazamientos_en_Nodos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Desplazamientos_en_Nodos_OpeningFcn, ...
                   'gui_OutputFcn',  @Desplazamientos_en_Nodos_OutputFcn, ...
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


% --- Executes just before Desplazamientos_en_Nodos is made visible.
function Desplazamientos_en_Nodos_OpeningFcn(hObject, eventdata, handles, varargin)
global vn_obj sub_s v_u mag_text

n = vn_obj(sub_s,2);
dx = round(v_u(3*n-2),4); dy = round(v_u(3*n-1),4); drot = round(v_u(3*n),4);

set(handles.t_nodo,'String',n,'FontWeight','Bold');
set(handles.t_x,'String',[num2str(dx) ' [' mag_text{2} ']'],'FontWeight','Bold');
set(handles.t_y,'String',[num2str(dy) ' [' mag_text{2} ']'],'FontWeight','Bold');
set(handles.t_rot,'String',[num2str(drot) ' [rad]'],'FontWeight','Bold');
%set(handles.txu,'String',['Desplazamiento' ' [' mag_text{2} '/rad]:']);

handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes Desplazamientos_en_Nodos wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Desplazamientos_en_Nodos_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
global obj_sel
delete(obj_sel);
