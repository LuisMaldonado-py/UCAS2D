function varargout = Comportamiento(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Comportamiento_OpeningFcn, ...
                   'gui_OutputFcn',  @Comportamiento_OutputFcn, ...
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

function Comportamiento_OpeningFcn(hObject, eventdata, handles, varargin)  
global vr_pro lis_mat vr_proc
vr_proc = vr_pro;                               % Realiza copia de curvas para boton cancelar
lis_mat = handles.l_rot;                        % Guarda identificador de listbox de curvas
if isempty(vr_pro) == 1                         % Si no hay curvas existentes
    set(handles.l_rot,'string','NULL');         % Carga lista vacia
else                                            % Si hay lista de curvas
    set(handles.l_rot,'string',vr_pro(:,2));    % Carga lista de curvas existentes
end 
centrar_guide;                                  % Llama script que centra el guide 
handles.output = hObject;
guidata(hObject, handles);

function varargout = Comportamiento_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_addnewmat_Callback(hObject, eventdata, handles)
global eve_mat
eve_mat = 1;        % Opcion Nueva Curva
Curva;              % Abre guide de Curvas de Comportamiento

function b_addcopymat_Callback(hObject, eventdata, handles)
global eve_mat vr_pro
if isempty(vr_pro) == 0     % Accion cuando exista curvas
    eve_mat = 2; Curva;     % Opcion copiar curva / Abre guide de Curvas de Comportamiento
end

function b_modmat_Callback(hObject, eventdata, handles)
global eve_mat vr_pro
if isempty(vr_pro) == 0     % Accion si existen curvas        
    eve_mat = 3; Curva;     % Opcion modificar o mostrar Curva / Abre guide de Curvas de Comportamiento
end

function b_delmat_Callback(hObject, eventdata, handles)     % Opcion para borrar curva
global vr_pro
if isempty(vr_pro) == 0 & size(vr_pro,1) > 1                % Si existe curvas / Deja que exista siempre 1 curva
    vr_pro(get(handles.l_rot,'value'),:)=[];                % Borra fila de curva seleccionada
    set(handles.l_rot,'value',1,'string',vr_pro(:,2));      % Carga value como 1 y lista nueva
    vr_pro(:,1)=num2cell((1:1:size(vr_pro,1)));             % Modifica numeracion de curvas o codigo
end 

function b_cancelar_Callback(hObject, eventdata, handles)
global vr_proc vr_pro
set(handles.l_rot,'value',1);   % Primera curva de la lista
vr_pro = vr_proc;               % Cancela valores creados y conserva valores iniciales
close(Comportamiento);          % Cierra guide de Curvas de Comportamiento

function b_ok_Callback(hObject, eventdata, handles)
close(Comportamiento);       % Cierra guide de Curvas de Comportamiento
%% ------------------------- No Programada --------------------------------
function l_rot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
function l_rot_Callback(hObject, eventdata, handles)
