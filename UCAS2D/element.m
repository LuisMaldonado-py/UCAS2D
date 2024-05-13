function element(clic,ax)                                                   % FUNCION PARA DIBUJO DE PUNTOS
global n_nodo ban_apl sub_e x1 y1 col_l ln vn_coor
global pop_esec pop_etip
if clic == 1                                                                % Si se da click derecho
    if n_nodo == 1 & ban_apl == 1                                           % Se activo bandera de aproximacion
        x1 = vn_coor(sub_e,2);y1 = vn_coor(sub_e,3);                        % Saca coordenadas elejidas
        n_nodo = 2;                                                         % Bandera de nodo 2 
        %axes(ax)                                                            % Activa axes                      
        %hold on                                                             % Sobremonta graficas
        ln=line([x1 x1],[y1 y1],'LineWidth',1.5,'Color',col_l,'linestyle','--');  % Linea guia actualizar
    elseif n_nodo == 2 & ban_apl == 1    
        n_nodo = 1;                                                         % Bandera de nodo 1 reinicia
        %axes(ax)                                                            % Activa axes  
        delete(ln);                                                         % Borra linea guia 
        x2 = vn_coor(sub_e,2);y2 = vn_coor(sub_e,3);                        % Coordenadas del nodo 2
        sec = get(pop_esec,'value');
        tip = get(pop_etip,'value');
        element_new(x1,y1,x2,y2,sec,tip,ax);
    end
elseif clic == 3 
    salir_ele()
end    