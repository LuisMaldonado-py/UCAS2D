global e_dim1 e_dim2 e_dim3 e_dim4 op_sec sec vs_pro1 vsec3
if op_sec ==2 & sec == 3
elseif sec == 1 | sec ==2 | sec == 3
    b= str2num(get(e_dim1,'string'));                                       % Obtiene ancho de seccion rectangular u otras
    h= str2num(get(e_dim2,'string'));                                       % Obtiene altura de seccion rectangular u otras
    if sec == 1                                                                 % Calculo de propiedades de seccion Rectangular
        vs_pro1(1)= h;                                                          % Anexa altura efectiva a vector de propiedades
        vs_pro1(2)= b;                                                          % Anexa ancho efectivo a vector de propiedades
        vs_pro1(3)= b * h;                                                      % Anexa area a vector de propiedades
        vs_pro1(4)= b * h/1.2;                                                  % Anexa area de corte en X a vector de propiedades
        vs_pro1(5)= b * h/1.2;                                                  % Anexa area de corte en Y a vector de propiedades
        vs_pro1(6)= b * (h^3)/12;                                               % Anexa inercia en X en vector de propiedades
        vs_pro1(7)= h * (b^3)/12;                                               % Anexa inercia en Y en vector de propiedades
        vs_pro1(8)= b * (h^2)/4;                                                % Anexa Modulo Plastico en X en vector de propiedades
        vs_pro1(9)= h * (b^2)/4;                                                % Anexa Modulo Plastico en Y en vector de propiedades
        
    elseif sec == 2                                                             % Calculo de propiedades de Perfil I
        tw = h; h = b;                                                          % Solo nomeclatura de dimensiones / espesor del alma / altura del alma
        bf = str2num(get(e_dim3,'string')); tf = str2num(get(e_dim4,'string')); % Ancho y espesor de los patines
        vs_pro1(1)= h;                                                          % Anexa altura efectiva a vector de propiedades
        vs_pro1(2)= bf;                                                         % Anexa ancho efectivo a vector de propiedades
        vs_pro1(3)= (2*bf*tf)+((h-(2*tf))*tw);                                  % Anexa area a vector de propiedades
        vs_pro1(4)= 2*bf*tf/1.2;                                                % Anexa area de corte en X a vector de propiedades
        vs_pro1(5)= h*tw;                                                       % Anexa area de corte en Y a vector de propiedades
        vs_pro1(6)= (((h^3)*bf)+(((h-2*tf)^3)*(tw-bf)))/12;                     % Anexa inercia en X en vector de propiedades
        vs_pro1(7)= (((bf^3)*h)+(((h-2*tf))*((tw^3)-(bf^3))))/12;               % Anexa inercia en Y en vector de propiedades
        vs_pro1(8)= ((((h-2*tf)/2)^2)*tw)+(bf*tf*(h-tf));                       % Anexa Modulo Plastico en X en vector de propiedades
        vs_pro1(9)= (((h-2*tf)/4)*(tw^2))+((bf^2)*tf/2);                        % Anexa Modulo Plastico en Y en vector de propiedades
        
    elseif sec == 3                                                             % Calculo de propiedades de Perfil I
        vs_pro1(1)= h;                                                          % Anexa altura efectiva a vector de propiedades
        vs_pro1(2)= b;                                                          % Anexa ancho efectivo a vector de propiedades
        vs_pro1(1,3:9) = vsec3;
    end
end 