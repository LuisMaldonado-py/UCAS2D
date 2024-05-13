function elementr(clic,ax)                                                  % FUNCION PARA DIBUJO DE ELEMENTOS EN REJILLA
global n_nodo ban_apl sub_e x1 y1 col_l ln coor_h
global pop_esec pop_etip
if clic == 1                                                                % Si se da click derecho
    if n_nodo == 1 & ban_apl == 1                                           % Se activo bandera de aproximacion
        x1 = coor_h(sub_e,1);y1 = coor_h(sub_e,2);                          % Coordenadas del primer nodo
        n_nodo = 2;
        axes(ax)
        ln=line([x1 x1],[y1 y1],'LineWidth',1.5,'Color',col_l,'linestyle','--');  % Linea guia actualizar
    elseif n_nodo == 2 & ban_apl == 1    
        n_nodo = 1;
        axes(ax)
        delete(ln)
        x2 = coor_h(sub_e,1);y2 = coor_h(sub_e,2);                          % Guarda coordenads del 2do nodo
        point_new(x1,y1,ax);                                                % Funcion dibujar punto nuevo 1 
        point_new(x2,y2,ax);                                                % Funcion dibujar punto nuevo 2
        sec = get(pop_esec,'value');
        tip = get(pop_etip,'value');
        element_new(x1,y1,x2,y2,sec,tip,ax);
    end
elseif clic == 3                                                            % Condicion para salir
    salir_ele()
end
global  vn_obj vn_coor ve_obj ve_conex

vn_obj
vn_coor
ve_obj
ve_conex
