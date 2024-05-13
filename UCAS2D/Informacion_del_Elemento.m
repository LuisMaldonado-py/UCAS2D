function varargout = Informacion_del_Elemento(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Informacion_del_Elemento_OpeningFcn, ...
                   'gui_OutputFcn',  @Informacion_del_Elemento_OutputFcn, ...
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

function Informacion_del_Elemento_OpeningFcn(hObject, eventdata, handles, varargin)
global op v_loce v_locv v_asi ve_p car_f l_res
global sub ve_obj ve_conex ve_tem ve_w ve_rel ve_pro vn_coor vn_obj vs_eti ve_add ve_des ve_rot
op = 1;                   % Opcion de Localizacion
%---------- Codigo para centrar guide ------------
centrar_guide;
%----------- Vector Etiqueta ---------------------
v_loce = {'Longitud';'Angulo';'Nodo Inicial (NI)';'   Sistema de Coordenadas';'   X';'   Y';'Nodo Final(NJ)';'   Sistema de Coordenadas';'   X';'   Y'};
v_care = {'Carga Puntual';'Longitud Relativa al NI';'Longitud Relativa al NJ'};
%----------- INFORMACION ----------------------------------------
lab = num2str(ve_obj(sub,2));                                       % Etiqueta  
set(handles.t_eti,'string',lab);
%----------------Informacion de Localizacion-----------------------------
%------------- Nodos Inciales y Finales -------------------------
ni = ve_conex(sub,2); nf = ve_conex(sub,3);    
ni = find(vn_coor(:,1) == ni);nf = find(vn_coor(:,1) == nf);
eni = vn_obj(ni,2);enf = vn_obj(nf,2);          % Nodo Inicial y final 
%-------------- Angulo y longitud -------------------------------
xi = vn_coor(eni,2); xf = vn_coor(enf,2); yi = vn_coor(eni,3); yf = vn_coor(enf,3);
[ang,long] = angulo_360(xi,xf,yi,yf);           % Angulo y Longitud
%----------------------------------------------------------------
v_locv = {num2str(long);num2str(ang);num2str(eni);'GLOBAL';num2str(xi);num2str(yi);num2str(enf);'GLOBAL';num2str(xf);num2str(yf)};
%----------------------------------------------
set(handles.tab_ele,'data',[v_loce v_locv]);
% ----------------------INFORMACION DE ASIGNAMIENTO-----------------------
%--------------- Seccion -----------------------
sec = ve_conex(sub,4); 
if sec>0
sec = find(cell2mat(vs_eti(:,1)) == sec);
nsec = vs_eti{sec,2};                                                       % Nombre de seccion
else
nsec = cell2mat(l_res(-ve_conex(sub,4),1));
end
%-------------- Prop Modif ---------------------
a = 0;
nom_mod = {'   Seccion Transversal';'   Area de Corte X';'   Area de Corte Y';'   Inercia X';'   Inercia Y'};
pro_m = {'Propiedades Modificadas' ''};
for i = 1:5
    if ve_pro(sub,i+1) ~= 1
        pro_m(end+1,1:2) = [nom_mod(i),num2str(ve_pro(sub,i+1))];
        a = 1;
    end
end
if a == 0
    pro_m = {'Propiedades Modificadas' 'NO'};                     % propiedades Modificadas, verifica
end
%------------------ Releses ------------------------
rel = ve_rel{sub,2};                % Vector de release Ve_rel = {Code   1 2 3 4 5 6]
ri = '';
rf = '';
for i = 1:size(rel,2)
    if rel(1,i) == 1
        ri = strcat(ri,',A');
    elseif rel(1,i) == 2
        ri = strcat(ri,',V');
    elseif rel(1,i) == 3
        ri = strcat(ri,',M');
    elseif rel(1,i) == 4
        rf = strcat(rf,',A');
    elseif rel(1,i) == 5
        rf = strcat(rf,',V');
    elseif rel(1,i) == 6
        rf = strcat(rf,',M');
    end
end    
if isempty(ri) == 0
    ri = ri(:,2:end);               % Informacion del release Nodo inicial
else
    ri = 'Ninguno';
end    
if isempty(rf) == 0
    rf = rf(:,2:end);               % Informacion del release Nodo final
else
    rf = 'Ninguno';
end;
%----------------- Desfase ------------------------
[dbn,den] = desfas(sub);
des_tip = {'Por Defecto';'Automatico';'Manual'};
%------------------ Rotacion --------------------
nam_rot = {'Por Defecto (X-X)';'90 Grados(Y-Y)'};
%---------------------------------------------------------------
v_asi = [{'Seccion' nsec};pro_m;{'Releases NI' ri;'Releases NJ' rf;'Desfase' num2str(des_tip{ve_des(sub,2)});'   Desfase en NI (db)' num2str(dbn);'   Desfase en NJ (de)' num2str(den);'Rotacion de Seccion' num2str(nam_rot{ve_rot(sub,2)})}];
%-------------- INFORMACION DE CARGAS ----------------------------
%------------- Cargas ------------------------------------------
car(1,1:3) = ve_p(sub,2:4);               % Vector de Cargas distribuida uniforme Ve_w = [Code  WT]   fx
car(2,1:3) = ve_p(sub,5:7);               % Vector de Cargas distribuida uniforme Ve_w = [Code  WT]   fy
car(3,1:3) = ve_p(sub,8:10);               % Vector de Cargas distribuida uniforme Ve_w = [Code  WT]  mz
car(4,1:3) = ve_w(sub,2:4);               % Vector de Cargas distribuida uniforme Ve_w = [Code  WT]   dx
car(5,1:3) = ve_w(sub,5:7);               % Vector de Cargas distribuida uniforme Ve_w = [Code  WT]   dy
car(6,1:2) = [ve_tem(sub,3) ve_tem(sub,2)];           % Vector de Cargas por Temperatura: Ve_tem = [Code Tinf Tsup] 
car(7,1) = ve_add(sub,2);             % Vector de Cargas distribuida uniforme Ve_w = [Code  WT]
%---------- Colocacion de informacion ------------------------
eti_p(1,1:3) = {'Fuerza en X';'   Relativa a NI';'   Relativa a NF'};
eti_p(2,1:3) = {'Fuerza en Y';'   Relativa a NI';'   Relativa a NF'};
eti_p(3,1:3) = {'Momento en Z';'   Relativa a NI';'   Relativa a NF'};
eti_p(4,1:3) = {'Distribuida en X';'   Relativa a NI';'   Relativa a NF'};
eti_p(5,1:3) = {'Distribuida en Y';'   Relativa a NI';'   Relativa a NF'};
eti_p(6,1:3) = {'Temperatura';'   T. Superior';'   T. Inferior'};
eti_p(7,1) = {'AL'};
car_f = {};
a = 3;
for i = 1:7
    load = car(i,1);
    if i == 7 
        a = 1;
    end  
    if i == 6
        if load ~= 0 | car(i,2) ~= 0
            car_f = [car_f;eti_p(i,1:a)' {'' car(i,1) car(i,2)}'];
        end
    else
        if load ~= 0
            car_f = [car_f;eti_p(i,1:a)' num2cell(car(i,1:a)')];      
        end    
    end 
end
handles.output = hObject;
guidata(hObject, handles);

function varargout = Informacion_del_Elemento_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function b_ok_Callback(hObject, eventdata, handles)
close(Informacion_del_Elemento);

function b_cerrar_Callback(hObject, eventdata, handles)
close(Informacion_del_Elemento);

function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
global obj_sel
delete(obj_sel);

function b_1_Callback(hObject, eventdata, handles)
global op v_loce v_locv
if op ~= 1                                                      % Carga Datos de localizacion
    set(handles.tab_ele,'data',[v_loce v_locv]);
    op = 1;                   % Opcion de Localizacion
end    

function b_2_Callback(hObject, eventdata, handles)
global op v_asi
if op ~= 2                                                      % Carga Datos de asignacion
    set(handles.tab_ele,'data',v_asi);
    op = 2;                   % Opcion de Localizacion
end 

function b_3_Callback(hObject, eventdata, handles)
global car_f op
if op ~= 3                                                      % Carga Datos de asignacion
    set(handles.tab_ele,'data',car_f);
    set(handles.tab_ele,'data',car_f);
    op = 3;                   % Opcion de Localizacion
end
