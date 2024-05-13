function selec_nod(clic,axe_dibujo)                     % FUNCION PARA DIBUJO DE ELEMENTOS EN REJILLA
global ban_tod sub_s nod_sel vn_obj vn_coor obj_sel     % Si se da click derecho
global x y ban_selc rec_sel x_selc y_selc a rec_dir op_play
if clic == 1 %& isempty(vn_coor) == 0   
    if ban_tod == 1                                     % Se activo bandera de aproximacion
        nod = vn_obj(sub_s,1);                          % Saca Codigo del nodo
        if size(nod_sel,1) > 0
            a = find(nod_sel(:,1)== nod);
        else
            a = [];
        end    
        if isempty(a) == 1 
            nod_sel(end+1,1) = nod;  
            axes(axe_dibujo);
            nod_sel(end,2) = scatter(vn_coor(sub_s,2),vn_coor(sub_s,3),5,'marker','x','MarkerEdgeColor','b','LineWidth',20);
        else
            delete(nod_sel(a,2));
            nod_sel(a,:) = [];
        end
    elseif ban_tod == 0 
        rec_dir = 1;
        ban_selc = 1;
        x_selc = x; y_selc = y;
        axes(axe_dibujo)
        hold on
        rec_sel = fill([0],[0],'y','linestyle', '--','FaceAlpha',0.5);
    end
elseif clic == 3
    if ban_tod == 1                                             % Se activo bandera de aproximacion
        desel();                % Deseleccionar Nodos
        axes(axe_dibujo);
        try delete(obj_sel); end
        obj_sel = scatter(vn_coor(sub_s,2),vn_coor(sub_s,3),'marker','o','MarkerEdgeColor','r','LineWidth',2.5);
        if op_play == 0
            sub_s
            Informacion_del_Nodo
        elseif op_play == 1
            
            Desplazamientos_en_Nodos
        end
    end
end    

        
    