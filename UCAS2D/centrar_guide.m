%------------- CODIGO PARA CENTRAR EL GUIDE -------------
tam_t = get(0,'screensize');                                                % Tamano de la pantalla
pos_act = get(gcf,'position');                                              % Posicion actual del guide
xf = tam_t(3) - pos_act(3);                                                 % Esquina final en X
xp = round(xf/2);                                                           % Coordenada promedio de ubicacion
yf = tam_t(4) - pos_act(4);                                                 % Esquina final en X
yp = round(yf/2);                                                           % Coordenada promedio de ubicacion
set(gcf,'position',[xp yp pos_act(3) pos_act(4)]);                          % Posicion final de guide