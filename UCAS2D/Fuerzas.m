function varargout = Fuerzas(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fuerzas_OpeningFcn, ...
                   'gui_OutputFcn',  @Fuerzas_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Fuerzas is made visible.
function Fuerzas_OpeningFcn(hObject, eventdata, handles, varargin)
global elem long CONN eq_C eq_A eq_V eq_M eq_D sub L subpartes Lo
global A_max V_max M_max D_max cerost_A cerost_V cerost_M ve_p ve_desf mag_text
elem=sub;
set(handles.Fuerzas,'Name',['Fuerzas del Elemento ',num2str(elem)]); % Cambio de nombre de GUI
cla(handles.a_equi); cla(handles.a_axial);
cla(handles.a_cort); cla(handles.a_momen); cla(handles.a_deflex);
hold(handles.a_equi,'on'); hold(handles.a_axial,'on');
hold(handles.a_cort,'on'); hold(handles.a_momen,'on'); hold(handles.a_deflex,'on')
%% DCL
V_ini=polyval(eq_V{elem}{1},0+ve_desf(elem,1)); V_fin=polyval(-eq_V{elem}{end},Lo(subpartes{elem}(end))-ve_desf(elem,2));
M_ini=polyval(eq_M{elem}{1},0+ve_desf(elem,1)); M_fin=polyval(-eq_M{elem}{end},Lo(subpartes{elem}(end))-ve_desf(elem,2));
%dibujar momento inicial 
scatter(handles.a_equi,-long(elem)/30,0,500,'k','LineWidth',2);
scatter(handles.a_equi,-long(elem)/30+2,0,500,'filled','w');
if M_ini>0 f_m=-0.60; else f_m=0.60; end
scatter(handles.a_equi,-long(elem)/30,f_m,'>','filled','k');

%dibujar momento final
scatter(handles.a_equi,long(elem)+long(elem)/30,0,500,'k','LineWidth',2);
scatter(handles.a_equi,long(elem)+long(elem)/30+2,0,500,'filled','w');
if M_fin>0 f_m=-0.60; else f_m=0.60; end
scatter(handles.a_equi,long(elem)+long(elem)/30,f_m,'>','filled','k');

%relleno carga
for j=1:size(subpartes{elem},2)
    e_f=subpartes{elem}(j);
    if j==1 v_ini=0+ve_desf(elem,1); else v_ini=v_fin; end
    v_fin=v_ini+L(e_f);
    fill(handles.a_equi,[v_ini v_ini v_fin v_fin],[0 eq_C{elem}{j}/eq_C{elem}{j} eq_C{elem}{j}/eq_C{elem}{j} 0],...
        [1 0 0],'LineStyle','none','FaceAlpha',.5);
end
line(handles.a_equi,[0 long(elem)],[0 0],'LineWidth',2,'Color',[0.5 0.5 0.5]);
%dibujar cortante inicial
line(handles.a_equi,[ve_desf(elem,1) ve_desf(elem,1)],[-1 -0.25],'LineWidth',2,'Color','k');
if V_ini>0 f_m=-0.25; f_v='^'; else f_m=-1; f_v='v'; end
scatter(handles.a_equi,ve_desf(elem,1),f_m,f_v,'filled','k');

%dibujar cortante final
line(handles.a_equi,[long(elem)-ve_desf(elem,2) long(elem)-ve_desf(elem,2)],[-1 -0.25],'LineWidth',2,'Color','k'); 
if V_fin>0 f_m=-0.25; f_v='^'; else f_m=-1; f_v='v'; end
scatter(handles.a_equi,long(elem)-ve_desf(elem,2),f_m,f_v,'filled','k')

%textos en cada dibujo
text(handles.a_equi,long(elem)/120+ve_desf(elem,1),-1,num2str(round(abs(V_ini),2)),...
    'FontSize',8,'FontWeight','bold');
text(handles.a_equi,long(elem)+long(elem)/120,-1,num2str(round(abs(V_fin),2)),...
    'FontSize',8,'FontWeight','bold');
text(handles.a_equi,-long(elem)/10,1,num2str(round(abs(M_ini),2)),'FontSize',8,...
    'FontWeight','bold');
text(handles.a_equi,long(elem),1,num2str(round(abs(M_fin),2)),'FontSize',8,...
    'FontWeight','bold');

%dibujar momento puntual
if ve_p(elem,8)~=0 & ve_p(elem,9)~=1 & ve_p(elem,9)~=0
scatter(handles.a_equi,long(elem)*ve_p(elem,9),0,500,'k','LineWidth',2);
if ve_p(elem,8)>0 f_m=-0.60; else f_m=0.60; end
scatter(handles.a_equi,long(elem)*ve_p(elem,9),f_m,'>','filled','k');
text(handles.a_equi,long(elem)*ve_p(elem,9),1,num2str(round(abs(ve_p(elem,8)),2)),'FontSize',8,...
    'FontWeight','bold');
end

%dibujar fuerza puntual
if ve_p(elem,5)~=0 & ve_p(elem,6)~=1 & ve_p(elem,6)~=0
line(handles.a_equi,[ve_p(elem,6) ve_p(elem,6)]*long(elem),[-1 -0.25],'LineWidth',2,'Color','k');
if ve_p(elem,5)>0 f_m=-0.25; f_v='^'; else f_m=-1; f_v='v'; end
scatter(handles.a_equi,ve_p(elem,6)*long(elem),f_m,f_v,'filled','k');
text(handles.a_equi,ve_p(elem,6)*long(elem)+5*2,-1,num2str(round(abs(ve_p(elem,5)),2)),'FontSize',8,...
    'FontWeight','bold');
end


%% Axial
Graficar_Fuerzas(cerost_A, eq_A, A_max, handles.a_axial)

%% Cortante
Graficar_Fuerzas(cerost_V, eq_V, V_max, handles.a_cort)

%% Momento
Graficar_Fuerzas(cerost_M, eq_M, M_max, handles.a_momen)

%% Deflexion
xdist=0; D_maxe=D_max(elem);
for j=1:size(subpartes{elem},2)
    e_f=subpartes{elem}(j);
    plot(handles.a_deflex,(0:Lo(e_f)/10:Lo(e_f))+xdist,polyval(eq_D{elem}{j}/D_maxe,0:Lo(e_f)/10:Lo(e_f)),'r');
    xdist=xdist+Lo(e_f);
end
line(handles.a_deflex,[0 long(elem)],[0 0],'LineWidth',2,'Color',[0.5 0.5 0.5]);

axis(handles.a_equi,[-long(elem)/10 long(elem)+long(elem)/10 -1.5 1.5]);
axis(handles.a_axial,[-long(elem)/10 long(elem)+long(elem)/10 -1.5 1.5]);
axis(handles.a_cort,[-long(elem)/10 long(elem)+long(elem)/10 -1.5 1.5]);
axis(handles.a_momen,[-long(elem)/10 long(elem)+long(elem)/10 -1.5 1.5]);
axis(handles.a_deflex,[-long(elem)/10 long(elem)+long(elem)/10 -1.5 1.5]);

%% Complemento
set(handles.st_inicial,'String',ve_desf(elem,1));
set(handles.st_final,'String',long(elem)-ve_desf(elem,2));
set(handles.NI,'String',CONN(elem,2));
set(handles.NJ,'String',CONN(elem,3));
uni_lon = [handles.txu01 handles.txu02 handles.txu03 handles.txu04 handles.txu05,...
    handles.txu06 handles.txu07 handles.txu08 handles.txu09];
set(uni_lon,'String',mag_text{2}); %unidades de longitud
set(handles.txu10,'String',[mag_text{1} '/' mag_text{2}]); %unidades de carga dist
set([handles.txu11 handles.txu12],'String',mag_text{1}); %unidades de fuerza
set(handles.txu13,'String',[mag_text{1} '-' mag_text{2}]); %unidades de momento
set(handles.l_uni,'String',[mag_text{1} ', ' mag_text{2} ', ' mag_text{3}]);
t_ubicacion_Callback(handles.t_ubicacion, eventdata, handles);



% Choose default command line output for Fuerzas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fuerzas wait for user response (see UIRESUME)
% uiwait(handles.Fuerzas);


% --- Outputs from this function are returned to the command line.
function varargout = Fuerzas_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function b_salir_Callback(hObject, eventdata, handles)
close(handles.Fuerzas)


% --- Executes on selection change in l_uni.
function l_uni_Callback(hObject, eventdata, handles)
% hObject    handle to l_uni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns l_uni contents as cell array
%        contents{get(hObject,'Value')} returns selected item from l_uni


% --- Executes during object creation, after setting all properties.
function l_uni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l_uni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_absoluto.
function rb_absoluto_Callback(hObject, eventdata, handles)
set(handles.rb_relativom,'Value',0);                                       %Desactiva esta opcion
set(handles.rb_relativoe,'Value',0);                                       %Desactiva esta opcion


function rb_relativom_Callback(hObject, eventdata, handles)
set(handles.rb_absoluto,'Value',0);                                        %Desactiva esta opcion
set(handles.rb_relativoe,'Value',0);                                       %Desactiva esta opcion


function rb_relativoe_Callback(hObject, eventdata, handles)
set(handles.rb_absoluto,'Value',0);                                        %Desactiva esta opcion
set(handles.rb_relativom,'Value',0);                                       %Desactiva esta opcion


function rb_valores_Callback(hObject, eventdata, handles)
set(handles.p_ubicacion,'Visible','On');
set(handles.rb_maximo,'Value',0);                                         %Desactiva esta opcion
t_ubicacion_Callback(handles.t_ubicacion, eventdata, handles);


function rb_maximo_Callback(hObject, eventdata, handles)
global elem A_max V_max M_max D_max ie_A ie_V ie_M ie_D eq_A eq_V eq_M eq_D long ve_w
global subpartes L xa_max xv_max xm_max xd_max Lo
set(handles.p_ubicacion,'Visible','Off'); 
set(handles.rb_valores,'Value',0);                                         %Desactiva esta opcion
xcar=ve_w(elem,6)*long(elem);
xa_maxe=xa_max(elem)+sum(Lo(subpartes{elem}(1:ie_A(elem)-1)));
xv_maxe=xv_max(elem)+sum(Lo(subpartes{elem}(1:ie_V(elem)-1)));
xm_maxe=xm_max(elem)+sum(Lo(subpartes{elem}(1:ie_M(elem)-1)));
xd_maxe=xd_max(elem)+sum(Lo(subpartes{elem}(1:ie_D(elem)-1)));
aux=findobj(handles.a_equi,'Ydata',[1 -1]); delete(aux);
line(handles.a_equi,[xcar,xcar],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]);
set(handles.u_equi,'String',xcar);
aux=findobj(handles.a_axial,'Ydata',[1 -1]); delete(aux);
line(handles.a_axial,[xa_maxe,xa_maxe],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]);
set(handles.u_axial,'String',xa_maxe);
aux=findobj(handles.a_cort,'Ydata',[1 -1]); delete(aux);
line(handles.a_cort,[xv_maxe,xv_maxe],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]);
set(handles.u_cort,'String',xv_maxe);
aux=findobj(handles.a_momen,'Ydata',[1 -1]); delete(aux);
line(handles.a_momen,[xm_maxe,xm_maxe],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]);
set(handles.u_momen,'String',xm_maxe);
aux=findobj(handles.a_deflex,'Ydata',[1 -1]); delete(aux);
line(handles.a_deflex,[xd_maxe,xd_maxe],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]);
set(handles.u_deflex,'String',xd_maxe);

