function varargout = Grafica_Ani_Pushover_Armaduras(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grafica_Ani_Pushover_Armaduras_OpeningFcn, ...
                   'gui_OutputFcn',  @Grafica_Ani_Pushover_Armaduras_OutputFcn, ...
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

function Grafica_Ani_Pushover_Armaduras_OpeningFcn(hObject, eventdata, handles, varargin)
global axe_pua dat_arm vn_coor des_max mag_text t_gpa
%% ------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');    % Pone visible al guide
WinOnTop(handles.figure1,true);         % Envia adelante al guide
axe_pua = handles.axe_puar;             % Guarda variable de axes
t_gpa = handles.t_gpar;                 % Guarda variable texto
cla(axe_pua,'reset');                   % Resetea axes
handles.output = hObject;
guidata(hObject, handles);

function varargout = Grafica_Ani_Pushover_Armaduras_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
