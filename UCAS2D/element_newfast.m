function element_newfast(conex,tip)        % FUNCION PARA DIBUJO DE ELEMENTOS
global vn_coor ve_conex ve_tem ve_w ve_pro ve_rel ve_obj ve_add ve_p vs_geo
global con_ele esp simb_l col_l ve_des ve_rot ve_rotu axe_dibujo
axes(axe_dibujo);hold on;
for i = 1:size(conex,1)
    ni = find(vn_coor(:,1) == conex(i,1));
    nf = find(vn_coor(:,1) == conex(i,2));
    [xi,yi,xf,yf] = ordenar_2nodos(vn_coor(ni,2),vn_coor(ni,3),vn_coor(nf,2),vn_coor(nf,3));     % Ordena nodos para configurar ni a nf
    if xi ~= vn_coor(ni,2)
        conex(i,:) = [conex(i,2) conex(i,1)];
        bas = ni; ni = nf; nf = bas;                    % Guarda variables de nodos cambiados    
    end
    ve_obj(end+1,3) = line([vn_coor(ni,2) vn_coor(nf,2)],[vn_coor(ni,3) vn_coor(nf,3)],'LineWidth',esp,'LineStyle',simb_l,'Color',col_l);  % Grafico de linea   ;  % Linea guia actualizar
    set(ve_obj(end,3),'DisplayName',num2str(i));
    set(ve_obj(end,3),'ButtonDownFcn','selec_ele(gco)');
end
con_ele = size(conex,1);
cod = (1:1:con_ele)';
ve_conex = [cod conex ones(con_ele,1)*vs_geo(1,1)];     % Vector de Conexion y Seccion: Ve_conex = [Code Ni Nf Sec]
ve_tem = [cod zeros(con_ele,2)];                        % Vector de Cargas por Temperatura: Ve_tem = [Code Tinf Tsup]
ve_w = [cod zeros(con_ele,6)];                          % Vector de Cargas distribuida uniforme Ve_w = [Code  Axial a b Cortante a b]
ve_p = [cod zeros(con_ele,9)];                          % Vector de Cargas distribuida uniforme Ve_w = [Code  Axial a b Cortante a b]
ve_pro = [cod ones(con_ele,7)];                         % Vector de propiedades modificadas [Ve_pro = [Code A Acx Acy Ix Iy Zx Zy]
ve_add = [cod zeros(con_ele,1)];                        % Vector de release ve_rel = {Code {rel}}       
ve_des = [cod ones(con_ele,1) zeros(con_ele,2)];        % Vector de desfase Ve_des = [Code tip db  de]
ve_rot = [cod ones(con_ele,1)];                         % Vector de desfase Ve_des = [Code tip ]   tip == 1 por defecto, ti[ == 2 rota 90
ve_rotu = [cod zeros(con_ele,1)];                       % Vector de rotulas Ve_des = [Code Codr]
ve_obj(:,1:2) = [cod cod];                              % Vector de objetod codigo y nombre
ve_rel = num2cell(cod);                                 % Vector de release
if tip == 1            
    ve_rel(:,2) = {[3 6]};
else
    ve_rel(:,2) = cell(con_ele,1);
end    
 