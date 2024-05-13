% PROGRAMA PARA ASIGNAR DESFASE
% Diferencia entre elemntos porticos y armaduras
% Asigana Desfase Manual o Automatico
function [dbn,den]=desfas(pos)                                              % [desfase_inicial desfase_final] = desfase(posicion_del_elemnto)
global ve_rel ve_des ve_conex vs_pro ve_rot op_des 
rel = ve_rel{pos,2};                                                        % Extrae Release del elemento
if isempty(rel) == 1 & isequal(rel,[3 6]) == 0                              % Si el elemento es diferente a un tipo Armadura, le puede asignar un release diferente a 0
    tip = ve_des(pos,2);                            % Extrae tipo de desfase asignado
    if tip == 1                                     % Opcion desfase es 0
        dbn = 0; den = 0;                           % Desfase inicial y final igual a 0
    elseif tip == 2                                                             % Colocar desfase automatico
        ni = ve_conex(pos,2);                                               % Codigo del nodo inicial
        nf = ve_conex(pos,3);                                               % Codigo del nodo final
        % Informacion de conectividad en Nodos
        inf_ni = conectividad(ni,1);                                        % Obtiene informacion de todos loa elementos conectados a nodo inicial [pos cod name tip ang]
        inf_nf = conectividad(nf,1);                                        % Obtiene informacion de todos loa elementos conectados a nodo final [pos cod name tip ang]
        sub_int = find(inf_ni(:,1) == pos);                                 % Busca posicion del elemento actual analizado en vector de conectividad inicial
        ang = inf_ni(sub_int,5);                                            % Extrae angulo del elemnto analizado 
        if ang == 0                                                         % Sentencia si es un elemento Horizontal
            v_db = find(inf_ni(:,5) == 90 & inf_ni(:,4) == 2);              % Busca elementos que sean verticales y porticos en nodo inicial
            v_de = find(inf_nf(:,5) == 90 & inf_nf(:,4) == 2);              % Busca elementos que sean verticales y porticos en nodo final
            c_db = 2; c_de = 2;
        elseif ang == 90                                                    % Sentencia si es un elemento Vertical   
            v_db = find(inf_ni(:,5) == 0 & inf_ni(:,4) == 2);               % Busca elementos que sean horizontales y porticos en nodo inicial
            v_de = find(inf_nf(:,5) == 0 & inf_nf(:,4) == 2);               % Busca elementos que sean horizontales y porticos en nodo inicial
            cv_db = find(inf_ni(:,5) == 90 & inf_ni(:,4) == 2);             % Busca si existen elementos verticales ha excepcion del mismo en nodo inicial
            cv_de = find(inf_nf(:,5) == 90 & inf_nf(:,4) == 2);             % Busca si existen elementos verticales ha excepcion del mismo en nodo final
            c_db = 2; c_de = 2;                                             % Las 2 banderas son similares, val == 1 si es elemnto unico en linea de accion, val ==2 si hay varios elementos conectados en la linea de accion 
            if size(cv_db,1) == 1                                           % Sentencia si no tiene conectado elementos verticales al nodo inicial
                c_db = 1;                                                   % No hay mas elementos conectadoe en linea de accion al nodo inicial                
            end 
            if size(cv_de,1) == 1                                           % Sentencia si no tiene conectado elementos verticales al nodo final
                c_de = 1;                                                   % No hay mas elementos conectadoe en linea de accion al nodo final
            end 
        else
            v_db = [];v_de = [];                                            % Vector porticos conectados, si el angulo es diferente de 0 o 90 (no analiza)
        end
        dbn = 0; den = 0;                                                   % Comienza analisis con desfase 0 
        if isempty(v_db) == 0                                               % Analisis desfase si existen elementos conectados a nodos iniciales
            for i = 1:size(v_db,1)                                          % Recorre todos los elementos conectados
                s = ve_conex(inf_ni(v_db(i),1),4);                          % Busca Seccion del elemnto analizado                   
                s = find(vs_pro(:,1) == s);                                 % Busca posicion en vector de secciones
%                 a = 3;                                                      % Columna de informacion para seccion rotada a==2 seccion no rotada, a==3 seccion rotada;
%                 if ve_rot(inf_ni(v_db(i),1),2) == 1                         % Revision de rotacion de la seccion
%                     a = 2;                                                  % Seccion no rotada
%                 end    
%                 dbn = max(vs_pro(s,a)/c_db,dbn);                            % Calculo de desfase de nodo iniical
                dbn = max(vs_pro(s,(ve_rot(inf_ni(v_db(i),1),2))+1)/c_db,dbn);
            end
        end
        if isempty(v_de) == 0                                               % DESFASE NODO FINAL / Similar a desfase de nodo inicial
            for i = 1:size(v_de,1)
                s = ve_conex(inf_nf(v_de(i),1),4);
                h_s = find(vs_pro(:,1) == s);
%                 a = 3;
%                 if ve_rot(inf_nf(v_de(i),1),2) == 1
%                     a = 2;
%                 end 
%                 den = max(vs_pro(h_s,a)/c_de,den);
                  den = max(vs_pro(h_s,(ve_rot(inf_nf(v_de(i),1),2))+1)/c_de,den);  
            end
        end   
    elseif tip == 3
        dbn = ve_des(pos,3); den = ve_des(pos,4);                             % Colocar desfase manual
    end    
else
    dbn = 0; den = 0;
end  