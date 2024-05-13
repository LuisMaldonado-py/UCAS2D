function Graficar_Fuerzas2(cerost_M, eq_M, M_max, e, ang, xi, yi, elem, f_p)
%e es la escala para la grafica para momento e=50 para cortante y axial e=1
%f_p fill o plot para relleno o valores, 1 es fill 2 es plot
global L long subpartes fill_m plot_m part_x tx Lo db de
    M_maxe=M_max(elem);
    M_maxt=max(abs(M_max));
    if M_maxt==0 M_maxt=Inf; end
    xdist=0;
    for j=1:size(subpartes{elem},2)
        e_f=subpartes{elem}(j);
        ceros_M{j}=cerost_M{elem}{j};
        if ~isempty(ceros_M{j})
            for i=1:length(ceros_M{j})+1
                if i==1 v_ini=xdist+db(e_f); else v_ini=v_fin; end
                if i==length(ceros_M{j})+1 v_fin=Lo(e_f)+xdist-de(e_f); else v_fin=ceros_M{j}(i)+xdist; end
                M_ini(j)=polyval(eq_M{elem}{j},v_ini-xdist); M_fin(j)=polyval(eq_M{elem}{j},v_fin-xdist);
                xaux=v_ini:L(e_f)/10:v_fin; M_aux=polyval(eq_M{elem}{j},xaux-xdist);
                if polyval(eq_M{elem}{j},(v_fin+v_ini)/2-xdist)>0 
                    fill_c=[0 0 1]; 
                else
                    fill_c=[1 0 0]; 
                end
                x0=[v_ini xaux v_fin v_fin]; y0=[0 M_aux/M_maxt*e M_fin(j)/M_maxt*e 0];
                x0r=x0*cos(ang(elem))-y0*sin(ang(elem));
                y0r=x0*sin(ang(elem))+y0*cos(ang(elem));
                xm=x0r+xi; ym=y0r+yi;
                if f_p==1
                    fill_m=[fill_m fill(xm,ym,fill_c,...                   %'LineStyle','none',
                        'FaceAlpha',.5)];
                    set(fill_m(end),'DisplayName',num2str(elem));
                    set(fill_m(end),'ButtonDownFcn','selec_ele(gco)');
                elseif f_p==2
                    plot_m=[plot_m plot(xm,ym,'k')];
                    try part_x{elem}; catch part_x{elem}=[]; end
                    aux=[0 part_x{elem} long(elem)];
                    if j==1 & i==1                                         %valor en el inicio
                        xm_i=xm(1); ym_i=ym(2);
                        if ym_i>yi fc=long(elem)/60; else fc=-long(elem)/60; end
                        tx=[tx text(xm_i,ym_i+fc,string(abs(M_ini(j))))];
                    end
                    if j==size(subpartes{elem},2) & i==length(ceros_M{j})+1%valor en el final
                        xm_f=xm(end); ym_f=ym(end-1);                      
                        if ym_f>yi fc=long(elem)/60; else fc=-long(elem)/60; end
                        tx=[tx text(xm_f,ym_f+fc,string(abs(M_fin(j))))];
                    end
                    if aux(j)<=long(elem)/2 & long(elem)/2<=aux(j+1);  %valor en el medio
                        x_med=long(elem)/2; M_med=polyval(eq_M{elem}{j},x_med-xdist);
                        xm_m=x_med*cos(ang(elem))-(M_med/M_maxt*e)*sin(ang(elem));
                        ym_m=x_med*sin(ang(elem))+(M_med/M_maxt*e)*cos(ang(elem));
                        xm_m=xi+xm_m; ym_m=yi+ym_m;
                        if ym_m>yi fc=long(elem)/60; else fc=-long(elem)/60; end
                        tx=[tx text(xm_m,ym_m+fc,string(abs(M_med)))];
                    end
                end 
            end
        else
            xaux=0+db(e_f):L(e_f)/10:Lo(e_f)-de(e_f); M_aux=polyval(eq_M{elem}{j},xaux);
            M_ini(j)=polyval(eq_M{elem}{j},0+db(e_f)); M_fin(j)=polyval(eq_M{elem}{j},Lo(e_f)-de(e_f));
            if M_ini(j)>0 fill_c='b'; else fill_c='r'; end
            x0=[0+db(e_f) xaux Lo(e_f)-de(e_f) Lo(e_f)-de(e_f)]+xdist; y0=[0 M_aux/M_maxt*e M_fin(j)/M_maxt*e 0];
            x0r=x0*cos(ang(elem))-y0*sin(ang(elem));
            y0r=x0*sin(ang(elem))+y0*cos(ang(elem));
            xm=x0r+xi; ym=y0r+yi;
            if f_p==1
                fill_m=[fill_m fill(xm,ym,fill_c,...                       %'LineStyle','none',
                    'FaceAlpha',.5)];
                set(fill_m(end),'DisplayName',num2str(elem));
                set(fill_m(end),'ButtonDownFcn','selec_ele(gco)');
            elseif f_p==2
                plot_m=[plot_m plot(xm,ym,'k')];
                try part_x{elem}; catch part_x{elem}=[]; end
                aux=[0 part_x{elem} long(elem)];
                if j==1                                                    %valor en el inicio
                    xm_i=xm(1); ym_i=ym(2);
                    if ym_i>yi fc=long(elem)/60; else fc=-long(elem)/60; end
                    tx=[tx text(xm_i,ym_i+fc,string(abs(M_ini(j))))];
                end
                if j==size(subpartes{elem},2)                              %valor en el final
                    xm_f=xm(end); ym_f=ym(end-1);
                    if ym_f>yi fc=long(elem)/60; else fc=-long(elem)/60; end
                    tx=[tx text(xm_f,ym_f+fc,string(abs(M_fin(j))))];
                end
                if aux(j)<=long(elem)/2 & long(elem)/2<=aux(j+1);          %valor en el medio
                    x_med=long(elem)/2; M_med=polyval(eq_M{elem}{j},x_med-xdist);
                    xm_m=x_med*cos(ang(elem))-(M_med/M_maxt*e)*sin(ang(elem));
                    ym_m=x_med*sin(ang(elem))+(M_med/M_maxt*e)*cos(ang(elem));
                    xm_m=xi+xm_m; ym_m=yi+ym_m;
                    if ym_m>yi fc=long(elem)/60; else fc=-long(elem)/60; end
                    tx=[tx text(xm_m,ym_m+fc,string(abs(M_med)))];
                end
            end 
        end
        xdist=xdist+Lo(e_f);
    end