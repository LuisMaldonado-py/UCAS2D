function varargout = Tablas(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tablas_OpeningFcn, ...
                   'gui_OutputFcn',  @Tablas_OutputFcn, ...
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

function Tablas_OpeningFcn(hObject, eventdata, handles, varargin)
global tabla_res op_play op_nolin                         % Lista de opciones
set(handles.figure1,'visible','on');                % Pone visible al guide
WinOnTop(handles.figure1,true);                     % Envia adelante al guide
if op_play == 1
    l_opciones = {' Nodos' ' Conectividad' ' Propiedades del Material'...
        ' Propiedades de la Seccion' ' Desplazamientos Nodales'...
        ' Reacciones en los Nodos' ' Fuerzas Elementales Locales (P)'...
        ' Fuerzas Elementales Globales (F)'...
        ' Matrices de Rigidez Elemental Local (kL)'...
        ' Matrices de Rigidez Elemental Global (kG)'...
        ' Matriz de Rigidez Global de la Estructura (K)'...
        ' Grados de liberdad S' ' Grados de liberdad P' ' Matriz Kpp'...
        ' Matriz Kps' ' Matriz Ksp' ' Matriz Kss'};                              
else
    if op_nolin == 1
        l_opciones = {' Nodos' ' Conectividad' ' Propiedades del Material'...
        ' Propiedades de la Seccion' ' Pushover Nodo Control'...
        ' Orden de Fluencia'};  % Pushover Nodos
    else
        l_opciones = {' Nodos' ' Conectividad' ' Propiedades del Material'...
            ' Propiedades de la Seccion' ' Datos Pushover Nodo Control' ...
            ' Orden de Fluencia'};
    end
end
set(handles.p_resul,'string',l_opciones);   % Carga lista de opciones pop_menu
tabla_res = handles.t_resul;                % Guarda variable global la tabla
set(tabla_res,'data',cell(4));              % Carga tabla vacia
set(tabla_res,'Columnname',{'';''});        % Carga nombre de columnas
opcion_tab(1);
handles.output = hObject;
guidata(hObject, handles);

function varargout = Tablas_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function p_resul_Callback(hObject, eventdata, handles)
opcion_tab(get(handles.p_resul,'value'));   % Opcion de tablas

function p_resul_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function b_exp_Callback(hObject, eventdata, handles)    % Exportar tablas
tab =  get(handles.t_resul,'data');     % Obtener tabla
if isa(tab,'double')                    % Obtiene tipo de variable
    tab = num2cell(tab);                % Transforma a tipo cell
end
C=get(handles.t_resul,'ColumnName')';   % Obtiene nombre de columnas
F=get(handles.t_resul,'RowName');       % Obtiene nombre de filas
if isempty(F) == 0                      % Si existe valores en filas
    C = [{''} C];                       % Combina vectores
    tab =[F tab]  
end
tab =[C ; tab];                         % Combina vectores
try                                     % Abre directorio y guarda archivos
    [file,path] = uiputfile('Tabla.xlsx','Exportar Tabla');
    filename = fullfile(path,file);
    xlswrite(filename,tab);
end
