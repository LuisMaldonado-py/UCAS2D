function selec_2ele(b)
global bot ele_sel band_poi band_ele band_rej ve_obj ban_tod 
%----------------- Elemento ----------------------------------
cod = str2num(get(gco,'DisplayName'));
%----------------- Tipo de click ------------------------------
if band_poi == 0 & band_ele == 0 & band_rej == 0 & ban_tod == 0 & isempty(ve_obj) == 0                                                 	% Si se dibuja elementos en rejilla
    if bot == 1 
        cod = str2num(get(gco,'DisplayName'));
        a = find(ele_sel(:,1) == cod);
        delete(ele_sel(a,2));
        ele_sel(a,:) = [];
    end
end    
    