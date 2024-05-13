function varargout = Informacion_del_Nodo(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Informacion_del_Nodo_OpeningFcn, ...
                   'gui_OutputFcn',  @Informacion_del_Nodo_OutputFcn, ...
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

function Informacion_del_Nodo_OpeningFcn(hObject, eventdata, handles, varargin)
global sub_s vn_obj vn_coor vn_fx vn_fy vn_fg vn_const
%---------- Codigo para centrar guide ------------
centrar_guide;
%----------- Cargar informacion -------------------------
lab = vn_obj(sub_s,2);                                                      % Etiqueta
x = vn_coor(sub_s,2); y = vn_coor(sub_s,3);                                 % Coordenadas nodo
res = vn_coor(sub_s,4:6);                                                   % Restriccion
fx = vn_fx(sub_s,2); fy = vn_fy(sub_s,2); mz = vn_fg(sub_s,2);              % Carga en el nodo
ux = vn_coor(sub_s,7); uy = vn_coor(sub_s,8); uz = vn_coor(sub_s,9);              % Carga en el nodo
%---------- Colocacion de informacion ------------------------
set(handles.t_neti,'string',num2str(lab));
set(handles.t_x,'string',num2str(x));
set(handles.t_y,'string',num2str(y));
rest = '';
a = 0; 
%% ---------------- Apoyo ---------------------
if isequal(vn_coor(sub_s,4:9),[0 0 0 0 0 0])                                                % Nodo Libre
    rest = 'Libre';                                                                         % Texto de Nodo Libre
elseif isequal(vn_coor(sub_s,4:6),[0 0 0]) & ~isequal(vn_coor(sub_s,7:9),[0 0 0])           % Resorte
    r = {'kx' 'ky' 'kz'};                                                                   % Tipo de Restriccion
    rest = strcat("Elas (",string(join(r(1,find(vn_coor(sub_s,7:9)~= 0)),{', '})),")");     % Texto de resorte
    set(handles.tk,'string','Rigideces Nodales');set(handles.tkx,'string','Rigidez en X');  % Cambio de texto en statics text
    set(handles.tky,'string','Rigidez en Y');set(handles.tkz,'string','Rigidez en Z');
elseif ~isequal(vn_coor(sub_s,4:6),[0 0 0])                                                 % Apoyo
    r = {'ux' 'uy' 'uz'};                                                                   % Tipo de Restriccion
    rest = strcat("Fijo (",string(join(r(1,find(vn_coor(sub_s,4:6)== 1)),{', '})),")");     % Texto de apoyo
end 
%% --------------- Constraints ----------------
const = 'None';
if ~isempty(vn_const)
    m = ''; s = '';
    if find(cell2mat(vn_const(:,3))== sub_s)
        m = 'Master';
    end
    for i = 1:size(vn_const(:,4),1)
        if find(vn_const{i,4} == sub_s)
            s = 'Slave';
        end
    end
    const = strcat(m,s);
    if ~isempty(m) & ~isempty(s)
        const = strcat(m," - ",s);
    elseif isempty(m) & isempty(s)
        const = 'None';
    end   
end
%% --------------------------------------------
set(handles.t_res,'string',rest);
set(handles.t_con,'string',const);
set(handles.t_fx,'string',num2str(fx));
set(handles.t_fy,'string',num2str(fy));
set(handles.t_mz,'string',num2str(mz));
set(handles.t_ux,'string',num2str(ux));
set(handles.t_uy,'string',num2str(uy));
set(handles.t_uz,'string',num2str(uz));
handles.output = hObject;
guidata(hObject, handles);

function varargout = Informacion_del_Nodo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
close(Informacion_del_Nodo);

function b_cerrar_Callback(hObject, eventdata, handles)
close(Informacion_del_Nodo);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
global obj_sel
delete(obj_sel);
