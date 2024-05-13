function [coor,conex]=vertical_8(n,h,l)
% PROGRAMA PARA ARMADURA 8 TIPO VERTICAL
% NODOS
ni = n+1;                                                                   % Numero de nodos inferior y superior, #nodos centrales igual a numero de divisiones
cinf = (0 : l : n*l)';                                                      % Coordenadas de nodos inferior y superiores en X
csup = [cinf ones(ni,1)*h];                                                 % Coordenadas de nodos superiores en y 
cinf = [cinf zeros(ni,1)];                                                  % Coordenadas de nodos inferior en Y
ccen = [(l/2:l:(n*l)-(l/2))'];                                              % Coordenadas de nodos centrales en X
ccen = [ccen ones(n,1)*h/2];                                                % Coordenadas de nodos centrales en Y 
coor = [cinf ; ccen ; csup];                                                % Vector de coordenadas
coor =[(1 : 1 : 2*ni+n)' coor];                                              % Vector de coordenadas + id
% ELEMENTOS
elem_i_h1 = [(1 : 1 : n);(2 : 1 : n+1)]';                                   % Elementos inferior horizontal
elem_c_d1 = [(1 : 1 : ni-1);(ni+1 : 1 : ni+n)]';                            % Elementos diagonales zona central baja izquierda
elem_c_d2 = [(2 : 1 : ni);(ni+1 : 1 : ni+n)]';                              % Elementos diagonales zona central baja derecha
elem_c_d3 = [(ni+1 : 1 : ni+n);(ni+n+1 : 1 : 2*ni+n+-1)]';                  % Elementos diagonales zona central alta izquierda
elem_c_d4 = [(ni+1 : 1 : ni+n);(ni+n+2 : 1 : 2*ni+n)]';                     % Elementos diagonales zona central alta derecha
elem_c_v = [(1 : 1 : ni);(ni+n+1 : 1 : 2*ni+n)]';                           % Elementos verticales
elem_s_h2 = [(ni+n+1 : 1 : 2*ni+n-1);(ni+n+2 : 1 : 2*ni+n)]';                % Elementos superior horizontal
conex = [elem_i_h1 ; elem_c_d1 ; elem_c_d2 ; elem_c_d3 ; elem_c_d4 ; elem_c_v ; elem_s_h2];    	% Tabla de conexion
conex = [(1:1:size(conex,1))' conex];                                    	% Tabla de conexion final



