function varargout = Asignar_Carga_de_Temperatura_Elemental(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Carga_de_Temperatura_Elemental_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Carga_de_Temperatura_Elemental_OutputFcn, ...
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

function Asignar_Carga_de_Temperatura_Elemental_OpeningFcn(hObject, eventdata, handles, varargin)
global op_ate mag_text
%---------- Codigo para centrar guide ------------
centrar_guide;
set(handles.text9,'string',strcat("[",mag_text{3},"]"));% Coloca unidad de desfase
set(handles.text10,'string',strcat('[',mag_text{3},']'));% Coloca unidad de desfase
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%-----------Opcion de Asignar fuerzas Nodales-------------------------
op_ate = 2;                     % Bandera de agregar fuerzas activada
%----------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Carga_de_Temperatura_Elemental_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_def_Callback(hObject, eventdata, handles)
set(handles.e_ts,'string','0');   %Valores por defecto
set(handles.e_ti,'string','0');   %Valores por defecto

function b_ok_Callback(hObject, eventdata, handles)
b_apl_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Carga_de_Temperatura_Elemental);

function b_apl_Callback(hObject, eventdata, handles)
global op_ate ele_sel ve_tem ve_obj op_ffp
if isempty(ele_sel) == 0                            % Revisa que verctor no este vacio
    ts = str2num(get(handles.e_ts,'string'));        % Lectura de fuerza en X
    ti = str2num(get(handles.e_ti,'string'));        % Lectura de fuerza en X
    switch op_ate 
        case 1                                          % Caso para agregar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_tem(cod,2) = ve_tem(cod,2) + ti;       % Agrega fuerza en X
                ve_tem(cod,3) = ve_tem(cod,3) + ts;       % Agrega fuerza en X
            end
        case 2                                          % Caso para reemplazar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_tem(cod,2) = ti;       % Agrega fuerza en X
                ve_tem(cod,3) = ts;       % Agrega fuerza en X
            end
        case 3                                          % Caso para borrar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_tem(cod,2) = 0;       % Agrega fuerza en X
                ve_tem(cod,3) = 0;       % Agrega fuerza en X
            end
    end
    desel();                % Deseleccionar Nodos
end
op_ffp = 5;                             % Opcion para colocar cargas puntuales
vis_cargas();                           % Funcion para crear cargas

function r_a_Callback(hObject, eventdata, handles)
global op_ate 
set(handles.r_r,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_ate = 1;                     % Bandera de agregar fuerzas activada

function r_r_Callback(hObject, eventdata, handles)
global op_ate 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_ate = 2;                     % Bandera de agregar fuerzas activada

function r_b_Callback(hObject, eventdata, handles)
global op_ate 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_r,'value',0);     % Bloque opcion borrar
op_ate = 3;                     % Bandera de agregar fuerzas activada

function e_1_Callback(hObject, eventdata, handles)

function e_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_2_Callback(hObject, eventdata, handles)

function e_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_3_Callback(hObject, eventdata, handles)

function e_3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_ti_Callback(hObject, eventdata, handles)
% hObject    handle to e_ti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_ti as text
%        str2double(get(hObject,'String')) returns contents of e_ti as a double


% --- Executes during object creation, after setting all properties.
function e_ti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_ti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_ts_Callback(hObject, eventdata, handles)
% hObject    handle to e_ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_ts as text
%        str2double(get(hObject,'String')) returns contents of e_ts as a double


% --- Executes during object creation, after setting all properties.
function e_ts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
