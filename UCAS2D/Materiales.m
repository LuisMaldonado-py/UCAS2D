function varargout = Materiales(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Materiales_OpeningFcn, ...
                   'gui_OutputFcn',  @Materiales_OutputFcn, ...
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

function Materiales_OpeningFcn(hObject, eventdata, handles, varargin)
global vm_eti vm_pro lis_mat vm_etic vm_proc con_mat con_matc
%--------- Variables -----------------
lis_mat = handles.l_mat;                                                    % Guarda identificador de listbox de materiales
%---------- Datos para Opcion Cancelar -----------------------
vm_etic = vm_eti;                                                           % Etiqueta de material guardado para opcion de cancelar
vm_proc = vm_pro;                                                           % Material guardado para opcion de cancelar
con_matc = con_mat;                                                         % Id del material para opcion cancelar
%------------------- CODIGO PARA CENTRAR EL GUIDE ----------------
centrar_guide                                                               % Llama script que centra el guide
%-------------------Cargar Datos -------------------------
set(lis_mat,'string',vm_eti(:,2));                                        % Carga lista de materiales
l_mat_Callback(hObject, eventdata, handles);                                % Corre program de lista
handles.output = hObject;
guidata(hObject, handles);

function varargout = Materiales_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_addnewmat_Callback(hObject, eventdata, handles)
global eve_mat
eve_mat = 1;                                                                % Evento para cuando se quiera agregar un nuevo material
Propiedades_del_Material;                                                   % Abre guide propiedades de los materiales

function b_addcopymat_Callback(hObject, eventdata, handles)
global eve_mat val_mat vm_pro lis_mat
%if isempty(vm_pro) == 0                                                        % Evita error de vector vacios
    eve_mat = 2;                                                            % Evento para cuando se quiera agregar un nuevo material
    val_mat = get(lis_mat,'value');                                   % Material a copiar 
    Propiedades_del_Material;                                               % Abre guide propiedades de los materiales
%end

function b_modmat_Callback(hObject, eventdata, handles)
global eve_mat val_mat lis_mat
eve_mat = 3;                                                                % Evento para cuando se quiera agregar un nuevo material
val_mat = get(lis_mat,'value');                                       % Material a copiar 
Propiedades_del_Material;                                                   % Abre guide propiedades de los materiales

function b_delmat_Callback(hObject, eventdata, handles)
global lis_mat vm_pro vm_eti 
min_mat = size(vm_pro,1);                                                      % Para que siempre se quede un elemento
if min_mat > 1                                                              % Evita error de vector vacios
    val_mat = get(lis_mat,'value');                                   % Identifica material a borrar
    vm_eti(val_mat,:)=[];                                                    % Borra fila del nodo seleccionado
    vm_pro(val_mat,:)=[];                                                      % Borra material seleccionado
    if val_mat == 1
        val_mat = 2;                                                        % Evita eeror de caja de lista en valor final             
    end
    set(lis_mat,'value',val_mat-1);                                         % Carga lista de materiales
    set(lis_mat,'string',vm_eti(:,2));                                          % Carga lista de materiales
end

function b_cancelar_Callback(hObject, eventdata, handles)
global vm_etic vm_proc vm_pro vm_eti con_mat con_matc
vm_eti = vm_etic;                                                           % Carga etiquetas del material al iniciar
vm_pro = vm_proc;                                                           % Carga propiedades del material al iniciar
con_mat = con_matc;                                                         % Id del material al iniciar 
close(Materiales);

function b_ok_Callback(hObject, eventdata, handles)
close(Materiales);

%----------------- No Programada ------------------------

function l_mat_Callback(hObject, eventdata, handles)
global lis_mat vm_eti vs_eti
a = get(lis_mat,'value');                                                    % Obtiene material elejido
b = vm_eti{a,1};
c = find(cell2mat(vs_eti(:,end)) == b)
if isempty(c) == 0
    set(handles.b_delmat,'enable','off');
else
    set(handles.b_delmat,'enable','on');
end

function l_mat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lis_mat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton6_Callback(hObject, eventdata, handles)

function lis_mat_Callback(hObject, eventdata, handles)
