function [coor,conex]=baltimore_6(n,h,l)
% PROGRAMA PARA ARMADURA 6 TIPO BALTIMORE
% LA ARMADURA FUNCIONA CON DIVISIONES MULTIPLOS DE 4
% NODOS
ni = n+1;                                                                   % Numero de nodos inferior
nc = n/2;                                                                   % Numero de nodos Central
ns = nc-1;                                                                  % Numero de nodos superior
cinf = (0 : l : n*l)';                                                      % Coordenadas de nodos inferior en X
cinf = [cinf zeros(ni,1)];                                                  % Coordenadas de nodos inferior en Y
ccen = (l:2*l:(nc*2*l))';                                                   % Coordenadas de nodos centrales en X
ccen = [ccen ones(nc,1)*h/2];                                               % Coordenadas de nodos centrales en Y 
csup = (2*l:2*l:(ns*2*l))';                                                 % Coordenadas de nodos superiores en X
csup = [csup ones(ns,1)*h];                                                 % Coordenadas de nodos superiores en y 
coor = [cinf ; ccen ; csup];                                                % Vector de coordenadas
coor =[(1 : 1 : ni+nc+ns)' coor];                                           % Vector de coordenadas + id
% ELEMENTOS
elem_i_h1 = [(1 : 1 : n);(2 : 1 : n+1)]';                                   % Elementos inferior horizontal
elem_c_d1 = [(1 : 2 : ni-2);(ni+1 : 1 : ni+nc)]';                           % Elementos diagonales zona central baja
elem_c_d2 = [(3 : 2 : ni);(ni+1 : 1 : ni+nc)]';                             % Elementos diagonales zona central baja
elem_c_v1 = [(2 : 2 : ni-1);(ni+1 : 1 : ni+nc)]';                          	% Elementos verticales zona central baja
elem_c_d3 = [(ni+2 : 1 : ni+(nc/2));(ni+nc+1 : 1 : ni+nc+(fix(ns/2)))]';    % Elementos diagonales zona central alta
elem_c_d4 = [(ni+(nc/2)+1 : 1 : ni+nc-1);(ni+nc+(round(ns/2)+1) : 1 : ni+nc+ns)]';  % Elementos diagonales zona central alta
elem_c_v2 = [(3 : 2 : ni-2);(ni+nc+1 : 1 : ni+nc+ns)]';                             % Elementos verticales
elem_s_h2 = [(ni+nc+1 : 1 : ni+nc+ns-1);(ni+nc+2 : 1 : ni+nc+ns)]';                 % Elementos superior horizontal
elem_i_com = [ni+1 ni+nc+1 ; ni+nc ni+nc+ns];                                       % Elementos complementarios diagonales
conex = [elem_i_h1 ; elem_c_d1 ; elem_c_d2 ; elem_c_v1 ; elem_c_d3 ; elem_c_d4 ; elem_c_v2 ; elem_s_h2 ; elem_i_com];   % Tabla de conexion
conex = [(1:1:size(conex,1))' conex];                                       % Tabla de conexion final



