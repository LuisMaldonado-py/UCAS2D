function varargout = Manual(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Manual_OpeningFcn, ...
                   'gui_OutputFcn',  @Manual_OutputFcn, ...
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

function Manual_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = Manual_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_acoor_Callback(hObject, eventdata, handles)  % AGREGAR FILAS
tabcoor = get(handles.u_coor,'data');   % Obtiene valores actuales de la tabla
set(handles.u_coor,'Data',[tabcoor;{char char}]);   % Agrega fila y carga tabla

function b_ecoor_Callback(hObject, eventdata, handles)  % ELIMINAR FILAS
tabcoor = get(handles.u_coor,'data');   % Obtiene valores actuales de la tabla
set(handles.u_coor,'Data',tabcoor(1:size(tabcoor,1)-1,:));      % Elimina fila y carga tabla

function b_aelem_Callback(hObject, eventdata, handles)  % AGREGAR FILAS
tabcoor = get(handles.u_elem,'data');   % Obtiene valores actuales de la tabla
set(handles.u_elem,'Data',[tabcoor;{char char}]);   % Agrega fila y carga tabla

function b_eelem_Callback(hObject, eventdata, handles)  % ELIMINAR FILAS
tabcoor = get(handles.u_elem,'data');   % Obtiene valores actuales de la tabla
set(handles.u_elem,'Data',tabcoor(1:size(tabcoor,1)-1,:));      % Elimina fila y carga tabla

function b_okmanual_Callback(hObject, eventdata, handles)
global pan_dibujo axe_dibujo vs_geo ban_nuevo b_lib
try
    ban_nuevo = 1;                                                              % Bandera de nuevo modelo
    set(axe_dibujo,'XTick',[],'YTick',[]);                                      % Eliminar ejes en axes
    set(pan_dibujo,'Visible','on');                                             % Aparece panel de dibujo
    %% Obtencion de Datos
    t_n = str2double(get(handles.u_coor,'data')); t_n = [(1:1:size(t_n,1))' t_n];    % Captura tabla de nodos
    t_c = str2double(get(handles.u_elem,'data'));                                   % Captura tabla de conectividad
    %% Filtro 1 --> Eliminar Filas Vacias
    basn = find(isnan(t_n(:,2)) == 1 | isnan(t_n(:,3)) == 1); t_n(basn,:) = [];     % Elimina filas vacias tab nodos
    basc = find(isnan(t_c(:,1)) == 1 | isnan(t_c(:,2)) == 1); t_c(basc,:) = [];     % Elimina filas vacias tab conec
    %% Filtro 2 --> Eliminar conectividad al mismo punto
    basc = find((t_c(:,1) == t_c(:,2)) == 1); t_c(basc,:) = []; % Elimina conectividad al mismo punto
    %% Filtro 3 --> Ordenar Conectividad de Nodos
    for i = 1:size(t_c,1)                   % Recorre tabla de conectividad                    
        ni = find(t_n(:,1) == t_c(i,1));    % Obtiene nodo incial 
        nf = find(t_n(:,1) == t_c(i,2));    % Obtiene nodo final
        [xi,yi,xf,yf] = ordenar_2nodos(t_n(ni,2),t_n(ni,3),t_n(nf,2),t_n(nf,3));    % Anliza conectividad 
        if t_n(ni,2) == xf & t_n(ni,3) == yf    % Analiza cambio conectividad
            t_c(i,1:2) = [t_c(i,2) t_c(i,1)];   % modifica conectividad
        end
    end
    %% Creacion de estructura Ordenar Conectividad
    tip = get(handles.p_est,'value');
    close(Manual);                               % Cierra guide actual
    %--------------- Dibuja Nodos / Elementos ------------------
    point_newfast(t_n(:,2:3));
    element_newfast(t_c,tip); 
    %---------------------------------------------------------
    centrar_axes(axe_dibujo,0.075);     % Funcion para centrar al axes
    axis equal                          % Hace eje proporcionales
    b_lib = 1; botones(1);              % Bloqueo de botones
    plano;                              % Visualiza Plano de coordenadas
catch
    errordlg('La estructura ingresada tiene datos erróneos, es necesario crear un nuevo modelo. Para más información consultar el manual de UCAS2D','Error');   % mensaje de error si estructura no fue posible
end

function p_cancelm_Callback(hObject, eventdata, handles)
close(Manual);  % Cerrar guide actual

function p_est_Callback(hObject, eventdata, handles)
%% ------------------------- No Programada ---------------------------
function t_nc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function p_est_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function t_ne_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
