function varargout = Tipo_de_Seccion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tipo_de_Seccion_OpeningFcn, ...
                   'gui_OutputFcn',  @Tipo_de_Seccion_OutputFcn, ...
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

function Tipo_de_Seccion_OpeningFcn(hObject, eventdata, handles, varargin)
%------------------- CODIGO PARA CENTRAR EL GUIDE ----------------
centrar_guide                                                               % Llama script que centra el guide
%---------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Tipo_de_Seccion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function bot_rs_Callback(hObject, eventdata, handles)
global sec                         
sec = 1;                                                                    % Seccion rectangular solida = 1
close(Tipo_de_Seccion);                                                     % Cierra guide actual
Geometria_de_la_Seccion;                                                    % Abre guide geometria de seccion   

function bot_i_Callback(hObject, eventdata, handles)
global sec
sec = 2;                                                                    % Seccion perfil I = 2
close(Tipo_de_Seccion);                                                     % Cierra guide actual
Geometria_de_la_Seccion;                                                    % Abre guide geometria de seccion

function bot_o_Callback(hObject, eventdata, handles)
global sec vsec3 ban_sec3
sec = 3;                                                                    % Seccion otras = 3
close(Tipo_de_Seccion);                                                     % Cierra guide actual
vsec3 = [1 1 1 1 1 1 1];                                                        % Vector de propiedades de secciones otras
ban_sec3 = 0;                                                               % Solo abre guide seccion de geometria 1 vez cuando es nueva seccion otra
Propiedades_de_la_Seccion;                                                  % Abre guide geometria de seccion

function b_cancelar_Callback(hObject, eventdata, handles)
close(Tipo_de_Seccion);                                                     % Cierra guide actual
