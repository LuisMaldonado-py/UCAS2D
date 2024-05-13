function etiquetas(handles,valor)
    global elem eq_C eq_A eq_V eq_M eq_D part_x
    set(handles.t_ubicacion,'String',valor);                           % En la texto muestra la coor 'x'
    set(handles.u_equi,'String',valor);
    set(handles.u_axial,'String',valor);
    set(handles.u_cort,'String',valor);
    set(handles.u_momen,'String',valor);
    set(handles.u_deflex,'String',valor);
    
    neq=1; Laux=0;
    if ~isempty(part_x)
    if ~isempty(part_x{elem})
        for j=1:size(part_x{elem},2)-1
            if valor>=part_x{elem}(j)
                Laux=+part_x{elem}(j); neq=j+1;
                if valor<=part_x{elem}(j+1) break; end
            end
        end
        if valor>part_x{elem}(end)
            neq=size(part_x{elem},2)+1; Laux=+part_x{elem}(end);
        end
    end
    end
        
    v_equi=round(polyval(eq_C{elem}{neq},valor-Laux),4);
    set(handles.f_equi,'String',v_equi);
    v_axial=string(round(polyval(eq_A{elem}{neq},valor-Laux),4));
    set(handles.f_axial,'String',v_axial);
    v_cort=string(round(polyval(eq_V{elem}{neq},valor-Laux),4));
    set(handles.f_cort,'String',v_cort);
    v_momen=string(round(polyval(-eq_M{elem}{neq},valor-Laux),4));
    set(handles.f_momen,'String',v_momen);
    v_deflex=string(round(polyval(eq_D{elem}{neq},valor-Laux),4));
    set(handles.f_deflex,'String',v_deflex);
end