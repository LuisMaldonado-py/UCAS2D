function varargout = Elemento(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Elemento_OpeningFcn, ...
                   'gui_OutputFcn',  @Elemento_OutputFcn, ...
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

function Elemento_OpeningFcn(hObject, eventdata, handles, varargin)
global vs_eti pop_esec pop_etip
%---------- Codigo para centrar guide ------------
centrar_guide;
%-----------------------------------------------
pop_esec = handles.lise_sec;                                        % Guarda pop menu de secciones
pop_etip = handles.lise_tip;                                        % Guarda pop menu de tipo de elemento
set(pop_esec,'string',vs_eti(:,2));                                 % Carga seccion
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%--------------------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Elemento_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%------------- No Programado --------------------------------
function lise_tip_Callback(hObject, eventdata, handles)

function lise_tip_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lise_sec_Callback(hObject, eventdata, handles)

function lise_sec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lise_tip_KeyPressFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
global ln band_ele n_nodo band_rej
band_ele = 0;band_rej = 0;
if n_nodo == 2 
    delete(ln);
    n_nodo = 1;
end  
