function varargout = Seccion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Seccion_OpeningFcn, ...
                   'gui_OutputFcn',  @Seccion_OutputFcn, ...
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

function Seccion_OpeningFcn(hObject, eventdata, handles, varargin)
global lista_sec vs_eti vs_geo vs_pro con_sec vs_etic vs_geoc vs_proc con_secc
%------------------- CODIGO PARA CENTRAR EL GUIDE ----------------
centrar_guide                                                               % Llama script que centra el guide
%-------------------- Copia de Secciones ----------------
vs_etic = vs_eti;                                                           % Copia de nombres seccion para opcion cancelar
vs_geoc = vs_geo;                                                           % Copia de geometria de la seccion para opcion cancelar
vs_proc = vs_pro;                                                           % Copia de propiedades de la seccion para opcion cancelar
con_secc = con_sec;                                                         % Copia de identificador de la seccion para opcion cancelar                                       
%---------------- Variable de elementos -----------------
lista_sec = handles.l_sec;                                                  % Guarda elemento list box para mostrar secciones
%--------------- Cargar lista de Secciones --------------
set(lista_sec,'string', vs_eti(:,2));                                       % Carga lista de secciones
set(lista_sec,'value',1);                                                  % Carga lista de secciones
%--------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Seccion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_imp_Callback(hObject, eventdata, handles)
global op_sec
op_sec = 1;                                                                 % Agregar Importar Seccion 
Importar_seccion;                                                           % Abre base de Datos AISC

function b_add_Callback(hObject, eventdata, handles)
global op_sec
op_sec = 2;                                                                 % Agregar Nueva Seccion 
Tipo_de_Seccion;                                                            % Abre guide tipo de seccion

function b_cop_Callback(hObject, eventdata, handles)
global op_sec lista_sec sec_e vs_eti sec
op_sec = 3;                                                                 % Opcion 3 copia de seccion existente                       
sec_e = get(lista_sec,'value');                                             % Obtiene material elejido a copiar
sec = vs_eti{sec_e,4};                                                      % Obtiene tipo de elemento
Geometria_de_la_Seccion;                                                    % Abre guide de la geometria de seccion

function b_mos_Callback(hObject, eventdata, handles)
global op_sec lista_sec sec_e vs_eti sec
op_sec = 4;                                                                 % Opcion 3 copia de seccion existente                       
sec_e = get(lista_sec,'value');                                             % Obtiene material elejido a copiar
sec = vs_eti{sec_e,4};                                                      % Obtiene tipo de elemento
Geometria_de_la_Seccion;                                                    % Abre guide de la geometria de seccion

function b_del_Callback(hObject, eventdata, handles)
global lista_sec vs_eti vs_geo vs_pro
min_mat = size(vs_geo,1);                                                  % Para que siempre se quede un elemento
if min_mat > 1                                                              % Evita error de vector vacios
    val_mat = get(lista_sec,'value');                                       % Identifica material a borrar
    vs_eti(val_mat,:)=[];                                                	% Borra fila del nodo seleccionado
    vs_geo(val_mat,:)=[];                                                  % Borra material seleccionado
    vs_pro(val_mat,:)=[];                                                  % Borra material seleccionado
    if val_mat == 1
        val_mat = 2;                                                        % Evita eeror de caja de lista en valor final             
    end
    set(lista_sec,'value',val_mat-1);                                             	% Carga lista de materiales
    set(lista_sec,'string',vs_eti(:,2));                                  	% Carga lista de materiales
end

function b_ok_Callback(hObject, eventdata, handles)
global ban_sec lista_secc vs_eti
close(Seccion)
if ban_sec == 1
    %--------------- Cargar lista de Secciones --------------
    set(lista_secc,'string', vs_eti(:,2));                                       % Carga lista de secciones
    set(lista_secc,'value',1);                                                  % Carga lista de secciones
    %--------------------------------------------------------
    ban_sec = 0;
end    

function b_cancelar_Callback(hObject, eventdata, handles)
global vs_eti vs_geo vs_pro con_sec vs_etic vs_geoc vs_proc con_secc
vs_eti = vs_etic;                                                           % Da de etiquetas de la seccion para opcion cancelar
vs_geo = vs_geoc;                                                           % Da geometria de la seccion para opcion cancelar
vs_pro = vs_proc;                                                           % Da propiedades de la seccion para opcion cancelar
con_sec = con_secc;                                                         % Da identificador de la seccion para opcion cancelar                                       
close(Seccion);                                                             % Cierra guide actual

%--------------- No Programada --------------------

function l_sec_Callback(hObject, eventdata, handles)

function l_sec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