v_equi=ve_w(elem,5);
set(handles.f_equi,'String',v_equi);
v_axial=string(round(polyval(eq_A{elem}{ie_A(elem)},xa_maxe-sum(Lo(subpartes{elem}(1:ie_A(elem)-1)))),4));
set(handles.f_axial,'String',v_axial);
v_cort=string(round(polyval(eq_V{elem}{ie_V(elem)},xv_maxe-sum(Lo(subpartes{elem}(1:ie_V(elem)-1)))),4));
set(handles.f_cort,'String',v_cort);
v_momen=string(round(polyval(-eq_M{elem}{ie_M(elem)},xm_maxe-sum(Lo(subpartes{elem}(1:ie_M(elem)-1)))),4));
set(handles.f_momen,'String',v_momen);
v_deflex=string(round(polyval(eq_D{elem}{ie_D(elem)},xd_maxe-sum(Lo(subpartes{elem}(1:ie_D(elem)-1)))),4));
set(handles.f_deflex,'String',v_deflex);



function b_inicial_Callback(hObject, eventdata, handles)
global valor elem ve_desf
set(handles.p_ubicacion,'Visible','On');
set(handles.rb_valores,'Value',1);                                         %Activa esta opcion
set(handles.rb_maximo,'Value',0);                                          %Desactiva esta opcion
valor=0+ve_desf(elem,1); set(handles.t_ubicacion,'String',valor);
mover_linea(handles,valor);


