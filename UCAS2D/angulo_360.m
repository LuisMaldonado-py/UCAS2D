function [teta,Long] = angulo_360(xi,xf,yi,yf)                              % Obtiene angulo total seleccionado 360
Ax = xf - xi;                                                               % Variacion en X                                                             
Ay = yf - yi;                                                               % Variacion en Y
Long=sqrt((Ax^2) + (Ay^2));                                                 % Longitud del nuevo punto
teta = radtodeg(atan(Ay/Ax));                                               % Angulo de deviacion con la horizontal
if Ax < 0 & Ay >= 0                                                         % Analisis en 2do cuadrante 
    teta = teta + 180;                                                      % Angulo de desviacion 360 
elseif Ax < 0 & Ay <= 0                                                     % Analisis en 3er cuadrante
    teta = teta + 180;                                                      % Angulo de desviacion 360 
elseif Ax >= 0 & Ay < 0                                                     % Analisis en 4to cuadrante
    teta = teta + 360;                                                      % Angulo de desviacion 360 
end    
