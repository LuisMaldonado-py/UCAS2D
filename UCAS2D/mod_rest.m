function mod_rest(nod_sel,rest,kres)
global vn_obj vn_coor axe_dibujo
%------------ Analisis de casos para restriccion ----------------
tip = 0;                                                                    % Para analizar si el nodo es libre o diferente
if isequal(rest,[0 0 0])== 1 & ~any(kres)                                   % Nodo libre
    sim = '.';                                                              % Tipo de marcador
    tip = 1;                                                                % Si es nodo libre
elseif isequal(rest,[1 0 0]) == 1 | isequal(rest,[0 1 0]) == 1 | isequal(rest,[0 0 1]) == 1             % Apoyo simple
    sim = 'o';                                                              % Tipo de marcador
elseif isequal(rest,[1 1 0]) == 1 | isequal(rest,[1 0 1]) == 1 | isequal(rest,[0 1 1]) == 1                                          % articulacion                                 
    sim = '^';                                                              % Tipo de marcador                                                             % Tipo de marcador
elseif isequal(rest,[1 1 1]) == 1                                           % Empotrado
    sim = 's';                                                              % Tipo de marcador
elseif isempty(find(kres)) == 0                                             % Apoyo elastico
    sim = 'h';
end
%------------ Programa  ----------------
colb = [0 1 0];                                                             % Color de borde 'MarkerEdgeColor'
esp =1.5;
r=0.13;                                                                      % Medida del marcador
yl=get(axe_dibujo,'ylim');
Ay = yl(2)-yl(1);
Ay = Ay*0.04/2;
g =(160*r)^2;                                                               % Area del marcador
lon = length(nod_sel);                                                      % Numero de nodos a modificar
axes (axe_dibujo);
for i = 1:lon                                                               % Recorre nodos
    id = nod_sel(i);                                                        % Obtiene nodo a analizar
    sub = find(vn_obj(:,1)==id);                                            % encuantra subindice del nodo
    vn_coor(sub,4:6)=rest;                                                  % Cambia vector de restricciones   
    if ~isempty(kres)                 % Rigidez del apoyo elastico 
        vn_coor(sub,7:9)=kres;
    else
        vn_coor(sub,7:9) = vn_coor(sub,4:6).*vn_coor(sub,7:9);
    end
    x = vn_coor(sub,2);y = vn_coor(sub,3);                                  % Obtiene coordenadas en X y Y
    if tip == 1                                                             % Lo que pasa si pone el nodo libre
        delete(vn_obj(sub,3));                                              % Borra nodo
        vn_obj(sub,3) = scatter(x,y,'marker',sim,'MarkerEdgeColor','b');                % Cambia el nodo a libre
    else
        delete(vn_obj(sub,3));                                              % Borra nodo
        vn_obj(sub,3) = scatter(x,y-Ay,g,'marker',sim,'MarkerEdgeColor',colb,'LineWidth',esp);   %,'MarkerFaceColor',colr)% Cambia el nodo a libre
    end
end