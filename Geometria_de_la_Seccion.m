function varargout = Geometria_de_la_Seccion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Geometria_de_la_Seccion_OpeningFcn, ...
                   'gui_OutputFcn',  @Geometria_de_la_Seccion_OutputFcn, ...
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

function Geometria_de_la_Seccion_OpeningFcn(hObject, eventdata, handles, varargin)
global e_nomsecc s_dim1 s_dim2 s_dim3 s_dim4 e_dim1 e_dim2 e_dim3 e_dim4 p_secc axes_sec
global sec op_sec con_sec vm_eti sec_e vs_eti vs_geo vsec3 vs_pro mag_text                   
%------------------- CODIGO PARA CENTRAR EL GUIDE ----------------
centrar_guide                                                               % Llama script que centra el guide
set(handles.text17,'string',strcat("[",mag_text{2},"]"));% Coloca unidad de desfase
set(handles.text18,'string',strcat("[",mag_text{2},"]"));% Coloca unidad de desfase
set(handles.text19,'string',strcat("[",mag_text{2},"]"));% Coloca unidad de desfase
set(handles.text20,'string',strcat("[",mag_text{2},"]"));% Coloca unidad de desfase
%---------------- Programa para nueva seccion -----------------------
e_nomsecc = handles.e_nomsec;p_secc = handles.p_sec;                        % Guarda elementos nombre de seccion y lista de materiales
s_dim1 = handles.s_d1; s_dim2 = handles.s_d2;                               % Guarda static text de dimensiones 
s_dim3 = handles.s_d3; s_dim4 = handles.s_d4;                               % Guarda static text de dimensiones 
e_dim1 = handles.e_d1; e_dim2 = handles.e_d2;                               % Guarda edit text de dimensiones 
e_dim3 = handles.e_d3; e_dim4 = handles.e_d4;                               % Guarda edit text de dimensiones 
v_text = [s_dim1 s_dim2 s_dim3 s_dim4];                                     % Vector de static text de dimensiones 
v_edit = [e_dim1 e_dim2 e_dim3 e_dim4];                                     % Vector de edit text de dimensiones 
axes_sec = handles.ax_sec;                                                  % Axes del la seccion analizada
%------------------------ Programa Inicial ---------------------------
t_sec = {'Ancho (b)' 'Altura (h)'};                                         % Texto para seccion rectangular y otras
d_sec = [30 30];                                                            % Datos para seccion rectangular
nom = 'SEC_SR_';                                                            % Nombre de seccion rectangular
a = 2;                                                                      % Longitud del vector de valores para seccion rectangular u otras
if sec == 2                                                                 % Si la seccion es perfil tipo I
	t_sec = {'Altura exterior (h)' 'Espesor del Alma (tw)' 'Ancho del patin (bf)' 'Espesor del patin (tf)'}; % Texto para seccion tipo I
    d_sec = [8 0.38 4.6 0.52];                                              % Datos para seccion I 
    nom = 'SEC_W_';                                                         % Nombre de seccion I
    a = 4;                                                                  % Longitud del vector de valores para seccion I
    set(handles.text19,'visible','on'); set(handles.text20,'visible','on');
elseif sec == 3                                                             % Si la seccion es otra
    nom = 'SEC_O_';                                                         % Texto para seccion otra
end
d = nom;                                                                    %Guarda variable nom
for i = 1: length(t_sec)                                                    % Modifica visibilidad y datos de text y static text
	set(v_text(i),'visible','on');                                          % Hace visible los text
	set(v_edit(i),'visible','on');                                          % Hace visible los edit text
	set(v_text(i),'string',t_sec{i});                                       % Escribe en static text
end
if op_sec == 3 | op_sec == 4
    nom = vs_eti{sec_e,2};                                                  % Nombre para seccion existente
    col = vs_eti{sec_e,3};                                                  % Color para seccion existente
    d_sec = vs_geo(sec_e,2:5);                                              % Datos para seccion existente
    b = vs_eti{sec_e,end};                                                  % Id local para material de seccion existente
    c = find(cell2mat(vm_eti(:,1)) == b);                                   % Id global para material de seccion existente
end
if op_sec == 2 | op_sec == 3
    nom = strcat(d,num2str(con_sec+1));                                     % Nombre para nueva seccion
    col = [0 1 0];                                                          % Color de la seccion
end
set(handles.b_colorsec,'backgroundcolor',col);                              % Coloca color de la seccion
set(e_nomsecc,'string',nom);                                                % Coloca nombre de la seccion
for i = 1 : a                                                      
    set(v_edit(i),'string',num2str(d_sec(i)));                              % Escribe en edit text datos de geometria de la seccion
end
%-------------------Cargar Datos -------------------------
if op_sec == 2                                                              % Analiza si se crea nueva seccionPone material nuevo el #1 de la lista
    c = 1;                                                                  % Pone material #1 de la lista, como material de la seccion
end    
set(handles.p_sec,'string',vm_eti(:,2));                                  	% Carga lista de materiales
set(handles.p_sec,'value',c);                                               % Coloca pop menu en valor del material designado
%--------------------------------------------------------
grafica_seccion;                                                            % Hace grafico de seccion
%---------- Codigo para Cargar Propiedades Existentes ------------
if sec == 3 & op_sec ~= 2                                                   % Para secciones existentes rectangular o I
    vsec3 = vs_pro(sec_e,4:10);                                              % Propiedades de seccion existente rectangular o perfil I
