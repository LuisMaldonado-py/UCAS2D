function varargout = Asignar_Secciones_en_Elementos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Secciones_en_Elementos_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Secciones_en_Elementos_OutputFcn, ...
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

function Asignar_Secciones_en_Elementos_OpeningFcn(hObject, eventdata, handles, varargin)
global lista_secc vs_eti 
%---------- Codigo para centrar guide ------------
centrar_guide;
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%---------------- Variable de elementos -----------------
lista_secc = handles.l_secc;                                                  % Guarda elemento list box para mostrar secciones
%--------------- Cargar lista de Secciones --------------
set(lista_secc,'string', vs_eti(:,2));                                       % Carga lista de secciones
set(lista_secc,'value',1);                                                  % Carga lista de secciones
%--------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Secciones_en_Elementos_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function l_secc_Callback(hObject, eventdata, handles)

function l_secc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function b_ana_Callback(hObject, eventdata, handles)
global ban_sec
ban_sec = 1;
Seccion
function b_ok_Callback(hObject, eventdata, handles)
b_api_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Secciones_en_Elementos);

function b_api_Callback(hObject, eventdata, handles)
global ele_sel ve_obj lista_secc ve_conex vs_geo op_eln
if isempty(ele_sel) == 0                            % Revisa que verctor no este vacio
    sec = get(lista_secc,'value');                  % Seccion
    sec = vs_geo(sec,1);
    for i =1:size(ele_sel,1)
    	cod = ele_sel(i,1);                     % Busca nodo codigo
        cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
        ve_conex(cod,4) = sec;                  % Agrega fuerza en X
    end
    desel();                                    % Deseleccionar Nodos
    op_eln = 2;                                 % Opcion de mostrar etiqueta de seccion
    etiele_act();                               % Funcion para crear etiqueta de elementos  
end
