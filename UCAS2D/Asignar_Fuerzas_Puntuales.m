function varargout = Asignar_Fuerzas_Puntuales(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Fuerzas_Puntuales_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Fuerzas_Puntuales_OutputFcn, ...
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

function Asignar_Fuerzas_Puntuales_OpeningFcn(hObject, eventdata, handles, varargin)
global op_afn mag_text
%---------- Codigo para centrar guide ------------
centrar_guide;
set(handles.text7,'string',strcat("[",mag_text{1},"]"));% Coloca unidad de desfase
set(handles.text8,'string',strcat('[',mag_text{1},']'));% Coloca unidad de desfase
set(handles.text9,'string',strcat('[',mag_text{1},'-',mag_text{2},']'));% Coloca unidad de desfase
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%-----------Opcion de Asignar fuerzas Nodales-------------------------
op_afn = 2;                     % Bandera de agregar fuerzas activada
%----------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Fuerzas_Puntuales_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_def_Callback(hObject, eventdata, handles)
set(handles.e_1,'string','0');   %Valores por defecto
set(handles.e_2,'string','0');   %Valores por defecto
set(handles.e_3,'string','0');   %Valores por defecto

function b_ok_Callback(hObject, eventdata, handles)
b_apl_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Fuerzas_Puntuales);

function b_apl_Callback(hObject, eventdata, handles)
global op_afn nod_sel vn_fx vn_fy vn_fg vn_obj op_ffp 
if isempty(nod_sel) == 0                            % Revisa que verctor no este vacio
    fx = str2num(get(handles.e_1,'string'));        % Lectura de fuerza en X
    fy = str2num(get(handles.e_2,'string'));        % Lectura de fuerza en Y
    fg = str2num(get(handles.e_3,'string'));        % Lectura de momento en Z
    switch op_afn 
        case 1                                          % Caso para agregar
            for i =1:size(nod_sel,1)
                cod = nod_sel(i,1);                     % Busca nodo codigo
                cod = find(vn_obj(:,1) == cod);         % Busca nodo posicion
                vn_fx(cod,2) = vn_fx(cod,2) + fx;       % Agrega fuerza en X
                vn_fy(cod,2) = vn_fy(cod,2) + fy;       % Agrega fuerza en Y
                vn_fg(cod,2) = vn_fg(cod,2) + fg;       % Agrega momento en Z
            end
        case 2                                          % Caso para reemplazar
            for i =1:size(nod_sel,1)
                cod = nod_sel(i,1);                     % Busca nodo codigo
                cod = find(vn_obj(:,1) == cod);         % Busca nodo posicion
                vn_fx(cod,2) = fx;       % Agrega fuerza en X
                vn_fy(cod,2) = fy;       % Agrega fuerza en Y
                vn_fg(cod,2) = fg;       % Agrega momento en Z
            end
        case 3                                          % Caso para borrar
            for i =1:size(nod_sel,1)
                cod = nod_sel(i,1);                     % Busca nodo codigo
                cod = find(vn_obj(:,1) == cod);         % Busca nodo posicion
                vn_fx(cod,2) = 0;       % Agrega fuerza en X
                vn_fy(cod,2) = 0;       % Agrega fuerza en Y
                vn_fg(cod,2) = 0;       % Agrega momento en Z
            end
    end
    desel();                % Deseleccionar Nodos
end
op_ffp = 1;                             % Opcion para colocar cargas puntuales
vis_cargas();                           % Funcion para crear cargas

function r_a_Callback(hObject, eventdata, handles)
global op_afn 
set(handles.r_r,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_afn = 1;                     % Bandera de agregar fuerzas activada

function r_r_Callback(hObject, eventdata, handles)
global op_afn 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_afn = 2;                     % Bandera de agregar fuerzas activada

function r_b_Callback(hObject, eventdata, handles)
global op_afn 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_r,'value',0);     % Bloque opcion borrar
op_afn = 3;                     % Bandera de agregar fuerzas activada

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
