function varargout = Viga(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Viga_OpeningFcn, ...
                   'gui_OutputFcn',  @Viga_OutputFcn, ...
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

function Viga_OpeningFcn(hObject, eventdata, handles, varargin)
centrar_guide;                  % Codigo para centrar guide
%--------Colocacion de Imagen Armadura-----------
img_viga=imread('viga.jpg');    % Lee archivo que contiene imagen para viga
axes(handles.a_viga);           % Llama al axes de viga
imshow(img_viga);               % Muestra imagen en axes
%-------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Viga_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
global pan_dibujo axe_dibujo con_nod ban_nuevo b_lib
ban_nuevo = 1;                                      % Bandera de nuevo modelo
set(axe_dibujo,'XTick',[],'YTick',[]);              % Eliminar ejes en axes
set(pan_dibujo,'Visible','on');                     % Aparece panel de dibujo
%-----------------------------------------------
nvanos = str2num(get(handles.e_nvanos,'string'));                           % Obtiene numero de vanos
bvano = str2num(get(handles.e_bvano,'string'));                             % Obtiene ancho de vanos
[coor,conex]  = vig(nvanos,bvano);                                           % Hace funcion para dibujar viga
a=get(handles.check_res,'value');                                           % Colocacion de retricciones 
close(Viga);                                                                % Cierra guide viga
%--------------- Dibuja Nodos / Elementos ------
point_newfast(coor(:,2:3))
element_newfast(conex(:,2:3),2); 
%-----------------------------------------------
centrar_axes(axe_dibujo,0.075);                                              % Funcion para centrar al axes
axis equal                                                                  % Hace eje proporcionales
if a == 1
    for i = 1:con_nod                                                       % Recorre los nodos                               
        if i ==1
            mod_rest(i,[1 1 0],[]);                                          % Funcion para modificar nodo
        else
            mod_rest(i,[0 1 0],[]);                                            % Funcion para modificar nodo
        end                                                                 % Hace eje proporcionales
    end
end
b_lib = 1; botones(1);      % Bloqueo de botones
plano;      % Visualiza Plano de coordenadas

function b_cancelar_Callback(hObject, eventdata, handles)
close(Viga);    % Cierra guide viga

function c_rejp_Callback(hObject, eventdata, handles)
if get(handles.c_rejp,'value') == 0
    set(handles.e_nvanos,'enable','on');    % Bloquea text numero de vanos en portico
    set(handles.e_bvano,'enable','on');     % Bloquea text ancho de vanos
    set(handles.b_editp,'enable','off');    % Bloquea boton editar rejilla
    set(handles.b_ok,'enable','on');       % Bloquea boton normal portico
else
    set(handles.e_nvanos,'enable','off');   % Bloquea text numero de vanos en portico
    set(handles.e_bvano,'enable','off');    % Bloquea text ancho de vanos
    set(handles.b_editp,'enable','on');     % Bloquea boton editar rejilla
    set(handles.b_ok,'enable','off');       % Bloquea boton normal portico
end

function b_editp_Callback(hObject, eventdata, handles)
global v_er                                                             % val_er = [tip npisos nvanos hpiso1 hpison bvano rest]
v_er = [2 str2num(get(handles.e_nvanos,'string')) str2num(get...        % Crea vector de propiedades de estructura
    (handles.e_bvano,'string')) get(handles.check_res,'value')];        % Tipo/ # Vanos/ Ancho de Vano/ Restricciones
Editar_Rejilla;                                                         % Guide de editar rejilla
%--------------------- NO PROGRAMADA ----------------------------
function e_nvanos_Callback(hObject, eventdata, handles)
function e_nvanos_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function e_bvano_Callback(hObject, eventdata, handles)
function e_bvano_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function check_res_Callback(hObject, eventdata, handles)
