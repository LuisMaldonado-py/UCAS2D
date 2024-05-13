function etinodo_act()                                            % Funcion para visualizacion de releases
global v_visu op_non vn_coor axe_dibujo vn_obj ve_conex
if isempty(v_visu) == 0                                         % Revisa si vector de visualicion esta vacio
    for i = 1:size(v_visu,1)                                    % Recorre vector de visualizacion para borrar datos
        if isempty(v_visu(i,3)) == 0 & v_visu(i,3) ~= 0         % Revisa que no este vacio o sea cero
            delete(v_visu(i,3)); v_visu(i,3) = 0;
        end
    end
end
if op_non == 1                                                  % Crea visualizacion de etiquetas
    %-------------------------- Longitud y Angulo -----------------------------
    visu_lon = [];
    visu_ang = [];
    for i = 1:size(ve_conex,1)                                  % Recorre anlizando cada elemento
        ni = ve_conex(i,2); ni = find(vn_coor(:,1) == ni);  % Busca Nodo inicial
        xi = vn_coor(ni,2); yi = vn_coor(ni,3);             % Coordenadas del nodo inicial
        nf = ve_conex(i,3); nf = find(vn_coor(:,1) == nf);  % Busca Nodo final
        xf = vn_coor(nf,2); yf = vn_coor(nf,3);             % Coordenadas del nodo final
        [teta,long] = angulo_360(xi,xf,yi,yf);
        visu_lon(i,1) = long;
        visu_ang(i,1) = teta;
    end
    pro_lon = mean2(visu_lon);
%--------------------------------------------------------------
    axes(axe_dibujo)
    hold on 
    for i = 1:size(vn_coor,1)                                   % Coloca en cada elelmento etiqueta
        v_visu(i,3) = text(axe_dibujo,vn_coor(i,2)+(pro_lon*0.05),vn_coor(i,3)+(pro_lon*0.05),int2str(vn_obj(i,2))); % Crea texto etiqueta
    end
end 