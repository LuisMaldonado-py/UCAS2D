function [FEquiv,Fempg]= FuerzasCOD(XY,CONN,CARGAS,B,L,A,I,T,o)
%Fuerzas de empotramiento perfecto extraido del libro de Kassimali
global Femptg Fempwg Fempwxg Fempwpg Fempwpxg Fempwmg Femplg
global t1 t2 w wx wp wpx wm dl
%--temperatura--
alfa=CONN(:,5);
h=CONN(:,7);
t1=CARGAS(:,1); %Temperatura 1 inf (en vigas hay t1~t2, en armaduras t2=t1)
t2=CARGAS(:,2); %Temperatura 2 sup
dt=t2-t1;      %Diferencia de temperatura
tm=(t1+t2)/2;  %Temp. promedio - Carga de temperatura
%--distribuida--
w=-CARGAS(:,3);  %Carga distribuida perpendicular
w_a=CARGAS(:,4); %Porcion de longitud del NI para w
w_b=CARGAS(:,5); %Porcion de longitud del NJ para w
%--distribuida axial--
wx=-CARGAS(:,6); %Carga distribuida axial
wx_a=CARGAS(:,7); %Porcion de longitud del NI para wx
wx_b=CARGAS(:,8); %Porcion de longitud del NJ para wx
%--fuerza puntual--
wp=-CARGAS(:,12); %Carga puntual perpendicular al elemento
wp_a=CARGAS(:,13); %Porcion de longitud del NI para wp
wp_b=CARGAS(:,14); %Porcion de longitud del NJ para wp
%--fuerza puntual axial--
wpx=-CARGAS(:,9); %Carga puntual axial al elemento
wpx_a=CARGAS(:,10); %Porcion de longitud del NI para wpx
wpx_b=CARGAS(:,11); %Porcion de longitud del NJ para wpx
%--momento puntual--
wm=-CARGAS(:,15); %Momento puntual en elemento
wm_a=CARGAS(:,16); %Porcion de longitud del NI para wm
wm_b=CARGAS(:,17); %Porcion de longitud del NJ para wm
%--error de fabricacion--
dl=-CARGAS(:,18); %Delta longitud / si es mas corta dl es neg
E=CONN(:,4);

