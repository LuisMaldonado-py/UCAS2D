function varargout = Armadura(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Armadura_OpeningFcn, ...
                   'gui_OutputFcn',  @Armadura_OutputFcn, ...
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

function Armadura_OpeningFcn(hObject, eventdata, handles, varargin)
global ax_arm
ax_arm = handles.a_tipo_armadura;32
%---------- Codigo para centrar guide ------------
centrar_guide;
%--------Colocacion de Imagen Armadura-----------
img_arm1=imread('a1.jpg');            % Lee archivo que contiene imagen para tipo de armadura
axes(ax_arm);                         % Llama al axes del tipo de armadura
imshow(img_arm1);                     % Muestra imagen en axes
%------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Armadura_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function e_n_arm_Callback(hObject, eventdata, handles)  % ---CODIGO PARA EDIT TEXT DE NUMERO DE DIVISIONES
a = str2double(get(handles.e_n_arm,'String'));                                                          % Leer numero de divisiones
b = get(handles.m_tipo_arm,'value');                                                                    % Lee el tipo de armadura escojida
if isnan(a) | a<=0                                                                                      % Sentencia de error
    set(handles.e_n_arm,'String',3)                                                                     % Arreglar error
    errordlg('Error el numero de divisiones no puede ser menor o igual a cero','Error');                % Cuadro de dialogo explicando error
end
if b == 6 & rem(a,4) ~= 0                                                                               % Para la armadura baltimore solo se debe ingresar el numero divisiones con multiplos de 4, este caso analiza este error
    set(handles.e_n_arm,'String','8');                                                                  % Devuelve el numero por defecto ya que la armadura solo trabaja con multiplos de 4
    errordlg('Este tipo de armadura solo acepta numero de divisiones con multiplos de 4','Error');      % Cuadro de dialogo explicando error
elseif b == 7 & rem(a,2) ~= 0                                                                          	% Para la armadura baltimore solo se debe ingresar el numero divisiones con multiplos de 2, este caso analiza este error
    set(handles.e_n_arm,'String','8');                                                                  % Devuelve el numero por defecto ya que la armadura solo trabaja con multiplos de 2
    errordlg('Este tipo de armadura solo acepta numero de divisiones con multiplos de 2','Error');      % Cuadro de dialogo explicando error
end 

function e_l_arm_Callback(hObject, eventdata, handles)  % ---CODIGO PARA EDIT TEXT DE LONGITUD DE ELEMENTOS
a=str2double(get(handles.e_l_arm,'String'));                                                            % Leer numero de divisiones
if isnan(a) | a<=0                                                                                      % Sentencia de error
    set(handles.e_l_arm,'String',3)                                                                     % Arreglar error
    errordlg('Error la longitud de las divisiones no puede ser menor o igual a cero','Error')           % Cuadro de dialogo explicando error
else
end

function e_h_arm_Callback(hObject, eventdata, handles)
a=str2double(get(handles.e_h_arm,'String'));                                                            %Leer numero de divisiones
if isnan(a) | a<=0                                                                                      %Sentencia de error
    set(handles.e_h_arm,'String',3)                                                                     %Arreglar error
    errordlg('Error la altura de la armadura no puede ser menor o igual a cero','Error')                 %Cuadro de dialogo explicando error
else
end

function check_manual_Callback(hObject, eventdata, handles)
%   INGRESO MANUAL DE ESTRUCTURA
a=get(handles.check_manual,'value');
if a==1
    set(handles.e_n_arm, 'enable', 'off');
    set(handles.e_l_arm, 'enable', 'off');
    set(handles.e_h_arm, 'enable', 'off');
    set(handles.m_tipo_arm, 'enable', 'off');
    set(handles.b_manual, 'enable', 'on');
else
    set(handles.e_n_arm, 'enable', 'on');
    set(handles.e_l_arm, 'enable', 'on');
    set(handles.e_h_arm, 'enable', 'on');
    set(handles.m_tipo_arm, 'enable', 'on');
    set(handles.b_manual, 'enable', 'off');
end

function b_manual_Callback(hObject, eventdata, handles)
Manual

function m_tipo_arm_Callback(hObject, eventdata, handles)
cont=get(hObject,'value');                                                  %Obtener tipo de armadura a analizar
img_a=strcat('a',int2str(cont),'.jpg');                                     %Forma el nombre del archivo del tipo de armadura
img_arm1=imread(img_a);                                                     %Lee archivo que contiene imagen para tipo de armadura
axes(handles.a_tipo_armadura);                                              %Llama al axes del tipo de armadura
imshow(img_arm1);                                                           %Muestra imagen en axes

function b_ok_arm_Callback(hObject, eventdata, handles)
global pan_dibujo axe_dibujo vs_geo ban_nuevo b_lib
ban_nuevo = 1;                                                              % Bandera de nuevo modelo
set(axe_dibujo,'XTick',[],'YTick',[]);                                      % Eliminar ejes en axes
set(pan_dibujo,'Visible','on');                                             % Aparece panel de dibujo
%------------------- Obtencion de datos ----------------------
n = str2num(get(handles.e_n_arm,'string'));                                 % Numero de divisiones
l = str2num(get(handles.e_l_arm,'string'));                                 % Longitud de elementos
h = str2num(get(handles.e_h_arm,'string'));                                 % Altura de elementos
tipo=get(handles.m_tipo_arm,'value');                                       % Tipo de armadura
[coor,conex] = armpre(n,l,h,tipo);                                       % Funcion para armadura escojida
a=get(handles.check_res,'value');                                           % Colocacion de retricciones 
close(Armadura);                                                            % Cierra guide armadura
%--------------- Dibuja Nodos / Elementos ------------------
point_newfast(coor(:,2:3))
element_newfast(conex(:,2:3),1); 
%---------------------------------------------------------
centrar_axes(axe_dibujo,0.075);                                             % Funcion para centrar al axes
axis equal                                                                  % Hace eje proporcionales
if a == 1
    mod_rest([1],[1 1 0],[]);                                                  % Funcion para modificar nodo
    mod_rest([n+1],[0 1 0],[]);                                                % Funcion para modificar nodo
end
b_lib = 1; botones(1);      % Bloqueo de botones
plano;      % Visualiza Plano de coordenadas

function b_cancelar_Callback(hObject, eventdata, handles)
close(Armadura)

%--------------------- NO PROGRAMADA ----------------------------
function e_n_arm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_l_arm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function m_tipo_arm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_h_arm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function check_res_Callback(hObject, eventdata, handles)
