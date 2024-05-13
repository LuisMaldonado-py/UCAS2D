function varargout = Animacion_Pasos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Animacion_Pasos_OpeningFcn, ...
                   'gui_OutputFcn',  @Animacion_Pasos_OutputFcn, ...
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

function Animacion_Pasos_OpeningFcn(hObject, eventdata, handles, varargin)
global U1g P1g mag_text d_gra mat_res op_nolin vn_coor axe_dibujo 
global vn_obj ve_conex ve_obj co_ro 
% ------------ Prepara la Visualizacion del Axes grafica ------------------
plot(handles.a_paso,U1g,P1g);   % Grafica curva pushover de fondo
ty = ylabel(handles.a_paso,strcat('Carga P (',mag_text{1},')')); % Titulo Eje Y
set(ty,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontAngle','italic','FontSize',8,'FontWeight','Bold');    % Edicion Eje Y
tx = xlabel(handles.a_paso,strcat('Desplazamiento en NC (',mag_text{2},')')); % Titulo Eje X
set(tx,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontAngle','italic','FontSize',8,'FontWeight','Bold');    % Edicion Eje X
% ------------------ Posicion Inicial de la Estructura --------------------
co = mat_res{7};  % Coordenadas Iniciales
if max(vn_coor(:,2)) >= max(vn_coor(:,3))               % Estructura mas grande en X
    Al = 0.2*(max(vn_coor(:,2))-min(vn_coor(:,2)));     % Calcula borde de Estructura
    set(axe_dibujo,'xlim',[min(vn_coor(:,2))-Al max(vn_coor(:,2))+Al]); axis(axe_dibujo,'equal'); % Centra la Estructura en X
else                                                    % Estructura mas grande en Y
    Al = 0.2*(max(vn_coor(:,3))-min(vn_coor(:,3)));     % Calcula borde de Estructura
    set(axe_dibujo,'ylim',[min(vn_coor(:,3))-Al max(vn_coor(:,3))+Al]); axis(axe_dibujo,'equal'); % Centra la Estructura en Y
end
if op_nolin == 2        % Portico
    for i = 1:size(co_ro,1)                          % Cambbia de Color Azul
        set(co_ro(i,3),'XData',co_ro(i,1),'YData',co_ro(i,2),'MarkerFaceColor','b');                   % Modifica rotula posicion inicial / color   
    end
else                    % Armadura
    for i = 1:size(vn_obj,1)                                % Mueve Nodos a Posicion Original
    set(vn_obj(i,3),'XData',co(i,1),'YData',co(i,2));   % Modifica Nodos
    end
end
for i = 1:size(ve_conex,1)                              % Mueve Elementos a Posicion Original
    ni = ve_conex(i,2); ni = find(vn_coor(:,1) == ni);  % Busca Posicion del Nodo Inicial
    nf = ve_conex(i,3); nf = find(vn_coor(:,1) == nf);  % Busca Posicion del Nodo Final
    set(ve_obj(i,3),'XData',[vn_coor(ni,2) vn_coor(nf,2)],...
        'YData',[vn_coor(ni,3) vn_coor(nf,3)],'Color','b'); % Modifica elemento
end
% --------------------------- Calculo de Variables ------------------------
des = []; rot = {};
for i = 1:size(mat_res{3},2)
    des(end+1,1:2) = [mat_res{3}{i}(1) find(mat_res{1,4}(:,1) == mat_res{3}{i}(1))];    % Desplazamiento / Posicion en vector U
    rot(end+1) = {char(strjoin(string(mat_res{3}{i}(1,2:end)), {'-'}))};                % Vector de Elemen / Rotulas
end
d_gra = [{[string(1:1:size(mat_res{3},2)) 'Total']'} {[des(:,1); mat_res{1,4}(end,1)]} {[des(:,2); size(mat_res{1,4},1)]} {rot'}];  % {Lista de menu / Desplazamiento / Posicion en vector U / Rotulas}
set(handles.p_falla,'string',d_gra{1},'value',size(d_gra{1},1));            % Carga lista de datos para grafica
handles.output = hObject;
guidata(hObject, handles);

function varargout = Animacion_Pasos_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
p_falla_Callback(hObject, eventdata, handles);

function p_falla_Callback(hObject, eventdata, handles)
global U1g P1g d_gra curp1 curp2 mat_res op_nolin ve_obj vn_obj vn_coor ve_conex co_ro 
u = mat_res{1,4}(:,1); p = mat_res{1,4}(:,2);   % Desplazamiento / Carga
if op_nolin == 2        % Portico
    t_e = "R: ";
    rx = mat_res{1,8}(:,1:size(mat_res{1,8},2)/2);
    ry = mat_res{1,8}(:,(size(mat_res{1,8},2)/2)+1:end);
    for i = 1:size(co_ro,1)                          % Cambia de Color Azul
        set(co_ro(i,3),'XData',co_ro(i,1),'YData',co_ro(i,2),'MarkerFaceColor','b');                   % Modifica rotula posicion inicial / color
    end
else                    % Armadura
    u = mat_res{1,4}(:,1); p = mat_res{1,4}(:,2);   % Desplazamiento / Carga
    t_e = "E: ";
    for i = 1:size(ve_conex,1)                          % Cambbia de Color Azul
        set(ve_obj(i,3),'Color','b');                   % Modifica elemento color   
    end
end
co = mat_res{7}; ux = mat_res{5}; uy = mat_res{6};  % Coordenadas Iniciales / Despla en X / Despla en Y
try; delete(curp1);delete(curp2); end;              % Borrar curva total / fallas 
curp1 = animatedline(handles.a_paso,'color','r','LineWidth',2);     % Curva Animada Roja
curp2 = animatedline(handles.a_paso,'color','r','MarkerSize',5,'LineStyle','none','Marker','s'); % Nodos en pntos de falla
addpoints(curp2,0,0);
falla = get(handles.p_falla,'value');       % Opcion de falla
%try
for i = 1 : d_gra{3}(falla)                % Desplazaminetos
    addpoints(curp1,u(i),p(i));                                     % Grafica curva
    ley([1 2]) = {strcat("u : ",num2str(u(i))),strcat("P : ",num2str(p(i)))};  % Crea String
    if isempty(find(d_gra{3} == i)) == 0
        addpoints(curp2,u(i),p(i));                                 % Agrega puntos de falla
        try 
            ley(3)={strcat(t_e,d_gra{4}{find(d_gra{3} == i)})};     % Añade elemento que falla
            ele = mat_res{3}{find(d_gra{3} == i)}(2:end);           % saca lista de elementos fallidos
            if op_nolin == 1            % Elementos fallidos
                for k = 1: size(ele,2)     
                    set(ve_obj(find(ve_obj(:,1)==ele(k)),3),'Color','r');
                end
            else                        % Rotulas fallidas
                for k = 1: size(ele,2)
                    set(co_ro(ele(k),3),'MarkerFaceColor','r');
                end
            end
        end 
    end
    set(handles.t_pusp,'string',ley);
    % Desplazamiento Nodos 
    for j = 1:size(vn_obj,1)                                % Mueve Nodos a Posicion Original
        set(vn_obj(j,3),'XData',co(j,1)+ux(i,j),'YData',co(j,2)+uy(i,j)); % Modifica Nodos
        drawnow limitrate;  % Salta Actualizaciones
    end
    % Desplazamiento Rotulas
    if op_nolin == 2            % Elementos fallidos
        for j = 1:size(co_ro,1)                                % Mueve Nodos a Posicion Original
            %set(co_ro(j,3),'XData',co_ro(j,1)+rx(i,j),'YData',co_ro(j,2)+ry(i,j)); % Modifica Nodos
            set(co_ro(j,3),'XData',rx(i,j),'YData',ry(i,j)); % Modifica Nodos
            drawnow limitrate;  % Salta Actualizaciones
        end
    end
    % Desplazamiento Elementos
    for j = 1:size(ve_conex,1)                              % Mueve Elementos a Posicion Original
        ni = ve_conex(j,2); ni = find(vn_coor(:,1) == ni);  % Busca Posicion del Nodo Inicial
        nf = ve_conex(j,3); nf = find(vn_coor(:,1) == nf);  % Busca Posicion del Nodo Final
        set(ve_obj(j,3),'XData',[vn_coor(ni,2)+ux(i,ni) vn_coor(nf,2)+ux(i,nf)],...
            'YData',[vn_coor(ni,3)+uy(i,ni) vn_coor(nf,3)+uy(i,nf)]); % Modifica elemento posicion / color 
        drawnow limitrate;  % Salta Actualizaciones
    end
    %drawnow limitrate;  % Salta Actualizaciones
%end
end

function b_cer_Callback(hObject, eventdata, handles)
close(Animacion_Pasos);      % Cerrar interfaz actual

function figure1_CloseRequestFcn(hObject, eventdata, handles)
global mat_res vn_coor axe_dibujo vn_obj ve_obj ve_conex op_nolin co_ro
%delete(hObject);
co = mat_res{7};  % Coordenadas Iniciales
if max(vn_coor(:,2)) >= max(vn_coor(:,3))               % Estructura mas grande en X
    Al = 0.2*(max(vn_coor(:,2))-min(vn_coor(:,2)));     % Calcula borde de Estructura
    set(axe_dibujo,'xlim',[min(vn_coor(:,2))-Al max(vn_coor(:,2))+Al]); axis(axe_dibujo,'equal'); % Centra la Estructura
else                                                    % Estructura mas grande en X
    Al = 0.2*(max(vn_coor(:,3))-min(vn_coor(:,3)));     % Calcula borde de Estructura
    set(axe_dibujo,'ylim',[min(vn_coor(:,3))-Al max(vn_coor(:,3))+Al]); axis(axe_dibujo,'equal'); % Centra la Estructura
end
for i = 1:size(vn_obj,1)                                % Mueve Nodos a Posicion Original
    set(vn_obj(i,3),'XData',co(i,1),'YData',co(i,2)); % Modifica Nodos
end
for i = 1:size(ve_conex,1)                              % Mueve Elementos a Posicion Original
    ni = ve_conex(i,2); ni = find(vn_coor(:,1) == ni);  % Busca Posicion del Nodo Inicial
    nf = ve_conex(i,3); nf = find(vn_coor(:,1) == nf);  % Busca Posicion del Nodo Final
    set(ve_obj(i,3),'XData',[vn_coor(ni,2) vn_coor(nf,2)],...
        'YData',[vn_coor(ni,3) vn_coor(nf,3)],'Color','b'); % Modifica elemento posicion / color   
end
if op_nolin == 2        % Portico
    for i = 1:size(co_ro,1)                          % Cambbia de Color Azul
        set(co_ro(i,3),'XData',co_ro(i,1),'YData',co_ro(i,2),'MarkerFaceColor','b');                   % Modifica rotula posicion inicial / color      
    end
end
delete(hObject);

%% -------------------------- No Programado -------------------------------
function p_falla_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