% --- Executes on button press in b_final.
function b_final_Callback(hObject, eventdata, handles)
global valor long elem ve_desf
set(handles.p_ubicacion,'Visible','On');
set(handles.rb_valores,'Value',1);                                         %Activa esta opcion
set(handles.rb_maximo,'Value',0);                                          %Desactiva esta opcion
valor=long(elem)-ve_desf(elem,2); set(handles.t_ubicacion,'String',valor);
mover_linea(handles,valor);


% --- Executes on selection change in pum_caso.
function pum_caso_Callback(hObject, eventdata, handles)
% global
opc=get(hObject,'Value');                                                  %obtiene la opc p.e=1 carga muerta



% --- Executes during object creation, after setting all properties.
function pum_caso_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pum_caso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function pum_caso_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pum_caso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pum_items.
function pum_items_Callback(hObject, eventdata, handles)
opc=get(hObject,'Value');                                                  %obtiene la opc p.e=1 axial
if opc==1                                                                  %Axial
    set(handles.p_axial,'Visible','On');                                   %prende el panel del axial
    set(handles.p_cortante,'Visible','Off');                               %apaga el panel del cort
    set(handles.p_momento,'Visible','Off');                                %apaga el panel del momento
elseif opc==2                                                              %Cortante
    set(handles.p_axial,'Visible','Off');
    set(handles.p_cortante,'Visible','On');
    set(handles.p_momento,'Visible','Off');
