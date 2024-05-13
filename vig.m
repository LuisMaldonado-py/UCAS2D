function [coor,conex] = vig(nvanos,bvano)
% PROGRAMA PARA Vigas
% NODOS
coor_x = (0 : bvano : nvanos*bvano)';                                       % Contador de altura de pisos / Base para coordenadas X de elementos horizontales
coor_y = zeros(nvanos+1,1);                                                  % Base para coordenadas Y de elementos horizontales
coor = [coor_x coor_y];
conex = (1 : 1 : nvanos);            	% Conexion de elementos horizontales nodo inicial
conex = [conex' (conex+1)'];                              % Conexion de elementos horizontales nodo inicial + nodo final
coor =[(1 : 1 : size(coor,1))' coor];                                    	% Vector de coordenadas + id
conex = [(1:1:size(conex,1))' conex];                                    	% Tabla de conexion final + id
