function [ele_conec] = conectividad(cod_nod,an)                 % Codigo de nodo y analisis an == 1 elemento ; an == 2 nodo ; 
global ve_obj ve_conex vn_coor ve_rel vn_obj
ele_conec = [];                                                 % Crea vector de Conectividad
for i = 1:size(ve_conex,1)                                      % Recorre cada elelemento
    if cod_nod == ve_conex(i,2) | cod_nod == ve_conex(i,3)      % Analiza nodo final e inicial
        if an == 1                                              % Analisis elemento
            rele = ve_rel{i,2};
            if isempty(rele) == 0 & isequal(rele,[3 6]) == 0
                a = 1; ang = 0;
            else
                a = 2;
                %-------------- Angulo y longitud --------------------------- 
                ni = ve_conex(i,2); nf = ve_conex(i,3);    
                ni = find(vn_coor(:,1) == ni);nf = find(vn_coor(:,1) == nf);
                eni = vn_obj(ni,2);enf = vn_obj(nf,2);          % Nodo Inicial y final 
                xi = vn_coor(eni,2); xf = vn_coor(enf,2); yi = vn_coor(eni,3); yf = vn_coor(enf,3);
                [ang,long] = angulo_360(xi,xf,yi,yf);                           % Angulo y Longitud
            end 
        else                                                    % Analisis nodo
            a = 0;ang = 0;                                      
        end    
            ele_conec(end+1,:) = [i ve_obj(i,1:2) a ang];       % Anexa elemento conectado [pos cod name tip ang]  
    end
end
