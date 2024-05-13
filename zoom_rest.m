function zoom_rest()
global vn_obj vn_coor axe_dibujo op_res
if isempty(vn_coor) == 0 & op_res == 1
    nod_sel = vn_obj(:,1);
    lon = size(nod_sel,1);                                                      % Numero de nodos a modificar
    colb = [0 1 0];                                                             % Color de borde 'MarkerEdgeColor' 
    colr = [0.4 0.4 0.4];                                                       % Color de relleno 'MarkerFaceColor' 
    esp =1.5;
    r=0.13;                                                                      % Medida del marcador
    g =(160*r)^2;                                                               % Area del marcador
    axes (axe_dibujo)
    yl=get(axe_dibujo,'ylim');
    Ay = yl(2)-yl(1);
    Ay = Ay*0.04/2;
    for i = 1:lon                                                               % Recorre nodos
        id = nod_sel(i);                                                        % Obtiene nodo a analizar
        sub = find(vn_obj(:,1)==id);                                            % encuantra subindice del nodo
        rest = vn_coor(sub,4:6);                                                % Cambia vector de restricciones
        kres = vn_coor(sub,7:9);                                                % Rigideces de los apoyos elasticos
    %------------ Analisis de casos para restriccion ----------------
            tip = 0;
            if isequal(rest,[0 0 0])== 1 & ~any(kres)
                sim = 'o';
                tip = 1;
            elseif isequal(rest,[1 0 0]) == 1 | isequal(rest,[0 1 0]) == 1 | isequal(rest,[0 0 1]) == 1
                sim = 'o';
            elseif isequal(rest,[1 1 0]) == 1 | isequal(rest,[1 0 1]) == 1 | isequal(rest,[0 1 1]) == 1                                          % articulacion                                 
                sim = '^'; 
            elseif isequal(rest,[1 1 1]) == 1
                sim = 's';
            elseif isempty(find(kres)) == 0
                sim = 'h';
            end
    %------------ Programa  ---------------- 
        x = vn_coor(sub,2);y = vn_coor(sub,3);                                  % Obtiene coordenadas en X y Y
        if tip == 1                                                             % Lo que pasa si pone el nodo libre
            delete(vn_obj(sub,3));                                              % Borra nodo
            vn_obj(sub,3) = scatter(x,y,50,'filled','b','marker',sim,'MarkerEdgeColor','b');                % Cambia el nodo a libre
        else
            delete(vn_obj(sub,3));                                              % Borra nodo
            vn_obj(sub,3) = scatter(x,y-Ay,g,'marker',sim,'MarkerEdgeColor',colb,'LineWidth',esp);   %,'MarkerFaceColor',colr)% Cambia el nodo a libre
        end
    end
end
%---------- Visual --------------------

