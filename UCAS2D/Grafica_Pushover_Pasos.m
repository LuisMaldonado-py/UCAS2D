function varargout = Grafica_Pushover_Pasos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grafica_Pushover_Pasos_OpeningFcn, ...
                   'gui_OutputFcn',  @Grafica_Pushover_Pasos_OutputFcn, ...
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

function Grafica_Pushover_Pasos_OpeningFcn(hObject, eventdata, handles, varargin)
global U1g P1g mag_text d_gra mat_res op_nolin conf1
conf1 = 0;   % Contador para interrumpir accion
plot(handles.a_paso,U1g,P1g);   % Grafica de fondo
t = title(handles.a_paso,'Curva Pushover');
set(t,'color',[0.18 0.17 0.55],'FontWeight','Normal','FontName','Times New Roman','FontSize',15);
ty = ylabel(handles.a_paso,strcat('Carga en la Estructura P (',mag_text{1},')'));
set(ty,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontAngle','italic','FontSize',10);
tx = xlabel(handles.a_paso,strcat('Desplazamiento en Nodo de Control (',mag_text{2},')'));
set(tx,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontAngle','italic','FontSize',10);
if op_nolin == 2        % Portico
    des = []; rot = {};
    for i = 1:size(mat_res{3},2)
        des(end+1,1:2) = [mat_res{3}{i}(1) find(U1g == mat_res{3}{i}(1))];      % Desplazamiento / Posicion en vector U
        rot(end+1) = {char(strjoin(string(mat_res{3}{i}(1,2:end)), {' - '}))};  % Rotulas
    end
    d_gra = [{[string(1:1:size(mat_res{3},2)) 'Total']'} {[des(:,1); U1g(end)]} {[des(:,2); size(U1g,2)]} {rot'}];  % {Lista de menu / Desplazamiento / Posicion en vector U / Rotulas}
    set(handles.p_falla,'string',d_gra{1},'value',size(d_gra{1},1));            % Carga lista de datos para grafica
else                    % Armadura
    des = []; rot = {};
    for i = 1:size(mat_res{3},2)
        des(end+1,1:2) = [mat_res{3}{i}(1) find(mat_res{1,4}(:,1) == mat_res{3}{i}(1))];      % Desplazamiento / Posicion en vector U
        rot(end+1) = {char(strjoin(string(mat_res{3}{i}(1,2:end)), {' - '}))};  % Rotulas
    end
    d_gra = [{[string(1:1:size(mat_res{3},2)) 'Total']'} {[des(:,1); mat_res{1,4}(end,1)]} {[des(:,2); size(mat_res{1,4},1)]} {rot'}];  % {Lista de menu / Desplazamiento / Posicion en vector U / Rotulas}
    set(handles.p_falla,'string',d_gra{1},'value',size(d_gra{1},1));            % Carga lista de datos para grafica
end
handles.output = hObject;
guidata(hObject, handles);

function varargout = Grafica_Pushover_Pasos_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
p_falla_Callback(hObject, eventdata, handles);

function p_falla_Callback(hObject, eventdata, handles)
global U1g P1g d_gra curp1 curp2 mat_res op_nolin conf1
conf1 = conf1 + 1; con = conf1;     % Interrumpir accion
if op_nolin == 2        % Portico
    u = U1g; p = P1g;   % Desplazamiento / Carga
    t_e = "Rotulas: ";
else                    % Armadura
    u = mat_res{1,4}(:,1); p = mat_res{1,4}(:,2);   % Desplazamiento / Carga
    t_e = "Elementos: ";
end
set(handles.t_ele,'string','');             % Borra texto en rotulas falladas
try; delete(curp1);delete(curp2); end;      % Borrar curva 
curp1 = animatedline(handles.a_paso,'color','r','LineWidth',2);     % Curva fondo
curp2 = animatedline(handles.a_paso,'color','r','MarkerSize',5,'LineStyle','none','Marker','s'); % Curva Nodos
addpoints(curp2,0,0);
falla = get(handles.p_falla,'value');   % Opcion de falla
% {Lista de menu / Desplazamiento / Posicion en vector U / Rotulas}
axes(handles.a_paso); hold on;
try
for i = 1 : d_gra{3}(falla)                % Desplazaminetos
    if conf1 ~= con break; end;             % Interrumpe accion
    addpoints(curp1,u(i),p(i));                                     % Grafica curva
    ley = {strcat("u : ",num2str(u(i))),strcat("P : ",num2str(p(i)))};  % Crea String
    set(handles.t_pusp,'string',ley);
    if isempty(find(d_gra{3} == i)) == 0
        addpoints(curp2,u(i),p(i));
        try; set(handles.t_ele,'string',strcat(t_e,d_gra{4}{find(d_gra{3} == i)})); end;
    end
    drawnow;
end
end
function b_cer_Callback(hObject, eventdata, handles)
close(Grafica_Pushover_Pasos);      % Cerrar interfaz actual

function p_falla_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in b_cer.
%function b_cer_Callback(hObject, eventdata, handles)
% hObject    handle to b_cer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
