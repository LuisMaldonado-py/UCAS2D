function Graficar_Fuerzas(cerost_M, eq_M, M_max, axes_m)
global L long elem subpartes Lo db de
    M_maxe=M_max(elem);
    xdist=0;
    for j=1:size(subpartes{elem},2)
        e_f=subpartes{elem}(j);
        ceros_M{j}=cerost_M{elem}{j};
        if ~isempty(ceros_M{j})
            for i=1:length(ceros_M{j})+1
                if i==1 v_ini=xdist+db(e_f); else v_ini=v_fin; end
                if i==length(ceros_M{j})+1 v_fin=Lo(e_f)+xdist-de(e_f); else v_fin=ceros_M{j}(i)+xdist; end
                M_ini=polyval(eq_M{elem}{j},v_ini-xdist); M_fin=polyval(eq_M{elem}{j},v_fin-xdist);
                xaux=v_ini:L(e_f)/10:v_fin; M_aux=polyval(eq_M{elem}{j},xaux-xdist);
                if polyval(eq_M{elem}{j},(v_fin+v_ini)/2-xdist)>0
                   fill_c=[0 0 1]; 
                else
                    fill_c=[1 0 0];
                end
                fill(axes_m,[v_ini xaux v_fin v_fin],[0 M_aux/M_maxe M_fin/M_maxe 0],...
                        fill_c,'LineStyle','none','FaceAlpha',.5); 
            end
        else
            xaux=0+db(e_f):L(e_f)/10:Lo(e_f)-de(e_f); M_aux=polyval(eq_M{elem}{j},xaux);
            M_ini(j)=polyval(eq_M{elem}{j},0+db(e_f)); M_fin(j)=polyval(eq_M{elem}{j},Lo(e_f)-de(e_f));
            if M_ini(j)>0 fill_c='b'; else fill_c='r'; end
            fill(axes_m,[0+db(e_f) xaux Lo(e_f)-de(e_f) Lo(e_f)-de(e_f)]+xdist,[0 M_aux/M_maxe M_fin(j)/M_maxe 0],...
                fill_c,'LineStyle','none','FaceAlpha',.5);
        end
        xdist=xdist+Lo(e_f);
    end
    line(axes_m,[0 long(elem)],[0 0],'LineWidth',2,'Color',[0.5 0.5 0.5]);
end