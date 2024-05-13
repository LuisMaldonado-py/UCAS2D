function varargout = Curva(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Curva_OpeningFcn, ...
                   'gui_OutputFcn',  @Curva_OutputFcn, ...
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

function Curva_OpeningFcn(hObject, eventdata, handles, varargin)
global mag_text gl_cur eve_mat vr_pro d_cur lis_mat
%% --------------------------- General ------------------------------------
d_cur = {{'Comportamiento Elasto-Plástico' 'Comportamiento Avanzado'}...                    % Datos para grafica / Titulo General de Curva
    {'Deformación Unitaria (\epsilon)' 'Rotación \theta (rads)'}...                         % Titulo del Eje X
    {'Esfuerzo (\sigma)' 'Momento' '\sigma / f_y' 'M / M_p'}...                             % Titulo del Eje Y
    {{'% E'} {'% K' 'Theta y'} {'Esf / Fy' 'D. Unitaria'} {'M / Mp' 'Rotación'}}...         % Titulo de tablas
    {[10] [1 0.005] [0 0;1 0.0018;0 0.1050] [0 0;1 0.05;2 2.5]}...                          % Valores de tabla nueva
    {[0 0;1 1; 4 1.3] [0 0;0.005 0.005;0.02 0.0052] [0 0;0.0018 1;0.1050 0] [0 0;0.05 1;2.5 2]}...     % Valores de grafica
    {{'f_y' '\epsilon_y' 1} {'M_p' '\theta_y' 0.005}}...                                    % Etiquetas de Ejes
    {{'E' 0.6 0.5 '%E' 2.4 1.25} {'K' 0.003 0.0025 '%K' 0.012 0.0056}}};                    % Etiquetas para curvas elasto plasticas  
try; delete(gl_cur(1));delete(gl_cur([2 3]));end                                            % Trata de borrar curva existente en axes
set(handles.a_curva,'YTickMode','auto','YTickLabelMode','auto','XTickMode','auto','XTickLabelMode','auto');    % Etiqueta de ejes
%% ------------------------ Carga Datos -----------------------------------
if eve_mat == 1                                                                 % Opcion de Nueva Curva
    set(handles.e_ncur,'string',strcat("Curva ", num2str(size(vr_pro,1)+1)));   % Nombre de curva
    p_tipc_Callback(hObject, eventdata, handles);                               % Datos de curvas nuevas
elseif eve_mat == 2 | eve_mat == 3                                              % Opcion Copiar / Mostrar Curva
    %% --------------------------- General --------------------------------
    set(handles.p_tipc,'enable','off'); set(handles.p_comc,'enable','off');     % Activa pop menus de tipo de curvas
    %% --------------------------------------------------------------------
    p_cur = get(lis_mat,'value');                                               % Posicion de la curva a copiar en vr_pro 
    op = vr_pro{p_cur,3}; com = round(op/2); tip = op - (2*(com-1));            % Tipo de curva / Comportamiento material/ Tipo de estructura
    set(handles.p_tipc,'value',tip); set(handles.p_comc,'value',com);           % Modifica opcion de pop menus
    if op < 3                                                                   % Curvas Elasto-Plastica             
        A = 1; try; A = vr_pro{p_cur,4}(2); end;                                % Trata de obtener el AX para estructuras tipo portico
        v = vr_pro{p_cur,4}(1)+0.0001; n = 3; Ay2 = v*n*A/100;                  % %E o %K (0.0001 evita traslape de text %E o %K)/ # de AX para zona platica / Calculo de AY en zona plastica
        vx = [0 A A+(n*A)]; vy = [0 A A+Ay2];                                   % Valores en X y Y de la curva
        set(handles.a_curva,'YTick',[A],'YTickLabel',d_cur{7}{tip}{1},'XTick',[A],'xTickLabel'...                   % Da formato a los ejes X/Y
            ,d_cur{7}{tip}{2},'FontAngle','italic','FontWeight','Bold');              
        gl_cur(2) = text(0.6*A,A/2,d_cur{8}{tip}{1},'FontAngle','italic','FontWeight','Bold');                      % Texto de E o K
        gl_cur(3) = text(0.9*A+(n*A/2),1.1*A+(Ay2/2),d_cur{8}{tip}{4},'FontAngle','italic','FontWeight','Bold',...  % Texto de %E o %K
            'HorizontalAlignment','center');                                  
        v = vr_pro{p_cur,4};
    else
        set(handles.b_mas,'enable','on'); set(handles.b_min,'enable','on');     % Activa aum/dis de fila
        vx = vr_pro{p_cur,4}(:,1); vy = vr_pro{p_cur,4}(:,2); v = [vy vx];      % Datos de tabla        
    end
    %% ------------------------ Cargar datos Generales ------------------------
    t = title(handles.a_curva,d_cur{1}{com});                                   % Titulo general
    set(t,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',12);    % Modifica titulo general
    tx = xlabel(handles.a_curva,d_cur{2}{tip});                                 % Titulo en eje X
    set(tx,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',9);    % Modifica titulo en X
    ty = ylabel(handles.a_curva,d_cur{3}{op});                                  % Titulo en eje Y
    set(ty,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',9);    % Modifica titulo en X
    %% ------------------------------------------------------------------------
    set(handles.t_curva,'data',v,'ColumnName',d_cur{4}{op});                        % Carga datos de la tabla y nombre de columnas
    gl_cur(1) = line(handles.a_curva,vx,vy,'Color',[0 0.6 1],...
         'LineWidth',1,'Marker','s','MarkerFaceColor','b');                         % Genera Curva en axes
    if eve_mat == 2                                                                 % Opcion copiar curva
        set(handles.e_ncur,'string',strcat("Curva ", num2str(size(vr_pro,1)+1)));   % Nombre de curva
    else                                                                            % Opcion mostrar o modificar curva
        set(handles.e_ncur,'string',vr_pro{p_cur,2});                               % Nombre de curva
    end
    grid(handles.a_curva,'on');                                                     % Activa grilla
end
handles.output = hObject;
guidata(hObject, handles);

function varargout = Curva_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function p_tipc_Callback(hObject, eventdata, handles)
p_comc_Callback(hObject, eventdata, handles);           % Funcion para modificar nueva curva

function p_comc_Callback(hObject, eventdata, handles);          % Funcion para modificar curva nueva
global mag_text gl_cur eve_mat lis_mat d_cur
%% ---------------------------- General -----------------------------------
try; delete(gl_cur(1));delete(gl_cur([2 3]));end                            % Trata de borrar graficos en axes
com = get(handles.p_comc,'value'); tip = get(handles.p_tipc,'value');       % Comportamiento de material / tipo de estructura
op = 2*(com-1)+tip;                                                         % Opcion de curva 
set(handles.a_curva,'YTickMode','auto','YTickLabelMode','auto','XTickMode','auto','XTickLabelMode','auto');     % Etiqueta de ejes
%% ------------------------ Carga Datos -----------------------------------
t = title(handles.a_curva,d_cur{1}{com});                                   % Titulo general
set(t,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',12);    % Modifica titulo general
tx = xlabel(handles.a_curva,d_cur{2}{tip});                                 % Titulo en eje X
set(tx,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',9);   % Modifica titulo en X
ty = ylabel(handles.a_curva,d_cur{3}{op});                                  % Titulo en eje Y
set(ty,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',9);   % Modifica titulo en X
set(handles.t_curva,'data',d_cur{5}{op},'ColumnName',d_cur{4}{op});         % Carga datos y nombre de la tabla
gl_cur(1) = line(handles.a_curva,d_cur{6}{op}(:,1),d_cur{6}{op}(:,2),'Color',[0 0.6 1],...      
     'LineWidth',1,'Marker','s','MarkerFaceColor','b');                     % Genera Curva en axes
if com == 1                                                                 % Comportamiento Elasto Plastico
    set(handles.b_mas,'enable','off'); set(handles.b_min,'enable','off');   % Desactiva aum/dis de fila
    set(handles.a_curva,'YTick',d_cur{7}{tip}{3},'YTickLabel',d_cur{7}{tip}{1},'XTick',d_cur{7}{tip}{3},'xTickLabel'...
    ,d_cur{7}{tip}{2},'FontAngle','italic','FontWeight','Bold');            % Carga datos del eje X/Y
    gl_cur(2) = text(d_cur{8}{tip}{2},d_cur{8}{tip}{3},d_cur{8}{tip}{1},'FontAngle','italic','FontWeight','Bold');   % Texto de E o K
    gl_cur(3) = text(d_cur{8}{tip}{5},d_cur{8}{tip}{6},d_cur{8}{tip}{4},'FontAngle','italic','FontWeight','Bold',...
        'HorizontalAlignment','center');                                    % Texto de %E o %K
else
    set(handles.b_mas,'enable','on'); set(handles.b_min,'enable','on');     % Activa aum/dis de fila
end
grid(handles.a_curva,'on');                                                 % Activa grillas 

function b_mas_Callback(hObject, eventdata, handles)            % Funcion para aumentar fila
set(handles.t_curva,'data',[get(handles.t_curva,'data');0 0]);  % Carga nueva fila 
t_curva_CellEditCallback(hObject, eventdata, handles);          % Modifica grafica de curva segun nuevos datos

function b_min_Callback(hObject, eventdata, handles)            % Funcion para aumentar fila
d =get(handles.t_curva,'data');                                 % Datos de tabla actual
if size(d,1) > 2                                                % Deja minimo para 2 puntos
    set(handles.t_curva,'data',d(1:end-1,:));                   % Borra fila
    t_curva_CellEditCallback(hObject, eventdata, handles);      % Modifica grafica de curva segun nuevos datos
end

function t_curva_CellEditCallback(hObject, eventdata, handles)  % Funcion para modificar curva
global d_cur gl_cur
%% ---------------------------- General -----------------------------------
tip = get(handles.p_tipc,'value');  op = 2*((get(handles.p_comc,'value'))-1)+tip;   % Tipo de estructura / Tipo de curva
try; delete(gl_cur(1));delete(gl_cur([2 3]));end                                    % Trata de borrar graficos en axes
d = get(handles.t_curva,'data');                                                    % Valores en tabla 
%% ------------------------ Carga Datos -----------------------------------
if op < 3                                       % Si se elije curva Elasto - Plastica
    A = 1; try; A = d(2); end;                  % Trata de obtener el AX para estructuras tipo portico
    v = d(1)+0.00001; n = 3; Ay2 = v*n*A/100;           % %E o %K (0.0001 evita traslape de text %E o %K)/ # de AX para zona platica / Calculo de AY en zona plastica
    vx = [0 A A+(n*A)]; vy = [0 A A+Ay2];       % Valores en X y Y de la curva
    set(handles.a_curva,'YTick',[A],'YTickLabel',d_cur{7}{tip}{1},'XTick',[A],'xTickLabel'...
        ,d_cur{7}{tip}{2},'FontAngle','italic','FontWeight','Bold');                            % Carga datos del eje X y Y
    gl_cur(2) = text(0.6*A,A/2,d_cur{8}{tip}{1},'FontAngle','italic','FontWeight','Bold');      % Texto de E o K
    gl_cur(3) = text(0.9*A+(n*A/2),1.1*A+(Ay2/2),d_cur{8}{tip}{4},'FontAngle','italic','FontWeight','Bold',...
        'HorizontalAlignment','center');                                    % Texto de %E o %K
    set(handles.b_mas,'enable','off'); set(handles.b_min,'enable','off');   % Desactiva aum/dis de fila
else
    vx = d(:,2); vy = d(:,1);                                               % Datos de tabla
end
gl_cur(1) = line(handles.a_curva,vx,vy,'Color',[0 0.6 1],...                % Genera Curva
    'LineWidth',1,'Marker','s','MarkerFaceColor','b');                     
grid(handles.a_curva,'on');                                                 % Inicia grillas 

function b_ok_Callback(hObject, eventdata, handles)
global vr_pro lis_mat eve_mat
tip = get(handles.p_tipc,'value'); op = 2*((get(handles.p_comc,'value'))-1)+tip;    % Tipo de estructura / Tipo de curva
d = get(handles.t_curva,'data');    % Datos de la tabla
if op > 2                                                                           % Opcion para curvas avanzadas
    d = [d(:,2) d(:,1)];            % Valores para curvas avanzadas
end
if eve_mat == 1 | eve_mat == 2          % Curva Nueva
    vr_pro = [vr_pro;{size(vr_pro,1)+1 get(handles.e_ncur,'string') op d}];                  % Anexa nueva curva
elseif eve_mat == 3                     % Curva Existente
    vr_pro(get(lis_mat,'value'),2:end) = {get(handles.e_ncur,'string') op d};   % Modifica curva
end
set(lis_mat,'string',vr_pro(:,2));    % Carga lista de curvas existentes
close(Curva);       % Cierra guide de curvas

function b_can_Callback(hObject, eventdata, handles)
close(Curva);       % Cierra guide de curvas
%% ---------------------------- No Programado -----------------------------
function p_tipc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function e_ncur_Callback(hObject, eventdata, handles)
function e_ncur_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p_comc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end