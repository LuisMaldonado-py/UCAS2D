function varargout = Asignar_Carga_Distribuida_Elemental(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Carga_Distribuida_Elemental_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Carga_Distribuida_Elemental_OutputFcn, ...
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

function Asignar_Carga_Distribuida_Elemental_OpeningFcn(hObject, eventdata, handles, varargin)
global op_ade mag_text
%---------- Codigo para centrar guide ------------
centrar_guide;
set(handles.text19,'string',strcat("[",mag_text{1},"/",mag_text{2},"]"));% Coloca unidad de desfase
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%-----------Opcion de Asignar fuerzas Nodales-------------------------
op_ade = 2;                     % Bandera de agregar fuerzas activada
%----------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Carga_Distribuida_Elemental_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_def_Callback(hObject, eventdata, handles)
set(handles.e_w,'string','0');   %Valores por defecto
set(handles.e_a,'string','0');   %Valores por defecto
set(handles.e_b,'string','0');   %Valores por defecto

function b_ok_Callback(hObject, eventdata, handles)
b_apl_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Carga_Distribuida_Elemental);

function b_apl_Callback(hObject, eventdata, handles)
global op_ade ele_sel ve_w ve_obj op_ffp
if isempty(ele_sel) == 0                            % Revisa que verctor no este vacio
    w = str2num(get(handles.e_w,'string'));        % Lectura de fuerza en X
    a = str2num(get(handles.e_a,'string'));
    b = str2num(get(handles.e_b,'string'));
    n = get(handles.p_wdir,'value');
    switch op_ade 
        case 1                                          % Caso para agregar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                %ve_w(cod,2) = ve_w(cod,s) + w;          % Agrega fuerza en X
                ve_w(cod,(n*3)-1:(n*3)+1) = [w a b];    % Agrega momento en Z
            end
        case 2                                          % Caso para reemplazar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_w(cod,(n*3)-1:(n*3)+1) = [w a b];    % Agrega momento en Z
            end
        case 3                                          % Caso para borrar
            for i =1:size(ele_sel,1)
                cod = ele_sel(i,1);                     % Busca nodo codigo
                cod = find(ve_obj(:,1) == cod);         % Busca nodo posicion
                ve_w(cod,(n*3)-1:(n*3)+1) = [0 0 0];                    % Agrega momento en Z
            end
    end
    desel();                % Deseleccionar Nodos
end
op_ffp = 4;                             % Opcion para colocar cargas puntuales
vis_cargas();                           % Funcion para crear cargas

function r_a_Callback(hObject, eventdata, handles)
global op_ade 
set(handles.r_r,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_ade = 1;                     % Bandera de agregar fuerzas activada

function r_r_Callback(hObject, eventdata, handles)
global op_ade 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_ade = 2;                     % Bandera de agregar fuerzas activada

function r_b_Callback(hObject, eventdata, handles)
global op_ade 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_r,'value',0);     % Bloque opcion borrar
op_ade = 3;                     % Bandera de agregar fuerzas activada

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



function e_w_Callback(hObject, eventdata, handles)
% hObject    handle to e_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_w as text
%        str2double(get(hObject,'String')) returns contents of e_w as a double


% --- Executes during object creation, after setting all properties.
function e_w_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p_wdir.
function p_wdir_Callback(hObject, eventdata, handles)
% hObject    handle to p_wdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p_wdir contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p_wdir


% --- Executes during object creation, after setting all properties.
function p_wdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_wdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_a_Callback(hObject, eventdata, handles)
% hObject    handle to e_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_a as text
%        str2double(get(hObject,'String')) returns contents of e_a as a double


% --- Executes during object creation, after setting all properties.
function e_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_b_Callback(hObject, eventdata, handles)
% hObject    handle to e_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_b as text
%        str2double(get(hObject,'String')) returns contents of e_b as a double


% --- Executes during object creation, after setting all properties.
function e_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
