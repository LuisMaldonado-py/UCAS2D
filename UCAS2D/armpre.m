%FUNCION PARA GENERAR ARMADURA ELEGIDA
function [coor,conex]=armpre(n,l,h,tipo)
if tipo == 1 | tipo==2 | tipo==3 | tipo==4 | tipo==5
    coor=zeros(n*2,2);                                                          % Crea vector de coordenadas
    a=atan(2*h/(n*l));                                                          % Calcula angulo de armadura
    for i=1:n
        x1=i*l;                                                                 % Calcula cordenadas en X                   
        if tipo==1| tipo==2                                                     % VARIABLE TIPO ES EL TIPO DE ARMADURA ESCOJIDA DEL MENU
            coor(i+1,1)=x1;                                                     % Ubicacion de coordenada X en vector de coordenadas
            if i<=n/2                                                           % Sentencia de cordenadas Y mitad izquierda de armadura
                y=x1*tan(a);                                                    % Calcula cOordenadas en Y cara izquierda armadura   
                coor(n+1+i,:)=[x1 y];                                           % Ubicacion de coordenada Y en vector de coordenadas  
            elseif i<n                                                          % Sentencia de cordenadas Y mitad derecha de armadura
                y=(2*h)-(x1*tan(a));                                            % Calcula cordenadas en Y cara derecha de armadura 
                coor(n+1+i,:)=[x1 y];                                           % Ubicacion de coordenada Y en vector de coordenadas 
            end
        elseif tipo==20 | tipo==3 | tipo==5 | tipo==4
                coor(i+1,1)=x1;                                                 % Ubicacion de coordenada X en vector de coordenadas
                coor(n+1+i,:)=[x1 h];                                           % Ubicacion de coordenada Y en vector de coordenadas              
        end
    end
    if tipo==20                                                                 % Sentencia de cordenadas esquina superior izquierda
        coor(2*n+2,:)=[0 h];                                                    % Ubicacion de coordenada Y en vector de coordenadas              
        coor(n+3:end,:)=coor(n+2:end-1,:);
        coor(n+2,:)=[0 h];
    elseif tipo==3 | tipo==4                                                    % Sentencia de cordenadas esquina superior izquierda
        coor=coor(1:n*2,:);                                                      % Ubicacion de coordenada Y en vector de coordenadas               
    elseif tipo==5                                                              % Sentencia de cordenadas esquina superior izquierda
         coor(n+2:(2*n)+1,1)=coor(n+2:(2*n)+1,1)-l/2; 
    end
    num=(1:size(coor,1))';                                                      % Tamano numero de nodos
    coor=[num,coor];                                                            % Crea vector de coordenadas final 
    %TABLA DE CONEXION 
    conex1=[coor(1:n,1),coor(2:n+1,1)];                                         % Elementos inferiores
    conex2=[1 n+2];                                                             % Elemento superior inicio
    conex3=[coor(n+2:(2*n)-1,1),coor(n+3:2*n,1)];                               % Elementos superior internos
    conex4=[2*n n+1];                                                           % Elemento final
    if tipo==1|tipo==4
        conex6=[coor(n+3:n+((n+2)/2),1),coor(2:((n-2)/2)+1,1)];                 % Elementos verticales
        conex7=[coor(n+((n+2)/2):(2*n)-1,1),coor(3+((n-2)/2):n,1)];             % Elementos Diagonales izquierda
        conex5=[coor(n+2:2*n,1),coor(2:n,1)];                                   % Elementos Diagonales derecha
    elseif tipo==2|tipo==3
        conex6=[coor(n+2:n+((n+2)/2)-1,1),coor(3:((n-2)/2)+2,1)];               % Elementos verticales
        conex7=[coor(n+((n+2)/2)+1:(2*n),1),coor(2+((n-2)/2):n-1,1)];           % Elementos Diagonales izquierda
        conex5=[coor(n+2:2*n,1),coor(2:n,1)];                                   % Elementos Diagonales derecha
    elseif tipo==5
        conex3=[coor(n+2:(2*n),1),coor(n+3:(2*n)+1,1)];                         % Elemento superior inicio
        conex4=[(2*n)+1 n+1];                                                   % Elementos superior internos
        conex5=[coor(n+2:2*n,1),coor(2:n,1)];                                   % Elementos superior internos
        conex6=[coor(n+3:(2*n)+1,1),coor(2:n,1)];                               % Elementos diaognales
        conex7=[];
    end
    conex=[conex1;conex2;conex3;conex4;conex5;conex6;conex7];                   % Union de conexion de elementos 
    num=(1:size(conex,1))';                                                     % Numero de elementos 
    conex=[num,conex];                                                          %creacion del vector final de elementos
elseif tipo == 6
    [coor,conex]=baltimore_6(n,h,l);
elseif tipo == 7
    [coor,conex]=K_7(n,h,l);
elseif tipo == 8
    [coor,conex]=vertical_8(n,h,l);
end    
            
