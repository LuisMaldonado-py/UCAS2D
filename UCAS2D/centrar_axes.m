function centrar_axes(ax_e,raz)                                        % Funcion para centrar grafica en zona de dibujo
x=get(ax_e,'xlim');
y=get(ax_e,'ylim');
if sum(abs(x))>=sum(abs(y))
    r=raz*sum(abs(x));
else 
    r=raz*sum(abs(y));
end
x(1) = x(1) - r;
x(2) = x(2) + r;
y(1) = y(1) - r;
y(2) = y(2) + r;
axis([x,y]);