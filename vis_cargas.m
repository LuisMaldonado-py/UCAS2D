function vis_cargas()                                            % Funcion para visualizacion de releases
global v_visu axe_dibujo 
global op_ffp ve_conex vn_coor vn_fx vn_fy ve_p ve_tem ve_add ve_w v_distri
if isempty(v_visu) == 0                                         % Revisa si vector de visualicion esta vacio
        for i = 1:size(v_visu,1)                                    % Recorre vector de visualizacion para borrar datos
            if isempty(v_visu(i,5)) == 0 & v_visu(i,5) ~= 0         % Revisa que no este vacio o sea cero
                delete(v_visu(i,5)); v_visu(i,5) = 0;
                delete(v_visu(i,6)); v_visu(i,6) = 0;
            end
            if isempty(v_visu(i,7)) == 0 & v_visu(i,7) ~= 0         % Revisa que no este vacio o sea cero
                delete(v_visu(i,7)); v_visu(i,7) = 0;
            end
            if isempty(v_visu(i,8)) == 0 & v_visu(i,8) ~= 0         % Revisa que no este vacio o sea cero
                delete(v_visu(i,8)); v_visu(i,8) = 0;
            end
        end
end
if isempty(v_distri) == 0
    delete(v_distri);
    v_distri = [];
end       
if op_ffp > 0
    axes(axe_dibujo)
    hold on
%-------------------------- Longitud y Angulo -----------------------------
    visu_lon = [];
    visu_coor = [];
    fle = 0.25;
    for i = 1:size(ve_conex,1)                                  % Recorre anlizando cada elemento
         ni = ve_conex(i,2); ni = find(vn_coor(:,1) == ni);  % Busca Nodo inicial
         xi = vn_coor(ni,2); yi = vn_coor(ni,3);             % Coordenadas del nodo inicial
         nf = ve_conex(i,3); nf = find(vn_coor(:,1) == nf);  % Busca Nodo final
         xf = vn_coor(nf,2); yf = vn_coor(nf,3);             % Coordenadas del nodo final
        [teta,long] = angulo_360(xi,xf,yi,yf);
        %--------- op == 3 ---------------------
        if op_ffp == 3 | op_ffp == 4 | op_ffp == 5  | op_ffp == 6  %& (ve_p(i,2) ~= 0 | ve_p(i,5) ~= 0)
            a = 1;
            if teta > 270 & teta < 360 == 90
                a = -1;
            end    
            Ay = cos(degtorad(teta));
            Ax = a * sin(degtorad(teta)); 
            if op_ffp == 3
                if ve_p(i,2) ~= 0 
                    visu_coor(i,1:2) = [xi+((xf-xi)*ve_p(i,3)) yi+((yf-yi)*ve_p(i,3))]; 
                end
                if ve_p(i,5) ~= 0 
                    visu_coor(i,3:4) = [xi+((xf-xi)*ve_p(i,6)) yi+((yf-yi)*ve_p(i,6))];     
                end
                visu_coor(i,5:6) = [Ax Ay];
            elseif op_ffp == 4
                if ve_w(i,2) ~= 0 
                    red = ((1-ve_w(i,3))-(1-ve_w(i,4)));            %Longitud relativa de la carga
                    visu_coor(i,1:5) = [xi+((xf-xi)*ve_w(i,3)) yi+((yf-yi)*ve_w(i,3)) xi+((xf-xi)*ve_w(i,4)) yi+((yf-yi)*ve_w(i,4)) red]; 
                end
                if ve_w(i,5) ~= 0 
                    red = ((1-ve_w(i,6))-(1-ve_w(i,7)));            %Longitud relativa de la carga
                    visu_coor(i,6:10) = [xi+((xf-xi)*ve_w(i,6)) yi+((yf-yi)*ve_w(i,6)) xi+((xf-xi)*ve_w(i,7)) yi+((yf-yi)*ve_w(i,7)) red];   
                end
                visu_coor(i,11:12) = [Ax Ay];
            elseif op_ffp == 5 | op_ffp == 6
                visu_coor(i,1:4) = [((xf+xi)/2) ((yf+yi)/2) Ax Ay]; 
            end
            
        end
        visu_ang(i,1) = teta;
        visu_lon(i,1) = long;
    end
    pro_lon = mean2(visu_lon);
    min_lon = min(visu_lon);
