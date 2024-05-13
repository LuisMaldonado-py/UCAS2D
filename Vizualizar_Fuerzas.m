function varargout = Vizualizar_Fuerzas(varargin)
% VIZUALIZAR_FUERZAS MATLAB code for Vizualizar_Fuerzas.fig
%      VIZUALIZAR_FUERZAS, by itself, creates a new VIZUALIZAR_FUERZAS or raises the existing
%      singleton*.
%
%      H = VIZUALIZAR_FUERZAS returns the handle to a new VIZUALIZAR_FUERZAS or the handle to
%      the existing singleton*.
%
%      VIZUALIZAR_FUERZAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIZUALIZAR_FUERZAS.M with the given input arguments.
%
%      VIZUALIZAR_FUERZAS('Property','Value',...) creates a new VIZUALIZAR_FUERZAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Vizualizar_Fuerzas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Vizualizar_Fuerzas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Vizualizar_Fuerzas

% Last Modified by GUIDE v2.5 17-Jan-2020 12:53:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Vizualizar_Fuerzas_OpeningFcn, ...
                   'gui_OutputFcn',  @Vizualizar_Fuerzas_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Vizualizar_Fuerzas is made visible.
function Vizualizar_Fuerzas_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
% global axe_dibujo
% axes(axe_dibujo);


% UIWAIT makes Vizualizar_Fuerzas wait for user response (see UIRESUME)
% uiwait(handles.Visualizar_Fuerzas);
set(findall(handles.p_nodos, '-property', 'enable'), 'enable', 'off');
set(findall(handles.p_defor, '-property', 'enable'), 'enable', 'off');



% --- Outputs from this function are returned to the command line.
function varargout = Vizualizar_Fuerzas_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rb_graficadas.
function rb_graficadas_Callback(hObject, eventdata, handles)
set(handles.rb_tabuladas,'Value',0);


% --- Executes on button press in rb_tabuladas.
function rb_tabuladas_Callback(hObject, eventdata, handles)
set(handles.rb_graficadas,'Value',0);


% --- Executes on button press in rb_nodos.
function rb_nodos_Callback(hObject, eventdata, handles)
set(handles.rb_elementos,'Value',0);
set(findall(handles.p_nodos, '-property', 'enable'), 'enable', 'on');
set(findall(handles.p_elementos, '-property', 'enable'), 'enable', 'off');


% --- Executes on button press in rb_elementos.
function rb_elementos_Callback(hObject, eventdata, handles)
set(handles.rb_nodos,'Value',0);
set(findall(handles.p_nodos, '-property', 'enable'), 'enable', 'off');
set(findall(handles.p_elementos, '-property', 'enable'), 'enable', 'on');
rb_fuerzas_Callback(hObject, eventdata, handles)


% --- Executes on button press in rb_valores.
function rb_valores_Callback(hObject, eventdata, handles)
set(handles.rb_relleno,'Value',0);


% --- Executes on button press in rb_relleno.
function rb_relleno_Callback(hObject, eventdata, handles)
set(handles.rb_valores,'Value',0);


% --- Executes on button press in rb_axial.
function rb_axial_Callback(hObject, eventdata, handles)
set(handles.rb_cortante,'Value',0);
set(handles.rb_momento,'Value',0);


% --- Executes on button press in rb_cortante.
function rb_cortante_Callback(hObject, eventdata, handles)
set(handles.rb_axial,'Value',0);
set(handles.rb_momento,'Value',0);


% --- Executes on button press in rb_fuerzas.
function rb_fuerzas_Callback(hObject, eventdata, handles)
set(handles.rb_defor,'Value',0);
set(findall(handles.p_defor, '-property', 'enable'), 'enable', 'off');
set(findall(handles.p_fuerzas1, '-property', 'enable'), 'enable', 'on');
set(findall(handles.p_fuerzas2, '-property', 'enable'), 'enable', 'on');



% --- Executes on button press in rb_defor.
function rb_defor_Callback(hObject, eventdata, handles)
set(handles.rb_fuerzas,'Value',0);
set(findall(handles.p_fuerzas1, '-property', 'enable'), 'enable', 'off');
set(findall(handles.p_fuerzas2, '-property', 'enable'), 'enable', 'off');
set(findall(handles.p_defor, '-property', 'enable'), 'enable', 'on');


% --- Executes on button press in cb_deformada.
function cb_deformada_Callback(hObject, eventdata, handles)
% hObject    handle to cb_deformada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_deformada


% --- Executes on button press in cb_original.
function cb_original_Callback(hObject, eventdata, handles)
% hObject    handle to cb_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_original


% --- Executes on button press in rb_momento.
function rb_momento_Callback(hObject, eventdata, handles)
set(handles.rb_axial,'Value',0);
set(handles.rb_cortante,'Value',0);


