function varargout = Curvas_Elasto_Plasticas(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Curvas_Elasto_Plasticas_OpeningFcn, ...
                   'gui_OutputFcn',  @Curvas_Elasto_Plasticas_OutputFcn, ...
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

function Curvas_Elasto_Plasticas_OpeningFcn(hObject, eventdata, handles, varargin)
global lis_mat con_rotu vr_pro con_rotuc vr_proc
lis_mat = handles.l_rot;                        % Guarda identificador de listbox de materiales
con_rotuc = con_rotu; vr_proc = vr_pro;         % Variable de contador y propiedades de rotulas guardado para opcion cancelar
centrar_guide                                   % Llama script que centra el guide
if isempty(vr_pro) == 1
    set(lis_mat,'string','NULL');               % Carga lista de constraints
else
    set(lis_mat,'string',vr_pro(:,2));          % Carga lista de materiales
end 
l_rot_Callback(hObject, eventdata, handles);    % Corre programa de lista para actualizar
handles.output = hObject;
guidata(hObject, handles);

function varargout = Curvas_Elasto_Plasticas_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_addnewmat_Callback(hObject, eventdata, handles)
global eve_mat
eve_mat = 1;                            % Evento para cuando se quiera agregar una nueva curva
Propiedades_Curva_Elasto_Plastica;          % Abre guide Curva

function b_addcopymat_Callback(hObject, eventdata, handles)
global eve_mat val_mat lis_mat vr_pro
if isempty(vr_pro) == 0
    eve_mat = 2;                            % Evento para cuando se quiera agregar una copia de curva
    val_mat = get(lis_mat,'value');         % Curva a copiar 
    Propiedades_Curva_Elasto_Plastica;          % Abre guide Curva
end

function b_modmat_Callback(hObject, eventdata, handles)
global eve_mat val_mat lis_mat vr_pro
if isempty(vr_pro) == 0
    eve_mat = 3;                            % Evento para cuando quiera modificar Curva
    val_mat = get(lis_mat,'value');         % Curva a modificar
    Propiedades_Curva_Elasto_Plastica;          % Abre guide Curva
end

function b_delmat_Callback(hObject, eventdata, handles)
global lis_mat vr_pro
min_mat = size(vr_pro,1);                   % Para que siempre se quede un elemento
if min_mat > 1                              % Evita error de vector vacios
    val_mat = get(lis_mat,'value');         % Identifica material a borrar
    vr_pro(val_mat,:)=[];                   % Borra fila de rotula seleccionado
    if val_mat == 1
        val_mat = 2;                        % Evita error en lista en valor final             
    end
    set(lis_mat,'value',val_mat-1);         % Carga value como 1, porque siempre existe
    set(lis_mat,'string',vr_pro(:,2));      % Carga lista de rotula
end

function b_cancelar_Callback(hObject, eventdata, handles)
global con_rotu con_rotuc vr_proc vr_pro
set(handles.l_rot,'value',1);
con_rotu = con_rotuc; vr_pro = vr_proc;     % Cancela valores creados y conserva valores iniciales
close(Curvas_Elasto_Plasticas);                % Cerrar guide actual

function b_ok_Callback(hObject, eventdata, handles)
close(Curvas_Elasto_Plasticas);                % Cerrar guide actual

function l_rot_Callback(hObject, eventdata, handles)
global lis_mat vr_pro ve_rotu
a = get(lis_mat,'value');                   % Obtiene posicion rotula elejida
if isempty(vr_pro) == 0 & isempty(find(ve_rotu(:,2) == vr_pro{a,1})) == 0   % Evita error de vacios
    set(handles.b_delmat,'enable','off');
else
    set(handles.b_delmat,'enable','on');
end
%----------------- No Programada ------------------------
function l_rot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
