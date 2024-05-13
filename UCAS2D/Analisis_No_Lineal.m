function varargout = Analisis_No_Lineal(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Analisis_No_Lineal_OpeningFcn, ...
                   'gui_OutputFcn',  @Analisis_No_Lineal_OutputFcn, ...
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

function Analisis_No_Lineal_OpeningFcn(hObject, eventdata, handles, varargin)   % Abre interfaz de No-Lineal
global vr_pro ve_conex vn_obj op_non mag_text vn_coor
op_non = 1; etinodo_act();                      % Elimina etiqueta del nodo en axes general
set(handles.t_pas,'string',strcat('Paso (',mag_text{2},')'));       % Unidades del Modelo
if isempty(ve_conex) == 0                       % Verifica que haya elementos
    if isempty(vr_pro) == 0                     % Verifica que existan curvas
        pc = find(cell2mat(vr_pro(:,3))== 2);   % Curvas tipo portico / Posicion de curvas
        if isempty(pc) == 0
            set(handles.p_curvag,'string',vr_pro(pc,2)); % Carga valores de curvas de portico
            set(handles.p_curvac,'string',vr_pro(pc,2)); % Carga valores de curvas de portico
        end
    end
    set(handles.p_nodo,'string',vn_obj(find(vn_coor(:,4)~= 1),2));   % Carga lista de nodos, para nodo control
end    
handles.output = hObject;
guidata(hObject, handles);

function varargout = Analisis_No_Lineal_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function p_tipo_Callback(hObject, eventdata, handles)
global op_nolin vr_pro lis_cpus 
op_nolin = get(handles.p_tipo,'value');                 % Opcion op = 1 Armadura; op = 2 Portico
set(handles.p_curvag,'value',1);                        % Opcion op = 1 Armadura; op = 2 Portico
set(handles.p_curvac,'value',1);                        % Opcion op = 1 Armadura; op = 2 Portico
if op_nolin == 1
    set(handles.text,'Title','Armadura');
    if isempty(vr_pro) == 0
        lis_cpus = find(cell2mat(vr_pro(:,3)) == op_nolin);        % Busca curva armaduras
        if isempty(lis_cpus) == 0
            set(handles.p_curvag,'string',vr_pro(lis_cpus,2));         % Carga valores de curvas de portico 
        else
            set(handles.p_curvag,'string','-- None --');        % Carga valores de curvas de portico     
        end
    else
        set(handles.p_curvag,'string','-- None --');        % Carga valores de curvas de portico
    end
    set(handles.p_curvac,'string','-- None --');        % Carga valores de curvas de portico      
    set(findall(handles.pan_col,'-property','enable'),'enable','off'); % Carga valores de curvas de portico 
else
    set(handles.text,'Title','Vigas');
    if isempty(vr_pro) == 0
        lis_cpus = find(cell2mat(vr_pro(:,3)) == 2);       % Busca curva porticos
        if isempty(lis_cpus) == 0
            set(handles.p_curvag,'string',vr_pro(lis_cpus,2)); % Carga valores de curvas de portico
            set(handles.p_curvac,'string',vr_pro(lis_cpus,2)); % Carga valores de curvas de portico
            set(findall(handles.pan_col,'-property','enable'),'enable','on'); % Carga valores de curvas de portico 
        else
            set(handles.p_curvag,'string','-- None --'); % Carga valores de curvas de portico
            set(handles.p_curvac,'string','-- None --'); % Carga valores de curvas de portico
            set(findall(handles.pan_col,'-property','enable'),'enable','on'); % Carga valores de curvas de portico 
        end
    else
        set(handles.p_curvag,'string','-- None --'); % Carga valores de curvas de portico
        set(handles.p_curvac,'string','-- None --'); % Carga valores de curvas de portico
        set(findall(handles.pan_col,'-property','enable'),'enable','on'); % Carga valores de curvas de portico 
    end
end
set(handles.p_curvag,'value',1);   % Value pop menu viga = 1
set(handles.p_curvac,'value',1);   % Value pop menu colum = 1
com = get(handles.p_met,'value'); tip = get(handles.p_tipo,'value');        % Tipo de metodo / Tipo de estructura
op = 2*(com-1)+tip; tc = {[1 1] [2 2] [1 3] [2 4]};                             % Opcion de estructura general / vector para posicion
if isempty(vr_pro) == 0                         % Verifica que existan curvas
    c = cell2mat(vr_pro(:,3)); 
    pc = find(c == tc{op}(1) | c == tc{op}(2));     % Curvas tipo portico / Posicion de curvas
    if isempty(pc) == 0
        set(handles.p_curvag,'string',vr_pro(pc,2)); % Carga valores de curvas de portico
        if op == 2 | op == 4
            set(handles.p_curvac,'string',vr_pro(pc,2)); % Carga valores de curvas de portico
        end
    end
end

function p_met_Callback(hObject, eventdata, handles)   % Uso de metodologia
global vr_pro
com = get(handles.p_met,'value'); tip = get(handles.p_tipo,'value');        % Tipo de metodo / Tipo de estructura
op = 2*(com-1)+tip; tc = {[1 1] [2 2] [1 3] [2 4]};                             % Opcion de estructura general / vector para posicion
if com == 1      % Metodo por Eventos
    set(handles.e_pas,'string','---','enable','off');
else            % Metodo por Pasos
    set(handles.e_pas,'string','0.1','enable','on');
end
if isempty(vr_pro) == 0                         % Verifica que existan curvas
    c = cell2mat(vr_pro(:,3)); 
    pc = find(c == tc{op}(1) | c == tc{op}(2));     % Curvas tipo portico / Posicion de curvas
    if isempty(pc) == 0
        set(handles.p_curvag,'string',vr_pro(pc,2)); % Carga valores de curvas de portico
        if op == 2 | op == 4
            set(handles.p_curvac,'string',vr_pro(pc,2)); % Carga valores de curvas de portico
        end
    end
end

function rinf_Callback(hObject, eventdata, handles)     % Opcion rotulas inferiores
a = get(handles.rinf,'value');          % Obtiene opcion de rotulas inferiores
b = get(handles.rsup,'value');          % Obtiene opcion de rotulas superiores
if a == 0 & b == 0                      % Activa rotulas inferiores
    b = set(handles.rsup,'value',1);
end     

function rsup_Callback(hObject, eventdata, handles)     % Opcion rotulas superiores
a = get(handles.rinf,'value');          % Obtiene opcion de rotulas inferiores
b = get(handles.rsup,'value');          % Obtiene opcion de rotulas superiores
if a == 0 & b == 0                      % Activa rotulas inferiores
    b = set(handles.rinf,'value',1);
end

function b_can_Callback(hObject, eventdata, handles)
close(Analisis_No_Lineal);          % Cierra guide actual

function b_ok_Callback(hObject, eventdata, handles)
global op_play ve_conex op_nolin ve_rel vn_coor ve_pro vm_pro vs_eti vs_pro ve_rot vm_eti
global con_nod con_ele vr_pro axe_dibujo graf_rotu lis_cpus vn_cop fle_nol mat_res dat_arm
global vn_const graf_rot vn_coor_o txr CONN2 long l_res 
global op_meto U1g P1g Ef vn_obj op_non r_der
if op_play == 0 & isempty(ve_conex) == 0 & isempty(vr_pro) == 0 & isempty(find(cell2mat(vr_pro(:,3)) == op_nolin)) == 0       % Evita error de que no exista curvas
    Reorganizar_Nodos();                    % Reorganiza Codigo de nodos y elementos
    %n_con = get(handles.p_nodo,'value');    % Obtiene posicion de nodo de control
    bas = vn_obj(find(vn_coor(:,4)~= 1),2); bas = bas(get(handles.p_nodo,'value'));
    n_con = find(vn_obj(:,2)==bas);
    set(handles.p_nodo,'string',vn_obj(find(vn_coor(:,4)~= 1),2));   % Carga lista de nodos, para nodo control
    op_meto = get(handles.p_met,'value');     % Obtiene tipo de metodo ha usar
    r_der = {};                             % Resultados de derivas
    %% ---------------------- Comportamineto ------------------------------
    com = get(handles.p_met,'value'); tip = get(handles.p_tipo,'value');        % Tipo de metodo / Tipo de estructura
    opc = 2*(com-1)+tip; tc = {[1 1] [2 2] [1 3] [2 4]};                         % Opcion de estructura general / vector para posicion
    c = cell2mat(vr_pro(:,3)); 
    pc = find(c == tc{opc}(1) | c == tc{opc}(2));     % Curvas tipo portico / Posicion de curvas
    c1 = pc(get(handles.p_curvag,'value')); 
%% ------------------- Analisis No-Lineal por Eventos ---------------------      
    if op_meto == 1
        constraints = [];
        if op_nolin == 1                        % Analiza Armadura
            cur1 = [vr_pro{c1,4} 0];    % Comportamiento en Armadura
            ve_rel(:,2) = {[3 6]};              % Crea relese tipo armadura
        else                                    % Analiza Porticos  
            c2 = pc(get(handles.p_curvac,'value'));
            cur1 = vr_pro{c1,4};    % Comportamiento en Armadura
            cur2 = vr_pro{c2,4};    % Comportamiento en Armadura
            ve_rel(:,2) = cell(size(ve_rel,1),1);   % Crea relese tipo portico
            if isempty(vn_const) == 0
                for i = 1:size(vn_const,1)
                    if isempty(vn_const(i,2)) == 0
                        master = vn_const{i,3};
                        slaves = vn_const{i,4};
                        gdl = vn_const{i,5};
                        master = zeros(size(slaves,2),1) + master;
                        gdl = zeros(size(slaves,2),3) + gdl;
                        slaves = zeros(size(slaves,2),1) + slaves';
                        constraints = [constraints;master slaves gdl]
                    end    
                end
            end
        end
        %% Creacion Vector de Propiedades
        secc = []; mate = []; ve_desf = [];     % Crea vectores para Secciones / Materiales / Vector de desfase 
        bass = []; basss={};basm = [];basmm = {};
        for i = 1: size(ve_conex,1)             % Crea vector de propiedades para elementos
            c = ve_conex(i,2:3);                % Vector de Conexion y Seccion: Ve_conex = [Code Ni Nf Sec]
            ci = find(vn_coor(:,1) == c(1)); ci = vn_coor(ci,2:3);  % Posicion Nodo inicial
            cf = find(vn_coor(:,1) == c(2)); cf = vn_coor(cf,2:3);  % Posicion Nodo final
            if ve_conex(i,4)>0
            sec = ve_conex(i,4);                        % Saco codigo la seccion
            sub_s = find(cell2mat(vs_eti(:,1)) == sec); % Busca subindice de la seccion
            mat = vs_eti{sub_s,6};                      % Saca material Vm_pro = [Codm ? E ? ? F ? ?]
            sub_m = find(vm_pro(:,1) == mat);           % Busca subindice del material
            find(vm_pro(:,1) == mat);                   % Busco subindice del material
            mate(i,:) = vm_pro(sub_m,2:end-2);      % Genero matriz de Materiales correpondientes a los elementos
            if isempty(basm) == 1 | isempty(find(basm == sub_m)) == 1
                basm(end+1,:) = sub_m;
                basmm(end+1,:) = num2cell(vm_pro(sub_m,2:end-2)); 
                basmm{end,1} = vm_eti{sub_m,2};    
            end
            [dbn,den]= desfas(i);                       % Analiza desfase ultimo y extrae desfase
            ve_desf(i,:) = [dbn,den];               % Coloca desfase
            % Seccion secc = [h b A Ac I]
            if ve_rot(i,2) == 1
                vec_sec = [vs_pro(sub_s,2:3) vs_pro(sub_s,4:5).*ve_pro(i,2:3) vs_pro(sub_s,7)*ve_pro(i,5) vs_pro(sub_s,9)*ve_pro(i,7)];        
            else   
                vec_sec = [vs_pro(sub_s,3) vs_pro(sub_s,2) vs_pro(sub_s,4).*ve_pro(i,2) vs_pro(sub_s,6)*ve_pro(i,4) vs_pro(sub_s,8)*ve_pro(i,6) vs_pro(sub_s,10)*ve_pro(i,8)];
            end    
            secc(i,:) = [vec_sec ci cf];        % Genero matriz de seccion correpondientes a los elementos
            if isempty(bass) == 1 | isempty(find(bass == sub_s)) == 1
                bass(end+1) = sub_s;
                if vs_eti{sub_s,4}==1
                    bas_n='Rectangular';
                elseif vs_eti{sub_s,4} == 2
                    bas_n='Tipo I';
                else
                    bas_n='Otras';
                end
                basss(end+1,:) = num2cell([0 0 vec_sec]);
                basss(end,1:2) = {vs_eti{sub_s,2} bas_n};
            end
            else
                k=cell2mat(l_res(-ve_conex(i,4),2));
                mate(i,2:5)=[k 0 0 0]; secc(i,1:6)=0; secc(i,7:10)=[ci cf]; ve_desf(i,1:2)=0; 
            end
        end
        %% Creacion de Vector de Nodos
        nodos = [vn_coor(:,1:6) zeros(size(vn_coor,1),6)];      % Nodos = [# x y rx ry rz fx fy fg dx dy dz)                   % Creo vector inicial de nodos
        nodos(n_con,7) = 1;                                     % Asigan carga en Nodo
        elem_pro = [ve_conex(:,1:3) mate(:,2) mate(:,4) secc(:,2) secc(:,1) ve_desf secc(:,4) mate(:,3) secc(:,5) secc(:,3) secc(:,6) mate(:,5)];     %elem_pro = [%elem NI NF E alpha b h db de Ac poisson I Area Z]
        %cur = find(cell2mat(vr_pro(:,3)) == op_nolin);          % Busca curva para analisis respectivo
        %cur1 = get(handles.p_curvag,'value');                   % Curva para vigas/armadura
        %cur1 = cur(cur1); cur1 = cell2mat(vr_pro(cur1,4:5));    % Busco curva posicion y datos viga/armadur
        %% Anlisis Porticos / Creacion de Rotulas en Porticos
        if op_nolin == 2                                        % Analisis de portico
            graf_rot=[];                                        % Coordenada de rotulas
            con_nodc = con_nod; con_elec = con_ele;             % Nuevo contador de nodos y elementos
            a = get(handles.rinf,'value');                      % Ubicacion de las rotulas
            b = get(handles.rsup,'value');
            %cur = find(cell2mat(vr_pro(:,3)) == op_nolin);      % Busca curva tipo porticos
            %cur2 = get(handles.p_curvac,'value');               % Curva para columnas
            %cur2 = cur(cur2); cur2 = cell2mat(vr_pro(cur2,4:5));% Busco curva posicion y datos columnas
            t2 = 0.9; t1 = 0.1;
            for i = 1: size(ve_conex,1)
                Ax = secc(i,end-1) - secc(i,end-3); Ay = ...
                    secc(i,end)- secc(i,end-2);                 % Variacion en X y Y
                long=sqrt((Ax^2) + (Ay^2));                     % Longitud del nuevo punto
                teta = radtodeg(atan(Ay/Ax));                   % Angulo de deviacion con la horizontal
                if teta == 90                                   % Colocacion de rotulas en columnas
                    if a == 1 & b == 1                          % Colocacion de 2 rotulas
                        con_nodc = con_nodc+2; con_elec = con_elec+2; 
                        nodos(end+1:end+2,1:3) = [con_nodc-1 secc(i,end-3)...
                            secc(i,end-2);con_nodc secc(i,end-1) secc(i,end)];      % Creacion de nuevos nodos
                        elem_pro(end+1:end+2,:) = [elem_pro(i,:);elem_pro(i,:)];    % Creaccion de nuevos elementos
                        elem_pro(end-1,[1 2 3 8 9 16 17])=[con_elec-1 ...
                            con_nodc-1 con_nodc 0 0 cur2];                          % Cambio de propiedades y nueva conexion rotula inicial
                        elem_pro(end,[1 2 8 16 17])=[con_elec con_nodc 0 cur2];     % Cambio de propiedades y nueva conexion elemento central
                        elem_pro(i,[3 9 16 17]) = [con_nodc-1 0 cur2];              % Cambio de propiedades y nueva conexion rotula final
                        graf_rot(end+1:end+2,:) = [secc(i,end-3)+t1*Ax secc(...
                            i,end-2)+t1*Ay i i;secc(i,end-3)+t2*Ax secc(i,end-2)+t2*Ay con_elec i];% Coordenadas rotulas ************************
                    elseif a == 1                                                   % Colocacion de rotula inferior
                        con_nodc = con_nodc+1; con_elec = con_elec+1; 
                        nodos(end+1,1:3) = [con_nodc secc(i,end-3) secc(i,end-2)];  % Creacion de nuevos nodos
                        elem_pro(end+1,:) = elem_pro(i,:);
                        elem_pro(end,[1 2 8 16 17])=[con_elec con_nodc 0 cur2];
                        elem_pro(i,[3 9 16 17]) = [con_nodc 0 cur2];
                        graf_rot(end+1,:) = [secc(i,end-3)+t1*Ax secc(i,end-2)+t1*Ay i i];  % Coordenadas rotulas ************************
                    elseif b == 1                                                       % Colocacion de rotula superior
                        con_nodc = con_nodc+1; con_elec = con_elec+1; 
                        nodos(end+1,1:3) = [con_nodc secc(i,end-1) secc(i,end)];        % Creacion de nuevos nodos
                        elem_pro(end+1,:) = elem_pro(i,:);
                        elem_pro(end,[1 3 9 16 17])=[con_elec con_nodc 0 cur2];
                        elem_pro(i,[2 8 16 17]) = [con_nodc 0 cur2];
                        graf_rot(end+1,:) = [secc(i,end-3)+t2*Ax secc(i,end-2)+t2*Ay i i];   % Coordenadas rotulas
                    end
                else                                                                    % Analisis de viga
                    con_nodc = con_nodc+2; con_elec = con_elec+2; 
                    nodos(end+1:end+2,1:3) = [con_nodc-1 secc(i,end-3) secc(i...
                        ,end-2);con_nodc secc(i,end-1) secc(i,end)];                    % Creacion de nuevos nodos
                    elem_pro(end+1:end+2,:) = [elem_pro(i,:);elem_pro(i,:)];
                    elem_pro(end-1,[1 2 3 8 9 16 17])=[con_elec-1 con_nodc-1 con_nodc 0 0 cur1];
                    elem_pro(end,[1 2 8 16 17])=[con_elec con_nodc 0 cur1];
                    elem_pro(i,[3 9 16 17]) = [con_nodc-1 0 cur1];
                    graf_rot(end+1:end+2,:) = [secc(i,end-3)+t1*Ax secc(i,...
                        end-2)+t1*Ay i i;secc(i,end-3)+t2*Ax secc(i,end-2)+t2*Ay con_elec i];           % Coordenadas rotulas 
                end
            end
            axes(axe_dibujo); hold on;                                          % Grafica de rotulas
            graf_rotu = scatter(graf_rot(:,1),graf_rot(:,2),50,'g','filled');
        %% Analisis de Armaduras
        else
            elem_pro(:,16:17) = ones(size(elem_pro,1),2).*cur1;                 % Analisis de Armadura
            if any(ve_conex(:,4)<0)
                ires=find(ve_conex(:,4)<0);
                elem_pro(ires,16:17)=[cell2mat(l_res(-ve_conex(ires,4),3)) -cell2mat(l_res(-ve_conex(ires,4),4))];
            end
        end
    %% Prepara Opcion de Analisis No-Lineal en Pantalla
        l_fle = ((max(vn_coor(:,2))-min(vn_coor(:,2)))+(max(vn_coor(:,3))-...   % Longitud de flecha
            min(vn_coor(:,3))))/2;
        axes(axe_dibujo); hold on;                                              % Llama a los Axes
        fle_nol = drawArrow([vn_coor(n_con,2)-l_fle*0.1 ...
            vn_coor(n_con,3)],[vn_coor(n_con,2) vn_coor(n_con,3)],'g');         % Dibuja flecha                                                        % Bloqueo de botones
        set(fle_nol,'LineWidth');     % Personalizar flecha
        botones(3);                     % Desactiva Botones
        %% ----------------- Desplazamientos Maximo -----------------------
        global desp_max
        desp_max = 0.07 * max(max(vn_coor(:,2))-min(vn_coor(:,2)),max(vn_coor(:,3))-min(vn_coor(:,3)));          % umax = Desplazamiento maximo a iterrar / El 7% de la dimension mas grande en X/Y
        if get(handles.r_l,'value') == 1                            % Si se ingreso valor del desplazamiento maximo
            try; desp_max = str2num(get(handles.e_umax,'string'));end;  % Desplazamineto maximo ingresado
        else                                                        % Si se ingreso % del desplazamineto maximo
            try; desp_max = str2num(get(handles.e_umax,'string'))*max(max(vn_coor(:,2))-min(vn_coor(:,2)),max(vn_coor(:,3))-min(vn_coor(:,3)))/100;end;  % Porcentaje ingresado -->  % de la longitud maxima
        end
        %% ----------------------------------------------------------------
        close(Analisis_No_Lineal);      % Cierra Guide No-Lineal
        op_play = 2;                    % Bandera No-Lineal
        elem_pro(:,16) = elem_pro(:,16)/100; % Cambio de porcentaje a porcion
        PorticosCOD2;                   % Porticos
        mat_res = [{basmm basss} dat_arm];  % Mat/Sec/Desplazaminetos por paso/ Despl NC / P / Fluyen / Nodo control
        %% ----------------- Derivas Metodo Eventos -----------------------
        if op_nolin == 2            % Analisis No-Lineal de Porticos
            global u_toa
            desx = [];
            for i = 1:size(u_toa,2)-1                               % Obtiene desplzamientos en x de cada iteraccion
                desx(end+1,:) = u_toa{i+1}(1:3:3*size(vn_coor,1)-2)'; % Desplazamiento en X
            end
            cx = unique(vn_coor(:,2));                              % Coordenadas en X unicas
            n_lx = size(cx,1); n_ly = size(unique(vn_coor(:,3)),1); % Numero de lineas en X/Y
            des = zeros(size(desx,1),n_ly); der = des;              % Vector de desplazamientos / derivas
            for j = 1:size(desx,1)                                  % Por iteraccion de falla
                des1 = zeros(n_ly-1,n_lx); der1 = des1;             % Vector de desplazamientos / derivas
                for i = 1:n_lx                                      % Analisis por linea en X
                    p_cy = find(vn_coor(:,2) == cx(i));             % Posicion de coordenadas Y por linea X
                    [bas1 bas2] = unique(vn_coor(find(vn_coor(:,2) == cx(i)),3)); p_cy = p_cy(bas2);        % Posicion ordenada de los nodos analizados
                    bas = abs(desx(j,p_cy(2:end))-desx(j,p_cy(1:end-1)));            % Desplazamientos por linea en Y
                    des1(1:(size(p_cy,1)-1),i) = bas;
                    der1(1:(size(p_cy,1)-1),i) = bas./(vn_coor(p_cy(2:end),3)-vn_coor(p_cy(1:end-1),3))';   % Derivas de Piso
                end 
                des(j,2:end) = max(des1,[],2)'; % Anexa desplazamientos finales
                der(j,2:end) = max(der1,[],2)'; % Anexa derivas finales
                %r_der = {des der};              % Resultados desplaaminetos / derivas por falla
            end
            r_der = {des der};
        end
        %% ----------------------------------------------------------------
        try delete(txr); end
        txr=[];                         % Texto que contiene numero de rotulas 
        if op_nolin == 1                % Si Analisis No-Lineal es en Armadura Guarda Coordenadas de Nodos
            vn_cop = vn_coor(:,2:3);
        elseif op_nolin == 2            % Anlisis No-Lineal de Porticos
            vn_coor_o=vn_coor(:,[2 3]); %vector de coordenadas originales de porticos
            pro_lon = mean(long(find(long>0)));
            for i=1:size(graf_rot,1)
                txr = [txr text(graf_rot(i,1)+pro_lon*0.05,graf_rot(i,2)+pro_lon*0.05,...
                    num2str(CONN2(graf_rot(i,3),3)),'Color','g')];
            end
        end
%% --------------------- Analisis No-Lineal por Pasos ---------------------     
    else
        % ------------------- Opciones Avanzadas ---------------------
        umax = 0.07 * max(max(vn_coor(:,2))-min(vn_coor(:,2)),max(vn_coor(:,3))-min(vn_coor(:,3)));          % umax = Desplazamiento maximo a iterrar / El 7% de la dimension mas grande en X/Y
        if get(handles.r_l,'value') == 1                            % Si se ingreso valor del desplazamiento maximo
            try; umax = str2num(get(handles.e_umax,'string'));end;  % Desplazamineto maximo ingresado
        else                                                        % Si se ingreso % del desplazamineto maximo
            try; umax = str2num(get(handles.e_umax,'string'))*max(max(vn_coor(:,2))-min(vn_coor(:,2)),max(vn_coor(:,3))-min(vn_coor(:,3)))/100;end;  % Porcentaje ingresado -->  % de la longitud maxima
        end
        dut = 0.1;try; dut = str2num(get(handles.e_pas,'string'));end;      % Paso del desplazamiento incremental
        %-------------------------------------------------------------
        if op_nolin == 2                                                                    % Funcion para ordenar porticos / Necesario para programa de Cubo
            elemenrotulas = [get(handles.rinf,'value') get(handles.rsup,'value');1 1];      % Ubicacion de Rotulas [inf sup;izq der]
            [c_or,nc]= ordenar_porticos(elemenrotulas);                                     % Funcion para organizar portico c_or -> [Pos_Nuevo Pos_Ant Cod_Ant]  nc->  posicion de ultima columna
            n_con = find(c_or(:,2) == n_con);                                               % Posicion de Nodo de Control / Nuevo Nodo de Control (Al reordenar porticos cambia)
        end
        %% -------------- Recoleccion de datos General --------------------
        vn_coor_o = vn_coor(:,[2 3]); vn_cop = vn_coor(:,2:3);                                              % Vector de coordenadas originales de porticos / Carlos
        CONN = [ve_conex(:,1:3) zeros(size(ve_conex,1),2)];                                                 % CONN = [N#Elemento Ni NF 0 0]  /  Genera Tabla de Conectividad
        XY =  [vn_coor(:,1:6) zeros(size(vn_coor,1),3) sum(vn_coor(:,4:6),2)+ones(size(vn_coor,1),1)];      % Vector de Nodos 
        XY(n_con,7) = 1; XY(find(XY(:,10) > 1),10) = 0;                                                     % Modifica --> Posicion de carga puntual incremental / Ultimo vector de XY si existe restriccion
        % ------------ Propiedades del Material y Seccion ----------------
        [logi,SECp] = ismember(ve_conex(:,4),vs_pro(:,1));                          % Posicion de Secciones
        [logiM,MATp] = ismember(cell2mat(vs_eti(SECp,6)),vm_pro(:,1)); logiS = [];  % Posicion de Materiales
        teta = [];      % Vector de Angulos 
        for i = 1:size(ve_conex,1)
            logiS(i,1:3) = [vs_pro(SECp(i),6+ve_rot(i,2)) vs_pro(SECp(i),8+ve_rot(i,2)) vs_pro(SECp(i),4)/vs_pro(SECp(i),4+ve_rot(i,2))];   % Inercia / Z / Factor de Forma 1.5
            ni = vn_coor(find(vn_coor(:,1) == ve_conex(i,2)),2:3);          % Posicion de nodo inicial
            nf = vn_coor(find(vn_coor(:,1) == ve_conex(i,3)),2:3);          % Posicion de nodo final
            teta(end+1) = radtodeg(atan((nf(2)-ni(2))/(nf(1)-ni(1))));      % Angulo del elemento 
        end   
        PROP = [ve_conex(:,1) vm_pro(MATp,3) vs_pro(SECp,4) logiS(:,1:2) vm_pro(MATp,4) logiS(:,3) vm_pro(MATp,5:6)];     % [#Elemento E A I Z v Factor de Corte alpha Fy]
        cur = find(cell2mat(vr_pro(:,3)) == op_nolin);      % Todas las curvas para estructura especifica
        %% ------------------ Tipo de Estructura --------------------------
        if op_nolin == 1                % Analiza Elementos Armaduras
            ve_rel(:,2) = {[3 6]};      % Transforma todos los elementos a tipo Armadura
            tol=0.000000001;            % Tolerancia para error en Armaduras
            elemenrotulas = 0; columnasportico =0; Lp = [0];    % Modifica variables para armadura / No existe en Armadura
            % ------- Comportamiento del Material ------------
            if vr_pro{c1,3} == 3
                cm = cell(size(ve_conex,1),1); cm(:,1)={vr_pro{c1,4}(:,[2 1])};     % Comportamiento de curva
            else
                cm = {};ne = size(ve_conex,1); arma = vr_pro{c1,4};   % Numero de elementos / Comportamiennto de Viga
                for i = 1:ne
                    ey = PROP(i,9)/PROP(i,2); cm(end+1,1) = {[0 0;1 ey;6 (5*ey*100/arma)+ey]}; % ey->Deformacion unitaria / cm--> Comportamiento
                end
            end
            [Pv,Rotulas,uf,rotaciones,Maplt,cr,u_lt,cv_hy,Ugeneral,CONNP,XYP,L]= NSP_Pushover_armadura(tol,umax,CONN,XY,PROP,elemenrotulas,columnasportico,cm,Lp,dut);  % Programa Analisis No-Lineal de Armaduras
            % --------------- Reduccion de datos para Visualizacion --------------
            n_i = 300;                              % Numero maximo de iteraciones
            if size(Rotulas,2) > n_i                % Calcula reduccion de pasos
                n_i = round(size(Rotulas,2)*1.2);   % Numero de pasos final 
            end
            fal = [];                               % Inicializacion de vector de recoleccon de fallas
            for i = 1:size(Rotulas,2)               % Saca los desplazaminetos en donde se encuentra las fallas 
                fal(end+1,1) = find(Pv(:,2) == Rotulas{i}(1));   % Fallas en la estructura
            end
            fal = unique([fal; size(Pv,1);(1:ceil(size(Pv,1)/n_i):size(Pv,1))']);  % Posicion de fallas
            mat_res{4} = Pv(fal,[2 1]);     % Push Over Nodo de control [Desplazamientos Carga]
            mat_res{5} = [zeros(1,size(vn_coor,1));Ugeneral(:,(fal(2:end)*2)-2)']; % Desplazamientos en X (mxn) m: Despla / n: Nodos
            mat_res{6} = [zeros(1,size(vn_coor,1));Ugeneral(:,(fal(2:end)*2)-1)']; % Desplazamientos en Y (mxn) m: Despla / n: Nodos
        elseif op_nolin == 2                                % Analiza Elementos Porticos  
            ve_rel(:,2) = cell(size(ve_rel,1),1);           % Transforma todos los elementos a tipo Porticos
            tol=0.001;                                      % Tolerancia para error en Porticos
            columnasportico = size(find(teta == 90),2);     % N# de Columnas
            Lp = [0];       % Cargas gravitacionales
            PROP (:,7)=1;   % Modificar Factor de corte
            % ------- Comportamiento del material elasto plastico ---------
            c2 = pc(get(handles.p_curvac,'value')); 
            if vr_pro{c1,3} == 4                                                    % Curvas Avanzadas
                cm = cell(size(ve_conex,1),1); 
                cm(find(teta ~= 90),:)={vr_pro{c1,4}(:,[2 1])};             % Comportamiento de Vigas 
                cm(find(teta == 90),:)={vr_pro{c2,4}(:,[2 1])};             % Comportamiento de Columnas
            else                                                                    % Curvas Elasto-plastica
                viga = vr_pro{c1,4}; colu = vr_pro{c2,4};   % Comportamiento viga / comportamiento Columnas
                %viga = cell2mat(vr_pro(cur(get(handles.p_curvag,'value')),4:5));    % Comportamiennto de Viga
                viga = [0 0;1 viga(2);2 (viga(2)*100/(viga(1)))+viga(2)];           % Comportamiennto de Viga 
                %colu = cell2mat(vr_pro(cur(get(handles.p_curvac,'value')),4:5));    % Comportamiennto de Columna
                colu = [0 0;1 colu(2);2 (colu(2)*100/(colu(1)))+colu(2)];           % Comportamiennto de Columna
                cm = cell(size(ve_conex,1),1); cm(find(teta == 90),:)={colu}; cm(find(teta ~= 90),:)={viga};  % Comportamiento de Material
            end
            %--------------------------------------------------------------
            [Pv,Rotulas,uf,rotaciones,Maplt,cr,u_lt,cv_hy,Ugeneral,CONNP,XYP,L,equalDOF]= NSP_Pushover(tol,umax,CONN,XY,PROP,elemenrotulas,columnasportico,cm,Lp,dut);  % Programa Analisis No-Lineal de Porticos
            Ugeneral = Ugeneral(find(XYP(:,end) == 0),:);   % Extrae Desplazamientos en Nodales
            n_i = 300;                              % Numero de paso maximos
            if size(Rotulas,2) > n_i                % Calcula reduccion de pasos
                n_i = round(size(Rotulas,2)*1.2);   % Numero de pasos finales si excede mas n_i fallas 
            end
            fal = [];
            for i = 1:size(Rotulas,2)           % Saca los desplazaminetos en donde se encuentra las fallas 
                fal(end+1,1) = find(Pv(:,2) == Rotulas{i}(1));   % Fallas en la estructura
            end
            desx = Ugeneral(:,(fal*2)-2)'; desy = Ugeneral(:,(fal*2)-1)';   % Desplazamientos en nodos X/Y en las fallas
            fal = unique([fal; size(Pv,1);(1:ceil(size(Pv,1)/n_i):size(Pv,1))']);  % Anade punto 0 y final
            mat_res{4} = Pv(fal,[2 1]);     % Push Over Nodo de control [Desplazamientos Carga]
            dxn = [zeros(1,size(vn_coor,1));Ugeneral(:,(fal(2:end)*2)-2)'];
            dyn = [zeros(1,size(vn_coor,1));Ugeneral(:,(fal(2:end)*2)-1)'];
            mat_res{5} = dxn;%[zeros(1,size(vn_coor,1));Ugeneral(:,(fal(2:end)*2)-2)']; % Desplazamientos en X (mxn) m: Despla / n: Nodos
            mat_res{6} = dyn;%[zeros(1,size(vn_coor,1));Ugeneral(:,(fal(2:end)*2)-1)']; % Desplazamientos en Y (mxn) m: Despla / n: Nodos
            nit = size(mat_res{5},1); % Numero de iteracciones / Numero de elementos
            bas1 = []; bas2 = [];
            for j = 1:nit
                a = 0;con = 0;  % a-> Variar entre columna y viga posicion de rotula / con -> Contador para rotulas 
                for i = 1:size(ve_conex,1);                         % Reorganizar modelo
                    ni = find(vn_coor(:,1) == ve_conex(i,2)); nf = find(vn_coor(:,1) == ve_conex(i,3));
                    % ----------------------- Posicion de rotulas -------------------------
                    Ax = (vn_coor(nf,2)+dxn(j,nf)) - (vn_coor(ni,2)+dxn(j,ni)); % Longitud en X del elemento
                    Ay = (vn_coor(nf,3)+dyn(j,nf)) - (vn_coor(ni,3)+dyn(j,ni)); % Longitud en Y del elemento
                    if i > nc  % Rotulas en Vigas
                        a = 1;
                    end
                    if elemenrotulas(1+a) == 1        % Columna superior / Viga izquierda
                        con = con+1;
                        bas1(j,con) = (vn_coor(ni,2)+dxn(j,ni))+(0.15*Ax); bas2(j,con)= (vn_coor(ni,3)+dyn(j,ni))+0.15*Ay;     % Ux de rotula / Uy de rotula
                    end
                    if elemenrotulas(3+a) == 1    % Columna inferior / Viga derecha
                        con = con+1;
                        bas1(j,con) = (vn_coor(ni,2)+dxn(j,ni))+(0.85*Ax); bas2(j,con)= (vn_coor(ni,3)+dyn(j,ni))+0.85*Ay;     % Ux de rotula / Uy de rotula
                    end
                end
            end
            mat_res{8} = [bas1 bas2];
            %% ----------------- Derivas Metodo Pasos ---------------------
            cx = unique(vn_coor(:,2));                              % Coordenadas en X unicas
            n_lx = size(cx,1); n_ly = size(unique(vn_coor(:,3)),1); % Numero de lineas en X/Y
            des = zeros(size(desx,1),n_ly); der = des;              % Vector de desplazamientos / derivas
            for j = 1:size(desx,1)                                  % Por iteraccion de falla
                des1 = zeros(n_ly-1,n_lx); der1 = des1;             % Vector de desplazamientos / derivas
                for i = 1:n_lx                                      % Analisis por linea en X
                    p_cy = find(vn_coor(:,2) == cx(i));             % Posicion de coordenadas Y por linea X
                    [bas1 bas2] = unique(vn_coor(find(vn_coor(:,2) == cx(i)),3)); p_cy = p_cy(bas2);        % Posicion ordenada de los nodos analizados
                    bas = abs(desx(j,p_cy(2:end))-desx(j,p_cy(1:end-1)));            % Desplazamientos por linea en Y
                    des1(1:(size(p_cy,1)-1),i) = bas;
                    der1(1:(size(p_cy,1)-1),i) = bas./(vn_coor(p_cy(2:end),3)-vn_coor(p_cy(1:end-1),3))';   % Derivas de Piso
                end 
                des(j,2:end) = max(des1,[],2)'; % Anexa desplazamientos finales
                der(j,2:end) = max(der1,[],2)'; % Anexa derivas finales
                %r_der = {des der};              % Resultados desplaaminetos / derivas por falla
            end
            r_der = {des der};
            %% ------------------------------------------------------------
        end
        %% ---------------- Datos para Resultados -------------------------
        zoom_rest; bas1 = []
        for i = 1:size(vn_obj,1)        % Saca posicion de nodos
            bas1(end+1,:) = [get(vn_obj(i,3),'XData') get(vn_obj(i,3),'YData')];  
        end
        mat_res{7} = bas1;
        [unib]=unique(MATp);                                                % Extraer Materiales
        mat_res{1} = [vm_eti(unib,2) num2cell(vm_pro(unib,3:6))];
        [unib,posb]=unique(SECp); ts = {'Rectangular' 'Perfil I' 'Otras'};  % Extraer Secciones
        mat_res{2} = [vs_eti(unib,2) ts(cell2mat(vs_eti(unib,4)))' num2cell(vs_pro(unib,[3 2])) num2cell(PROP(posb,3)) num2cell(PROP(posb,3)./PROP(posb,7)) num2cell(PROP(posb,4:5))];
        Ef = (1:1:size(Pv,1)-1); U1g = Pv(:,2)'; P1g = Pv(:,1)';
        mat_res{3} = Rotulas;
        %% --------------- Programa Visual ------------------
        botones(3);                     % Desactiva Botones
        set(handles.p_curvag,'value',1);set(handles.p_curvac,'value',1);    % Valores de pop-menu
        close(Analisis_No_Lineal);      % Cierra Guide No-Lineal
        op_play = 2;
    end
    op_non = 0; etinodo_act();          % Borra etiqueta de Nodos
end

function r_l_Callback(hObject, eventdata, handles)
global vn_coor mag_text
set(handles.r_l,'value',1); % Activa opcion de longitud
set(handles.r_p,'value',0); % Desactiva opcion de porcentaje
umax = '100';try; umax = num2str(0.07*max(max(vn_coor(:,2))-min(vn_coor(:,2)),max(vn_coor(:,3))-min(vn_coor(:,3))));end;
set(handles.e_umax,'string',umax);
set(handles.t_pmax,'string',strcat('Maximo (',mag_text{2},')'));

function r_p_Callback(hObject, eventdata, handles)
set(handles.r_l,'value',0); % Desactiva opcion de longitud
set(handles.r_p,'value',1); % Activa opcion de porcentaje
set(handles.e_umax,'string','7');
set(handles.t_pmax,'string','Maximo (%)');

%% -------------------------- No Programado -------------------------------
function p_tipo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p_nodo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p_curvag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p_curvac_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function p_curvac_Callback(hObject, eventdata, handles)
function p_curvag_Callback(hObject, eventdata, handles)
function p_nodo_Callback(hObject, eventdata, handles)
function p_met_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function e_umax_Callback(hObject, eventdata, handles)

function e_umax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_pas_Callback(hObject, eventdata, handles)

function e_pas_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
