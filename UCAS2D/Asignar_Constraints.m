function varargout = Asignar_Constraints(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Constraints_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Constraints_OutputFcn, ...
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

function Asignar_Constraints_OpeningFcn(hObject, eventdata, handles, varargin)
global lista_constra vn_const
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%---------------- Variable de elementos -----------------
lista_constra = handles.l_constra;                                          % Guarda elemento list box para mostrar constraints
%--------------- Cargar lista de Secciones --------------
if isempty(vn_const) == 0
    set(lista_constra,'string',vn_const(:,2));                                    % Carga lista de secciones
    set(lista_constra,'value',1);                                                  % Carga lista de secciones
end
%---------- Codigo para centrar guide ------------
centrar_guide;
%--------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Constraints_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function l_constra_Callback(hObject, eventdata, handles)

function b_ok_Callback(hObject, eventdata, handles)
b_api_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Constraints);

function b_api_Callback(hObject, eventdata, handles)
global nod_sel vn_const lista_constra vn_coor
if isempty(nod_sel) == 0 & isempty(vn_const) == 0                 % Asignara nodos seleccionados
    a = get(lista_constra,'value');                               % Selecciona el caso
    n_esc = [];
    for i = 1: size(nod_sel)
        escla = nod_sel(i,1);
        cons = vn_const{a,5};
        s1 = find(vn_const{a,4} == escla);
        res = vn_coor(find(vn_coor(:,1) == escla),4:9);
        s2 = 1;
        for j = 1:3
            if (res(j) == 1 | res(j+3) ~= 0) & cons(j) == 1
                s2 = 0;
            end
            %
            %if res(j+3) ~= 0 & cons(j) == 1
            %    s2 = 0;
            %end
        end
        if isempty(s1) == 1 & s2 == 1
            n_esc(end+1) = escla;
        end
    end    
    vn_const(a,4) = {[vn_const{a,4} n_esc]};              % Anexa nuevos esclavos      
end
desel();                                                          % Deseleccionar Nodos

function b_bor_Callback(hObject, eventdata, handles)
global nod_sel vn_const 
if isempty(nod_sel) == 0 & isempty(vn_const) == 0   % Asignara nodos seleccionados
    for i = 1:size(vn_const(:,4),1)                 % Analiza cada caso
        escla = vn_const{i,4};                      % Saca nodos esclavos
        [C,ia]=intersect(escla,nod_sel(:,1));       % Busca constraints en comuna 
        if isempty(ia) == 0                         % Ve si existen nodos aplicados
            escla(ia) = [];                         % Elimina nodos en el caso
            vn_const(i,4) = {escla};                % Modifica lista
        end
    end
end
desel();                                                          % Deseleccionar Nodos
%--------------------------- No Programado --------------------------------
function l_constra_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