elseif opc==3                                                              %Momento
    set(handles.p_axial,'Visible','Off');
    set(handles.p_cortante,'Visible','Off');
    set(handles.p_momento,'Visible','On');
end


% --- Executes during object creation, after setting all properties.
function pum_items_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pum_items (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pum_valorunico.
function pum_valorunico_Callback(hObject, eventdata, handles)
% hObject    handle to pum_valorunico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pum_valorunico contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pum_valorunico


% --- Executes during object creation, after setting all properties.
function pum_valorunico_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pum_valorunico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t_ubicacion_Callback(hObject, eventdata, handles)
global valor long elem
valor=str2double(get(hObject,'String'));
if valor>long(elem) | valor<0
    warndlg('El valor es incorrecto','Ubicacion');
    valor=0; set(hObject,'String','0');   
end
mover_linea(handles,valor);


function t_ubicacion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_ubicacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function Fuerzas_WindowButtonDownFcn(hObject, eventdata, handles)
% % global valor L XYo NI NJ
% % c_izq = strcmpi(get(handles.Fuerzas,'selectiontype'),'normal');            % Reconoce click izquierdo         
% % xl = get(handles.a_equi,'xlim'); yl = get(handles.a_equi,'ylim');          % Obtiene limites de todos los axes
% % cd_equi = get(handles.a_equi,'CurrentPoint'); 
% % x = cd_equi(1,1); y_equi = cd_equi(1,2);                                   % Obtiene todas las coordenadas del 'x'
% %                                                                            y la coordenada 'y' del axes equi     
% % cd_axial = get(handles.a_axial,'CurrentPoint'); y_axial = cd_axial(1,2);   % Coordenada en 'y' del axes axial
% % cd_deflex = get(handles.a_deflex,'CurrentPoint'); y_deflex = cd_deflex(1,2);% Coordenada en 'y' del axes deflex
% % y=0;                                                                       % Evita error si no entra al if
% % if x>xl(1) & x<xl(2) & y_equi>yl(1) & y_equi<yl(2)
% %     y=y_equi                                                              % Escoge un solo 'y' para todos
% % elseif x>xl(1) & x<xl(2) & y_axial>yl(1) & y_axial<yl(2)
% %     y=y_axial                                                             % Escoge un solo 'y' para todos
% % elseif x>xl(1) & x<xl(2) & y_deflex>yl(1) & y_deflex<yl(2)
% %     y=y_deflex                                                            % Escoge un solo 'y' para todos
% % end
% % if x>xl(1) & x<xl(2) & y>yl(1) & y<yl(2) & c_izq==1                        % Click izq en algun axes
% %     if x<0 x=0; elseif x>L x=L; end                                        % Click en axes pero en extremos
% %     valor=x;                                                               % Sincroniza coor 'x'
% %     mover_linea(handles,valor);                                            % Dibuja linea valor en todos axes
% %     set(handles.p_ubicacion,'Visible','On');                               % Activa panel ubicacion
% %     set(handles.rb_maximo,'Value',0);                                      % Desactiva opc maximo
% %     set(handles.rb_valores,'Value',1);                                     % Activa opc valores
% % end


% --- Executes on mouse press over axes background.
function a_equi_ButtonDownFcn(hObject, eventdata, handles)
global valor long elem
c_izq = strcmpi(get(handles.Fuerzas,'selectiontype'),'normal');            % Reconoce click izquierdo         
cd = get(hObject,'CurrentPoint');                                          % Obtiene coordenadas del click
x = cd(1,1); y = cd(1,2);
if c_izq==1                                                                % Click izq en el axes
    if x<0 x=0; elseif x>long(elem) x=long(elem); end                            % Click en axes pero en extremos
    valor=x;                                                               % Sincroniza coor 'x'
    mover_linea(handles,valor);                                            % Dibuja linea valor en todos axes
    set(handles.p_ubicacion,'Visible','On');                               % Activa panel ubicacion
    set(handles.rb_maximo,'Value',0);                                      % Desactiva opc maximo
    set(handles.rb_valores,'Value',1);                                     % Activa opc valores
end


% --- Executes on mouse press over axes background.
function a_axial_ButtonDownFcn(hObject, eventdata, handles)
a_equi_ButtonDownFcn(handles.a_axial, eventdata, handles)


% --- Executes on mouse press over axes background.
function a_cort_ButtonDownFcn(hObject, eventdata, handles)
a_equi_ButtonDownFcn(handles.a_cort, eventdata, handles)


% --- Executes on mouse press over axes background.
function a_momen_ButtonDownFcn(hObject, eventdata, handles)
a_equi_ButtonDownFcn(handles.a_momen, eventdata, handles)


% --- Executes on mouse press over axes background.
function a_deflex_ButtonDownFcn(hObject, eventdata, handles)
a_equi_ButtonDownFcn(handles.a_deflex, eventdata, handles)


% --- Executes when user attempts to close Fuerzas.
function Fuerzas_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
global obj_sel
delete(obj_sel);
