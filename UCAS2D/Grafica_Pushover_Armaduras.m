function varargout = Grafica_Pushover_Armaduras(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grafica_Pushover_Armaduras_OpeningFcn, ...
                   'gui_OutputFcn',  @Grafica_Pushover_Armaduras_OutputFcn, ...
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

function Grafica_Pushover_Armaduras_OpeningFcn(hObject, eventdata, handles, varargin)
global dat_arm vn_coor des_max mag_text
%% -------------------------- Este. Grafica ---------------------------------
t = title(handles.a_pus,'Curva Pushover');
set(t,'color',[0.18 0.17 0.55],'FontWeight','Normal','FontName','Times New Roman','FontAngle','italic','FontSize',15);
ty = ylabel(handles.a_pus,'Carga en la Estructura P (Tonf)');
set(ty,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontSize',10)%,'FontAngle','italic');
tx = xlabel(handles.a_pus,'Desplazamiento en GDL de Control (cm)');
set(tx,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontSize',10)%,'FontAngle','italic');
%% -------------------------------------
t_nod = string(vn_coor(:,1)); t_nod(dat_arm{5}) = "Control";    % Crea texto de nodos
set(handles.p_nodo,'string',t_nod);         % carga lista de nodos
set(handles.p_nodo,'value',dat_arm{5});     % Pone en nodo de control la grafica
gdl = ((dat_arm{5}-1)*3)+1;                 % Busca GDL
u = dat_arm{2}';
p = dat_arm{3}';
axes(handles.a_pus);                        % Llama Axes
curve = animatedline('color','r','Marker','o');
%% GENERA EL CODIGO PARA GRAFICAR LA ESTRUCTURA DEFORMADA
uni_com = {'mm' 'cm' 'in' 'ft' 'm'; '1000' '100' '40' '4' '1'};     % anlisis de unidades    
des_max = str2num(uni_com{2,find(contains(uni_com(1,:),mag_text(2)))});  % desplazamiento maximo
%try; a = inputdlg (strcat(' Ingrese el desplazamiento maximo [',mag_text{2},']'),' Desplazamiento Maximo ',[1 40],{num2str(des_max)});des_max = str2num(a{1});end  % Captura desplazamiento maximo ingressado
n_it = size(dat_arm{1},2); n_con = dat_arm{5};  % Numero de iterraciones / nodo de control
try; a = find(dat_arm{1}(gdl,:) <= des_max); n_it = a(end); end   % Numero de iterraciones
if n_it < 7
    a = 1.5;
else
    a = 2.5;
end
time = a/n_it;
for i=1:n_it
    addpoints(curve,u(i),p(i));
    drawnow
    pause(time);
end
handles.output = hObject;
guidata(hObject, handles);

function varargout = Grafica_Pushover_Armaduras_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_imp_Callback(hObject, eventdata, handles)

function b_cer_Callback(hObject, eventdata, handles)
close(Grafica_Pushover_Armaduras);      % Cerrar interfaz actual

function b_ok_Callback(hObject, eventdata, handles)
close(Grafica_Pushover_Armaduras);      % Cerrar interfaz actual

function p_nodo_Callback(hObject, eventdata, handles)
global dat_arm des_max mag_text
nodo = get(handles.p_nodo,'value');         % Obtiene Nodo
uxy = get(handles.p_gdl,'value');           % Obtiene Ux/Uy
gdl = ((nodo-1)*3)+uxy;                 % Busca GDL
u = dat_arm{1}; u = [0 u(gdl,:)]';          % Busca Desplazmaineto
p = dat_arm{3}';                            % Genera Cargas
axes(handles.a_pus);                        % Llama Axes
cla
curve = animatedline('color','r','Marker','o');
%% GENERA EL CODIGO PARA GRAFICAR LA ESTRUCTURA DEFORMADA
n_it = size(dat_arm{1},2); n_con = dat_arm{5};  % Numero de iterraciones / nodo de control
try; a = find(dat_arm{1}(((dat_arm{5}-1)*3)+1,:) <= des_max); n_it = a(end); end   % Numero de iterraciones
if n_it < 7
    a = 1.5;
else
    a = 2.5;
end
time = a/n_it;
for i=1:n_it
    addpoints(curve,u(i),p(i));
    drawnow
    pause(time);
end

function p_nodo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function p_gdl_Callback(hObject, eventdata, handles)
global dat_arm des_max mag_text
nodo = get(handles.p_nodo,'value');         % Obtiene Nodo
uxy = get(handles.p_gdl,'value');           % Obtiene Ux/Uy
gdl = ((nodo-1)*3)+uxy;                 % Busca GDL
u = dat_arm{1}; u = [0 u(gdl,:)]';          % Busca Desplazmaineto
p = dat_arm{3}';                            % Genera Cargas
axes(handles.a_pus);                        % Llama Axes
cla
curve = animatedline('color','r','Marker','o');
%% GENERA EL CODIGO PARA GRAFICAR LA ESTRUCTURA DEFORMADA
n_it = size(dat_arm{1},2); n_con = dat_arm{5};  % Numero de iterraciones / nodo de control
try; a = find(dat_arm{1}(((dat_arm{5}-1)*3)+1,:) <= des_max); n_it = a(end); end   % Numero de iterraciones
if n_it < 7
    a = 1.5;
else
    a = 2.5;
end
time = a/n_it;
for i=1:n_it
    i
    addpoints(curve,u(i),p(i));
    drawnow
    pause(time);
end

function p_gdl_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
