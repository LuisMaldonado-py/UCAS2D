function varargout = Definir_Constraints(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Definir_Constraints_OpeningFcn, ...
                   'gui_OutputFcn',  @Definir_Constraints_OutputFcn, ...
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

function Definir_Constraints_OpeningFcn(hObject, eventdata, handles, varargin)
global vn_const con_const lis_cons vn_constc con_constc
%vn_const = {}; 
%con_const = 0;
%--------- Variables -----------------
lis_cons = handles.l_con;                                                    % Guarda identificador de listbox de materiales
%---------- Datos para Opcion Cancelar -----------------------
vn_constc = vn_const;                                                       % Etiqueta de  constraints guardado para opcion de cancelar
con_constc = con_const;                                                     % Id del  constraints para opcion cancelar
%------------------- CODIGO PARA CENTRAR EL GUIDE ----------------
centrar_guide                                                               % Llama script que centra el guide
%-------------------Cargar Datos -------------------------
if isempty(vn_const) == 1
    set(lis_cons,'string','NULL');                                           % Carga lista de constraints
else
    set(lis_cons,'string',vn_const(:,2));                                    % Carga lista de constraints
end    
l_con_Callback(hObject, eventdata, handles);                                % Corre programa de lista
handles.output = hObject;
guidata(hObject, handles);

function varargout = Definir_Constraints_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_addnewmat_Callback(hObject, eventdata, handles)
global eve_const con_const op_non
con_const = con_const+1;                                                % Constador de constraints
eve_const = 1;                                                              % Evento para cuando se quiera agregar un nuevo constraints
op_non = 1; etinodo_act();  % Etiqueta de nodo
Constraints;                                                   % Abre guide propiedades de los constraints

function b_modmat_Callback(hObject, eventdata, handles)
global eve_const vn_const op_con lis_cons
eve_const = 2;                                                              % Evento para cuando quiera ver o modificar constraints
if isempty(vn_const) == 0
    op_con = get(lis_cons,'value');                                          % Identifica constraints a mostrat
    Constraints;                                                            % Abre guide propiedades de los constraints
end

function b_delmat_Callback(hObject, eventdata, handles)
global lis_cons vn_const 
min_mat = size(vn_const,1);                                                 % Para que siempre se quede un elemento
val_mat = get(lis_cons,'value');                                             % Identifica constraints a borrar
vn_const(val_mat,:)=[];                                                     % Borra fila del nodo seleccionado
if min_mat > 1 
    if val_mat == 1
        val_mat = 2;                                                        % Evita eror de caja de lista en valor final             
    end
    set(lis_cons,'value',val_mat-1);                                         % Carga lista de constraints
    set(lis_cons,'string',vn_const(:,2));                                      % Carga lista de constraints    
else
    set(lis_cons,'value',1);                                                 % Carga lista de constraints
    set(lis_cons,'string','NULL');                                           % Carga lista de constraints
end
l_con_Callback(hObject, eventdata, handles)

function b_cancelar_Callback(hObject, eventdata, handles)
global vn_const con_const vn_constc con_constc op_non
vn_const = vn_constc;                                                       % Etiqueta de constraints guardado para opcion de cancelar
con_const = con_constc;                                                     % Id del constraints para opcion cancelar
op_non = 0; etinodo_act();  % Etiqueta de nodo
close(Definir_Constraints);

function b_ok_Callback(hObject, eventdata, handles)
global op_non
op_non = 0; etinodo_act();  % Etiqueta de nodo
close(Definir_Constraints);

function l_con_Callback(hObject, eventdata, handles)
global lis_cons vn_const                                                     % Reconoce el boton borrar
a = get(lis_cons,'value');                                                   % Obtiene constraints elejido
if isempty(vn_const) == 1 %| isempty(vn_const{a,4}) == 0                     % Revisa si contiene SLAVE o datos para manejar boton borrar
    set(handles.b_delmat,'enable','off');                                   % Desactiva boton borrar
else
    set(handles.b_delmat,'enable','on');                                    % Aciva boton borrar
end
%----------------- No Programada ------------------------
function l_con_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lis_mat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton6_Callback(hObject, eventdata, handles)

function lis_mat_Callback(hObject, eventdata, handles)
