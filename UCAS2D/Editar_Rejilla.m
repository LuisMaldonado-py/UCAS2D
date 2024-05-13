function varargout = Editar_Rejilla(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Editar_Rejilla_OpeningFcn, ...
                   'gui_OutputFcn',  @Editar_Rejilla_OutputFcn, ...
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

function Editar_Rejilla_OpeningFcn(hObject, eventdata, handles, varargin)
global v_er op_despla cx_ini  cy_ini                                
cx_ini = 0;                                                         % Coordenada en X inicial = 0
cy_ini = 0;                                                         % Coordenada en y inicial = 0
if v_er(1) == 1 | v_er(1) == 3                                      % Opcion Rejilla / Portico 
    v_erejx = [(1:1:v_er(3)+1)' (0:v_er(6):v_er(3)*v_er(6))'];      % Coordenadas de rejilla en X
    if v_er(1) == 3                                                 % Portico  v_er = [tip npisos nvanos hpiso1 hpison bvano]
        v_erejy = [1 0;2 v_er(4)];                                  % Coordenadas de rejilla en Y para 1 piso portico
        if v_er(2) ~= 1                                             % Rejilla % val_er = [tip ny nx cx by bx res cy]
            v_erejy = [v_erejy ;(3:1:v_er(2)+1)' ((v_er(5)...       % Coordenadas de rejilla en Y para multiples pisos portico 
                :v_er(5):(v_er(2)-1)*v_er(5))'+v_er(4))];                                
        end
    else
        cx_ini = v_er(4); cy_ini = v_er(8);                             % Coordenada en X inicial y Y inicial = 0
        v_erejx(:,2) = v_erejx(:,2) + cx_ini;                           % Coordenadas en X
        v_erejy = [(1:1:v_er(2)+1)' ...
            (0:v_er(5):v_er(2)*v_er(5))'+ cy_ini];                      % Coordenadas en Y
    end
    set(handles.u_elem,'Data',v_erejy);                                 % Carga datos en Y
elseif v_er(1) == 2                                                     % Opcion Viga
    set(findall(handles.pan_y,'-property','enable'),'enable','off');    % Carga valores de viga en X
    v_erejx = [(1:1:v_er(2)+1)' (0:v_er(3):v_er(2)*v_er(3))'];          % Coordenadas de rejilla en X
    set(handles.u_elem,'Columnname',{'';''});  % Carga nombre de las columnas tabla Y 
end
set(handles.u_coor,'Data',v_erejx);                                     % Carga datos en X
%----------------------------- VARIABLE DE OPCIONES -------------------
op_despla = 1;                                                          % Comenzar con desplazmineto por coordenadas
handles.output = hObject;
guidata(hObject, handles);

function varargout = Editar_Rejilla_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
global op_despla cx_ini cy_ini axe_dibujo pan_dibujo ban_nuevo 
global v_er con_nod b_lib coor_h bot_point
tab_coor = [];
n = 1;                                           % Para portico o reja solo X
botones(1); 
if v_er(1) == 1 | v_er(1) == 3                                 % Opcion viga 
	n = 2;
end
if op_despla == 2
    a = handles.u_coor;b = cx_ini;               % Variabke de tabla y coordenada inicial para cada tabla X O Y
    for j = 1:n                                  % For para transformacion de variables
        tab = get(a,'Data');                     % Obtengo tabla en x
        tanex = [b];                             % Primeras coordenadas
        for i = 1:size(tab,1)                    % For para formar coordenadas
            tanex(end+1) = tab(i,2)+tanex(end);  % Anexa coordenadas
        end
        tab_coor{j} = tanex'                     % Carga Coordenadas
        a = handles.u_elem;b = cy_ini;           % Variable de tabla y coordenada inicial para cada tabla X O Y            
    end
else
    tab = get(handles.u_coor,'Data'); tab_coor{1}=tab(:,2);
    if v_er(1) ~= 2
        tab = get(handles.u_elem,'Data'); tab_coor{2}=tab(:,2);
    end
end
if v_er(1) == 2 %------------------------------- VIGA ---------------------
    nv = size(tab_coor{1},1);                   % Nuemero de vanos
    coor= [cell2mat(tab_coor) zeros(nv,1)];     % Tabla de coordenadas
    conex = [(1:1:nv-1)' (2:1:nv)'];            % Tabla de conexion
    close(Editar_Rejilla);                      % Cierra interfaz actual
    close(Viga);                                % Cierra interfaz de viga
elseif v_er(1) == 1 | v_er(1) == 3 %--------------------------- PORTICO ------------------
    coor = [];elem_h = []; elem_v = [];                                 % Crea vectores para modificar
    x = tab_coor{1}; y = tab_coor{2};np = size(y,1);nv = size(x,1);     % Vectores ordenadas en X y Y y su tama;o
    for i = 1:np
        coor = [coor;x ones(nv,1)*y(i)];                % Crea vector de coordenadas
        if i > 1 & v_er(1) == 3                                       % Para eliminar planta baja
                elem = ((nv*(i-1))+1 : 1 : (nv*i)-1);       % Conexion de elementos horizontales nodo inicial
                elem_h = [elem_h ; [elem' (elem+1)']];      % Conexion de elementos horizontales nodo inicial + nodo final
        elseif v_er(1) == 1
            elem = ((nv*(i-1))+1 : 1 : (nv*i)-1);       % Conexion de elementos horizontales nodo inicial
            elem_h = [elem_h ; [elem' (elem+1)']];      % Conexion de elementos horizontales nodo inicial + nodo final
        end
        if i ~= np                                      % Ultimo pisos
            elem = (1+(nv*(i-1)): 1 : nv*i);            % Conexion de elementos vertical nodo inicial
            elem_v = [elem_v ; [elem' (elem+nv)']];     % anexa a vector final
        end
    end
    conex = [elem_h ; elem_v];                  % Tabla de conexion
    close(Editar_Rejilla);                      % Cierra interfaz actual
    if v_er(1) == 3
        close(Portico);                             % Cierra interfaz de porticos
    else                %--------------------------- REJILLA ------------------
        close(Rejilla); set(bot_point,'enable','off');  % Desactiva botones
    end
end
ban_nuevo = 1;                              % Bandera de nuevo modelo
set(axe_dibujo,'XTick',[],'YTick',[]);      % Eliminar ejes en axes
set(pan_dibujo,'Visible','on');             % Aparece panel de dibujo
%------------------ Dibuja Nodos / Elementos
if v_er(1) == 2 | v_er(1) == 3 
    point_newfast(coor)
    element_newfast(conex,2); 
    b_lib = 1;                      % Activa botones de dibujo
else
    col_p = [0.4 0.4 0.4]; col_l = [0.8 0.8 0.8];                               % Datos de Color de punto y linea 
    simb_p = '*'; simb_l = '--'; esp = 1.5; 
    coor =[(1 : 1 : size(coor,1))' coor]; conex = [(1:1:size(conex,1))' conex]; 	% Tablas + id
    axes(axe_dibujo); hold on;                      % Uso actual de axes de dibujo
    scatter(coor(:,2),coor(:,3),simb_p,'MarkerEdgeColor',col_p);                % Grafica Nodos
    for i = 1:size(conex,1)                                                     % BUSQUEDA DE NODO FINAL E INICIAL PARA ELEMENTOS                     
        NI = find(conex(i,2)==coor(:,1));                                       % ENCUENTRA LA POSICION DEL NODO INICIAL
        NJ = find(conex(i,3)==coor(:,1));                                       % ENCUENTRA LA POSICION DEL NODO FINAL
    %GRAFICO DE ELEMENTOS
        line([coor(NI,2) coor(NJ,2)],[coor(NI,3) coor(NJ,3)],'LineWidth',esp,'LineStyle',simb_l,'Color',col_l);  % Grafico de linea   
    end
    coor_h = coor(1:end,2:3);                                                   % Vector de coordenadas de la rejilla
    b_lib = 2;                                                                  % Dibujo rejilla    
end
%-------------------------------------------
centrar_axes(axe_dibujo,0.075);             % Funcion para centrar al axes
axis equal                                  % Sobreposicion de elementos  
if v_er(1) == 3 & v_er(7) == 1 
    mod_rest((1:1:nv),[1 1 0],[]);             % Funcion para modificar nodo                                                                % Hace eje proporcionales
elseif v_er(1) == 2 & v_er(4) == 1
    mod_rest(1,[1 1 0],[]);mod_rest((2:1:nv),[0 1 0],[]);    % Funcion para modificar nodo
end
plano;      % Visualiza Plano de coordenadas

function checkbox2_Callback(hObject, eventdata, handles)    % Modifica desplazamineto por coordenadas o espaciamiento
global op_despla cx_ini cy_ini v_er
set(handles.checkbox2,'value',1);                           % Activa desplazamiento por coordenadas
set(handles.checkbox3,'value',0);                           % Desactiva desplazamiento por longitud
if op_despla ~= 1                                           % Si se realiza cambio
    op_despla = 1; a = handles.u_coor; b = cx_ini; n = 1;   % Opcion Coordenadas/ Lectura de tabla/ Coordenada inicial/ Tipo de estrucutra portico o viga 
    set(handles.u_coor,'Columnname',{'Rejilla Id';'Coordenada X'});  % Carga nombre de las columnas tabla X
    n = 1;                                                  % Para portico o reja solo X
    if v_er(1) == 1 | v_er(1) == 3                                         % Opcion viga 
        n = 2;
        set(handles.u_elem,'Columnname',{'Rejilla Id';'Coordenada Y'});  % Carga nombre de las columnas tabla Y 
    end
    for j = 1:n                                             % For para transformacion de variables
        tab = get(a,'Data');                                % Obtengo tabla en x
        tanex = [1 b];                                      % Primeras coordenadas
        for i = 1:size(tab,1)                               % For para formar coordenadas
            tanex(end+1,:) = [i+1 tab(i,2)+tanex(end,2)];   % Anexa coordenadas
        end
        set(a,'Data',tanex);                                % Carga Coordenadas
        a = handles.u_elem;b = cy_ini;                      % Variable de tabla y coordenada inicial para cada tabla X O Y            
    end
end

function checkbox3_Callback(hObject, eventdata, handles)    % Modifica desplazamineto por coordenadas o espaciamiento   
global op_despla v_er
set(handles.checkbox2,'value',0);                               % Activa desplazamiento por longitud
set(handles.checkbox3,'value',1);                               % Desactiva desplazamiento por coordenadas
if op_despla ~= 2                                               % Si se realiza cambio
    op_despla = 2;                                              % Cambia opcion por longitud
    a = handles.u_coor;                                         % Variable de tabla X O Y            
    set(handles.u_coor,'Columnname',{'Rejilla Id';'Espaciado X'});  % Carga nombre de las columnas tabla X
    n = 1;                                                  % Para portico o reja solo X
    if v_er(1) == 1 | v_er(1) == 3                                         % Opcion viga 
        n = 2;
        set(handles.u_elem,'Columnname',{'Rejilla Id';'Espaciado Y'});  % Carga nombre de las columnas tabla Y 
    end
    for j = 1:n                                                 % For para cada tabla
        tab = get(a,'Data');                                    % Obtengo tabla en x
        tab = [tab(1:end-1,1) tab(2:end,2)-tab(1:end-1,2)];     % Calcula desplaxamiento
        set(a,'Data',tab);                                      % Carga desplazamineto 
        a = handles.u_elem;                                     % Cambio de tabla
    end
end
%**************************************************************************
function p_cancelm_Callback(hObject, eventdata, handles) % Cierra guide de editar rejilla
close(Editar_Rejilla); 

function b_acoor_Callback(hObject, eventdata, handles)  % Agregar fila en tabla X
tab=get(handles.u_coor,'data');                         % Obtiene tabla de datos
tab = [tab ; [tab(end,1)+1 tab(end,end)*1.5]];          % Anexa nueva fila
set(handles.u_coor,'Data',tab);                         % Carga nueva fila

function b_ecoor_Callback(hObject, eventdata, handles)  % Elimina fila en tabla X
tab=get(handles.u_coor,'data');                         % Obtiene tabla
set(handles.u_coor,'Data',tab(1:size(tab,1)-1,:));      % Elimina fila y carga nueva tabla

function b_aelem_Callback(hObject, eventdata, handles)  % Agregar fila en tabla Y
tab=get(handles.u_elem,'data');                         % Obtiene tabla de datos
tab = [tab ; [tab(end,1)+1 tab(end,end)*1.5]];          % Anexa nueva fila
set(handles.u_elem,'Data',tab);                         % Carga nueva fila

function b_eelem_Callback(hObject, eventdata, handles)  % Elimina fila en tabla Y
tab=get(handles.u_elem,'data');                         % Obtiene tabla
set(handles.u_elem,'Data',tab(1:size(tab,1)-1,:));      % Elimina fila y carga nueva tabla

function u_coor_CellEditCallback(hObject, eventdata, handles)  % Obtiene valores de transformacion en tipo de desplazamiento
global cx_ini op_despla
if op_despla == 1                                       % Analiza si despla es por coordenadas
    tab = get(handles.u_coor,'Data');                   % obtiene primer coordenada
    if isnan(tab(1,2)) == 0                             % Evita error del NaN
        cx_ini = tab(1,2);                              % Guarda nueva coordenada inicial        
    else    
        tab(1,2) = cx_ini;                              % Carga valor 0 en primer coordenada, si ocurre error 
        set(handles.u_coor,'Data',tab);                 % Carga valores en tabla
    end
end

function u_elem_CellEditCallback(hObject, eventdata, handles)
global cy_ini op_despla
if op_despla == 1                           % Analiza si despla es por coordenadas
    tab = get(handles.u_elem,'Data');       % obtiene primer coordenada
    if isnan(tab(1,2)) == 0                 % evita error del NaN
        cy_ini = tab(1,2);                  % Guarda nueva coordenada inicial        
    else    
        tab(1,2) = cy_ini;                  % Carga valor 0 en primer coordenada, si ocurre error 
        set(handles.u_elem,'Data',tab);     % Carga valores en tabla
    end
end
%----------------------------- NO PROGRAMADA ------------------------------
function t_nc_Callback(hObject, eventdata, handles)
function t_nc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function t_ne_Callback(hObject, eventdata, handles)
function t_ne_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton9_Callback(hObject, eventdata, handles)
function pushbutton10_Callback(hObject, eventdata, handles)
