function salir_ele()                        % Programa para salir de modo dibujo de elmentos
global ln band_ele n_nodo band_rej 
band_ele = 0;band_rej = 0;                  % Bandera para dibujar elemento en blanco y rejilla 
if n_nodo == 2                              % Si bandera de numero de nodo es 2 existe una linea guia
    delete(ln);                             % Elimina linea guia               
    n_nodo = 1;                             % Bandera de numero de nodos hace 1
end
close(Elemento);                            % Cierra guide elementos
    