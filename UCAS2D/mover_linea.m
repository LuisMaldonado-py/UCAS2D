function mover_linea(handles,valor)
%Dibuja una linea en 'valor' / Mueve una linea 
    global long elem
    l_axes=findobj(handles.Fuerzas,'Type','axes');                         %Busca a los 5 axes(lista de axes)
    for i=1:length(l_axes)                                                 %Para dibujar hay que seleccionar cada axes
        aux=findobj(l_axes(i),'Ydata',[1 -1]);                             %Busca lineas en un axes seleccionado con cierto Ydata
        if size(aux,1)==0                                                  %Revisa si aun no existe esa linea
            line(l_axes(i),[valor,valor],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]); %Dibuja una linea de valor
        else                                                               %En caso de que ya exista la linea
            delete(aux);                                                   %Elimina la linea existente
            line(l_axes(i),[valor,valor],[1 -1],'LineWidth',1,'Color',[0.5 0.5 0.5]); %Dibuja otra linea con valor actual
        end
    end
    f=handles.Fuerzas;                                                     %Guarda la Figura Fuerzas
    l_lines=findobj(f,'YData',[1 -1]);                                     %Busca las 5 lineas dibujas en los 5 axes(lista de lineas)
%     aux69=findobj(handles.a_axial,'Type','Patch'); problema al poner fill
%     set(aux69,'ButtonDownFcn',@inicio);
    set(l_lines,'ButtonDownFcn',@inicio);                                  %Asigna la funcion 'inicio' cuando se de click en cualquier linea valor
    function inicio(varargin)
        set(f,'WindowButtonMotionFcn',@moviendo);                          %Activa el movimiento del raton y llama la funcion 'moviendo'
    end
    function moviendo(varargin)
        cx=get(l_axes(1),'CurrentPoint');                                  %Obtiene las coordenadas del click de un axes cualquiera
        if cx(1)<0 cx(1)=0; elseif cx(1)>long(elem) cx(1)=long(elem); end  %La coor 'x' si es <0 asignar 0 y si es mayor a long asignar long                    
        set(l_lines,'XData',cx(1)*[1 1]);                                  %Asigna a la lista de lineas la coor 'x' nueva
        etiquetas(handles,cx(1));                                          %Funcion para las etiquetas si mueve una linea
    end
    set(f,'WindowButtonUpFcn',@fin)                                        %Asigna la funcion 'fin' cuando suelta el click
    function fin(varargin)
        set(f,'WindowButtonMotionFcn','');                                 %Desactiva la funcion 'moviendo', deja sin efecto el mov del raton
    end
    etiquetas(handles,valor);                                              %Funcion para las etiquetas si solo dibuja
end