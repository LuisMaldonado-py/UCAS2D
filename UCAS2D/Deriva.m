function varargout = Deriva(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Deriva_OpeningFcn, ...
                   'gui_OutputFcn',  @Deriva_OutputFcn, ...
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

function Deriva_OpeningFcn(hObject, eventdata, handles, varargin)
global mag_text gl_der r_der op_play gp_der t_pder
%% ------------------------------ Datos -----------------------------------
des = r_der{1};  % Desplazamientos en pisos
n_p = size(des,2)-1;    % Numero de pisos sin base
%% ----------------------- Modificacion de axes ---------------------------
t = title(handles.a_der,'Máximos Desplazamiento de Pisos');   % Titulo general
set(t,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',12);    % Modifica titulo general
tx = xlabel(handles.a_der,strcat('Desplazamiento (',mag_text{2},')'));      % Titulo en X
set(tx,'color',[0.18 0.17 0.55],'FontWeight','Bold','FontName','Times New Roman','FontAngle','italic','FontSize',10);   % Modifica titulo en X
line(handles.a_der,zeros(n_p+1,1),(0:1:n_p),'Color','b','LineWidth',1.5,'Marker','s');  % Genera una linea inicial
yeti = ["Base"; strcat("Piso",string(1:1:n_p)')];           % Etiqueta en eje Y
set(handles.a_der,'YTick',(0:1:n_p),'YTickLabel',yeti);     % Carga datos del eje Y
grid(handles.a_der,'on');                                   % Inicia grillas
%% --------------------------- Cargar Datos -------------------------------
if op_play == 2      % Analisis No-Lineal
    set(handles.p_dcas,'String',string((1:1:size(des,1)))); % Carga numero de fallas
end
hold on
gl_der = line(handles.a_der,des(1,:),(0:1:n_p),'Color','r','LineWidth',1.5,'Marker','none');  % Genera primeros desplazamientos
gp_der = [];
for i = 1:n_p+1
    gp_der(i) = scatter(handles.a_der,des(1,i),i-1,75,'r','s','filled');
    set(gp_der(i),'DisplayName',strcat ("Ux: ",num2str(des(1,i))));
    set(gp_der(i),'ButtonDownFcn','sel_der(gco)');
end
set(handles.t_dmax,'string',strcat("Umin: ",string(min(des(1,2:end))),"   Umax: ",string(max(des(1,:)))));   % Valores maximos y minimos
%% ------------------------------------------------------------------------
t_pder = handles.t_psel;
%% ------------------------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Deriva_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function p_dtip_Callback(hObject, eventdata, handles)
p_dcas_Callback(hObject, eventdata, handles);           % Funcion similar 

function p_dcas_Callback(hObject, eventdata, handles)
global gl_der r_der gp_der
fal = get(handles.p_dcas,'value');          % Falla escojida
set(handles.t_psel,'string','');            % Borra informacion del piso seleccionado
if get(handles.p_dtip,'value') == 1         % Opcion desplazamientos
    val = r_der{1}; tex = "U";              % Desplazamientos / Texto para desplazamientos
    t = title(handles.a_der,'Máximos Desplazamiento de Pisos');   % Titulo general
else                                        % Opcion derivas
    val = r_der{2}; tex = "D";              % Derivas / Texto derivas 
    t = title(handles.a_der,'Máximas Derivas de Pisos');   % Titulo general
end
set(gl_der,'Xdata',val(fal,:));             % Carga nuevos valores de linea
for i = 1:size(val,2)                       % Valores de puntos y datos
    set(gp_der(i),'Xdata',val(fal,i),'Ydata',i-1,'DisplayName',strcat (tex,"x: ",num2str(val(fal,i)))); 
    set(gp_der(i),'ButtonDownFcn','sel_der(gco)');
end
set(handles.t_dmax,'string',strcat(tex,"min: ",string(min(val(fal,2:end))),"   ",tex,"max: ",string(max(val(fal,:)))));   % Valores maximos y minimos

%% -------------------------- No Programado -------------------------------
function p_dtip_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function p_dcas_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
