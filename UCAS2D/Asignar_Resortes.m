function varargout = Asignar_Resortes(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Resortes_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Resortes_OutputFcn, ...
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

function Asignar_Resortes_OpeningFcn(hObject, eventdata, handles, varargin)
global l_res
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);
try l_res(:,1); catch l_res={'Res1' 100 0 250}; end
set(handles.l_res,'string',l_res(:,1));
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Resortes_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function l_res_Callback(hObject, eventdata, handles)

function l_res_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function b_ok_Callback(hObject, eventdata, handles)
b_aplicar_Callback(hObject, eventdata, handles);
close(Asignar_Resortes);

function b_cerrar_Callback(hObject, eventdata, handles)
close(Asignar_Resortes);

function b_aplicar_Callback(hObject, eventdata, handles)
global ele_sel ve_conex op_eln
if ~isempty(ele_sel)
    id_r=get(handles.l_res,'value');
    for i=1:size(ele_sel,1)
        ve_conex(ele_sel(i,1),4)=-id_r;
    end
    desel();
    op_eln = 2;
    etiele_act();
end
        
    
    