%--------------------------------------------------------------    
    if op_ffp == 1 | op_ffp == 2 
        if op_ffp == 1                                      % Si la opcion son cargas puntuales
            v_sim = [vn_fx(:,2) vn_fy(:,2)];                % Guarda cargas en X y Y    
        else
            v_sim = vn_coor(:,7:8).*vn_coor(:,4:5);          % Guarda desplazamientos en Y y X
        end    
        for i = 1 : size(vn_coor,1)                         % Recorre todos lo nodos
            x = vn_coor(i,2); y = vn_coor(i,3);             % Coordenadas del nodo inicial
            p1 = [x;y];                                     % coordenadas iniciales de la flecha
            if v_sim(i,1) ~= 0                              % Analiza si existe Carga en X 
                a = 'right';b = -1;                         % Direccion de flecha
                p0x = [x+(fle*pro_lon);y];                  % Punto final de flecha
                if v_sim(i,1) > 0                           % Analiza carga izquierda o derecha
                    p0x = [x-(fle*pro_lon);y];              % Punto final de flecha
                    a = 'left';%b = 1;                      % Direccion opuesta
                end
                v_visu(i,5) = drawArrow(p0x,p1,'k');        % Dibuja flecha
                v_visu(i,6) = text(p0x(1),p0x(2)+(0.1*pro_lon),num2str(v_sim(i,1)),'HorizontalAlignment',a); % Crea texto etiqueta
            end                                             
            if v_sim(i,2) ~= 0                              % Analiza si existe Carga en X Proceso similar
                p0y = [x;y+(fle*pro_lon)]; b = -0.05 * pro_lon;
                if v_sim(i,2) > 0
                    p0y = [x;y-(fle*pro_lon)];
                    b = b *-1;
                end  
                v_visu(i,7) = drawArrow(p0y,p1,'k');
                v_visu(i,8) = text(p0y(1)+(0.05*pro_lon),(p0y(2)+b),num2str(v_sim(i,2))); % Crea texto etiqueta
            end
        end
        %------------------ op == 3 ----------------------
    elseif op_ffp == 3
        for i = 1 : size(ve_conex,1)                         % Recorre todos lo nodos
            if ve_p(i,2) ~= 0 | ve_p(i,5) ~= 0
                if ve_p(i,2) ~= 0                             % Analiza si existe Carga en X 
                    x = visu_coor(i,1); y = visu_coor(i,2);     % Coordenadas del nodo inicial
                    p1 = [x;y];                                 % coordenadas iniciales de la flecha
                    a = 'right';b = -1;                         % Direccion de flecha
                    p0x = [x+(fle*visu_coor(i,6)*pro_lon) y+(fle*visu_coor(i,5)*pro_lon)];                  % Punto final de flecha
                    if ve_p(i,2) > 0                           % Analiza carga izquierda o derecha
                        p0x = [x-(fle*visu_coor(i,6)*pro_lon) y-(fle*visu_coor(i,5)*pro_lon)];              % Punto final de flecha
                        a = 'left';%b = 1;                       % Direccion opuesta
                    end
                    v_visu(i,5) = drawArrow(p0x,p1,'k');        % Dibuja flecha
                    Al = 0.07;
                    Ax = -visu_coor(i,5)*Al*pro_lon;
                    Ay = visu_coor(i,6)*Al*pro_lon;
                    v_visu(i,6) = text(((p0x(1)+x)/2)+Ax,((p0x(2)+y)/2)+Ay,num2str(ve_p(i,2)),'HorizontalAlignment','center','Rotation',visu_ang(i,1)); % Crea texto etiqueta
                end                                             
                if ve_p(i,5) ~= 0                              % Analiza si existe Carga en X Proceso similar
                    x = visu_coor(i,3); y = visu_coor(i,4);     % Coordenadas del nodo inicial
                    p1 = [x;y];
                    p0y = [x-(fle*visu_coor(i,5)*pro_lon) y+(fle*visu_coor(i,6)*pro_lon)];
                    b = 0.05 * pro_lon; a = 'left';
                    if ve_p(i,5) > 0
                        p0y = [x+(fle*visu_coor(i,5)*pro_lon) y-(fle*visu_coor(i,6)*pro_lon)];
                        b = b ;a = 'right';
                    end  
                    v_visu(i,7) = drawArrow(p0y,p1,'k');
                    ang = visu_ang(i,1);
                    Al = 0.05;
                    Ax = visu_coor(i,5)*Al*pro_lon;
                    Ay = visu_coor(i,6)*Al*pro_lon;
                    if ang > 270 & ang < 360
                        ang = ang -180;
                    elseif ang == 0
                        Ax = Al*pro_lon; Ay = 0; 
                    elseif ang == 90
                        Ax = 0; Ay = Al*pro_lon;    
                    end
                    v_visu(i,8) = text(((p0y(1)+x)/2)+Ax,((p0y(2)+y)/2)+Ay,num2str(ve_p(i,5)),'HorizontalAlignment','center','Rotation',ang-90); % Crea texto etiqueta
                end
            end
        end
    elseif op_ffp == 5
        for i = 1 : size(ve_conex,1)                         % Recorre todos lo nodos
            if ve_tem(i,2) ~= 0 | ve_tem(i,3) ~= 0
                Al = 0.04; ang = visu_ang(i,1);
                Ax = -visu_coor(i,3)*Al*pro_lon;
                Ay = visu_coor(i,4)*Al*pro_lon;
                v_visu(i,7) = text(visu_coor(i,1)+Ax,visu_coor(i,2)+Ay,num2str(ve_tem(i,3)),'HorizontalAlignment','center','Rotation',ang); % Crea texto etiqueta
                v_visu(i,8) = text(visu_coor(i,1)-Ax,visu_coor(i,2)-Ay,num2str(ve_tem(i,2)),'HorizontalAlignment','center','Rotation',ang); % Crea texto etiqueta 
            end
        end
    elseif op_ffp == 6
        for i = 1 : size(ve_conex,1)                         % Recorre todos lo nodos
            if ve_add(i,2) ~= 0
                Al = 0.04; ang = visu_ang(i,1);
                Ax = -visu_coor(i,3)*Al*pro_lon;
                Ay = visu_coor(i,4)*Al*pro_lon;
                v_visu(i,7) = text(visu_coor(i,1)+Ax,visu_coor(i,2)+Ay,num2str(ve_add(i,2)),'HorizontalAlignment','center','Rotation',ang); % Crea texto etiqueta
            end
        end
    elseif op_ffp == 4
        v_distri = zeros(size(ve_conex,1),15);
        for i = 1 : size(ve_conex,1)                         % Recorre todos lo nodos
            if ve_w(i,2) ~= 0 | ve_w(i,5) ~= 0
                if ve_w(i,2) ~= 0                             % Analiza si existe Carga en X 
                    xi = visu_coor(i,1); yi = visu_coor(i,2);    % Coordenadas del nodo inicial
                    xf = visu_coor(i,3); yf = visu_coor(i,4);
                    Ax = visu_coor(i,12); Ay = visu_coor(i,11); red = visu_coor(i,5);
                    if red >= 0.5
                        n = round(red*6);
                    else
                        n = 3;
                    end
                    if ve_w(i,2) < 0
                        xi = xf; yi = yf; xf = visu_coor(i,1); yf = visu_coor(i,2);
                        Ax = -Ax; Ay = -Ay;
                    end 
                    Al =  visu_lon(i,1) * red/(n-1);
                    u = (Al*Ax/10);v = (Al*Ay/10);
                    for j = 0:n-1
                        p0 = [xi+(Al*Ax*j) yi+(Al*Ay*j)];
                        p1 = p0 + [u v];
                        if j == n-1
                            p1 = p0;
                            p0 = p0 - [2*u 2*v];
                        end
                        v_distri(i,2+j) =  drawArrow(p0,p1,'k');
                        set(v_distri(i,2+j),'LineWidth',2.5);
                    end
                    Al = 0.05; ang = visu_ang(i,1);
                    Ax = -visu_coor(i,11)*Al*pro_lon;
                    Ay = visu_coor(i,12)*Al*pro_lon;
                    v_distri(i,1) = text(((xi+xf)/2)+Ax,((yi+yf)/2)+Ay,num2str(ve_w(i,2)),'HorizontalAlignment','center','Rotation',ang); % Crea texto etiqueta
                end
                if ve_w(i,5) ~= 0                             % Analiza si existe Carga en X 
                    xi = visu_coor(i,6); yi = visu_coor(i,7);    % Coordenadas del nodo inicial
                    xf = visu_coor(i,8); yf = visu_coor(i,9);
                    Ax = -visu_coor(i,12); Ay = visu_coor(i,11); red = visu_coor(i,10);
                    if red >= 0.5
                        n = round(red*6);
                    else
                        n = 3;
                    end
                    a = 1;
                    if ve_w(i,5) < 0
                        a = -1;
                    end
                    dl = visu_lon(i,1) * red/(n-1);
                    Al =  0.1 * pro_lon;
                    u = a*(Al*Ay);v = a*(Al*Ax);
                    v_distri(i,9) = line([xi+u xf+u],[yi+v yf+v],'LineWidth',1,'LineStyle','-','Color','k');
                    for j = 0:n-1
                        p1 = [xi-(dl*Ax*j) yi+(dl*Ay*j)];
                        p0 = p1 + [u v];
                        v_distri(i,10+j) =  drawArrow(p0,p1,'k');
                        set(v_distri(i,10+j),'LineWidth',1);
                    end
                    Al = 1.3; ang = visu_ang(i,1);
                    v_distri(i,8) = text(((xi+xf)/2)+(u*Al),((yi+yf)/2)+(v*Al),num2str(ve_w(i,5)),'HorizontalAlignment','center','Rotation',ang); % Crea texto etiqueta
                end
            end
            if isequal (v_distri,zeros(size(ve_conex,1),15)) == 1
                v_distri = [];
            end    
        end
    end
end

