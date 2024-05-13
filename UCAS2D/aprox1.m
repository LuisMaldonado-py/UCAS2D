function [coor_ap,ban_aprox,nodo] = aprox1(coor,xm,ym,ah)                              % Obtiene angulo total seleccionado 360
rel = 0.005;                                                                 % La relacion de aproximacion al punto, se puede CALIBRAR
xlim = get(ah, 'xlim');                                                     % La relacion de aproximacion se hace en base al EJE X
ylim = get(ah, 'ylim');                                                     % La relacion de aproximacion se hace en base al EJE Y
inty = rel * (ylim(2) - ylim(1));                                           % Longitud de comparacion en eje X
intx = rel * (xlim(2) - xlim(1));                                           % Longitud de comparacion en eje Y
if inty >= intx
    intx = inty;
end    
tam = size (coor,1);                                                        % Tamano del vector coordenadas
coor_ap = [];                                                               % Crea vector de coordenadas         
long_ap = sqrt(2*(intx^2));                                                  % Calcula longitud de aproximacion unica longitud
ban_aprox = 1;                                                               % Bandera desactivada
nodo = 0;
for i = 1:tam                                                               % Bucle para analisis de coordenadas posibles
    x = coor(i,1);                                                          % Coordenada en X de los puntos de aproximacion   
    y = coor(i,2);                                                          % Coordenada en Y de los puntos de aproximacion
    long_m = sqrt(((xm - x)^2) + ((ym - y)^2));                             % calcula longitud del mouse con punto de aproximacion
    if long_m < long_ap
        long_ap = long_m;                                                   % Guarda longitud minima
        coor_ap = [x y];                                                    % Guarda coordenadas
        ban_aprox = 0;
        nodo = i;                                                           % Bandera desactivada
    end
end

    

