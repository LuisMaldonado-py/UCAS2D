function varargout = Asignar_Releases(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Asignar_Releases_OpeningFcn, ...
                   'gui_OutputFcn',  @Asignar_Releases_OutputFcn, ...
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

function Asignar_Releases_OpeningFcn(hObject, eventdata, handles, varargin)
global che_rel c_rel1 c_rel2 c_rel3 c_rel4 c_rel5 c_rel6
%---------- Codigo para centrar guide ------------
centrar_guide;
c_rel1 = handles.c_1;
c_rel2 = handles.c_2;
c_rel3 = handles.c_3;
c_rel4 = handles.c_4;
c_rel5 = handles.c_5;
c_rel6 = handles.c_6;
%------------ CODIGO PARA GUIDE SIEMPRE ADELANTE ----------------
set(handles.figure1,'visible','on');                                        % Pone visible al guide
WinOnTop(handles.figure1,true);                                             % Envia adelante al guide
handles.output = hObject;
guidata(hObject, handles);

function varargout = Asignar_Releases_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%----------- No Programada ---------------------
function b_res_Callback(hObject, eventdata, handles)
global che_rel c_rel1 c_rel2 c_rel3 c_rel4 c_rel5 c_rel6
che_rel = [c_rel1 c_rel2 c_rel3 c_rel4 c_rel5 c_rel6];
for i = 1:6
    set(che_rel(i),'value',0);
end    

function b_ok_Callback(hObject, eventdata, handles)
b_apl_Callback(hObject, eventdata, handles)
b_cer_Callback(hObject, eventdata, handles)

function b_cer_Callback(hObject, eventdata, handles)
close(Asignar_Releases);

function b_apl_Callback(hObject, eventdata, handles)
global ve_rel ele_sel ve_obj che_rel c_rel1 c_rel2 c_rel3 c_rel4 c_rel5 c_rel6 op_rel
che_rel = [c_rel1 c_rel2 c_rel3 c_rel4 c_rel5 c_rel6];
b  = [];
if isempty(ele_sel) == 0
    for i = 1:6
        a = get(che_rel(i),'value');
        if a == 1
            b(1,end+1) = i;
        end    
    end
    for i =1:size(ele_sel,1)
        cod = ele_sel(i,1);
        cod = find(ve_obj(:,1) == cod);
        ve_rel(cod,2) = {b};
    end
    desel();
end
op_rel = 1;
rel_act();

function c_1_Callback(hObject, eventdata, handles)

function c_4_Callback(hObject, eventdata, handles)

function c_2_Callback(hObject, eventdata, handles)

function c_5_Callback(hObject, eventdata, handles)

function c_3_Callback(hObject, eventdata, handles)

function c_6_Callback(hObject, eventdata, handles)
