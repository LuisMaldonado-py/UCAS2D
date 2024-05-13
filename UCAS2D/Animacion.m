function varargout = Animacion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Animacion_OpeningFcn, ...
                   'gui_OutputFcn',  @Animacion_OutputFcn, ...
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

function Animacion_OpeningFcn(hObject, eventdata, handles, varargin)
global dat_arm ve_conex vn_coor vn_obj mag_text
global axe_dibujo vn_cop ve_obj fle_nol des_max
uni_com = {'mm' 'cm' 'in' 'ft' 'm'; '1000' '100' '40' '4' '1'};     % anlisis de unidades    
des_max = str2num(uni_com{2,find(contains(uni_com(1,:),mag_text(2)))});  % desplazamiento maximo
%try; a = inputdlg (strcat(' Ingrese el desplazamiento maximo [',mag_text{2},']'),' Desplazamiento Maximo ',[1 40],{num2str(des_max)});des_max = str2num(a{1});end  % Captura desplazamiento maximo ingressado
n_it = size(dat_arm{1},2); n_con = dat_arm{5};  % Numero de iterraciones / nodo de control
try; a = find(dat_arm{1}(((n_con-1)*3)+1,:) <= des_max); n_it = a(end); end   % Numero de iterraciones
set(handles.p_pas,'string',['Original' string((1:1:n_it))]);  % Cargar Pasos
vn_coor(:,2:3) = vn_cop;
l_fle = ((max(vn_cop(:,1))-min(vn_cop(:,1)))+(max(vn_cop(:,2))-...   % Longitud de flecha
        min(vn_cop(:,2))))/2;
axes(axe_dibujo);
zoom_rest();
delete(fle_nol);fle_nol = [];   % Borra y vacia Flecha
fle_nol = drawArrow([vn_coor(n_con,2)-l_fle*0.1 ...
    vn_coor(n_con,3)],[vn_coor(n_con,2) vn_coor(n_con,3)],'g');         % Dibuja flecha                                                        % Bloqueo de botones
set(fle_nol,'LineWidth',2);     % Personalizar flecha
set(ve_obj(:,3),'Color','g');
for i = 1:size(ve_conex,1)
    set(ve_obj(i,3),'xdata',[vn_cop(ve_conex(i,2),1) vn_cop(ve_conex(i,3),1)],'ydata',[vn_cop(ve_conex(i,2),2) vn_cop(ve_conex(i,3),2)]);
end                                             % Envia adelante al guide
%-------------------- Codigo para enviar adelante interfaz-----------------
set(handles.figure1,'visible','on');    % Pone visible al guide
WinOnTop(handles.figure1,true);         % Envia adelante al guide
Grafica_Ani_Pushover_Armaduras;         % Abre interfaz de grafica
handles.output = hObject;
guidata(hObject, handles);

function varargout = Animacion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function r_rep_Callback(hObject, eventdata, handles)
set(handles.r_rep,'value',1);       % Bloquea y activa radio button
set(handles.r_pas,'value',0);
set(handles.p_pas,'enable','off');    

function r_pas_Callback(hObject, eventdata, handles)
set(handles.r_pas,'value',1);       % Bloquea y activa radio button
set(handles.r_rep,'value',0);
set(handles.p_pas,'enable','on');

function b_apl_Callback(hObject, eventdata, handles)
global dat_arm axe_dibujo vn_coor ve_conex vn_cop fle_nol axe_pua
global ve_obj op_non des_max t_gpa
%% ----------------- 2 PANTALLA --------------------
ucp = dat_arm{2}';pcp = dat_arm{3}';    % Datos de u = desplzamineto nodo de control / p = carga
try; cla(axe_pua,'reset'); curve = animatedline(axe_pua,'color','r','Marker','s','LineWidth',1)...
        ;addpoints(curve,0,0);set(t_gpa,'string',{"u : 0","P : 0"});end;    % Resetea axes / Crea curva
%% -------------------------------------------------
op_non = 0; etinodo_act();          % Etiqueta de nodo
porl = 1.5; col = 'g'; porf = 0.1;  % Porcion de la flecha
n_con = dat_arm{5};                 % Nodo de Control
l_fle = ((max(vn_cop(:,1))-min(vn_cop(:,1)))+(max(vn_cop(:,2))-...   % Longitud de flecha
        min(vn_cop(:,2))))/4;
npas = size(dat_arm{1},2);          % Numero de iterraciones 
try; a = find(dat_arm{1}(((n_con-1)*3)+1,:) <= des_max); npas = a(end); end;   % Numero de iterraciones
Af = 0.2/npas;
flu = dat_arm{4};                   % Elementos que fluyen
axes(axe_dibujo); hold on;          % Llama a los Axes
%% -------------------------- Graficar ------------------------------------
if get(handles.r_rep,'value') == 1  % Si Se escoje reproducion automatica
    set(ve_obj(:,3),'Color','g');   % Transforma armadura en verde
    if npas < 7                     % Tiempo de analisis contador
        a = 2.5;
    else
        a = 5;
    end
    time = a/npas;                  % Divide el tiempo en numero de iterracciones
    for j = 1 : npas                % Recorre las iterraccion
