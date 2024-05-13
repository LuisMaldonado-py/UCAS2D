function varargout = Grafica_Pushover_Porticos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grafica_Pushover_Porticos_OpeningFcn, ...
                   'gui_OutputFcn',  @Grafica_Pushover_Porticos_OutputFcn, ...
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

function Grafica_Pushover_Porticos_OpeningFcn(hObject, eventdata, handles, varargin)
global p GDL graf_rot res_obj axe_dibujo
t = title(handles.p_pus,'Curva Pushover');
set(t,'color',[0.18 0.17 0.55],'FontWeight','Normal','FontName','Times New Roman','FontSize',15);
ty = ylabel(handles.p_pus,'Carga en la Estructura P (Tonf)');
set(ty,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontAngle','italic','FontSize',10);
tx = xlabel(handles.p_pus,'Desplazamiento en GDL (cm)');
set(tx,'color',[0.18 0.17 0.55],'FontName','Times New Roman','FontAngle','italic','FontSize',10);
set(handles.p_GDL,'String',p); %Agregar al popupmenu los GDL p
set(handles.p_GDL,'Value',find(p(GDL)==p)); %GDL de control
handles.output = hObject;
guidata(hObject, handles);

function varargout = Grafica_Pushover_Porticos_OutputFcn(hObject, eventdata, handles) 
global U1g P1g resortes Ef
cla(handles.p_pus);
hold on
if length(resortes)>10
    parar=0.25;
else
    parar=0.5;
end
for i=1:size(Ef,2)
    plot(handles.p_pus,U1g([i i+1]),P1g([i i+1]),'r-o');
    pause(parar)
end
varargout{1} = handles.output;


% --- Executes on button press in b_ok.
function b_ok_Callback(hObject, eventdata, handles)
global resortes P1g up_toa Ef axe_dibujo res_obj graf_rot txr long CONN2

axes(axe_dibujo); hold on
try delete(res_obj); delete(txr); end
res_obj=[]; txr=[];
pro_lon = mean(long(find(long>0)));
for i=1:size(graf_rot,1)
    res_obj = [res_obj scatter(graf_rot(i,1),graf_rot(i,2),50,'g','filled')];
    set(res_obj(i),'DisplayName',strcat('r',num2str(graf_rot(i,3))));
    txr = [txr text(graf_rot(i,1)+pro_lon*0.05,graf_rot(i,2)+pro_lon*0.05,...
        num2str(CONN2(graf_rot(i,3),3)),'Color','g')];
end

cla(handles.p_pus);
pos=get(handles.p_GDL,'Value');
rb_completa = get(handles.rb_completa,'Value');
rb_iteracion = get(handles.rb_iteracion,'Value');
ite=get(handles.lis_iteracion,'Value');
hold on
if length(resortes)>10
    parar=0.25;
else
    parar=0.5;
end
if rb_completa==1 rt=size(Ef,2); else rt=ite; end
for i=1:rt
    plot(handles.p_pus,[up_toa{i}(pos) up_toa{i+1}(pos)],P1g([i i+1]),'r-o');
    if rb_completa==1 pause(parar); end
end


% --- Executes on button press in b_cer.
function b_cer_Callback(hObject, eventdata, handles)
global txr res_obj
try delete(txr); delete(res_obj); end
close(Grafica_Pushover_Porticos);      % Cerrar interfaz actual


% --- Executes on button press in b_imp.
function b_imp_Callback(hObject, eventdata, handles)
% hObject    handle to b_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in p_GDL.
function p_GDL_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function p_GDL_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_completa.
function rb_completa_Callback(hObject, eventdata, handles)
set(handles.rb_iteracion,'Value',0);
set(handles.lis_iteracion,'Visible','Off');

% --- Executes on button press in rb_iteracion.
function rb_iteracion_Callback(hObject, eventdata, handles)
global Ef
set(handles.rb_completa,'Value',0);
set(handles.lis_iteracion,'String',1:length(Ef));
set(handles.lis_iteracion,'Visible','On');

% --- Executes on selection change in lis_iteracion.
function lis_iteracion_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function lis_iteracion_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