% --- Executes on button press in b_aplicar.
function b_aplicar_Callback(hObject, eventdata, handles)
global axe_dibujo ve_conex vn_coor eq_A eq_V eq_M eq_D long L subpartes Lo
global A_max V_max M_max D_max cerost_A cerost_V cerost_M reac vn_coor_o
global fill_m line_d ve_obj vn_obj punts v_u CONN2 plot_m tx v_R v_s op_res ve_rel
axes(axe_dibujo);

opc_fuerzas=get(handles.rb_fuerzas,'Value');
opc_deformada=get(handles.rb_defor,'Value');
opc_axial=get(handles.rb_axial,'Value');
opc_cortante=get(handles.rb_cortante,'Value');
opc_momento=get(handles.rb_momento,'Value');
cb_deformada=get(handles.cb_deformada,'Value');
cb_original=get(handles.cb_original,'Value');
rb_relleno=get(handles.rb_relleno,'Value');
rb_valores=get(handles.rb_valores,'Value');
rb_nodos=get(handles.rb_nodos,'Value');
rb_elementos=get(handles.rb_elementos,'Value');
rb_graficadas=get(handles.rb_graficadas,'Value');
rb_tabuladas=get(handles.rb_tabuladas,'Value');

try delete(fill_m); delete(line_d); delete(punts); delete(plot_m); delete(tx); end
try delete(reac); end
fill_m=[]; line_d=[]; punts=[]; plot_m=[]; tx=[]; reac=[]; vn_coor(:,[2 3]) = vn_coor_o; op_res=1; zoom_rest();
if rb_elementos==1
set(vn_obj(:,3),'MarkerEdgeColor','b','MarkerFaceColor','None');
set(ve_obj(:,3),'Color','b');
releases= ve_rel(:,2);
esc = max(max(vn_coor_o(:,1))-min(vn_coor_o(:,1)),max(vn_coor_o(:,2))-min(vn_coor_o(:,2)))/20; %escala axial, cortante y momento
escd = max(long)/5; %escala deformada
for i=1:size(vn_coor,1)
    v_pd(i,:)=[vn_coor(i,2)+v_u(3*i-2)/max(abs(D_max))*escd;...
        vn_coor(i,3)+v_u(3*i-1)/max(abs(D_max))*escd;];           %vector de puntos desplazados
end
if cb_original==0 & opc_deformada==1
    set(ve_obj(:,3),'Visible','Off');
    set(vn_obj(:,3),'Visible','Off');
else
    set(ve_obj(:,3),'Visible','On');
    set(vn_obj(:,3),'Visible','On');
end
for elem=1:size(ve_conex,1)
    o_elem=findobj(axe_dibujo,'DisplayName',num2str(elem));
    NI=find(ve_conex(elem,2)==vn_coor(:,1));
    NF=find(ve_conex(elem,3)==vn_coor(:,1));
    ang(elem)=atan2((vn_coor_o(NF,2)-vn_coor_o(NI,2)),(vn_coor_o(NF,1)-vn_coor_o(NI,1)));
    x_dat=get(o_elem,'XData'); y_dat=get(o_elem,'YData');
    xi=x_dat(1); yi=y_dat(1);
    if rb_relleno==1 f_p=1; elseif rb_valores==1 f_p=2; end
    if opc_axial==1 & opc_fuerzas==1
        Graficar_Fuerzas2(cerost_A, eq_A, A_max, esc, ang, xi, yi, elem, f_p);
    elseif opc_cortante==1 & opc_fuerzas==1
        Graficar_Fuerzas2(cerost_V, eq_V, V_max, esc, ang, xi, yi, elem, f_p);
    elseif opc_momento==1 & opc_fuerzas==1
        Graficar_Fuerzas2(cerost_M, eq_M, M_max, esc, ang, xi, yi, elem, f_p);
    elseif cb_deformada==1 & opc_deformada==1
        set(vn_obj(:,3),'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor','None');
        set(ve_obj(:,3),'Color',[0.5 0.5 0.5]);
        punts=[punts scatter(v_pd(:,1),v_pd(:,2),'b','filled')];
        vn_coor(:,[2 3]) = v_pd;
        try releases{elem}(1); catch releases{elem}(1)=0; end
        if releases{elem}==[3 6] %def en armaduras
            line_d=[line_d plot([vn_coor(NI,2) vn_coor(NF,2)],[vn_coor(NI,3) vn_coor(NF,3)],...
                'b','LineWidth',2)];
            set(line_d(end),'DisplayName',num2str(elem));
            set(line_d(end),'ButtonDownFcn','selec_ele(gco)');
        else %def en porticos
        xdist=0;
        for j=1:size(subpartes{elem},2)
            e_f=subpartes{elem}(j);
            u_axi=0; u_axf=0; 
            u_ayi=polyval(eq_D{elem}{j},0); 
            u_ayf=polyval(eq_D{elem}{j},Lo(e_f));
            if j==1 %inicio
                if ang(elem)==pi/2 
                    u_axi=v_u(CONN2(e_f,2)*3-1);
                    u_ayi=-v_u(CONN2(e_f,2)*3-2); %x0r pos -> y0 neg
                else
                    u_axi=v_u(CONN2(e_f,2)*3-2);
                    u_ayi=v_u(CONN2(e_f,2)*3-1);
                end
            end
            if j==size(subpartes{elem},2) %fin
                if ang(elem)==pi/2 
                    u_axf=v_u(CONN2(e_f,3)*3-1);
                    u_ayf=-v_u(CONN2(e_f,3)*3-2); %x0r pos -> y0 neg
                else
                    u_axf=v_u(CONN2(e_f,3)*3-2);
                    u_ayf=v_u(CONN2(e_f,3)*3-1);
                end
            end
            x0=[0:Lo(e_f)/25:Lo(e_f) Lo(e_f)]; 
            y0=[u_ayi polyval(eq_D{elem}{j},x0(2:end-1)) u_ayf];
            if max(abs(D_max))~=0
            u_axi=u_axi/max(abs(D_max))*escd; u_axf=u_axf/max(abs(D_max))*escd;
            x0=[u_axi:(Lo(e_f)+u_axf-u_axi)/25:Lo(e_f)+u_axf Lo(e_f)+(u_axf)]+xdist;
            y0=y0/max(abs(D_max))*escd; %*escd factor escala
            if (x0(end)==x0(end-1)) & (y0(end)~=y0(end-1))
                x0(end-2:end-1)=[]; y0(end-2:end-1)=[]; 
            end
            end
            x0r=x0*cos(ang(elem))-y0*sin(ang(elem));
            y0r=x0*sin(ang(elem))+y0*cos(ang(elem));
            xd=x0r+xi; yd=y0r+yi;
            line_d=[line_d plot(xd,yd,'b','LineWidth',2)];
            set(line_d(end),'DisplayName',num2str(elem));
            set(line_d(end),'ButtonDownFcn','selec_ele(gco)');
            xdist=xdist+Lo(e_f);
        end
        end
    end
