function [xf,yf] = long_key(x1,y1,long,ang)              % Funcion para encontrar cooordenadas finales                                                          % Angulo seleccionado
y = long * sin(degtorad(ang));                                     % Longitud en X
x = long * cos(degtorad(ang));                                     % Longitud en Y    
xf = x1 + x;                                                                % Nueva coordenada en Y
yf = y1 + y;                                                                % Nueva coordenada en X
