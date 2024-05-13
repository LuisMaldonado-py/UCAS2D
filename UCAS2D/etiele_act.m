function etiele_act()                                            % Funcion para visualizacion de releases
global v_visu axe_dibujo l_res
global op_eln ve_obj ve_conex vs_eti vm_eti ve_rot ve_pro ve_des vn_coor
if isempty(v_visu) == 0                                         % Revisa si vector de visualicion esta vacio
    for i = 1:size(v_visu,1)                                    % Recorre vector de visualizacion para borrar datos
        if isempty(v_visu(i,4)) == 0 & v_visu(i,4) ~= 0         % Revisa que no este vacio o sea cero
            delete(v_visu(i,4)); v_visu(i,4) = 0;
        end
    end
end
if op_eln > 0
    eti = {};
    if  op_eln == 1   
        eti(:,1) = cellstr(string(ve_obj(:,2)));
    elseif op_eln == 2 | op_eln == 3
        for i = 1:size(ve_conex,1)
            sub = ve_conex(i,4);
            if sub>0
            sub = find(cell2mat(vs_eti(:,1)) == sub);
            eti(i,1) = vs_eti(sub,2);
            else
            eti(i,1) = l_res(-sub,1);
            end
            if op_eln == 3
                if sub>0
                sub = vs_eti{sub,6};
                sub = find(cell2mat(vm_eti(:,1)) == sub);
                eti(i,1) = vm_eti(sub,2);
                else
                eti(i,1) = {'Resortes'};
                end
            end
        end
    elseif  op_eln == 4   
        for i = 1:size(ve_conex,1)
            if isequal(ve_pro(i,2:end),[1 1 1 1 1 1 1]) == 1
                eti(i,1) = {'No'};
            else
                eti(i,1) = {'Si'};
            end
        end 
    elseif  op_eln == 5   
        for i = 1:size(ve_conex,1)
            if ve_rot(i,2) == 1
                eti(i,1) = {'0°'};
            else
                eti(i,1) = {'90°'};
            end
        end 
    elseif  op_eln == 6   
        for i = 1:size(ve_conex,1)
            if ve_des(i,2) == 1
                eti(i,1) = {'Ninguno'};
            elseif ve_des(i,2) == 2
                eti(i,1) = {'Auto'};
            else    
                eti(i,1) = {'Manual'};
            end
        end 
    end
    %-------------------------- Longitud y Angulo -----------------------------
    visu_lon = [];
    visu_ang = [];
    visu_coor = [];
    for i = 1:size(ve_conex,1)                                  % Recorre anlizando cada elemento
        ni = ve_conex(i,2); ni = find(vn_coor(:,1) == ni);  % Busca Nodo inicial
        xi = vn_coor(ni,2); yi = vn_coor(ni,3);             % Coordenadas del nodo inicial
        nf = ve_conex(i,3); nf = find(vn_coor(:,1) == nf);  % Busca Nodo final
        xf = vn_coor(nf,2); yf = vn_coor(nf,3);             % Coordenadas del nodo final
        [teta,long] = angulo_360(xi,xf,yi,yf);
        a = 1;
        if teta > 270 & teta < 360 == 90
            a = -1;
        end    
        Ay = cos(degtorad(teta));
        Ax = a * sin(degtorad(teta));  
        visu_lon(i,1) = long;
        visu_ang(i,1) = teta;
        visu_coor(i,1:4) = [(xi+xf)/2 (yi+yf)/2 Ax Ay];
    end
    pro_lon = mean2(visu_lon);
%--------------------------------------------------------------
    axes(axe_dibujo)
    hold on 
    for i = 1:size(ve_conex,1)                                   % Coloca en cada elelmento etiqueta
        %v_visu(i,4) = text(visu_coor(i,1)+(pro_lon*0.1),visu_coor(i,2)+(pro_lon*0.1),eti{i,1}); % Crea texto etiqueta
        v_visu(i,4) = text(visu_coor(i,1)-(visu_coor(i,3)*pro_lon*0.05),visu_coor(i,2)+(visu_coor(i,4)*pro_lon*0.05),eti{i,1},'HorizontalAlignment','center','Rotation',visu_ang(i,1)); % Crea texto etiqueta
    end
end