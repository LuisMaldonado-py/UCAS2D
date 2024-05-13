function varargout = Asignar_Propiedades_Modificables_en_Elementos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Propiedades_Modificables_en_Elementos_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Propiedades_Modificables_en_Elementos_OutputFcn, ...
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

function Asignar_Propiedades_Modificables_en_Elementos_OpeningFcn(hObject, eventdata, handles, varargin)
%---------- Codigo para centrar guide ------------
centrar_guide;
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
%----------------------------------------------
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Propiedades_Modificables_en_Elementos_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_def_Callback(hObject, eventdata, handles)
set(handles.e_st,'string','1');
set(handles.e_acx,'string','1');
set(handles.e_acy,'string','1');
set(handles.e_mix,'string','1');
set(handles.e_miy,'string','1');
set(handles.e_mpx,'string','1');
set(handles.e_mpy,'string','1');

function b_ok_Callback(hObject, eventdata, handles)
b_apli_Callback(hObject, eventdata, handles);
b_cer_Callback(hObject, eventdata, handles);

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Propiedades_Modificables_en_Elementos);

function b_apli_Callback(hObject, eventdata, handles)
global ve_pro ele_sel ve_obj op_eln
if isempty(ele_sel) == 0
    a(1) = str2num(get(handles.e_st,'string'));
    a(2) = str2num(get(handles.e_acx,'string'));
    a(3) = str2num(get(handles.e_acy,'string'));
    a(4) = str2num(get(handles.e_mix,'string'));
    a(5) = str2num(get(handles.e_miy,'string'));
    a(6) = str2num(get(handles.e_mpx,'string'));
    a(7) = str2num(get(handles.e_mpy,'string'));
    for i =1:size(ele_sel,1)
        cod = ele_sel(i,1);
        cod = find(ve_obj(:,1) == cod);
        ve_pro(cod,2:8) = a;
    end
    desel()
    op_eln = 4;                                 % Opcion de mostrar etiqueta modificacion propiedades
    etiele_act();                               % Funcion para crear etiqueta de elementos
end

function e_st_Callback(hObject, eventdata, handles)

function e_st_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_acx_Callback(hObject, eventdata, handles)

function e_acx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_acy_Callback(hObject, eventdata, handles)

function e_acy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_mix_Callback(hObject, eventdata, handles)

function e_mix_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_miy_Callback(hObject, eventdata, handles)

function e_miy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_mpx_Callback(hObject, eventdata, handles)
% hObject    handle to e_mpx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_mpx as text
%        str2double(get(hObject,'String')) returns contents of e_mpx as a double


% --- Executes during object creation, after setting all properties.
function e_mpx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_mpx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_mpy_Callback(hObject, eventdata, handles)
% hObject    handle to e_mpy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_mpy as text
%        str2double(get(hObject,'String')) returns contents of e_mpy as a double


% --- Executes during object creation, after setting all properties.
function e_mpy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_mpy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
