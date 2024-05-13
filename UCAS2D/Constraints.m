function varargout = Constraints(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Constraints_OpeningFcn, ...
                   'gui_OutputFcn',  @Constraints_OutputFcn, ...
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

function Constraints_OpeningFcn(hObject, eventdata, handles, varargin)
global eve_const con_const vn_const vn_obj op_con
che_con = [handles.c_tx handles.c_ty handles.c_rot];
%--------------- Inicializacion de guide con constraionts nuevo
set(handles.p_const,'string',vn_obj(:,2));                              % Carga de posibles nodos master
if eve_const == 1                                                           % Opcion de Constraints Nuevo
    set(handles.e_caso,'string',strcat('CASO_',num2str(con_const)));        % Label de caso
elseif eve_const == 2                                                       % Opcion de 
    set(handles.e_caso,'string',vn_const{op_con,2});                        % Label de caso
    a = find(vn_obj(:,1) == vn_const{op_con,3});                            % Busca Posisicon del nodo master en lista de nodos
    set(handles.p_const,'value',a);                                         % Carga nodo master
    a = vn_const{op_con,5};                                                 % Obtiene restricciones
    for i = 1:3                                                             % Colocacion de r
        set(che_con(i),'value',a(i));
    end    
end
%---------- Codigo para centrar guide ---------------------------
centrar_guide;
handles.output = hObject;
guidata(hObject, handles);

function varargout = Constraints_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
global eve_const con_const vn_const vn_obj op_con lis_cons
nom = get(handles.e_caso,'string');                                         % Extrae nombre del caso constraints
mas = get(handles.p_const,'value');                                         % 
res(1) = get(handles.c_tx,'value');
res(2) = get(handles.c_ty,'value');
res(3) = get(handles.c_rot,'value');
if isequal(res,[0 0 0]) == 0
    if eve_const == 1
        vn_const(end+1,:) = {con_const nom vn_obj(mas,1) [] res};
    elseif eve_const == 2
        vn_const(op_con,2:5) = {nom vn_obj(mas,1) [] res};
    end
    set(lis_cons,'string',vn_const(:,2));
end
eve_const = 0;
b_can_Callback(hObject, eventdata, handles);

function b_can_Callback(hObject, eventdata, handles)
close(Constraints);
%---------------- No Programado ---------------------
function c_tx_Callback(hObject, eventdata, handles)

function c_ty_Callback(hObject, eventdata, handles)

function c_rot_Callback(hObject, eventdata, handles)

function p_const_Callback(hObject, eventdata, handles)

function p_const_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_caso_Callback(hObject, eventdata, handles)

function e_caso_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
global eve_const con_const
if eve_const == 1 
    con_const = con_const -1;
end    
    