end
if op_sec ~= 2 & vs_eti{sec_e,5} == 1;
    %a = vs_geo(sec_e,2:5)
    for i = 1 : 4
        set(v_edit(i),'enable','off');
    end
else
%---------- Codigo para calcular propiedades ------------
    e_d1_Callback(hObject, eventdata, handles);                                 % Hace que se calcule las propiedadess de la seccion
end
handles.output = hObject;
guidata(hObject, handles);

function varargout = Geometria_de_la_Seccion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_colorsec_Callback(hObject, eventdata, handles)
color_sec = uisetcolor([1 0 0],'Seleccionar Color de Material');            % Saca panel de colores y obtiene color
set(handles.b_colorsec,'backgroundcolor',color_sec);                        % Cambia de color el boton

function b_cancelar_Callback(hObject, eventdata, handles)
close(Geometria_de_la_Seccion);                                             % Cierra guide actual

function b_pro_Callback(hObject, eventdata, handles)
Propiedades_de_la_Seccion;                                                  % Abre guide geometria de seccion

function b_ok_Callback(hObject, eventdata, handles)
global op_sec e_dim1 e_dim2 e_dim3 e_dim4 vsec3
global e_nomsecc sec lista_sec p_secc con_sec sec_e vm_eti vs_eti vs_geo vs_pro vs_pro1
v_edit=[e_dim1 e_dim2 e_dim3 e_dim4];
nom = get(e_nomsecc,'string');                                              % Obtiene nombre le seccion
col = get(handles.b_colorsec,'backgroundcolor');                            % Cambia de color el boton
a = str2num(get(v_edit(1),'string'));                                       % Obtiene caracteristicas
b = str2num(get(v_edit(2),'string'));                                       % Obtiene caracteristicas
val_new = [a b 0 0];                                                        % Propiedades geometricas de la seccion
mat = get(p_secc,'value');                                                  % Material local
mat = vm_eti{mat,1};                                                        % Material Global
if sec == 2                                                                 % Seccion Perfil I
    d = str2num(get(v_edit(3),'string'));                                   % Obtiene caracteristicas
    c = str2num(get(v_edit(4),'string'));                                   % Obtiene caracteristicas
    val_new = [a b d c];                                                    % Vector nuevo de geometria
end
if op_sec == 2 | op_sec == 3                                                % Si anexa nueva seccion
    con_sec = con_sec + 1;                                                  % Contador de secciones
    vs_eti(end+1,:) = {con_sec nom col sec 0 mat};                          % Anexa geometria y tipo de nuevo seccion
    vs_geo(end+1,:) = [con_sec val_new];                                    % Anexa nombre de la seccion y color
    vs_pro(end+1,:) = [con_sec vs_pro1];                                    % Anexa Propiedades de la seccion
elseif op_sec == 4 
    vs_eti(sec_e,2:3) = {nom col};                                          % Anexa geometria y tipo de nuevo seccion
    vs_eti(sec_e,end) = {mat};                                              % Anexa geometria y tipo de nuevo seccion
    vs_geo(sec_e,2:5) = val_new;                                    % Anexa nombre de la seccion y color
    if vs_eti{sec_e,end-1} == 0
        calculo_pro_sec;
        vs_pro(sec_e,2:end) = vs_pro1;
    end   
end
if op_sec == 2 & sec == 3                                                   % si es un nuevo material con seccion otra
	vs_pro(end,:) = [con_sec b a vsec3];                                    % incorpora propiedades de la seccion
end
set(lista_sec,'string',vs_eti(:,2));                                        % Carga lista de secciones
close(Geometria_de_la_Seccion);                                             % Cierra Guide Actual  

%--------------- No Programado ------------------------

function p_sec_Callback(hObject, eventdata, handles)

function p_sec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_d5_Callback(hObject, eventdata, handles)

function e_d5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_d1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_d1_Callback(hObject, eventdata, handles)
global sec e_dim1 e_dim2 e_dim3 e_dim4 axes_sec
grafica_seccion;                                                            % Grafica seccion
ban_pro = 0;                                                                % Desactiva activacion de text en guide propiedades de la seccion
calculo_pro_sec;                                                            % Calculo de propiedades de la seccion

function e_d2_Callback(hObject, eventdata, handles)
global sec e_dim1 e_dim2 e_dim3 e_dim4 axes_sec
grafica_seccion;                                                            % Grafica seccion
ban_pro = 0;                                                                % Desactiva activacion de text en guide propiedades de la seccion
calculo_pro_sec;                                                            % Calculo de propiedades de la seccion

function e_d2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_d3_Callback(hObject, eventdata, handles)
global sec e_dim1 e_dim2 e_dim3 e_dim4 axes_sec
grafica_seccion;                                                            % Grafica seccion
ban_pro = 0;                                                                % Desactiva activacion de text en guide propiedades de la seccion
calculo_pro_sec;                                                            % Calculo de propiedades de la seccion

function e_d3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_d4_Callback(hObject, eventdata, handles)
global sec e_dim1 e_dim2 e_dim3 e_dim4 axes_sec
grafica_seccion;                                                            % Grafica seccion
ban_pro = 0;                                                                % Desactiva activacion de text en guide propiedades de la seccion
calculo_pro_sec;                                                            % Calculo de propiedades de la seccion

function e_d4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_nomsec_Callback(hObject, eventdata, handles)

function e_nomsec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function b_ok_CreateFcn(hObject, eventdata, handles)
