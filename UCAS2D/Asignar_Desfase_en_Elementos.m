%PROGRAMA PARA ASIGNAR DESFASE A LOS ELEMENTOS
function varargout = Asignar_Desfase_en_Elementos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Desfase_en_Elementos_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Desfase_en_Elementos_OutputFcn, ...
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
%--------------------------------------------------------------------------
function Asignar_Desfase_en_Elementos_OpeningFcn(hObject, eventdata, handles, varargin)
global op_des mag_text 
set(handles.a_des,'xtick','','ytick','');           % Borra ejes en axes ilustrativo de desfase
set(handles.t_db,'string',strcat("db [",mag_text{2},"]"));% Coloca unidad de desfase
set(handles.t_de,'string',strcat('de [',mag_text{2},']'));% Coloca unidad de desfase
%--------------------- Script para centrar guide --------------------------
centrar_guide;                                      % Programa para centrar guide actual
%--------- Colocacion de Imagen Ilustrativa en guide de desfase -----------
img_arm1=imread('desfase.jpg');                     % Lee archivo que contiene imagen de desfase
axes(handles.a_des);                                % Llama al axes del tipo de desfase
imshow(img_arm1);                                   % Muestra imagen en axes
%-------------------- Codigo para enviar adelante interfaz-----------------
set(handles.figure1,'visible','on');                % Pone visible al guide
WinOnTop(handles.figure1,true);                     % Envia adelante al guide
%------------------------ Opcion para desfase -----------------------------
op_des = 1;                                         % Opcion sin desfase
%--------------------------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);
%--------------------------------------------------------------------------
function varargout = Asignar_Desfase_en_Elementos_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%--------------------------------------------------------------------------
function b_def_Callback(hObject, eventdata, handles)        % Boton de valores por defecto interfaz actual
global op_des
if op_des == 3                      % Configuracion de label para desfase manual
    a = '0';                        % Coloca valores iniciales 0
else
    a = '-';                        % Para otras opciones borra valores
end    
set(handles.e_db,'string',a);       % Carga valores por defecto
set(handles.e_de,'string',a);       % Carga valores por defecto
%--------------------------------------------------------------------------
function b_ok_Callback(hObject, eventdata, handles)         % Boton OK interfaz actual
b_apl_Callback(hObject, eventdata, handles);            % Aplica desfase elejido
b_cer_Callback(hObject, eventdata, handles);            % Cierra interfa actual
%--------------------------------------------------------------------------
function b_cer_Callback(hObject, eventdata, handles)        % Boton Cerrar interfaz actual
close(Asignar_Desfase_en_Elementos);                        % Cierra Interfaz Actual  
%--------------------------------------------------------------------------
function b_apl_Callback(hObject, eventdata, handles)        % Boton Aplicar interfaz grafica
global op_des ele_sel ve_obj ve_des op_eln
if isempty(ele_sel) == 0                                % Revisa que vector de elementos seleccionados no este vacio
    switch op_des 
        case 1                                          % Caso para sin desfase 0
            for i =1:size(ele_sel,1)                    % Recorre eleemntos seleccionados
                cod = ele_sel(i,1);                     % Busca codigo del elemento
                cod = find(ve_obj(:,1) == cod);         % Busca posicion del elemento
                ve_des(cod,2:4) = [1 0 0];              % Modifica vector de desfase Ve_des = [Code tip db  de]
            end
        case 2                                          % Caso para desfase automatico                                       % Caso para reemplazar
            for i =1:size(ele_sel,1)                    % Recorre eleemntos seleccionados
                cod = ele_sel(i,1);                     % Busca codigo del elemento
                cod = find(ve_obj(:,1) == cod);         % Busca posicion del elemento
                ve_des(cod,2) = 2;          % Modifica vector de desfase Ve_des = [Code tip db  de]
                [dbn,den] = desfas(cod);                % Usa funcion para desfase automatico/manual
                ve_des(cod,3:4) = [dbn den];          % Modifica vector de desfase Ve_des = [Code tip db  de]
            end
        case 3                                          % Caso para borrar
            db = str2num(get(handles.e_db,'string'));   % Lectura de desfase inicial
            de = str2num(get(handles.e_de,'string'));   % Lectura de desfase final
            for i =1:size(ele_sel,1)                    % Recorre eleemntos seleccionados
                cod = ele_sel(i,1);                     % Busca codigo del elemento
                ve_des(cod,2:4) = [3 db de];            % Vector de desfase Ve_des = [Code tip db  de]
                [dbn,den]=desfas(cod);                  % Usa funcion para desfase automatico/manual
                ve_des(cod,2:4) = [3 dbn den];          % Modifica vector de desfase Ve_des = [Code tip db  de]
            end
    end
    desel();                                            % Funcion deseleccionar elementos
    op_eln = 6;                                         % Opcion de mostrar etiqueta de desfase
    etiele_act();                                       % Funcion para crear etiquetas de elementos 
end
%--------------------------------------------------------------------------
function r_a_Callback(hObject, eventdata, handles)          % Checkbox desfase 0
global op_des
set(handles.r_r,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
set(handles.e_db,'enable','off');     % Activa texto de desfase
set(handles.t_db,'enable','off');     % Activa texto de desfase
set(handles.e_de,'enable','off');     % Activa texto de desfase
set(handles.t_de,'enable','off');     % Activa texto de desfase
set(handles.e_db,'string','-');     % Activa texto de desfase
set(handles.e_de,'string','-');     % Activa texto de desfase
op_des = 1;                     % Bandera de agregar fuerzas activada
%--------------------------------------------------------------------------
function r_r_Callback(hObject, eventdata, handles)          % Checkbox desfase automatico         
global op_des 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
set(handles.e_db,'enable','off');     % Activa texto de desfase
set(handles.t_db,'enable','off');     % Activa texto de desfase
set(handles.e_de,'enable','off');     % Activa texto de desfase
set(handles.t_de,'enable','off');     % Activa texto de desfase
set(handles.e_db,'string','-');     % Activa texto de desfase
set(handles.e_de,'string','-');     % Activa texto de desfase
op_des = 2;                     % Bandera de agregar fuerzas activada   
%--------------------------------------------------------------------------
function r_b_Callback(hObject, eventdata, handles)          % Checkbox desfase manual
global op_des 
set(handles.r_a,'value',0);             % Bloque opcion de sin desfase
set(handles.r_r,'value',0);             % Bloque opcion de desfase automatico
set(handles.e_db,'enable','on');        % Activa texto de desfase
set(handles.t_db,'enable','on');        % Activa texto de desfase
set(handles.e_de,'enable','on');        % Activa texto de desfase
set(handles.t_de,'enable','on');        % Activa texto de desfase
set(handles.e_db,'string','0');         % Activa texto de desfase
set(handles.e_de,'string','0');         % Activa texto de desfase
op_des = 3;                             % Bandera de desfase manual activado

%************************** NO PROGRAMADA *********************************

function e_1_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function e_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function e_2_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function e_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function e_3_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function e_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function e_de_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function e_de_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function popupmenu2_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function e_db_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function e_db_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
