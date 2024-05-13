function selec_rec(tip,xo,yo,xf,yf)                     % FUNCION PARA CUADRO SELECCIONADOR
global axe_dibujo vn_coor ve_conex ele_sel nod_sel vn_obj
%---------------------- Seleccion de nodos --------------------------------
axes(axe_dibujo);hold on;                   % Llama a axes
if tip == -1
    %axes(axe_dibujo);hold on;                   % Llama a axes
    for i = 1:size(vn_coor,1)                             % Recorre lista de nodos
        if vn_coor(i,2) > xf & vn_coor(i,2) < xo & vn_coor(i,3) < max(yo,yf) & vn_coor(i,3) > min(yo,yf)    % Analiza que este dentro de cuadro seleccionador
            nod = vn_obj(i,1);                              % Saca Codigo del nodo
            a = '';                                                                  
            if size(nod_sel,1) > 0                          % Analiza si vector de nodos seleccionados esta vacio
                a = find(nod_sel(:,1)== nod);               % Busca si el nodo ya estaba seleccionado
            end    
            if isempty(a) == 1                              % Si el nodo ya etsab seleccionado
                nod_sel(end+1,1) = nod;                     % anexa nodo creado
                nod_sel(end,2) = scatter(vn_coor(i,2),vn_coor(i,3),5,'marker','x','MarkerEdgeColor','b','LineWidth',20);  % crea objeto de seleccion
            end
        end
    end
%---------------------- Seleccion de elementos -----------------------------    
elseif tip == 1 & isempty(ve_conex) == 0                                    % Revisa si existen elementos    
    %axes(axe_dibujo);hold on; 
    for i = 1:size(ve_conex,1)                                              % Recorre lista de elementos
        cod = ve_conex(i,1); a = [];                                        % saca Codigo dele elemento
        if size(ele_sel,1) > 0                                              % Revisa si existen elementos seleccionados
            a = find(ele_sel(:,1)== cod);                                   % Busca si ele elemento analizado esta seleccionado
        end      
        if isempty(a) == 1                                                  % si el elemento no esta seleccionado
            ni = ve_conex(i,2);nf = ve_conex(i,3);                          % busca nodo inicial y final
            s_ni = find(vn_coor(:,1)== ni);s_nf = find(vn_coor(:,1)== nf);  % Busca posicion de las coordenadas de nodos iniciales y finales
            x1 = vn_coor(s_ni,2);y1 = vn_coor(s_ni,3);                      % Extrae coordenadas de nodo inicial 
            x2 = vn_coor(s_nf,2);y2 = vn_coor(s_nf,3);                      % Extrae coordenadas de nodo final
            if x1>xo & x1<xf & y1<max(yo,yf) & y1>min(yo,yf)                % Analiza que este dentro de cuadro seleccionador
                if x2>xo & x2<xf & y2<max(yo,yf) & y2>min(yo,yf)            % Analiza que este dentro de cuadro seleccionador
                    ele_sel(end+1,1) = cod;                                 % Anexa codigo del elemntos en vector de seleccion
                    ele_sel(end,2) = line([x1 x2],[y1 y2],'LineWidth',2.5,'LineStyle','--','Color',[0.75 0.75 0.75]);  % Grafico de linea de seleccion
                    set(ele_sel(end,2),'DisplayName',num2str(cod));         % Da nombre a linea de seleccion
                    set(ele_sel(end,2),'ButtonDownFcn','selec_2ele(gco)');  % Crea funcion de seleccion a linea de seleccion
                end
            end
        end
    end
end