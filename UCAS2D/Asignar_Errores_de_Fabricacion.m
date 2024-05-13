function varargout = Asignar_Errores_de_Fabricacion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Errores_de_Fabricacion_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Errores_de_Fabricacion_OutputFcn, ...
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

function Asignar_Errores_de_Fabricacion_OpeningFcn(hObject, eventdata, handles, varargin)
global op_ate mag_text
%---------- Codigo para centrar guide ------------
centrar_guide;
set(handles.text9,'string',strcat("[",mag_text{2},"]"));% Coloca unidad de desfase
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%-----------Opcion de Asignar fuerzas Nodales-------------------------
op_ate = 1;                     % Bandera de agregar fuerzas activada
%----------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Errores_de_Fabricacion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_def_Callback(hObject, eventdata, handles)
set(handles.e_al,'string','0');   %Valores por defecto

function b_ok_Callback(hObject, eventdata, handles)
b_apl_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Errores_de_Fabricacion);

function b_apl_Callback(hObject, eventdata, handles)
global op_ate ele_sel ve_tem ve_obj ve_add op_ffp
if isempty(ele_sel) == 0                            % Revisa que verctor no este vacio
    AL = str2num(get(handles.e_al,'string'));        % Lectura de fuerza en X
    switch op_ate 
        case 1                                          % Caso para reemplazar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_add(cod,2) = AL;       % Agrega fuerza en X
            end
        case 2                                          % Caso para borrar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_add(cod,2) = 0;       % Agrega fuerza en X
            end
    end
    desel();                % Deseleccionar Nodos
end
op_ffp = 6;                             % Opcion para colocar cargas puntuales
vis_cargas();                           % Funcion para crear cargas

function r_r_Callback(hObject, eventdata, handles)
global op_ate 
set(handles.r_r,'value',1);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_ate = 1;                     % Bandera de agregar fuerzas activada

function r_b_Callback(hObject, eventdata, handles)
global op_ate 
set(handles.r_r,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',1);     % Bloque opcion borrar
op_ate = 2;                     % Bandera de agregar fuerzas activada
% ------------------------ NO PROGRAMADO ----------------------------------
function e_1_Callback(hObject, eventdata, handles)

function e_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_2_Callback(hObject, eventdata, handles)

function e_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_3_Callback(hObject, eventdata, handles)

function e_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_ti_Callback(hObject, eventdata, handles)

function e_ti_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu2_Callback(hObject, eventdata, handles)

function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_al_Callback(hObject, eventdata, handles)

function e_al_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end