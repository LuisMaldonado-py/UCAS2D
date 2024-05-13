function [coor,conex]=K_7(n,h,l)
% PROGRAMA PARA ARMADURA 7 TIPO K
% LA ARMADURA FUNCIONA CON DIVISIONES MULTIPLOS DE 2
% NODOS
ni = n+1;                                                                   % Numero de nodos inferior
nc = n-2;                                                                   % Numero de nodos Central
ns = n-1;                                                                   % Numero de nodos superior
cinf = (0 : l : n*l)';                                                      % Coordenadas de nodos inferior en X
cinf = [cinf zeros(ni,1)];                                                  % Coordenadas de nodos inferior en Y
ccen = [(l:l:(nc*l/2))' ; ((((nc/2)+2)*l):l:((nc+1)*l))'];                   % Coordenadas de nodos centrales en X
ccen = [ccen ones(nc,1)*h/2];                                               % Coordenadas de nodos centrales en Y 
csup = (l:l:(ns*l))';                                                       % Coordenadas de nodos superiores en X
csup = [csup ones(ns,1)*h];                                                 % Coordenadas de nodos superiores en y 
coor = [cinf ; ccen ; csup];                                                % Vector de coordenadas
coor =[(1 : 1 : ni+nc+ns)' coor];                                           % Vector de coordenadas + id
% ELEMENTOS
elem_i_h1 = [(1 : 1 : n);(2 : 1 : n+1)]';                                   % Elementos inferior horizontal
elem_c_d1 = [(3 : 1 : round(ni/2));(ni+1 : 1 : ni+(nc/2))]';                % Elementos diagonales zona central baja izquierda
elem_c_d2 = [(round(ni/2) : 1 : ni-2);(ni+(nc/2)+1 : 1 : ni+nc)]';          % Elementos diagonales zona central baja derecha
elem_c_v1 = [(2 : 1 : fix(ni/2));(ni+1 : 1 : ni+(nc/2))]';                  % Elementos verticales zona central baja izquierda
elem_c_v2 = [(fix(ni/2)+2 : 1 : ni-1) ; (ni+(nc/2)+1 : 1 : ni+nc)]';        % Elementos verticales zona central baja derecha
elem_c_v3 = [(ni+1 : 1 : ni+(nc/2));(ni+nc+1 : 1 : ni+nc+fix(ns/2))]';      % Elementos verticales zona central alta izquierda
elem_c_v4 = [(ni+(nc/2)+1 : 1 : ni+nc);(ni+nc+fix(ns/2)+2 : 1 : ni+nc+ns)]';        % Elementos verticales zona central alta derecha
elem_c_d3 = [(ni+1 : 1 : ni+(nc/2));(ni+nc+2 : 1 : ni+nc+round(ns/2))]';            % Elementos diagonales zona central alta izquierda
elem_c_d4 = [(ni+(nc/2)+1 : 1 : ni+nc);(ni+nc+round(ns/2) : 1 : ni+nc+ns-1)]';      % Elementos diagonales zona central alta derecha
elem_s_h2 = [(ni+nc+1 : 1 : ni+nc+ns-1);(ni+nc+2 : 1 : ni+nc+ns)]';                 % Elementos superior horizontal
elem_i_com = [1 ni+nc+1 ; ni ni+nc+ns ; round(ni/2) round(ns/2)+ni+nc];             % Elementos complementarios diagonales y vertical central
conex = [elem_i_h1 ; elem_c_d1 ; elem_c_d2 ; elem_c_v1; elem_c_v2; ...
    elem_c_v3 ; elem_c_v4 ; elem_c_d3 ; elem_c_d4; elem_s_h2; elem_i_com];          % Tabla de conexion
conex = [(1:1:size(conex,1))' conex];                                               % Tabla de conexion final



