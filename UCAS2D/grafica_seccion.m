cla(axes_sec,'reset');                                                      % Borra graficas del axes
axes (axes_sec);hold on;                                                    % Llama al axes de geometria de la seccion
b= str2num(get(e_dim1,'string'));                                           % Obtiene ancho de seccion rectangular u otras
h= str2num(get(e_dim2,'string'));                                           % Obtiene altura de seccion rectangular u otras
if sec == 1                                                                 % Dibujo de Seccion Rectangular
    rectangle('Position',[0 0 b h],'EdgeColor','k','FaceColor',[.8 .8 .8]);
elseif sec == 2                                                             % Dibujo de Seccion perfil I
    hold on                                                                 % Traslape de graficas
    tw = h; h = b;                                                          % Solo nomeclatura de dimensiones / espesor del alma / altura del alma
    bf = str2num(get(e_dim3,'string')); tf = str2num(get(e_dim4,'string'));             % Ancho y espesor de los patines
    rectangle('Position',[(bf-tw)/2 0 tw h],'EdgeColor','k','FaceColor',[.8 .8 .8]);    % Rectangulo del alma
    rectangle('Position',[0 0 bf tf],'EdgeColor','k','FaceColor',[.8 .8 .8]);           % Rectangulo patin inferior
    rectangle('Position',[0 h-tf bf tf],'EdgeColor','k','FaceColor',[.8 .8 .8]);        % Rectangulo patin superior
    b = bf;                                                                             % Nuevo Limite en X
elseif sec == 3                                                                                 % Dibujo de Seccion Otras
    rectangle('Position',[0 0 b h],'Curvature',[1 1],'EdgeColor','k','FaceColor',[.7 .7 .7]);   % Ovalo de secciones otras
end
%% ----------------------- Dibujar Ejes -----------------------------------
d = 0.05; c = 'r'; m = max(h,b);   % Distancia extendida / Color del eje / maximo entre altura y base
eje = line([b*(1+d) b/2 b/2],[h/2 h/2 h*(1+d)]); set(eje,'color',c,'LineWidth',0.75); 
scatter(b/2,h/2,'s',c);   % Punto x=0 , y=0
scatter(b/2,h*(1+d),'fill','^',c);   % Flecha de Y
scatter(b*(1+d),h/2,'fill','>',c);   % Flecha de X
text((b/2)+(m*d),h*(1+d),'Y','Color',c);     % Texto de Y
text(b*(1+d),(h/2)+(m*d*1.5),'X','Color',c,'HorizontalAlignment','center');     % Texto de X
%% ------------------------------------------------------------------------
xlim([0-(b*d*2) b*(1+(2*d))]);ylim([0-(h*d*2) h*(1+(2*d))]); % Nuevos Limites para centrar axes
axis equal                                                                  % Ejes iguales
set(axes_sec,'XTick',[],'YTick',[]);                                        % Eliminar ejes en axes
box on