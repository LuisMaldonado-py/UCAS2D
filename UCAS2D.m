function varargout = UCAS2D(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UCAS2D_OpeningFcn, ...
                   'gui_OutputFcn',  @UCAS2D_OutputFcn, ...
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
function UCAS2D_OpeningFcn(hObject, eventdata, handles, varargin) % Funcion para Iniciar Guide
clearvars global
global pan_dibujo axe_dibujo bot_mat bot_sec ban_restr
global car_d tp_x tp_y pan1 pan2 pan3 op_play 
global bmen_1 bmen_2 bmen_3 bmen_4 bmen_5 bmen_6 bmen_7       
global bher_1 bher_2 bher_3 bher_4 bher_5 bher_6 bher_7 
global bher_8 bher_9 bher_10 bher_11 bot_point bot_frame 
global ban_selc ban_nuevo ve_conex mag_text p_uax unid
%% Guarda Botones de Barra Menu
bmen_1 = handles.M1_Archivo;        % Opcion barra de menu Archivo
bmen_2 = handles.M1_Definir;        % Opcion barra de menu Definir
bmen_3 = handles.M1_Draw;           % Opcion barra de menu Dibujar
bmen_4 = handles.M1_Asignar;        % Opcion barra de menu Asignar
bmen_5 = handles.M1_Analisis;       % Opcion barra de menu Analisis
bmen_6 = handles.M1_Visualizar;     % Opcion barra de menu Visualizar
bmen_7 = handles.M1_Ayuda;          % Opcion barra de menu Ayuda
%% Guarda Botones de Barra de Harramientas
bher_1 = handles.H_Nuevo;           % Boton barra de herramientas Nuevo
bher_2 = handles.H_Abrir;           % Boton barra de herramientas Abrir
bher_3 = handles.H_Guardar;         % Boton barra de herramientas Guardar
bher_4 = handles.H_Bloquear;        % Boton barra de herramientas Bloquear analisis
bher_5 = handles.H_Correr;          % Boton barra de herramientas Correr analisis
bher_6 = handles.H_Zoom;            % Boton barra de herramientas Zooom
bher_7 = handles.H_Pan;             % Boton barra de herramientas Pan
bher_8 = handles.H_Ver;             % Boton barra de herramientas Ver etiquetas
bher_9 = handles.H_Original;        % Boton barra de herramientas Grafica estructura original
bher_10 = handles.H_Deformada;      % Boton barra de herramientas Grafica estructura deformada
bher_11 = handles.H_Cargas;         % Boton barra de herramientas Cargas
bot_point = handles.b_point;        % Boton barra de herramientas Graficar nodos
bot_frame = handles.b_frame;        % Boton barra de herramientas Graficar elementos
%% Guarda Elementos para Pantalla Principal
pan_dibujo = handles.pan_1;         % Panel que contine espacio de trabajo
axe_dibujo = handles.axes1;         % Axes principal
p_uax = handles.p_unia;             % Unidades Principales   
tp_x = handles.t_cx;                % Edit text de coord X escritura
tp_y = handles.t_cy;                % Edit text de coord Y escritura
pan1 = handles.pan_1; pan2 = handles.pan_2; pan3 = handles.pan_3;   % Paneles de Inicio
%%  Variables Iniciales
car_d = [48 49 50 51 52 53 54 55 56 57 46 45];  % Valores de las teclas
ban_restr = 0;                  % Bandera guide restricciones
op_play = 0;                    % Bandera para para analisis 0->Nada/1->Lineal/2->No-Lineal
ban_nuevo = 0;                  % Bandera para axes activado
ban_selc = 0;                   % Bandera de cuadro seleccionador
ve_conex = [];                  % Vector de conexion
mag_text = {'Tonf' 'cm' 'C' 16};   % Variables de magnitud {Fuerza Longitud Temperatura}
unid =[36127.305	,62427983.245	,36.127305	,62427.983245	,0.00980665	,9806650	,1	,1000000000	,9.80665	,9806650000	,0.001	,1000000	,9.80665	,1000	,9806.65	,1;...
    ,386.088	,32.174	,386.088	,32.174	,9806.65	,9.806	,9806.65	,9.806	,9806.65	,9.806	,9806.65	,9.806	,980.665	,980.665	,980.665	,980.665;...
    ,14223.3	,2048197.705	,14.2233	,2048.197705	,0.0980665	,98066.5	,10	,10000000	,98.0665	,98066500	,0.01	,10000	,9.80665	,1000	,9806.65	,1;...
    ,0.55555555556 ,0.55555555556	,0.55555555556	,0.55555555556	,1	,1	,1	,1	,1	,1	,1	,1	,1	,1	,1	,1];

redime()                        % Redimensionar Axes
botones(0);                     % Funcion Desactiva/Activa botones
handles.output = hObject;
guidata(hObject, handles);
function varargout = UCAS2D_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%% BOTON NUEVO MODELO -----------------------------------------------------
function M1_Nuevo_Callback(hObject, eventdata, handles)         % Boton para modelo nuevo (Principal)
global ve_conex
op_abrir = 0;       % Opcion para cerrar modelo op_abrir --> 0 Cancelar/1 Guardar/2 Cerrar
crear_arc;          % Script para cerrar modelo
if op_abrir == 1    % Opcion Guardar
    H_Guardar_ClickedCallback(hObject, eventdata, handles);     % Funcion Guardar
    op_abrir =2;    % Opcion Cerrar Modelo
end
if op_abrir == 2 	% Si se Cerro Modelo, posteriormente abre nuevo modelo
global vm_eti vm_pro con_mat vs_eti vs_geo vs_pro con_sec est_ani
global vn_obj vn_coor vn_fx vn_fy vn_fg con_nod col_p simb_p
global ve_obj ve_tem ve_w ve_des ve_rel con_ele col_l simb_l esp ve_pro ve_p 
global axe_dibujo bot_point bot_mat bot_sec fle_nol vm_proc
global band_poi band_ele ban_nuevo ban_app p_uax mag_text
global tec con_key tp_x tp_y n_nodo b_lib band_rej coor_h nod_sel ele_sel 
global ve_add ban_sec ve_rot op_col op_rel v_visu op_res op_non op_eln  
global op_ffp v_distri vn_const con_const con_rotu ve_rotu vr_pro op_play l_res vn_coor_o
op_play = 0;    % Bandera para Analisis Bloquear
%% Materiales por defecto
vm_eti = {1 'A36' [0.5 0.5 0];2 '4000psi' [0 0 1]};     % Diccionario de materiales Vm_eti = {Codm Name Color]
vm_pro = [1 7.85e-6 2038.9019 0.3 0.0000117 2.5311 7.85e-6/981 784.193;2 2.4e-6 253.4564 0.2 0.0000099 0.2812 2.4e-6/981 105.607]     % Propiedades de materiales por defecto Vm_pro = [Codm p E v C.Temp fy den G]
vm_proc = vm_pro; %Copia de materiales
con_mat = 2;                                            % Contador de Materiales
%% Secciones por defecto 
vs_eti = {1 'SR 30x30' [1 0 0] 1 0 2;2 'IPE 80' [0 0 1] 2 0 1}; % Diccionario de Secciones vs_eti = {Cods Name Color Tip importar Codm]
vs_geo = [1 30 30 0 0 ;2 8 0.38 4.6 0.52];                      % Secciones por defecto Vs_geo1 o 2 =[Cods h b] - Vs_geo2 = [Cods h tw bf tf] 
vs_pro = [1 30 30 900 750 750 67500 67500 6750 6750;2  8 4.6 7.4288 3.9867 3.04 77.701 8.4676 22.494 5.752];      % Secciones por defecto propiedades Vs_pro = [Cods h b A Acx Acy Ix Iy Zx Zy]
con_sec = 2;                                                    % Contador de Secciones 
%% Informacion de Nodos
vn_obj = [];                % Vector de Objeto y etiqueta: Guarda el elemento visualVn_obj = {Codn name obj]
vn_coor = [];               % Vector de Coordenadas y restricciones: Guarda coordenadas y restricciones Vn_coor = {Codn x y rx ry rg u1 u2 u3]
vn_coor_o = [];             % Vector de coordenadas originales
vn_fx = [];                 % Vector de Fuerzas nodales en X Vn_fy = {Codn   Fx1]
vn_fy = [];                 % Vector de Fuerzas nodales en Y Vn_fy = {Codn   Fy1]
vn_fg = [];                 % Vector de momentos nodales Vn_fg = {Codn   M1]
vn_const = {};              % Vector de constraints vn_const = {cod_cons 'Name' Master Slave [Dx Dy Dz]} D = 0 Sin Restriccion, D = 1 Con Restriccion 
con_const = 0;              % Contador de caso de constraints
con_nod = 0;                % Contador de nodos para identificador
col_p = 'b'; simb_p = 'o';  % Color y simbolo de nodo
%% Informacion de Elementos
ve_obj = [];                % Vector de Objeto y etiqueta: Guarda el elemento visualVn_obj = [Code name obj]
ve_conex = [];              % Vector de Conexion y Seccion: ve_conex = [Code Ni Nf Sec]
ve_add = [];                % Vector de errores ve_error = [code Al]
ve_tem = [];                % Vector de Cargas por Temperatura: ve_tem = [Code Tinf Tsup]
ve_w = [];                  % Vector de Cargas distribuida uniforme ve_w = [Code  Axial a b Cortante a b]
ve_p = [];                  % Vector de Cargas puntual ve_p = [Code FuerzaX a b FuerzaY a b Momento a b]
ve_rel = {};                % Vector de release ve_rel = {Code   1 2 3 4 5 6]
ve_pro = [];                % Vector de propiedades modificadas ve_pro = [Code A Acx Acy Ix Iy Zx Zy]
ve_des = [];                % Vector de desfase ve_des = [Code tip db  de]      tip = 0 (Sin Desfase), tip = 2 (Auto),tip = 3 (manual)
ve_rot = [];                % Vector de rotacion de seccion ve_des = [Code tip ]   tip == 1 por defecto, ti[ == 2 rota 90
con_ele = 0;                % Contador de elem para name
ve_rotu = [];               % Vector de rotulas asociadas al elemento ve_rotu = {Code Codr]
%con_rotu = 2;               % Contador de rotulas
col_l = 'b'; simb_l = '-'; esp = 2.5;   % Color, Simbolo y Grosor de Linea
%% Informacion de resorte
l_res={'Res1' 100 0 250};     % Vector de resortes l_res={Nombre K %K Py};
%% Informacion de Curva Elasto-Plastico
vr_pro = {1 'Armadura EP' 1 1; 2 'Portico EP' 2 [0 0.005];3 'Armadura A' 3 [0 0;0.0018 1;0.1050 0]; 4 'Portico A' 4 [0 0;0.05 1;2.5 2]}; % Curvas de comportamiento [# Name Tip Datos]
%% Modificacion de la Ventana Inicial
set(handles.p_inicio1,'Visible','off'); % Invisible Panel1 de Inicio
set(handles.p_inicio2,'Visible','off'); % Invisible Panel2 de Inicio
%% Modificacion Zona de Dibujo ----------------------
cla(axe_dibujo,'reset'); axis equal;    % Reiniciar axes en blanco/ axes con ejes iguales
set(axe_dibujo,'XTick',[],'YTick',[]);  % Eliminar ejes en axes
%% Banderas
band_poi = 0;       % Bandera para dibujo de puntos 
band_ele = 0;       % Bandera para dibujo de elementos
band_rej = 0;       % Bandera para dibujo de elementos en rejilla
ban_app =0;         % Bandera de aproximacion
tec = '';           % datos por teclado
con_key = 0;        % Contador de letras en teclado
n_nodo = 1;         % Numero de nodos graficados
b_lib = 0;          % Bandera de dibujo libre
coor_h = [];        % Datos de rejilla
nod_sel = [];       % Lista de Nodos Seleccionados
ele_sel = [];       % Lista de Elementos Seleccionados
%ban_sec = 0;       % Bandera anadir seccion desde asignar seccion
%ban_nuevo = 0;     % Bandera para axes activado
%% Opciones de Visualizacion
op_col = 1;         % Color de Elementos op_col --> Por defecto/ seccion/ Material                            
v_visu = [0 0 0 0 0 0 0 0]; % Visualizacion [Rni Rnf eti-nodo eti-ele Flecha-Fx eti-fx Flecha-Fy eti-fy] 
v_distri = [];      % Vector cargas distribuidas visual
op_rel = 0;         % Opcion de Releases por defecto desactivado
op_res = 1;         % Opcion de restricciones por defecto activado
op_non = 0;         % Opcion etiqueta de nodo por defecto desactivado
op_eln = 0;         % Opcion etiqueta de elementos por defecto desactivado
op_ffp = 0;         % Opcion cargas nodales por defecto desactivado
est_ani = [];       % Estructura Deformada No-Lineal, elementos
fle_nol = [];       % Flecha No-Lineal
%% Coordenadas de Localizacion de raton
set(tp_x,'string','CX : '); % Hace visible text coord x
set(tp_y,'string','CY : '); % Hace visible text coord y
%%set(bot_point,'enable','on');           % Activa Boton de punto
Nuevo;  % Abre Interfaz de nuevo
set(p_uax,'value',16);  % Carga unidades inciales
end
function b_nuevo_Callback(hObject, eventdata, handles)          % Boton para modelo nuevo
M1_Nuevo_Callback(hObject, eventdata, handles);          
function H_Nuevo_ClickedCallback(hObject, eventdata, handles)   % Boton para modelo nuevo
M1_Nuevo_Callback(hObject, eventdata, handles);
%% BOTON MATERIALES -------------------------------------------------------
function M1_Materiales_Callback(hObject, eventdata, handles)    % Boton para definir materiales nuevos
Materiales;     % Abre interfaz de definir Materiales
%% BOTON SECCION ---------------------------------------------------------- 
function M1_Seccion_Callback(hObject, eventdata, handles)       % Boton para definir secciones nuevos
Seccion;        % Abre interfaz de definir seccion
%% BOTON PUNTOS -----------------------------------------------------------
function b_point_ClickedCallback(hObject, eventdata, handles)   % Boton para dibujar nodos (Principal)
global band_poi tp_x tp_y
if band_poi == 0                % Analiza si esta desactivada esta opcion para activarla
    band_poi = 1;               % Activa bandera de punto
    set(tp_x,'visible','on');   % Hace visible text de ingresar coord x
    set(tp_y,'visible','on'); 	% Hace visible text de ingresarcoord y
    offset;                     % Abre Interfaz Offset
end     
function M1_Nod_Callback(hObject, eventdata, handles)           % Boton para dibujar nodos
b_point_ClickedCallback(hObject, eventdata, handles);           % Boton para dibujar elementos
%% BOTON DIBUJAR ELEMENTOS ------------------------------------------------
function b_frame_ClickedCallback(hObject, eventdata, handles)   % Boton para dibujar elementos (Principal)
global band_ele  band_poi tp_x tp_y vn_obj b_lib band_rej
if b_lib == 1
    if band_ele == 0 & size(vn_obj,1) > 1 
        Elemento
        if band_poi == 1
            band_poi = 0;
            close(offset)
            set(tp_x,'visible','off');                                          % Hace visible text coord x
            set(tp_y,'visible','off');                                          % Hace visible text coord y
        end    
        band_ele = 1;
        
    end                                                                 % Ayuda a dibujar eleemnto
elseif b_lib == 2
    if band_rej == 0    
        band_rej = 1;
    end
    Elemento
end     
function M1_Ele_Callback(hObject, eventdata, handles)           % Boton para dibujar elementos
b_frame_ClickedCallback(hObject, eventdata, handles);   % Llama funcion de dibujar elementos 
%------------------------ Boton Resticciones ------------------------------
function M1_Nodos_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
global band_poi axe_dibujo y band_ele band_rej vn_coor bot ve_obj
%----------------- Tipo de click ------------------------------
if strcmpi(get(handles.figure1,'selectiontype'),'open') == 1                % Click Doble
    bot = 4;
elseif strcmpi(get(handles.figure1,'selectiontype'),'alt') == 1             % Click Derecho
    bot = 3;
elseif strcmpi(get(handles.figure1,'selectiontype'),'extend')== 1           % Click scroll
    bot = 2;
elseif strcmpi(get(handles.figure1,'selectiontype'),'normal') == 1          % Click Izquierdo
    bot = 1;
end
%----------------- Limites Axes -------------------------------------------
xli = get(axe_dibujo,'xlim');
yli = get(axe_dibujo,'ylim'); yl = yli(1);
%------------------ Puntos ------------------------------------------------
if band_poi == 1 & y > yl                                                   % Si se dibuja puntos
    point_free(bot,axe_dibujo);                                             % Funcion para dibujar puntos en blanco
    set(axe_dibujo,'xlim',xli);set(axe_dibujo,'ylim',yli);                  % Hace ejes equivalentes
%------------------ Elementos Blanco --------------------------------------
elseif band_ele == 1 & y > yl                                               % Si se dibuja elemtnos en blanco
    element(bot,axe_dibujo);                                                % Funcion para dibujar elemntos en blanco
    set(axe_dibujo,'xlim',xli);set(axe_dibujo,'ylim',yli);                  % Hace ejes equivalentes
%------------------ Elementos Rejilla--------------------------------------
elseif band_rej == 1 & y > yl                                               % Si se dibuja elementos en rejilla
    elementr(bot,axe_dibujo);                                               % Funcion para dibujar elemntos en rejilla
    set(axe_dibujo,'xlim',xli);set(axe_dibujo,'ylim',yli);                  % Hace ejes equivalentes                                                                  % Hace ejes equivalentes
%------------------ Nodos Seleccionados------------------------------------
elseif isempty(vn_coor) == 0 %| isempty(ve_obj) == 0                        % Verifica si existe nodos
    selec_nod(bot,axe_dibujo);                                              % Funcion para seleccionar objetos
end
%--------------------------------------------------------------------------
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
global vn_coor axe_dibujo ban_nuevo band_ele band_poi
global x y ban_app ban_apl
global sub 
global n_nodo x1 y1 sub_e ln
global coor_h band_rej ban_tod sub_s 
global ban_selc x_selc y_selc rec_sel rec_dir
%--------------------------------------------------------------------------
ye = get(axe_dibujo,'ylim'); yl = ye(1); xl = get(axe_dibujo,'xlim');       % Limites de ejes
cp = get(axe_dibujo,'CurrentPoint'); x = cp(1,1); y = cp(1,2);              % Coordenadas del mouse en x y z                                                 % Coordenadas del mouse especifico x y 
%----------------------- COORDENADAS ZONA DE DIBUJO -----------------------
if ban_nuevo == 1 & y > yl
    t_cx=strcat('X: ',num2str(cp(1,1))); t_cy=strcat('Y: ',num2str(cp(1,2)));   % Texto de Coordenadas
    set(handles.t_coorx,'string',t_cx);                                     % Envia informacion a static text
    set(handles.t_coory,'string',t_cy);                                     % Envia informacion a static text
end
%--------------- Aproximacion a Puntos y Asignacion de Restricciones ------------------------------
if isempty(vn_coor) == 0 & band_poi == 1
    [ban_app,sub,c_ap] = aprox(vn_coor(:,2:3),x,y,axe_dibujo,0.01);         % Funcion aproximar 
    if ban_app == 1                                                         % Si la bandera de aproximacion esta activa
        set(handles.figure1,'pointer','circle');                            % Cambia puntero a circulo
        x = c_ap(1); y = c_ap(2);
    else
        set(handles.figure1,'pointer','arrow');                             % Cambia puntero a flecha
    end
%--------------- Dibujo de elementos ----------------------------
elseif band_ele == 1 | band_rej == 1                                        % Si se dibuja elementos
    if band_ele == 1
        [ban_apl,sub_e,c_ap] = aprox(vn_coor(:,2:3),x,y,axe_dibujo,0.01);   % Funcion aproximar elemtnos en blanco 
    else
        [ban_apl,sub_e,c_ap] = aprox(coor_h,x,y,axe_dibujo,0.01);           % Funcion aproximar elemntos en rejilla
    end
    if ban_apl == 1                                                         % Si la bandera de aproximacion esta activa
        set(handles.figure1,'pointer','circle');                            % Cambia puntero a circulo
    else
        set(handles.figure1,'pointer','arrow');                             % Cambia puntero a flecha
    end
    if n_nodo == 2                                      % Dibuja Linea guia                                                                           
        xdat = [x1,x];                                  % Da valores en x de la linea
        ydat = [y1,y];                                  % Da valores en y de la linea
        set(ln,'XData',xdat,'YData',ydat);              % Actualiza linea linea guia
        drawnow                                         % Moviliza la linea guias
    end    
elseif isempty(vn_coor) == 0
    [ban_tod,sub_s,c_ap] = aprox(vn_coor(:,2:3),x,y,axe_dibujo,0.005);      % Funcion aproximar 
    if ban_tod == 1                                                         % Si la bandera de aproximacion esta activa
        set(handles.figure1,'pointer','circle');                            % Cambia puntero a circulo
    else
        set(handles.figure1,'pointer','arrow');                             % Cambia puntero a flecha
    end
else
    set(handles.figure1,'pointer','arrow');                                 % Cambia puntero a flecha
end
%----------------- Creacion del cuadro Seleccionador ----------------------
if ban_selc == 1                        % Bandera de cuadro seleccionador
    if x > x_selc                       % Tipo de seleccion
        rec_dir = 1; col = 'r';         % Seleccionar Nodos
    else
        rec_dir = -1; col = 'b';        % Seleccionar elementos
    end 
    %axes(axe_dibujo);hold on;           % Llama axes de dibujo y sobrepone
    set(axe_dibujo,'xlim',xl);set(axe_dibujo,'ylim',ye);                                    % Hace ejes equivalentes
    set(rec_sel,'XData',[x_selc x_selc x x],'YData',[y_selc y y y_selc],'FaceColor',col);   % Grafica Rectangulo
    drawnow                             % actualiza rectangulo
end
%------------------ Asignacion de Restricciones ---------------------------
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
global ban_nuevo x y axe_dibujo
if ban_nuevo == 1
    xl = get(axe_dibujo,'xlim'); yl = get(axe_dibujo,'ylim');                               % Obtiene limites en axes
    Lx = (xl(2) - xl(1)); Ly = (yl(2) - yl(1));
    rel = Ly / Lx;
    Lxi = (x - xl(1)); Lyi = (y - yl(1));
    porc_xi = Lxi / Lx;porc_yi = Lyi / Ly;
    raz = 0.1;
    Ax = Lx * raz; Ay = Ax * rel;
    if eventdata.VerticalScrollCount < 0 
        xl = [xl(1)+(Ax*porc_xi) xl(2)-(Ax-Ax*porc_xi)]; 
        yl = [yl(1)+(Ay*porc_yi) yl(2)-(Ay-Ay*porc_yi)]; 
    elseif eventdata.VerticalScrollCount > 0 
        xl = [xl(1)-(Ax*porc_xi) xl(2)+(Ax-Ax*porc_xi)]; 
        yl = [yl(1)-(Ay*porc_yi) yl(2)+(Ay-Ay*porc_yi)]; 
    end
    set(axe_dibujo,'xlim',xl);set(axe_dibujo,'ylim',yl)
    zoom_rest();
    plano;                    % Sistema de coordenadas
end
%--------------------------------------------------------------------------
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
global c1 band_poi car_d tec con_key x y axe_dibujo tp_x tp_y band_ele band_rej
c = eventdata.Character; cod = double(c); tecla = eventdata.Key;
if band_poi == 1
    if isempty(cod) | cod == 27                                             % Presiono Esc o Tecla especial  
        tec = ''; con_key = 0; band_poi = 0; 
        set(handles.figure1,'visible','on');
        close(offset)
        set(tp_x,'visible','off');                                          % Hace visible text coord x
        set(tp_y,'visible','off');                                          % Hace visible text coord y
    elseif cod == 8                                                         % Si presiono Borrar  
        tec = ''; con_key = 0;                                              % Borro coordenada actual
    elseif find(car_d == cod)                                               % Si esta dentro de vector de numeros
        tec = strcat(tec,c);                                                % Concatena valor
    elseif cod == 44                                                        % Si preiono coma
        [v_key,s_key] = str2num(tec);                                       % Define coordenada en X
        if s_key == 1 & con_key == 0                                        % Si es un valor numerico
            c1 = v_key; con_key = 1;                                        % Guarda coordenada en X y cont = 1
        end
            tec = '';                                                       % Borra valor ingresado
    elseif cod == 13                                                        % Presiono ENTER
        [v_key,s_key] = str2num(tec);                                       % Transforma coordenada Y
        if s_key == 1                                                       % Analiza coordenada Y
            c2 = v_key; con_key = 0;
            x = c1; y = c2;            
            point_new(x,y,axe_dibujo); 
        else
            con_key = 1;
        end
        tec = '';
    end
    if cod == 13
        set(tp_x,'string','CX : ');                                          % Hace visible text coord x
        set(tp_y,'string','CY : ');                                          % Hace visible text coord y
    elseif con_key == 0
        set(tp_x,'string',strcat('CX : ',tec));                                          % Hace visible text coord x
    elseif  con_key == 1
        set(tp_x,'string',strcat('CX : ',num2str(c1)));                                          % Hace visible text coord x
        set(tp_y,'string',strcat('CY : ',tec));                                          % Hace visible text coord y
    end    
elseif band_ele == 1 | band_rej == 1
    if isempty(cod)== 0 & cod == 27
        salir_ele();
    end  
elseif band_poi == 0 | band_ele == 0 | band_rej == 0    % Deseleccionar y Borrar
    if isempty(cod)== 0 & cod == 27 % Deseleccionar
        desel();                                        % Borrar datos seleccionados
    elseif cod == 127               % Borrar elementos
        borrar_obj();
    end 
end     
%--------------------------------------------------------------------------
function figure1_ResizeFcn(hObject, eventdata, handles)
global ban_nuevo axe_dibujo
redime()
if ban_nuevo == 1                                                           % Si la zona dibujo esta activada modificada los ejes proporcionales
    %axes(axe_dibujo)                                                        % Llama al axes de dibujo
    centrar_axes(axe_dibujo,0.075);                                              % Funcion para centrar al axes
    axis equal                                                              % Genera ejes proporcionales
    plano;                    % Sistema de coordenadas
end
%--------------------------------------------------------------------------
function H_Correr_ClickedCallback(hObject, eventdata, handles)
global vn_coor vn_fx vn_fy vn_fg op_play mat_res
global ve_add ve_tem ve_w ve_pro vm_pro ve_conex vs_eti vs_pro ve_p ve_rot vn_const disc
global mat_nodos mat_propi mat_cargas vm_eti ve_rel op_rel op_non op_ffp op_eln 
global v_u ve_desf CONN2 v_R v_s vn_coor_o l_res r_der
v_u=[]; ve_desf=[]; CONN2=[]; vn_coor_o = vn_coor(:,[2 3]);
if op_play == 0 & isempty(ve_conex) == 0  
    op_play = 1;
    Reorganizar_Nodos();    % Reorganiza Codigo de nodos y elementos
    %--------------------- NODOS ----------------------------
    nodos = [vn_coor(:,1:6) vn_fx(:,2) vn_fy(:,2) vn_fg(:,2) vn_coor(:,7:9)]; % Nodos = [# x y rx ry rz fx fy fg dx dy dz)
    %--------------------- Elementos ---------------------------
    secc = [];                      % Vector de Secciones           
    mate = [];                      % Vector Materiales
    ve_desf = [];                   % Vector de desfase 
    bass = []; basss={};basm = [];basmm = {};
    for i = 1: size(ve_conex,1)
        if ve_conex(i,4)>0
        sec = ve_conex(i,4);                                % Saco codigo la seccion
        sub_s = find(cell2mat(vs_eti(:,1)) == sec);         % Busca subindice de la seccion
        mat = vs_eti{sub_s,6};                              % Saca material Vm_pro = [Codm ? E ? ? F ? ?]
        sub_m = find(vm_pro(:,1) == mat);                   % Busca subindice del material
        %find(vm_pro(:,1) == mat);                           % Busco subindice del material
        mate(i,:) = vm_pro(sub_m,2:end-2);                % Genero matriz de Materiales correpondientes a los elementos end+1
        if isempty(basm) == 1 | isempty(find(basm == sub_m)) == 1
            basm(end+1,:) = sub_m;
            basmm(end+1,:) = num2cell(vm_pro(sub_m,2:end-2)); 
            basmm{end,1} = vm_eti{sub_m,2};    
        end
        % Desfase [db de]
        [dbn,den]= desfas(i);                               % Analiza desfase ultimo y extrae desfase
        ve_desf(i,:) = [dbn,den];                           %end+1
        % Seccion secc = [h b A Ac I]
        if ve_rot(i,2) == 1
            vec_sec = [vs_pro(sub_s,2:3) vs_pro(sub_s,4:5).*ve_pro(i,2:3) vs_pro(sub_s,7)*ve_pro(i,5) vs_pro(sub_s,9)*ve_pro(i,7)];        
        else   
            vec_sec = [vs_pro(sub_s,3) vs_pro(sub_s,2) vs_pro(sub_s,4).*ve_pro(i,2) vs_pro(sub_s,6)*ve_pro(i,4) vs_pro(sub_s,8)*ve_pro(i,6) vs_pro(sub_s,10)*ve_pro(i,8)];
        end    
        secc(i,:) = vec_sec;        % Genero matriz de seccion correpondientes a los elementos end+1
        if isempty(bass) == 1 | isempty(find(bass == sub_s)) == 1
            bass(end+1) = sub_s;
            if vs_eti{sub_s,4}==1
                bas_n='Rectangular';
            elseif vs_eti{sub_s,4} == 2
                bas_n='Tipo I';
            else
                bas_n='Otras';
            end
            basss(end+1,:) = num2cell([0 0 vec_sec]);
            basss(end,1:2) = {vs_eti{sub_s,2} bas_n};
        end
        else
            k=cell2mat(l_res(-ve_conex(i,4),2));
            mate(i,2:5)=[k 0 0 0]; secc(i,1:6)=0; ve_desf(i,1:2)=0;
            ve_tem(i,2:3)=0; ve_w(:,2:7)=0; ve_p(i,2:10)=0; ve_add(i,2)=0;
        end
    end
    elem_pro = [ve_conex(:,1:3) mate(:,2) mate(:,4) secc(:,2) secc(:,1) ve_desf secc(:,4) mate(:,3) secc(:,5) secc(:,3) secc(:,6) mate(:,5)];     %elem_pro = [%elem NI NF E alpha b h db de Ac poisson I Area Z]
    elem_load =  [ve_tem(:,2:3) ve_w(:,5:7) ve_w(:,2:4) ve_p(:,2:10) ve_add(:,2)];                                                      %elem_load = [tinf tsup Wy Wy_a Wy_b Wx Wx_a Wx_b Wpx Wp_a Wp_b Wpy Wp_a Wp_b Wm Wm_a Wm_b Error]
    %----------------------------- Constraints ----------------------------
    constraints = [];
    if isempty(vn_const) == 0
        for i = 1:size(vn_const,1)
            if isempty(vn_const(i,2)) == 0
                master = vn_const{i,3};
                slaves = vn_const{i,4};
                gdl = vn_const{i,5};
                master = zeros(size(slaves,2),1) + master;
                gdl = zeros(size(slaves,2),3) + gdl;
                slaves = zeros(size(slaves,2),1) + slaves';
                constraints = [constraints;master slaves gdl]
            end    
        end
    end
    PorticosCOD2
    v_u=u; v_R=R; v_s=s;
    if disc == 1
        PorticosCOD
    end
    mat_res = {u s p R pele' fele' kl' kg' K Kpp Kps Ksp Kss basmm basss Fempg FEquiv F Up Fs};  % Despla/GDLS/GDLP/Reacciones/FEL/FEG/kEL/KEG/KGlobal/Kpp/Kps/Ksp/Kss 
%% --------------------- Derivas Analisis Lineal ----------------------
    r_der ={};      % resultados de derivas    
    desx = u((1:3:3*size(vn_coor,1)-2),1)';
    cx = unique(vn_coor(:,2));                              % Coordenadas en X unicas
    n_lx = size(cx,1); n_ly = size(unique(vn_coor(:,3)),1); % Numero de lineas en X/Y
    des1 = zeros(n_ly-1,n_lx); der1 = des1;             % Vector de desplazamientos / derivas
    for i = 1:n_lx                                      % Analisis por linea en X
        p_cy = find(vn_coor(:,2) == cx(i));             % Posicion de coordenadas Y por linea X
        [bas1 bas2] = unique(vn_coor(find(vn_coor(:,2) == cx(i)),3)); p_cy = p_cy(bas2);        % Posicion ordenada de los nodos analizados
        bas = abs(desx(1,p_cy(2:end))-desx(1,p_cy(1:end-1)));            % Desplazamientos por linea en Y
        des1(1:(size(p_cy,1)-1),i) = bas;
        der1(1:(size(p_cy,1)-1),i) = bas./(vn_coor(p_cy(2:end),3)-vn_coor(p_cy(1:end-1),3))';   % Derivas de Piso
    end 
    r_der = {[0 max(des1,[],2)'] [0 max(der1,[],2)']};              % Resultados desplaaminetos / derivas por falla
%% --------------------------------------------------------------------
    % Visualizacion
    op_eln = 0; etiele_act();   % Desaparece etiqueta de elementos
    op_rel = 0; rel_act();      % Desaparece Releases
    op_non = 0; etinodo_act();  % Etiqueta del nodo
    op_ffp = 0; vis_cargas();   % Eliminar Cargas
    H_Deformada_ClickedCallback(handles.H_Deformada, eventdata, handles)
    botones(2); 
 end

function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
global rec_sel rec_dir x_selc y_selc x y ban_selc
if ban_selc == 1                                % Revisa si bandera de cuadro seleccionador esta activado
    delete (rec_sel);                           % Borra rectangulo al soltar
    selec_rec(rec_dir,x_selc,y_selc,x,y);       % Funcion para seleccionar objetos 
    ban_selc = 0;                               % Desactiva bandera de cuadro seleccionador
end
%--------------------------------------------------------------------------
function axes1_ButtonDownFcn(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton4_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton5_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton6_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton7_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton8_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton9_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton10_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton11_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton12_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function pushbutton13_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function uipushtool33_ClickedCallback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Archivo_Callback(hObject, eventdata, handles)
menui = [handles.M1_Guardar handles.M1_Exportar];
global ve_conex
set(menui,'enable','on');       % Activa todos botones
if isempty(ve_conex) == 1       % Analiza la activacion de botones
    set(menui,'enable','off');  % Bloquea botones de menu 
end
%--------------------------------------------------------------------------
function M1_Editar_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Ver_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Definir_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Asignar_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Visualizar_Callback(hObject, eventdata, handles)
global op_play ve_rel
menui = [handles.M1_Deformada handles.M1_Diagramas handles.M1_Ani handles.M1_Cpu];  % Menu de botones
set(menui,'enable','on');               % Activa todos botones
if op_play == 2                         % Analisis Lineal
    set(menui([1 2]),'enable','off');   % Bloquea botones de menu 
elseif op_play == 1                     % Analisis No-Lineal
    set(menui([3 4]),'enable','off');   % Bloquea botones de menu 
end
tam = size(ve_rel,1); con = 0;          % Numero de elementos / contador de elemntos tipo portico
for i = 1:tam
    if isequal(ve_rel{i,2},[3 6]) == 1 
        con = con+1;                    % Contador de elementos tipo armadura
    end
end
if con/tam < 0.5
    set(handles.M1_Derivas,'enable','on');   % Bloquea botones de menu 
end
%--------------------------------------------------------------------------
function M1_Salir_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Deformada_Callback(hObject, eventdata, handles)
H_Deformada_ClickedCallback(handles.H_Deformada, eventdata, handles)        % Estructura deformada
%--------------------------------------------------------------------------
function M1_Diagramas_Callback(hObject, eventdata, handles)
Vizualizar_Fuerzas                                                          %Interfaz Vizualizar Fuerzas 
%--------------------------------------------------------------------------
function M1_Puntual_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Lineal_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Constr_Callback(hObject, eventdata, handles)
Definir_Constraints;                                                        % Interfaz Definir Constraints
%--------------------------------------------------------------------------
function M1_Combinaciones_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Vista2d_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Vista3d_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function M1_Documentacion_Callback(hObject, eventdata, handles) % Abrir Manual
open('Documentacion\Manual_UCAS2D.pdf');
%--------------------------------------------------------------------------
function M1_Acerca_Callback(hObject, eventdata, handles)        % Abrir UCAS2D
Acerca; % Informacion de UCAS2D
%--------------------------------------------------------------------------
function list_ang_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% -------------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
%------------ Modificar Propiedades de los Elementos ----------------------
function M1_modpro_Callback(hObject, eventdata, handles)
Asignar_Propiedades_Modificables_en_Elementos;
%-------------------- Asignar Releases ------------------------------------
function M1_rel_Callback(hObject, eventdata, handles)
Asignar_Releases;
%--------------------------------------------------------------------------
function M1_dis_Callback(hObject, eventdata, handles)
Asignar_Carga_Distribuida_Elemental
%--------------------------------------------------------------------------
function M1_tem_Callback(hObject, eventdata, handles)
Asignar_Carga_de_Temperatura_Elemental
%--------------------------------------------------------------------------
function M1_pun_Callback(hObject, eventdata, handles)
Asignar_Fuerzas_Puntuales
%--------------------------------------------------------------------------
function M1_des_Callback(hObject, eventdata, handles)
Asignar_Desplazamientos_Nodales
%--------------------------------------------------------------------------
function M1_desf_Callback(hObject, eventdata, handles)
Asignar_Desfase_en_Elementos
%--------------------------------------------------------------------------
function M1_error_Callback(hObject, eventdata, handles)
Asignar_Errores_de_Fabricacion
%--------------------------------------------------------------------------
function M1_asec_Callback(hObject, eventdata, handles)
Asignar_Secciones_en_Elementos;
%--------------------------------------------------------------------------
function M1_epun_Callback(hObject, eventdata, handles)
Asignar_Carga_Puntual_a_Elemento
%--------------------------------------------------------------------------
function M1_rot_Callback(hObject, eventdata, handles)
Rotar_Seccion
%--------------------------------------------------------------------------
function H_Ver_ClickedCallback(hObject, eventdata, handles)
Opciones_de_Visualizacion
% ----------------- Asignar Restricciones ---------------------------------
function M1_Restricciones_Callback(hObject, eventdata, handles)
global ve_obj
if isempty(ve_obj) == 0
    restricciones
end
% -------------- Asignar Constraints --------------------------------------
function M1_Constraints_Callback(hObject, eventdata, handles)
Asignar_Constraints;
% --------------------------------------------------------------------
function M1_Guardaras_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function M1_Importar_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function M1_Exportar_Callback(hObject, eventdata, handles) 
global op_play op_nolin
if op_play == 2 & op_nolin == 1
    set(handles.M1_Open,'enable','on');     % Activa boton cuando se corre analisis no lineal
else
    set(handles.M1_Open,'enable','off');     % Activa boton cuando se corre analisis no lineal
end
% --------------------------------------------------------------------
function M1_Ayuda_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function M1_Draw_Callback(hObject, eventdata, handles)
global b_lib
set(handles.M1_Nod,'enable','on');      % Activa boton de punto
if b_lib == 2                           % Analisis si existe Rejilla
    set(handles.M1_Nod,'enable','off'); % Activa boton de punto
end
% --------------------------------------------------------------------
function M1_Analisis_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function M1_lin_Callback(hObject, eventdata, handles)
H_Correr_ClickedCallback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function M1_nolin_Callback(hObject, eventdata, handles)
global op_play ve_obj op_nolin 
if op_play == 0 & isempty(ve_obj) == 0             % Opcion desbloquear 
    op_nolin = 2; Analisis_No_Lineal;     % Opcion no - lineal portico/ Abrir interfaz de No-Lineal
end
%% Desbloquear Modelo 
function H_Bloquear_ClickedCallback(hObject, eventdata, handles)    % Desbloque el modelo en analisis
global op_play op_nolin fle_nol ve_conex res_obj vn_coor_o txr
global vn_cop ve_obj graf_rotu vn_coor bot_point b_lib co_ro
if op_play == 1 | op_play == 2      % Verifica si el modelo estaba corriendo 
    if op_play == 2                 % Analisis No-Lineal
        if op_nolin == 1            % Analiza la opcion No-Lineal Armadura
            delete(fle_nol);fle_nol = [];   % Borra y vacia Flecha
            set(ve_obj(:,3),'Color','b');   % Carga elementos a color azul
            vn_coor(:,2:3) = vn_cop; zoom_rest();   % recupera coordenadas iniciales
            for i = 1:size(ve_conex,1)      % Carga estructura original
                set(ve_obj(i,3),'xdata',[vn_cop(ve_conex(i,2),1) vn_cop(ve_conex(i,3),1)],'ydata',[vn_cop(ve_conex(i,2),2) vn_cop(ve_conex(i,3),2)]);
            end 
        else                        % Analiza la opcion No-Lineal Portico
            delete(fle_nol);fle_nol = [];   % Borra y vacia Flecha
            if exist('graf_rotu')   % Borrar rotulas
                delete(graf_rotu); graf_rotu = [];  % Borra y vacia rotulas      
            end
            try delete(res_obj); delete(txr); end
            vn_coor(:,[2 3])=vn_coor_o;
            for i=1:size(ve_obj,1)
                ni = ve_conex(ve_obj(i,1),2); nf = ve_conex(ve_obj(i,1),3);
                set(ve_obj(i,3),'XData',[vn_coor(ni,2) vn_coor(nf,2)]);
            end
            zoom_rest();
            try;                % Elimina rotulas de pasos
                for i = 1:size(co_ro,1)
                    delete(co_ro(i,3)); 
                end
                co_ro = [];
            end;   % Eliminacion rotulas pasos
        end
    else
        H_Original_ClickedCallback(hObject, eventdata, handles)
    end
    op_play = 0;    % Bloquea estado de play
    botones(1);     % Bloquear botones
    if b_lib == 2
        set(bot_point,'enable','off');
    end
end

function M1_Guardar_Callback(hObject, eventdata, handles)
H_Guardar_ClickedCallback(hObject, eventdata, handles)
%--------------------------------------------------------------------
function b_abrir_Callback(hObject, eventdata, handles)      % Abrir nuevo proyecto
H_Abrir_ClickedCallback(hObject, eventdata, handles)
function M1_Abrir_Callback(hObject, eventdata, handles)     % Abrir nuevo proyecto
H_Abrir_ClickedCallback(hObject, eventdata, handles)    
%------------------------------------------------------------------------------------------
function figure1_CloseRequestFcn(hObject, eventdata, handles)   % Cerrar Interfaz UCAS2D
global op_abrir ve_conex    
crear_arc;                                                      % Funcion analizar cierre de modelo
if op_abrir == 1                                                % Opcion primero guardar Activada
    H_Guardar_ClickedCallback(hObject, eventdata, handles)      % Funcion Guardar
elseif op_abrir == 2 
    delete(hObject);
end
function M1_Pushover_Callback(hObject, eventdata, handles)  % Abre interfaz de Push over
Comportamiento;         % Guide de Comportamiento del Material
%Curvas_Elasto_Plasticas;                               
function M1_tab_Callback(hObject, eventdata, handles)       % Abre guide de tablas   
Tablas;               
function M1_Mem_Callback(hObject, eventdata, handles)       % Crea memoria de calculo
Memoria_Cal;    % Crea memoria de calculo
% --------------------------------------------------------------------
function H_Cargas_ClickedCallback(hObject, eventdata, handles)
Vizualizar_Fuerzas
% --------------------------------------------------------------------
function H_Original_ClickedCallback(hObject, eventdata, handles)
global axe_dibujo fill_m line_d punts plot_m tx reac vn_obj ve_obj op_res vn_coor vn_coor_o
axes(axe_dibujo); vn_coor(:,[2 3]) = vn_coor_o;
set(vn_obj(:,3),'MarkerEdgeColor','b','MarkerFaceColor','None');
set(ve_obj(:,3),'Color','b','Visible','On');
try delete(fill_m); delete(line_d); delete(punts); delete(plot_m); delete(tx); delete(reac); end
op_res=1; zoom_rest();
% --------------------------------------------------------------------
function H_Deformada_ClickedCallback(hObject, eventdata, handles)
global ve_conex vn_coor subpartes L axe_dibujo eq_D op_res  ve_rel long D_max
global fill_m line_d vn_obj ve_obj punts v_u CONN2 plot_m tx reac vn_coor_o Lo
try delete(fill_m); delete(line_d); delete(punts); delete(plot_m); delete(tx); delete(reac); end
line_d=[]; punts=[]; vn_coor(:,[2 3]) = vn_coor_o;
escd = max(long)/5; %escala deformada
for i=1:size(vn_coor,1)
    v_pd(i,:)=[vn_coor(i,2)+v_u(3*i-2)/max(abs(D_max))*escd;...
        vn_coor(i,3)+v_u(3*i-1)/max(abs(D_max))*escd;];           %vector de puntos desplazados
end
set(vn_obj(:,3),'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor','None');
set(ve_obj(:,3),'Color',[0.5 0.5 0.5]);
releases= ve_rel(:,2);
punts=[punts scatter(v_pd(:,1),v_pd(:,2),'b','filled')];
vn_coor(:,[2 3]) = v_pd;
for elem=1:size(ve_conex,1)
    o_elem=findobj(axe_dibujo,'DisplayName',num2str(elem));
    NI=find(ve_conex(elem,2)==vn_coor(:,1));
    NF=find(ve_conex(elem,3)==vn_coor(:,1));
    ang(elem)=atan2((vn_coor_o(NF,2)-vn_coor_o(NI,2)),(vn_coor_o(NF,1)-vn_coor_o(NI,1)));
    x_dat=get(o_elem,'XData'); y_dat=get(o_elem,'YData');
    xi=x_dat(1); yi=y_dat(1);
    try releases{elem}(1); catch releases{elem}(1)=0; end
    if releases{elem}==[3 6] %def en armaduras
        line_d=[line_d plot([vn_coor(NI,2) vn_coor(NF,2)],[vn_coor(NI,3) vn_coor(NF,3)],...
            'b','LineWidth',2)];
        set(line_d(end),'DisplayName',num2str(elem));
        set(line_d(end),'ButtonDownFcn','selec_ele(gco)');    
    else %def en porticos
    xdist=0;
    for j=1:size(subpartes{elem},2)
        e_f=subpartes{elem}(j);
        u_axi=0; u_axf=0; 
        u_ayi=polyval(eq_D{elem}{j},0); 
        u_ayf=polyval(eq_D{elem}{j},Lo(e_f));
        if j==1 %inicio
            if ang(elem)==pi/2 
                u_axi=v_u(CONN2(e_f,2)*3-1);
                u_ayi=-v_u(CONN2(e_f,2)*3-2); %x0r pos -> y0 neg
            else
                u_axi=v_u(CONN2(e_f,2)*3-2);
                u_ayi=v_u(CONN2(e_f,2)*3-1);
            end
        end
        if j==size(subpartes{elem},2) %fin
            if ang(elem)==pi/2 
                u_axf=v_u(CONN2(e_f,3)*3-1);
                u_ayf=-v_u(CONN2(e_f,3)*3-2); %x0r pos -> y0 neg
            else
                u_axf=v_u(CONN2(e_f,3)*3-2);
                u_ayf=v_u(CONN2(e_f,3)*3-1);
            end
        end
        x0=[0:Lo(e_f)/25:Lo(e_f) Lo(e_f)];
        y0=[u_ayi polyval(eq_D{elem}{j},x0(2:end-1)) u_ayf]; 
        if max(abs(D_max))~=0
        u_axi=u_axi/max(abs(D_max))*escd; u_axf=u_axf/max(abs(D_max))*escd; %*escd factor escala
        x0=[u_axi:(Lo(e_f)+u_axf-u_axi)/25:Lo(e_f)+u_axf Lo(e_f)+(u_axf)]+xdist;
        y0=y0/max(abs(D_max))*escd; %*escd factor escala
        end
        x0r=x0*cos(ang(elem))-y0*sin(ang(elem));
        y0r=x0*sin(ang(elem))+y0*cos(ang(elem));
        xd=x0r+xi; yd=y0r+yi;
        line_d=[line_d plot(xd,yd,'b','LineWidth',2)];
        set(line_d(end),'DisplayName',num2str(elem));
        set(line_d(end),'ButtonDownFcn','selec_ele(gco)');    
        xdist=xdist+Lo(e_f);
    end
    end
end
op_res=1; zoom_rest();
  
% --------------------------------------------------------------------
function M1_Ani_Callback(hObject, eventdata, handles)
global op_nolin op_meto
if op_meto == 1
    if op_nolin==1
        Animacion;  % Abre interfaz de animacion no-lineal
    elseif op_nolin==2
        Animacion_Pus;
    end
elseif op_meto == 2
    Animacion_Pasos;    % Animacion No Lineal por pasos
end
% --------------------------------------------------------------------
function M1_Cpu_Callback(hObject, eventdata, handles)
global op_nolin op_meto
if op_meto == 1
    if op_nolin==1
        Grafica_Pushover_Armaduras;
    elseif op_nolin==2
        Grafica_Pushover_Porticos;
    end    
elseif op_meto == 2
    Grafica_Pushover_Pasos;    % Grafica Pushover por pasos
end

function H_Guardar_ClickedCallback(hObject, eventdata, handles)
%% Funcion para Guardar Datos
global ve_conex                                                             % Variable tabla de conexion
if isempty(ve_conex) == 0                                                   % Analiza si existe elementos
    global vm_eti vm_pro con_mat vs_eti vs_geo vs_pro con_sec               % Variables de Materiales/Secciones
    global vn_coor vn_fx vn_fy vn_fg vn_const con_const con_nod             % Variable nodos
    global ve_add ve_tem ve_w ve_p ve_rel ve_pro ve_des ve_rot con_ele      % Variable elementos
    global ve_rotu con_rotu vr_pro mag_text
    try                                                                    % Tratar
        [archivo,direccion] = uiputfile('.mat','Guardar Modelo'); 
        full = fullfile(direccion,archivo);                                     % Guarda archivo y direccion
        save(full,'ve_conex','vm_eti','vm_pro','con_mat','vs_eti','vs_geo',...
            'vs_pro','con_sec','vn_coor','vn_fx','vn_fy','vn_fg','vn_const',...
            'con_const','con_nod','ve_add','ve_tem','ve_w','ve_p','ve_rel',...
            've_pro','ve_des','ve_rot','con_ele','ve_rotu','con_rotu','vr_pro','mag_text');
    end
end
function H_Abrir_ClickedCallback(hObject, eventdata, handles)
%% Analisis de Abrir Modelo Existente
global ve_conex
op_abrir = 0; crear_arc;                                                      % Funcion analizar cierre de modelo
if op_abrir == 1                                                % Opcion primero guardar Activada
    H_Guardar_ClickedCallback(hObject, eventdata, handles)      % Funcion Guardar
    op_abrir =2;                                                % Funcion Abrir activada
end
%% Prepara para Abrir Modelo Existente
if op_abrir == 2                                                    % Abrir aarchivo
    global vm_eti vm_pro con_mat                                        % Variables de Materiales
    global vs_eti vs_geo vs_pro con_sec                                 % Variables de Seccion
    global vn_coor vn_fx vn_fy vn_fg vn_const con_const con_nod         % Variable nodos
    global ve_add ve_tem ve_w ve_p ve_rel ve_pro ve_des ve_rot con_ele  % Variable elementos
    global vn_obj col_p simb_p pan_dibujo mag_text
    global ve_obj col_l simb_l esp p_uax
    global axe_dibujo bot_mat bot_sec 
    global band_poi band_ele ban_nuevo ban_app
    global tec con_key tp_x tp_y n_nodo b_lib band_rej coor_h nod_sel ele_sel ban_sec
    global op_col op_rel v_visu op_res op_non op_eln op_ffp v_distri est_ani fle_nol
    try
%% Preparara Espacio de Trabajo
        [archivo,direccion] = uigetfile('*.mat','Abrir Modelo');    % Abre directorio 
        full = fullfile(direccion,archivo);load(full);  % Carga Modelo Existente
        set(handles.p_inicio1,'Visible','off');         % Desaparaece Panel 1
        set(handles.p_inicio2,'Visible','off');         % Desaparaece Panel 2
        set(pan_dibujo,'Visible','on');                 % Aparece axes
        cla(axe_dibujo,'reset'); axis equal;            % Elimina todos los objetos en axes / Ejes Iguales
        set(axe_dibujo,'XTick',[],'YTick',[]);          % Elimina ejes
        set(tp_x,'string','CX : ');set(tp_y,'string','CY : ');                      % Hace visible text coord X y Y
%% Banderas de Inicio 
        band_poi = 0;band_ele = 0;band_rej = 0;ban_app =0;tec = '';con_key = 0;n_nodo = 1;      % Bandera para dibujar puntos/elementos/rejilla/ban_aproximacion/teclado 
        b_lib = 1;coor_h = [];nod_sel = [];ele_sel = [];ban_sec = 0;                            % Si es dibujo libre/vector de seleccion nodos/elementos/bandera anadir seccion
%% Banderas de Visualizacion 
        op_col = 1; v_visu = [0 0 0 0 0 0 0 0]; v_distri = []; op_rel = 0;         % Opcion de Releases por defecto desactivado
        op_res = 1; op_non = 0; op_eln = 0; op_ffp = 0; est_ani = []; fle_nol = [];       % Flecha No-Lineal                            % Por defecto no aparece flechas de cargas nodales
        %% ----------------------------------------------------  
        ban_nuevo = 1;                                                              % Bandera de modelo abierto
        % --------------------- NODOS ----------------------------
        vn_obj = [];col_p = 'b'; simb_p = 'o';                                                  % Color del nodo y Simbolo del nodo
        vn_obj = [vn_coor(:,1) (1:1:size(vn_coor,1))'];                             % Genera vector de objetos
        axes(axe_dibujo)
        hold on
        for i = 1:size(vn_coor,1)                                                   % Recorre nodos para graficar
            vn_obj(i,3) = scatter(vn_coor(i,2),vn_coor(i,3),50,'filled',...
                col_p,'marker',simb_p,'MarkerEdgeColor',col_p);                     % Grafica de Nodos
        end
        %--------------------------------- Elementos ------------------------------
        ve_obj = [];col_l = 'b'; simb_l = '-'; esp = 2.5;                           % Color - Simbolo y grosor de linea
        ve_obj = [ve_conex(:,1) (1:1:size(ve_conex,1))'];                           % Genera vector de nodos
        for i = 1:size(ve_conex,1)                                                  % BUSQUEDA DE NODO FINAL E INICIAL PARA ELEMENTOS
            NI = find(vn_coor(:,1)== ve_conex(i,2));                                % ENCUENTRA LA POSICION DEL NODO INICIAL
            NJ = find(vn_coor(:,1)== ve_conex(i,3));                                % ENCUENTRA LA POSICION DEL NODO FINAL
            ve_obj(i,3) = line([vn_coor(NI,2) vn_coor(NJ,2)],[vn_coor(NI,3) ...
                vn_coor(NJ,3)],'LineWidth',esp,'LineStyle',simb_l,'Color',col_l);   % Grafico de elementos
            set(ve_obj(i,3),'DisplayName',num2str(ve_conex(i,1)));
            set(ve_obj(i,3),'ButtonDownFcn','selec_ele(gco)');
        end
        centrar_axes(axe_dibujo,0.075);                                             % Funcion para centrar al axes
        axis equal                                                                  % Hace eje proporcionales
        zoom_rest();                                                                % Grafica Restricciones
        %---------------------- Bloqueo de botones --------------------------------
        set(p_uax,'value',mag_text{4});             % Cargar unidades
        set(axe_dibujo,'XTick',[],'YTick',[]); 
        botones(1);
        etiele_act();                                                               % Funcion para crear etiqueta de elementos 
        vis_cargas();                                                               % Funcion para crear cargas
        plano;      % Visualiza Plano de coordenadas %set(p_uax,'value',mag_text{4});             % Cargar unidades
    end
end    
%% ---------------------------- NO PROGRAMADA -----------------------------

function p_unia_Callback(hObject, eventdata, handles)
% hObject    handle to p_unia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p_unia contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p_unia


% --- Executes during object creation, after setting all properties.
function p_unia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_unia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M1_Info_Callback(hObject, eventdata, handles)
H_Ver_ClickedCallback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function M1_SAP_Callback(hObject, eventdata, handles)  % Exportar a SAP2000
SAP2000();
% --------------------------------------------------------------------
function M1_Open_Callback(hObject, eventdata, handles) % Exportar a OpenSees
OpenSees();

function b_ea1_Callback(hObject, eventdata, handles)    % Ejemplo A1
op_ej = 1;
abrir_ex;

function b_ea2_Callback(hObject, eventdata, handles)    % Ejemplo A2
op_ej = 2;
abrir_ex;

function b_ep1_Callback(hObject, eventdata, handles)    % Ejemplo P1
op_ej = 3;
abrir_ex;

function b_ep2_Callback(hObject, eventdata, handles)    % Ejemplo P2
op_ej = 4;
abrir_ex;

function t_v1_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_1.mp4');catch;implay('Videos\Video_1.mp4');end;   % Video 1

function t_v2_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_2.mp4');catch;implay('Videos\Video_2.mp4');end;   % Video 2

function t_v3_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_3.mp4');catch;implay('Videos\Video_3.mp4');end;   % Video 3

function t_v4_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_4.mp4');catch;implay('Videos\Video_4.mp4');end;   % Video 4

function t_v5_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_5.mp4');catch;implay('Videos\Video_5.mp4');end;   % Video 5

function t_v6_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_6.mp4');catch;implay('Videos\Video_6.mp4');end;   % Video 6

function t_v7_ButtonDownFcn(hObject, eventdata, handles)
try;winopen('Videos\Video_7.mp4');catch;implay('Videos\Video_7.mp4');end;   % Video 7

function t_v8_ButtonDownFcn(hObject, eventdata, handles)

function t_v9_ButtonDownFcn(hObject, eventdata, handles)
% --------------------------------------------------------------------
function M1_Vid_Callback(hObject, eventdata, handles)
Videos_Tutoriales;          % Abre interfaz de videos


% --------------------------------------------------------------------
function M1_Resortes_Callback(hObject, eventdata, handles)
Resortes;


% --------------------------------------------------------------------
function M1_AResor_Callback(hObject, eventdata, handles)
Asignar_Resortes;


% --------------------------------------------------------------------
function M1_Derivas_Callback(hObject, eventdata, handles)
Deriva;     % Guide de derivas
