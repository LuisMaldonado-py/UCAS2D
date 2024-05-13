function element_new(x1,y1,x2,y2,sec,tip,ax)        % FUNCION PARA DIBUJO DE ELEMENTOS
global vn_coor ve_conex ve_tem ve_w ve_pro ve_rel ve_obj ve_add ve_p
global con_ele esp simb_l col_l ve_des ve_rot ve_rotu
if x1 ~= x2 | y1 ~= y2                                                      % Evita error que se dibuje un elemento con nodos similares
    [xi,yi,xf,yf] = ordenar_2nodos(x1,y1,x2,y2);                            % Ordena nodos para configurar ni a nf
    ni = find(vn_coor(:,2) == xi & vn_coor(:,3) == yi); ni = vn_coor(ni,1); % Obtiene nodo incial 
    nf = find(vn_coor(:,2) == xf & vn_coor(:,3) == yf); nf = vn_coor(nf,1); % Obtiene nodo final
    ban_ele = 1;                                                            % Activa bandera de crear elemento
    if isempty(ve_obj) == 0                                                 % Evita error de repetir elementos
        e1 = find(ve_conex(:,2) == ni & ve_conex(:,3) == nf);
        e2 = find(ve_conex(:,2) == nf & ve_conex(:,3) == ni);
        if isempty(e1) == 0 | isempty(e2) == 0                          
            ban_ele = 0; 
        end
    end
    if ban_ele == 1                                                         % Sie el elemento es nuevo
        con_ele = con_ele + 1;                                              % Contador de eleemntos
        rel = [];                                                           % Release de porticos y vigas
        if tip == 1                                                         % Release de armadura
        	rel = [3 6];
        end 
        %------------ MODIFICACION VECTORES ELEMENTALES -------------------
        ve_conex(end+1,:) = [con_ele ni nf sec];        % Vector de Conexion y Seccion: Ve_conex = [Code Ni Nf Sec]
        ve_tem(end+1,:) = [con_ele 0 0];                % Vector de Cargas por Temperatura: Ve_tem = [Code Tinf Tsup]
        ve_w(end+1,1:7) = [con_ele 0 0 0 0 0 0];  % Vector de Cargas distribuida uniforme Ve_w = [Code  Axial a b Cortante a b]
        ve_p(end+1,1:10) = [con_ele 0 0 0 0 0 0 0 0 0];        % Vector de Cargas distribuida uniforme Ve_w = [Code  Axial a b Cortante a b]
        ve_pro(end+1,:) = [con_ele 1 1 1 1 1 1 1];          % Vector de propiedades modificadas [Ve_pro = [Code A Acx Acy Ix Iy Zx Zy]
        ve_rel(end+1,1:2) = {con_ele rel};              % Vector de release ve_rel = {Code {rel}}       
        ve_add(end+1,1:2) = [con_ele 0];              % Vector de release ve_rel = {Code {rel}}       
        ve_des(end+1,:) = [con_ele 1 0 0];                % Vector de desfase Ve_des = [Code tip db  de]
        ve_rot(end+1,:) = [con_ele 1];                % Vector de desfase Ve_des = [Code tip ]   tip == 1 por defecto, ti[ == 2 rota 90
        ve_rotu(end+1,:) = [con_ele 0];                % Vector de rotulas Ve_des = [Code Codr]
        axes(ax)
        ve_obj(end+1,3) = line([xi xf],[yi yf],'LineWidth',esp,'LineStyle',simb_l,'Color',col_l);  % Grafico de linea   ;  % Linea guia actualizar
        ve_obj(end,1) = con_ele;                        % Vn_obj = [Code name obj]
        ve_obj(:,2) = (1:1:size(ve_obj,1))';            % Ordena elementos 
        set(ve_obj(end,3),'DisplayName',num2str(con_ele));
        set(ve_obj(end,3),'ButtonDownFcn','selec_ele(gco)');
        %------------------------------------        
	end    
end
 