NGDL=size(XY,1)*3;
FEquiv=zeros(NGDL,1);
Fempg={};
if any(tm(:,1))~=0 | any(w(:,1))~=0 | any(wx(:,1))~=0 | any(wp(:,1))~=0 | any(wpx(:,1))~=0 | any(wm(:,1))~=0 | any(dl(:,1))~=0
    for i=1:size(CONN,1)
        NI=find(CONN(i,2)==XY(:,1));
        NJ=find(CONN(i,3)==XY(:,1));

        Femptg{i}=zeros(6,1); %Femp temperatura-global
        Fempwg{i}=zeros(6,1); %Femp distribuida-global
        Fempwxg{i}=zeros(6,1); %Femp distribuida en x-global
        Fempwpg{i}=zeros(6,1); %Femp puntual-global
        Fempwpxg{i}=zeros(6,1); %Femp puntual en x-global
        Fempwmg{i}=zeros(6,1); %Femp momento-global
        Femplg{i}=zeros(6,1); %Femp longitud/error-global
    
        if tm(i)~=0; % Carga termica \Armadura-Viga
            Atemp=E(i)*A(i)*alfa(i)*tm(i);
            Mtemp=E(i)*I(i)*alfa(i)*dt(i)/h(i);
            Femptl{i}=[Atemp;0;-Mtemp;-Atemp;0;Mtemp];
            Femptlr{i}=T{i}*Femptl{i};
            Femptg{i}=(B{i})'*Femptlr{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Femptg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Femptg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Femptg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Femptg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Femptg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Femptg{i}(6,1);
        end

        if w(i)~=0; % Carga distribuida \Viga
            l1=w_a(i)*L(i);
            l2=w_b(i)*L(i);
            Vdist_a=w(i)*L(i)/2*(1-l1/L(i)^4*(2*L(i)^3+...
                -2*l1^2*L(i)+l1^3)-l2^3/L(i)^4*(2*L(i)-l2));
            Vdist_b=w(i)*L(i)/2*(1-l1^3/L(i)^4*(2*L(i)-l1)+...
                -l2/L(i)^4*(2*L(i)^3-2*l2^2*L(i)+l2^3));
            Mdist_a=w(i)*L(i)^2/12*(1-l1^2/L(i)^4*(6*L(i)^2+...
                -8*l1*L(i)+3*l1^2)-l2^3/L(i)^4*(4*L(i)-3*l2));
            Mdist_b=-w(i)*L(i)^2/12*(1-l2^2/L(i)^4*(6*L(i)^2+...
                -8*l2*L(i)+3*l2^2)-l1^3/L(i)^4*(4*L(i)-3*l1));
            Fempwl{i}=[0;Vdist_a;Mdist_a;0;Vdist_b;Mdist_b];
            
            if o{i}==[3] %articulacion en la izq
                Fempwl{i}=[0;Vdist_a-3/(2*L(i))*Mdist_a;0;0;Vdist_b+3/(2*L(i))*Mdist_a;Mdist_b-1/2*Mdist_a];
            elseif o{i}==[6] %articulacion en la der
                Fempwl{i}=[0;Vdist_a-3/(2*L(i))*Mdist_b;Mdist_a-1/2*Mdist_b;0;Vdist_b+3/(2*L(i))*Mdist_b;0];
            elseif ~isempty(find(o{i}==[3])) & ~isempty(find(o{i}==[6])) %articulacion en ambos extremos 
                Fempwl{i}=[0;Vdist_a-1/L(i)*(Mdist_a+Mdist_b);0;0;Vdist_b+1/L(i)*(Mdist_a+Mdist_b);0];
            end
            
            Fempwlr{i}=T{i}*Fempwl{i};
            Fempwg{i}=(B{i})'*Fempwlr{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Fempwg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Fempwg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Fempwg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Fempwg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Fempwg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Fempwg{i}(6,1);
        end
        
        if wx(i)~=0; % Carga distribuida axial \Armadura-Viga
            l1=wx_a(i)*L(i);
            l2=wx_b(i)*L(i);
            Adist_a=wx(i)/(2*L(i))*(L(i)-l1-l2)*(L(i)-l1+l2);
            Adist_b=wx(i)/(2*L(i))*(L(i)-l1-l2)*(L(i)+l1-l2);
            Fempwxl{i}=[Adist_a;0;0;Adist_b;0;0];
            Fempwxlr{i}=T{i}*Fempwxl{i};
            Fempwxg{i}=(B{i})'*Fempwxlr{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Fempwxg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Fempwxg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Fempwxg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Fempwxg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Fempwxg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Fempwxg{i}(6,1);
        end
        
        if wp(i)~=0; % Fuerza puntual \Viga
            l1=wp_a(i)*L(i);
            l2=wp_b(i)*L(i);
            Vp_a=wp(i)*l2^2/L(i)^3*(3*l1+l2);
            Vp_b=wp(i)*l1^2/L(i)^3*(3*l2+l1);
            Mp_a=wp(i)*l1*l2^2/L(i)^2;
            Mp_b=-wp(i)*l1^2*l2/L(i)^2;
            Fempwpl{i}=[0;Vp_a;Mp_a;0;Vp_b;Mp_b];
            Fempwplr{i}=T{i}*Fempwpl{i};
            Fempwpg{i}=(B{i})'*Fempwplr{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Fempwpg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Fempwpg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Fempwpg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Fempwpg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Fempwpg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Fempwpg{i}(6,1);
        end
        
        if wpx(i)~=0; % Fuerza puntual axial \Viga
            l1=wpx_a(i)*L(i);
            l2=wpx_b(i)*L(i);
            Ap_a=wpx(i)*l2/L(i);
            Ap_b=wpx(i)*l1/L(i);
            Fempwpxl{i}=[Ap_a;0;0;Ap_b;0;0];
            Fempwpxlr{i}=T{i}*Fempwpxl{i};
            Fempwpxg{i}=(B{i})'*Fempwpxlr{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Fempwpxg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Fempwpxg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Fempwpxg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Fempwpxg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Fempwpxg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Fempwpxg{i}(6,1);
        end
        
        if wm(i)~=0; % Momento puntual \Viga
            l1=wm_a(i)*L(i);
            l2=wm_b(i)*L(i);
            Vm_a=-6*wm(i)*l1*l2/L(i)^3;
            Vm_b=6*wm(i)*l1*l2/L(i)^3;
            Mm_a=wm(i)*l2/L(i)^2*(l2-2*l1);
            Mm_b=wm(i)*l1/L(i)^2*(l1-2*l2);
            Fempwml{i}=[0;Vm_a;Mm_a;0;Vm_b;Mm_b];
            Fempwmlr{i}=T{i}*Fempwml{i};
            Fempwmg{i}=(B{i})'*Fempwmlr{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Fempwmg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Fempwmg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Fempwmg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Fempwmg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Fempwmg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Fempwmg{i}(6,1);
        end
        
        if dl(i)~=0; % Error de fabricacion \Armadura
            Plong=E(i)*A(i)*dl(i)/L(i);
            Fempll{i}=Plong*[1;0;0;-1;0;0];
            Femplg{i}=(B{i})'*Fempll{i};

            FEquiv(3*NI-2,1)=FEquiv(3*NI-2,1)-Femplg{i}(1,1);
            FEquiv(3*NI-1,1)=FEquiv(3*NI-1,1)-Femplg{i}(2,1);
            FEquiv(3*NI,1)=FEquiv(3*NI,1)-Femplg{i}(3,1);
            FEquiv(3*NJ-2,1)=FEquiv(3*NJ-2,1)-Femplg{i}(4,1);
            FEquiv(3*NJ-1,1)=FEquiv(3*NJ-1,1)-Femplg{i}(5,1);
            FEquiv(3*NJ,1)=FEquiv(3*NJ,1)-Femplg{i}(6,1);
        end
        
        Fempg{i}=Femptg{i}+Fempwg{i}+Fempwxg{i}+Fempwpg{i}+Fempwpxg{i}+Fempwmg{i}+Femplg{i};
    end
end
end