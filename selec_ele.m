function selec_ele(b)
global sub band_poi band_ele band_rej ve_obj bot ban_tod ele_sel obj_sel
global ve_conex vn_coor axe_dibujo op_play vn_coor_o
if isempty(vn_coor_o) vn_coor_o=vn_coor(:,[2 3]); end
%----------------- Tipo de click ------------------------------
if band_poi == 0 & band_ele == 0 & band_rej == 0 & ban_tod == 0 & isempty(ve_obj) == 0                                                 	% Si se dibuja elementos en rejilla
    cod = str2num(get(gco,'DisplayName'));
    if bot == 1 
        sub = find(ve_obj(:,1) == cod);
        a = [];
        if size(ele_sel,1) > 0
            a = find(ele_sel(:,1)== cod);
        end    
        if isempty(a) == 1 
            ni = ve_conex(sub,2);nf = ve_conex(sub,3);
            s_ni = find(vn_coor(:,1)== ni);s_nf = find(vn_coor(:,1)== nf);
            xi = vn_coor(s_ni,2);yi = vn_coor(s_ni,3);
            xf = vn_coor(s_nf,2);yf = vn_coor(s_nf,3);
            ele_sel(end+1,1) = cod;  
            axes(axe_dibujo);
            ele_sel(end,2) = line([xi xf],[yi yf],'LineWidth',2.5,'LineStyle','--','Color',[0.75 0.75 0.75]);  % Grafico de linea   ;  % Linea guia actualizar
            set(ele_sel(end,2),'DisplayName',num2str(cod));
            set(ele_sel(end,2),'ButtonDownFcn','selec_2ele(gco)');
        else
            delete(ele_sel(a,2));
            ele_sel(a,:) = [];
        end
    elseif bot == 3    
        desel();                % Deseleccionar Nodos
        sub = find(ve_obj(:,1) == cod);
        ni = ve_conex(sub,2);nf = ve_conex(sub,3);
        s_ni = find(vn_coor(:,1)== ni);s_nf = find(vn_coor(:,1)== nf);
        xi = vn_coor_o(s_ni,1);yi = vn_coor_o(s_ni,2);
        xf = vn_coor_o(s_nf,1);yf = vn_coor_o(s_nf,2);
        axes(axe_dibujo);
        obj_sel = line([xi xf],[yi yf],'LineWidth',3.5,'LineStyle','-','Color','r');  % Grafico de linea   ;  % Linea guia actualizar
        sub = find(ve_obj(:,1) == cod);
        if op_play == 0
            Informacion_del_Elemento
        end
        if op_play == 1
            Fuerzas
        end
    end 
end
    