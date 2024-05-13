function varargout = Importar_seccion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Importar_seccion_OpeningFcn, ...
                   'gui_OutputFcn',  @Importar_seccion_OutputFcn, ...
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

function Importar_seccion_OpeningFcn(hObject, eventdata, handles, varargin)
global unit
%------------------- CODIGO PARA CENTRAR EL GUIDE ----------------
centrar_guide                                                               % Llama script que centra el guide
%-------------------- Base de Datos AISC -------------------------
AISC_P
%------------------------------------------------------------------
unit = 1;                                                                   % Conversion de unidades, activado en cm
%------------------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Importar_seccion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function p_tipo_Callback(hObject, eventdata, handles)
global per_w per_s per_hp per tip_s
tip_s = get(handles.p_tipo,'Value');
switch tip_s
    case 1
        per = {'Perfil' 'Perfil'};
    case 2
        per = per_w;
    case 3
        per = per_s;
    case 4
        per = per_hp;
end
set(handles.p_perfil,'Value',1);
set(handles.p_perfil,'string',per(:,2));

function check_selec_Callback(hObject, eventdata, handles)
vis = get(handles.check_selec,'value');
if vis == 1
    set(handles.b_imp,'enable','on');
    set(handles.check_base,'value',0);
    set(handles.p_tipo,'enable','off');
    set(handles.p_perfil,'enable','off');
end    

function b_cancelar_Callback(hObject, eventdata, handles)
close(Importar_seccion);                                                    % Cierra guide actual

function b_ok_Callback(hObject, eventdata, handles)                                                   
global per tip_s lista_sec con_sec vm_eti vs_eti vs_geo vs_pro unit
if tip_s == 2 | tip_s == 3 | tip_s == 4                                     % Evita error de elejir texto inicales en pop menu
    con_sec = con_sec + 1;                                                  % Id de la seccion
    per_car = get(handles.p_perfil,'value')                                 % Obtiene perfiles AISC elejido
    vs_eti(end+1,:) = {con_sec per{per_car,2} [1 1 0] 2 1 vm_eti{1,1}};           	% Diccionario de secciones vs_eti = {Cods Name Color Tip importar Codm]
    perv = cell2mat(per(per_car,3:13))
    vs_geo(end+1,:) = [con_sec perv(1,1:4).*unit];                                  % Secciones por defecto Vs_geo1 o 2 =[Cods h b] - Vs_geo2 = [Cods h tw bf tf] 
    vs_pro(end+1,:) = [con_sec perv(1,1).*unit perv(1,3).*unit perv(1,5:7).*(unit^2) perv(1,8:9).*(unit^4) perv(1,10:11).*(unit^3)];      %Secciones por defecto propiedades Vs_pro = [Cods h b A Acx Acy Ix Iy Zx ZY]
    set(lista_sec,'string',vs_eti(:,2));                                    % Carga lista de secciones
end 
close(Importar_seccion);                                                    % Cierra Guide actual  
%----------------------- No Programada -----------------------
function popupmenu4_CreateFcn(hObject, eventdata, handles)

function b_imp_Callback(hObject, eventdata, handles)

function p_tipo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function p_perfil_Callback(hObject, eventdata, handles)

function p_perfil_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function check_base_Callback(hObject, eventdata, handles)

function p_uni_Callback(hObject, eventdata, handles)
global unit                                                                 % Factor de conversion
a = get(handles.p_uni,'value');
switch a
    case 1                                                                  % Pulgadas
        unit = 0.3937;
    case 2                                                                  % Pies
        unit = 0.0328;
    case 3                                                                  % Milimetros
        unit = 10;
    case 4                                                                  % Centimetros
        unit = 1;
    case 5                                                                  % Metros
        unit = 0.1;    
end

function p_uni_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
