function [xf,yf,ang_selec] = angulo_sel(rang,res,ang,angd,yi,xi,l_polar)              % Funcion para encontrar cooordenadas finales
angf=30;
for i = 1 : rang                                                            % Bucle para analizar limites del angulo escojido
    if i == 1 | i == rang + 1                                               % Indeterminaciones iniciales 0g y finales 360g
        if angd >= ang(rang+1) + res | angd < ang(1) + (ang(2)/2)           % Analisis si el angulo se encuentra en el angulo inicial
            angf = 0;                                                       % Genera angulo 0
        elseif angd >= ang(rang + 1) - (ang(2)/2) & angd < ang(rang + 1) + res  % Analisis del angulo final
            angf = ang(rang + 1);                                           % genera angulo correspondiente el ultimo
            if angf == 360                                                  % Sentencia para cambiar angulo de 360 a 0
                angf = 0;                                                   % Cambio del angulo
            end
        end
    else
    	if angd >= ang(i) - (ang(2)/2) & angd < ang(i) + (ang(2)/2)         % Analiza los angulos restantes
        	angf = ang(i);                                                  % Determina angulo respectivo           
        end
    end
end 
ang_selec = angf;                                                           % Angulo seleccionado
y = l_polar * sin(degtorad(ang_selec));                                     % Longitud en X
x = l_polar * cos(degtorad(ang_selec));                                     % Longitud en Y    
xf = xi + x;                                                                % Nueva coordenada en Y
yf = yi + y;                                                                % Nueva coordenada en X
