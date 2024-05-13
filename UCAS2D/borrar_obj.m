function borrar_obj()
global nod_sel ele_sel vn_obj vn_coor vn_fx vn_fy vn_fg vn_const con_const
global ve_obj ve_conex ve_add ve_tem ve_w ve_p ve_rel ve_pro ve_des ve_rot
global vn_coor_o
nele = ele_sel;                 % Guarda informacion inicial de elementos seleccionados 
if isempty(nod_sel) == 0        % Ve si el vector esta con elementos
    n_s = find(ismember(vn_obj(:,1),nod_sel(:,1)) == 1);    % Obtengo posicion de nodos seleccionados
    delete(vn_obj(n_s,3));      % Borrar puntos
    vn_obj(n_s,:) = [];         % Borrar Vector de Objeto y etiqueta: Guarda el elemento visualVn_obj = {Codn name obj]
    vn_coor(n_s,:) = [];        % Borrar Vector de Coordenadas y restricciones: Guarda coordenadas y restricciones Vn_coor = {Codn x y rx ry rg u1 u2 u3]
    vn_fx(n_s,:) = [];          % Borrar Vector de Fuerzas nodales en X Vn_fy = {Codn   Fx1]
    vn_fy(n_s,:) = [];          % Borrar Vector de Fuerzas nodales en Y Vn_fy = {Codn   Fy1]
    vn_fg(n_s,:) = [];          % Borrar Vector de momentos nodales Vn_fg = {Codn   M1]        %[ele_conec] = conectividad(cod_nod,an)
    if isempty(ve_conex) == 0
        e_cp = find(ismember(ve_conex(:,2),nod_sel(:,1)) == 1 | ismember(ve_conex(:,3),nod_sel(:,1)) == 1); % Posicion de elementos conectados
        if isempty(ele_sel) == 0 & isempty(e_cp) == 0       % Si existe elem con y elem sel
            e_cc = ve_conex(e_cp,1);                        % Codigo de elementos conectados
            bas1 = find(ismember(e_cc,ele_sel(:,1)) == 0);  % Posicion de elementos nuevos/no sele
            %bas1 = find(ismember(ele_sel(:,1),e_cc) == 0);  % Posicion de elementos nuevos/no sele
            if isempty(bas1) == 1                          % Analiza si existen elemntos conectados
                ele_sel(end+1:end+size(e_cc,1),1) = e_cc;   % Carga elementos
            else
                e_cc(bas1,:) = [];
                ele_sel(end+1:end+size(e_cc,1),1) = e_cc;
            end
        elseif isempty(ele_sel) == 1 & isempty(e_cp) == 0           % Si hay elementos nuevos y no hay elementos seleccionados
            ele_sel(end+1:end+size(e_cp,1),1) = ve_conex(e_cp,1);   % Anexa elementos
            ele_sel(1,2) = 0;  
        end
    end
    for i = 1:size(nod_sel,1)       % For para eliminar elemento
        delete(nod_sel(i,2));       % Borrar nodos seleccionados
    end
    nod_sel = [];                   % Vector vacio de seleccion de nodos
    if isempty(vn_obj) == 0         % Nombre de nodos de 0 a #nodos
        vn_obj(:,2) = (1:1:size(vn_obj,1))'; % Actusliza lista   
    end
    vn_const = {}; con_const = 0;   % Elimino casos de constraints vn_const = {cod_cons 'Name' Master Slave [Dx Dy Dz]} D = 0 Sin Restriccion, D = 1 Con Restriccion 
end
if isempty(ele_sel) == 0
   e_s = find(ismember(ve_obj(:,1),ele_sel(:,1)) == 1);   % Posicion de elementos seleccionados
    delete(ve_obj(e_s,3));
    ve_obj(e_s,:) = [];                 % Vector de Objeto y etiqueta: Guarda el elemento visualVn_obj = [Code name obj]
    ve_conex(e_s,:) = [];               % Vector de Conexion y Seccion: Ve_conex = [Code Ni Nf Sec]
    ve_add(e_s,:) = [];                 % Vector de errores ve_error = [code Al]
    ve_tem(e_s,:) = [];                 % Vector de Cargas por Temperatura: Ve_tem = [Code Tinf Tsup]
    ve_w(e_s,:) = [];                   % Vector de Cargas distribuida uniforme Ve_w = [Code  Axial a b Cortante a b]
    ve_p(e_s,:) = [];                   % Vector de Cargas puntual Ve_p = [Code FuerzaX a b FuerzaY a b Momento a b]
    ve_rel(e_s,:) = [];                 % Vector de release ve_rel = {Code   1 2 3 4 5 6]
    ve_pro(e_s,:) = [];                 % Vector de propiedades modificadas Ve_pro = [Code A Acx Acy Ix Iy Zx Zy]
    ve_des(e_s,:) = [];                 % Vector de desfase Ve_des = [Code tip db  de]      tip = 0 (Sin Desfase), tip = 2 (Auto),tip = 3 (manual)
    ve_rot(e_s,:) = [];                 % Vector de rotacion de seccion Ve_des = [Code tip ]   tip == 1 por defecto, ti[ == 2 rota 90
    if isempty(nele) == 0               % Borra elementos seleccionados
        for i = 1:size(nele,1)          % Borrar elementos seleccionados
            delete(ele_sel(i,2));       % Borrar elementos seleccionados
        end
    end
    ele_sel = [];                       % Vacia vector de elemntos seleccionados
    if isempty(ve_obj) == 0             % Nombre de elementos de 0 a #elementos
        ve_obj(:,2) = (1:1:size(ve_obj,1))';    % Actualiza lista de nodos
    end
end
Reorganizar_Nodos();    % Reorganiza Nodos
try; vn_coor_o = vn_coor(:,[2 3]); end;    % Variable para dibujar linea de seleccion