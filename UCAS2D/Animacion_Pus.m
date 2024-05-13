function varargout = Animacion_Pus(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Animacion_Pus_OpeningFcn, ...
                   'gui_OutputFcn',  @Animacion_Pus_OutputFcn, ...
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

function Animacion_Pus_OpeningFcn(hObject, eventdata, handles, varargin)
global vn_coor_o vn_coor Ef
set(handles.lista_iteraciones,'String',1:length(Ef));
set(handles.lista_iteraciones,'Enable','Off');
vn_coor(:,[2 3]) = vn_coor_o; %comienza con coor originales
%--------------------------------------------------------------------------
set(handles.figure1,'visible','on');                % Pone visible al guide
WinOnTop(handles.figure1,true);                     % Envia adelante al guide
Grafica_Ani_Pushover_Armaduras;         % Abre interfaz de grafica
handles.output = hObject;
guidata(hObject, handles);

function varargout = Animacion_Pus_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function rb_iteracion_Callback(hObject, eventdata, handles)
set(handles.rb_completo,'Value',0);
set(handles.lista_iteraciones,'Enable','On');

function rb_completo_Callback(hObject, eventdata, handles)
set(handles.rb_iteracion,'Value',0);
set(handles.lista_iteraciones,'Enable','Off');

function b_aplicar_Callback(hObject, eventdata, handles)
global graf_rotu graf_rot axe_dibujo res_obj Ef resortes ve_obj vn_coor ve_conex u_toa
global xdat_o ydat_o vn_coor_o CONN2
global U1g P1g axe_pua t_gpa % Datos de UIg = desplzamineto nodo de control / P1g = carga

%% ----------------- 2 PANTALLA --------------------
%% ----------------- 2 PANTALLA --------------------   
try; cla(axe_pua,'reset'); curve = animatedline(axe_pua,'color','r','Marker','s','LineWidth',1)...
        ;addpoints(curve,0,0);set(t_gpa,'string',{"u : 0","P : 0"});end;  % Resetea axes / Crea curva
%% -------------------------------------------------
try delete(graf_rotu); delete(res_obj); end 
res_obj=[]; vn_coor(:,[2 3])=vn_coor_o;
rb_completo=get(handles.rb_completo,'Value');
rb_iteracion=get(handles.rb_iteracion,'Value');
iteracion=get(handles.lista_iteraciones,'Value');
axes(axe_dibujo); hold on
for i=1:size(graf_rot,1)
    res_obj = [res_obj scatter(graf_rot(i,1),graf_rot(i,2),50,'g','filled')];
    set(res_obj(i),'DisplayName',strcat('r',num2str(graf_rot(i,3))));
end

% if length(Ef)>10
%     parar=0;
% else
%     parar=0;
% end

if rb_completo==1 rt=size(Ef,2); else rt=iteracion; end
for i=1:rt %iteracion
    vn_coor(:,2)=vn_coor(:,2)+u_toa{i+1}(1:3:3*size(vn_coor,1)-2); %solo en x
    zoom_rest();
%% ------- Estructura --------- 
    for e=1:size(ve_obj,1) %elemento
        ni = ve_conex(ve_obj(e,1),2); nf = ve_conex(ve_obj(e,1),3);
        set(ve_obj(e,3),'XData',[vn_coor(ni,2) vn_coor(nf,2)]);
        m = (vn_coor(nf,2)-vn_coor(ni,2))/(vn_coor(nf,3)-vn_coor(ni,3))    %pend inv
        res_e = find(e==graf_rot(:,4)); %resortes en elemento
        for reso=1:size(res_e)   %resorte
            xr = get(res_obj(res_e(reso)),'XData'); yr = get(res_obj(res_e(reso)),'YData');
            ni_r = CONN2(graf_rot(res_e(reso),3),2);
            if m~=Inf %rotula en columna
                set(res_obj(res_e(reso)),'XData',(yr-vn_coor(ni,3))*m+vn_coor(ni,2));
            else           %rotula en viga
                set(res_obj(res_e(reso)),'XData',xr+u_toa{i+1}(3*ni_r-2));
            end
        end
    end
    for k=1:length(Ef{i})
        rot=findobj(axe_dibujo,'DisplayName',strcat('r',num2str(Ef{i}(k))));
        set(rot,'MarkerEdgeColor','r','MarkerFaceColor','r')
    end
%     if rt==size(Ef,2) pause(parar); end
%% --------- Curva ------------ 
    try
        ley = {strcat("u : ",num2str(U1g(i+1))),strcat("P : ",num2str(P1g(i+1)))};  % Crea String % U1g P1
        set(t_gpa,'string',ley);                % Crea Text
        addpoints(curve,U1g(i+1),P1g(i+1));                                     % Grafica curva
        drawnow; end;
end

function b_cerrar_Callback(hObject, eventdata, handles)
global ve_obj vn_coor_o vn_coor ve_conex res_obj txr
try delete(res_obj); delete(txr); end
vn_coor(:,[2 3])=vn_coor_o;
for i=1:size(ve_obj,1)
    ni = ve_conex(ve_obj(i,1),2); nf = ve_conex(ve_obj(i,1),3);
    set(ve_obj(i,3),'XData',[vn_coor(ni,2) vn_coor(nf,2)]);
end
zoom_rest();
close(Animacion_Pus)

function figure1_CloseRequestFcn(hObject, eventdata, handles) %NO ENTRA AQUI
global ve_obj vn_coor_o vn_coor ve_conex res_obj txr
try delete(res_obj); delete(txr); end 
vn_coor(:,[2 3])=vn_coor_o;
for i=1:size(ve_obj,1)
    ni = ve_conex(ve_obj(i,1),2); nf = ve_conex(ve_obj(i,1),3);
    set(ve_obj(i,3),'XData',[vn_coor(ni,2) vn_coor(nf,2)]);
end
zoom_rest();
try; close(Grafica_Ani_Pushover_Armaduras);end;
delete(hObject);
%% ----------------- NO PROGRAMADO -------------------------------
function lista_iteraciones_Callback(hObject, eventdata, handles)

function lista_iteraciones_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