end
op_res=1;
if (cb_original==0 & cb_deformada==0 & opc_deformada==1) op_res=0; end
zoom_rest();
end

%Reacciones
if rb_nodos==1
set(vn_obj(:,3),'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor','None');
set(ve_obj(:,3),'Visible','On','Color',[0.5 0.5 0.5]);
reac=[]; op_res=0;
for i=1:size(v_R,1)
    n=ceil(v_s(i)/3);
    set(vn_obj(n,3),'Visible','Off');
    if rb_graficadas==1
    if mod(v_s(i),3)==1 %en x
        reac=[reac line([vn_coor(n,2)-min(long)/5 vn_coor(n,2)],[vn_coor(n,3) vn_coor(n,3)],'LineWidth',2,'Color','r')];
        if v_R(i)>0 f_m=-min(long)/60; f_v='>'; else f_m=-min(long)/5; f_v='<'; end
        reac=[reac scatter(vn_coor(n,2)+f_m,vn_coor(n,3),60,f_v,'filled','r')];
        tx=[tx text(vn_coor(n,2)-min(long)/5,vn_coor(n,3)+min(long)/30,string(abs(v_R(i))))];
    end
    if mod(v_s(i),3)==2 %en y
        reac=[reac line([vn_coor(n,2) vn_coor(n,2)],[vn_coor(n,3)-min(long)/5 vn_coor(n,3)],'LineWidth',2,'Color','r')];
        if v_R(i)>0 f_m=-min(long)/60; f_v='^'; else f_m=-min(long)/5; f_v='v'; end
        reac=[reac scatter(vn_coor(n,2),vn_coor(n,3)+f_m,60,f_v,'filled','r')];
        tx=[tx text(vn_coor(n,2)+min(long)/30,vn_coor(n,3)-min(long)/5,string(abs(v_R(i))))];
        set(tx(end), 'Rotation',90);
    end
    end
    if rb_tabuladas==1
    if mod(v_s(i),3)==1 xyz='x'; aba=1; end
    if mod(v_s(i),3)==2 xyz='y'; aba=2; end
    if mod(v_s(i),3)==0 xyz='z'; aba=3; end
    tx=[tx text(vn_coor(n,2),vn_coor(n,3)-min(long)/10*aba,['R' xyz ' = ' char(string(v_R(i)))])];
    end
end
end


% --- Executes on button press in b_cerrar.
function b_cerrar_Callback(hObject, eventdata, handles)
close(handles.Visualizar_Fuerzas)


% --- Executes during object creation, after setting all properties.
function Visualizar_Fuerzas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Visualizar_Fuerzas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close Visualizar_Fuerzas.
function Visualizar_Fuerzas_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