%% --------- Curva ------------ 
        try
        ley = {strcat("u : ",num2str(ucp(j+1))),strcat("P : ",num2str(pcp(j+1)))};  % Crea String
        set(t_gpa,'string',ley);
        addpoints(curve,ucp(j+1),pcp(j+1));                                     % Grafica curva
        drawnow; end;
%% ------- Estructura --------- 
        e_flu = flu{j};             % Obtine elemento que fluye en iterraccion
        set(ve_obj(e_flu,3),'Color','r');   % Cambia de color el elemnto que fluyo
        u = [zeros(size(dat_arm{1},1),1) dat_arm{1}];   % Obtiene desplazaminetos por iterraccion
        ux = u((1:3:size(u,1)-2),j); uy = u((2:3:size(u,1)-1),j);   % Desplazamminetos en el X/Y paso
        vn_coor(:,2:3) = vn_cop(:,1:2)+[ux uy]; % Nodos
        zoom_rest();                    % Actualiza los nodos
        delete(fle_nol);fle_nol = [];   % Borra y vacia Flecha
        porf = j*Af; 
        if j == npas
            porl = 2.5; col = 'r'; porf = 0.3;
        elseif j > npas/2   
            porl = 2; col = 'y'; %porf = j*Af; 
        else
            porl = 1.5; col = 'g'; %porf = 0.1;
        end
        fle_nol = drawArrow([vn_coor(n_con,2)-l_fle*porf ...
            vn_coor(n_con,3)],[vn_coor(n_con,2) vn_coor(n_con,3)],col);         % Dibuja flecha                                                        % Bloqueo de botones
        set(fle_nol,'LineWidth',porl);     % Personalizar flecha
        for i = 1:size(ve_conex,1)
            set(ve_obj(i,3),'xdata',[vn_coor(ve_conex(i,2),2) vn_coor(ve_conex(i,3),2)],'ydata',[vn_coor(ve_conex(i,2),3) vn_coor(ve_conex(i,3),3)]);
        end
        set(axe_dibujo,'xlim',[min(vn_coor(:,2))-0.1*l_fle max(vn_coor(:,2))+0.1*l_fle],'ylim',[min(vn_coor(:,3))-0.1*l_fle max(vn_coor(:,3))+0.1*l_fle]);
        axis equal
        pause(time);
    end
else
    set(ve_obj(:,3),'Color','g');
    pas = get(handles.p_pas,'value');
    u = [zeros(size(dat_arm{1},1),1) dat_arm{1}];
    ux = u((1:3:size(u,1)-2),pas); uy = u((2:3:size(u,1)-1),pas);   % Desplazamminetos en el X/Y paso
    vn_coor(:,2:3) = vn_cop(:,1:2)+[ux uy]; % Nodos
    zoom_rest();
    delete(fle_nol);fle_nol = [];   % Borra y vacia Flecha
    porf = pas*Af;
    if pas == npas
            porl = 3.5; col = 'r'; porf = 0.3
        elseif pas > npas/2   
            porl = 2.75; col = 'y'; 
        else
            porl = 2; col = 'g';
    end
    fle_nol = drawArrow([vn_coor(n_con,2)-l_fle*porf ...
        vn_coor(n_con,3)],[vn_coor(n_con,2) vn_coor(n_con,3)],'g');         % Dibuja flecha                                                        % Bloqueo de botones
    set(fle_nol,'LineWidth',2);     % Personalizar flecha
    for j = 1 : pas-1
%% --------- Curva ------------ 
        try
        ley = {strcat("u : ",num2str(ucp(j+1))),strcat("P : ",num2str(pcp(j+1)))};  % Crea String
        set(t_gpa,'string',ley);
        addpoints(curve,ucp(j+1),pcp(j+1));                                     % Grafica curva
        drawnow; end;
%% ------- Estructura --------- 
        e_flu = flu{j};
        set(ve_obj(e_flu,3),'Color','r');
    end
     for i = 1:size(ve_conex,1)
         set(ve_obj(i,3),'xdata',[vn_coor(ve_conex(i,2),2) vn_coor(ve_conex(i,3),2)],'ydata',[vn_coor(ve_conex(i,2),3) vn_coor(ve_conex(i,3),3)]);
     end
     set(axe_dibujo,'xlim',[min(vn_coor(:,2))-0.1*l_fle max(vn_coor(:,2))+0.1*l_fle],'ylim',[min(vn_coor(:,3))-0.1*l_fle max(vn_coor(:,3))+0.1*l_fle]);
     axis equal   
end

function b_cer_Callback(hObject, eventdata, handles)
close(Animacion);   % Cierra interfaz actual
%% --------------------------- NO PROGRAMADO ------------------------------
function p_pas_Callback(hObject, eventdata, handles)
function p_pas_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
global fle_nol ve_obj
close(Animacion);   % Cierra interfaz actual
try; close(Grafica_Ani_Pushover_Armaduras);end;
try;delete(fle_nol);end;   % Borra y vacia Flecha
set(ve_obj(:,3),'Color','b');
%delete(hObject);