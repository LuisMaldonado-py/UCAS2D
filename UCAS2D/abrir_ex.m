global ve_conex vm_eti vm_pro con_mat                                        % Variables de Materiales
global vs_eti vs_geo vs_pro con_sec                                 % Variables de Seccion
global vn_coor vn_fx vn_fy vn_fg vn_const con_const con_nod         % Variable nodos
global ve_add ve_tem ve_w ve_p ve_rel ve_pro ve_des ve_rot con_ele  % Variable elementos
global vn_obj col_p simb_p pan_dibujo mag_text
global ve_obj col_l simb_l esp p_uax
global axe_dibujo bot_mat bot_sec 
global band_poi band_ele ban_nuevo ban_app
global tec con_key tp_x tp_y n_nodo b_lib band_rej coor_h nod_sel ele_sel ban_sec
global op_col op_rel v_visu op_res op_non op_eln op_ffp v_distri est_ani fle_nol
%% Preparara Espacio de Trabajo
%[archivo,direccion] = uigetfile('*.mat','Abrir Modelo');    % Abre directorio 
%full = fullfile(direccion,archivo);
if op_ej == 1
    modelo = 'Ejemplos\Ejemplo_A1.mat'; % Modelo Analisis Lineal de Armaduras Ejemplo A1 
elseif op_ej == 2
    modelo = 'Ejemplos\Ejemplo_A2.mat'; % Modelo Analisis Lineal de Armaduras Ejemplo A2 
elseif op_ej == 3
    modelo = 'Ejemplos\Ejemplo_P1.mat'; % Modelo Analisis Lineal de Armaduras Ejemplo P1 
elseif op_ej == 4
    modelo = 'Ejemplos\Ejemplo_P2.mat'; % Modelo Analisis Lineal de Armaduras Ejemplo P2 
end
load(modelo);  % Carga Modelo Existente
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