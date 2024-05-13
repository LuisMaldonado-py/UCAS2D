function varargout = Asignar_Desplazamientos_Nodales(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Desplazamientos_Nodales_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Desplazamientos_Nodales_OutputFcn, ...
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

function Asignar_Desplazamientos_Nodales_OpeningFcn(hObject, eventdata, handles, varargin)
global op_adn mag_text
%---------- Codigo para centrar guide ------------
centrar_guide;
set(handles.text7,'string',strcat("[",mag_text{2},"]"));% Coloca unidad de desfase
set(handles.text8,'string',strcat('[',mag_text{2},']'));% Coloca unidad de desfase
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%-----------Opcion de Asignar fuerzas Nodales-------------------------
op_adn = 2;                     % Bandera de agregar fuerzas activada
%----------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Desplazamientos_Nodales_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_def_Callback(hObject, eventdata, handles)
set(handles.e_1,'string','0');   %Valores por defecto
set(handles.e_2,'string','0');   %Valores por defecto
set(handles.e_3,'string','0');   %Valores por defecto

function b_ok_Callback(hObject, eventdata, handles)
b_apl_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Desplazamientos_Nodales);

function b_apl_Callback(hObject, eventdata, handles)
global op_adn nod_sel vn_obj vn_coor op_ffp
if isempty(nod_sel) == 0                            % Revisa que vector no este vacio
    d(1) = str2num(get(handles.e_1,'string'));        % Lectura de fuerza en X
    d(2) = str2num(get(handles.e_2,'string'));        % Lectura de fuerza en Y
    d(3) = str2num(get(handles.e_3,'string'));        % Lectura de momento en Z
%% -------- Apoyos Elasticos ---------------

%% -----------------------------------------
    switch op_adn 
        case 1                                          % Caso para agregar
            for i =1:size(nod_sel,1)
                cod = nod_sel(i,1);                     % Busca nodo codigo
                cod = find(vn_obj(:,1) == cod);         % Busca nodo posicion
                if isequal(vn_coor(cod,4:6),[0 0 0]) == 0 & isequal(vn_coor(cod,7:9),[0 0 0]) == 1 
                    r = d.*vn_coor(cod,4:6);
                    vn_coor(cod,7:9) = vn_coor(cod,7:9) + r;
                end 
            end
        case 2                                          % Caso para reemplazar
            for i =1:size(nod_sel,1)
                cod = nod_sel(i,1);                     % Busca nodo codigo
                cod = find(vn_obj(:,1) == cod);         % Busca nodo posicion
                if isequal(vn_coor(cod,4:6),[0 0 0]) == 0 & isequal(vn_coor(cod,7:9),[0 0 0]) == 1 
                    r = d.*vn_coor(cod,4:6);
                    vn_coor(cod,7:9) = r;
                end 
            end
        case 3                                          % Caso para borrar
            for i =1:size(nod_sel,1)
                cod = nod_sel(i,1);                     % Busca nodo codigo
                cod = find(vn_obj(:,1) == cod);         % Busca nodo posicion
                if isequal(vn_coor(cod,4:6),[0 0 0]) == 0 & isequal(vn_coor(cod,7:9),[0 0 0]) == 1  
                    vn_coor(cod,7:9) = [0 0 0];             % Agrega desplazamiento nulos
                end 
            end
    end
    desel();                % Deseleccionar Nodos
end
op_ffp = 2;                             % Opcion para colocar desplazamientos puntuales
vis_cargas();                           % Funcion para crear cargas

function r_a_Callback(hObject, eventdata, handles)
global op_adn 
set(handles.r_r,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_adn = 1;                     % Bandera de agregar desplazamiento

function r_r_Callback(hObject, eventdata, handles)
global op_adn 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_b,'value',0);     % Bloque opcion borrar
op_adn = 2;                     % Bandera de reemplazar desplazamiento

function r_b_Callback(hObject, eventdata, handles)
global op_adn 
set(handles.r_a,'value',0);     % Bloque opcion reemplazar
set(handles.r_r,'value',0);     % Bloque opcion borrar
op_adn = 3;                     % Bandera de borrar desplazamiento

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
