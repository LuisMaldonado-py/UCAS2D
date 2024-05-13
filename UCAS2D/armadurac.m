%% DATOS
XY    =   textread('NodosP.txt');
CONN  =   textread('ElementosP.txt');

XY=[coor XY];
CONN=[conex CONN];

E=CONN(:,4);
alfa=CONN(:,5);
A=CONN(:,6);
Fext=[]; Rest=[]; 
for i=1:size(XY,1)
        Fext=[Fext;(XY(i,6:7))'];     %Recoge la 6ta y 7ma columna que estan las fuerzas puntuales aplicadas
        Rest=[Rest;(XY(i,4:5))'];     %Recoge la 4ta y 5ta columna que estan las restricciones
end
s=find(Rest);
p=find(~(Rest));

%% No lineal
opc1=menu('Analisis no lineal','Si','No');
if opc1==1
    Fy=input('Ingrese el valor de Fy: ');
    Py=Fy*A;
    GDL=input('GDL a aplicar la carga unitaria: ');
    Fext(:)=0; Fext(GDL)=1;
end

%% CALCULOS
for i=1:size(CONN,1)
    NI      =   find(CONN(i,2)==XY(:,1));                                   % Encuentra la posicion del nodo inicial
	NJ      =   find(CONN(i,3)==XY(:,1));                                   % Encuentra la posicion del nodo final
    L(i)  = sqrt((XY(NI,2)-XY(NJ,2))^2+(XY(NI,3)-XY(NJ,3))^2);
    a(i)  = atan((XY(NJ,3)-XY(NI,3))/(XY(NJ,2)-XY(NI,2)));
%     if XY(NJ,3)-XY(NI,3)>0 && XY(NJ,2)-XY(NI,2)<0                           % Segundo cuadrante
%         a(i)  = a(i)+pi();
%     elseif XY(NJ,3)-XY(NI,3)<0 && XY(NJ,2)-XY(NI,2)<0                       % Tercer cuadrante
%         a(i)  = a(i)-pi();
%     end
end
L=L';
a=a';

%Matriz de Transformación
B={};
kl={};
kg={};
for i=1:size(a)
    B{i}=[cos(a(i)),sin(a(i)),0,0
        -sin(a(i)),cos(a(i)),0,0
          0,0,cos(a(i)),sin(a(i))
          0,0,-sin(a(i)),cos(a(i))];
    kl{i}=((E(i)*A(i))/L(i))*[1,0,-1,0
                          0,0, 0,0
                          -1,0,1,0
                          0,0,0,0];
    kg{i}=(B{i})'*kl{i}*B{i};
end
%% MATRIZ DE RIGIDEZ GLOBAL
[K]= MATRIZ_K(XY,CONN,kg);
Kpp=K(p,p);
Ksp=K(s,p);
Kps=K(p,s);
Kss=K(s,s);

%% VECTOR DE FUERZAS

[FEquiv,Fempg]= Fuerzas(XY,CONN,B,L);
F=Fext-FEquiv;
Fp=F(p,1);

%% F=K*U

% Desplazamiento en Nodos (Up)
Up=inv(Kpp)*Fp

% Reacciones en Apoyos
Fs=Ksp*Up;
R=Fs+FEquiv(s,1);

% Vector de desplazamientos
C=0;
for i=1:2*size(XY,1)
    if Rest(i)==1
        u(i,1)=0;
    else
        C=C+1;
        u(i,1)=Up(C,1);
    end
end

%% Fuerzas en Elementos
fele={};
pele={};

for i=1:size(CONN,1)
    NI=find(CONN(i,2)==XY(:,1));
    NJ=find(CONN(i,3)==XY(:,1));
    if isempty(Fempg)~=1
        if isempty(Fempg{i})==1
            fele{i}=kg{i}*[u(2*NI-1:2*NI);u(2*NJ-1:2*NJ)];
            pele{i}=B{i}*fele{i};
        else
            fele{i}=kg{i}*[u(2*NI-1:2*NI);u(2*NJ-1:2*NJ)]+Fempg{i};
            pele{i}=B{i}*fele{i};
        end
    else
        fele{i}=kg{i}*[u(2*NI-1:2*NI);u(2*NJ-1:2*NJ)];
        pele{i}=B{i}*fele{i};
    end
end


%% No lineal
%Pu=Fuerza unitaria Pf=Fuerza para fluir  PS=elem q ya fluyeron
if opc1==1
    PS=[]; figure
    for i=1:size(E,1) %-1 xq ya se hizo una iteracion pero no Pu ni Pf
        for e=1:size(E,1)
             if isempty(find(e==PS)) %Verifica si e=elem aun no fluye
                Pu{i}(e)=abs(pele{e}(1));
                if i-1==0 %Primera iteracion
                    Pf{i}(e)=(Py(e))/Pu{i}(e);
                else      %Siguientes iteraciones
                    aux{e}(i)=P1(i-1)*Pu{i-1}(e);
                    Pf{i}(e)=(Py(e)-sum(aux{e}))/Pu{i}(e);
                end
             end
        end
        if i==length(Pf)
            P1(i)=min(Pf{i}(find(Pf{i}))); %min Pf que aun no fluye(Pf~0)
            U1(i)=Up(mod(GDL,2)+2*mod(GDL+1,2))*P1(i); %%Up=[x 0] o Up=[0 y]
            P1g(i+1)=sum(P1); U1g(i+1)=sum(U1);
            plot(U1g,P1g,'-k'); hold on
            Ef{i}=find(P1(i)==Pf{i}); E(Ef{i})=CONN(Ef{i},4)*0.001; 
            PS=[PS Ef{i}];
            [pele,Up,Kpp]= Pushover(B,E,A,L,p,XY,CONN,Fp,GDL);
        end
    end
end


%% Coordenadas para graficar
XYo=XY(:,2:3); e=10; %factor de escala para observar en el grafico
% Vector de coordenadas deformadas
for i=1:size(XY,1)
    XYd(i,1)=XYo(i,1)+e*u(2*i-1);
    XYd(i,2)=XYo(i,2)+e*u(2*i);
end

% Vector de coordenadas de fuerza axial
for i=1:size(CONN,1)
    NI=find(CONN(i,2)==XY(:,1));
    NJ=find(CONN(i,3)==XY(:,1));
    XYa{i}(:,1)=XYo([NI,NJ],1)+e*fele{i}(2)*[1;1];
    XYa{i}(:,2)=XYo([NI,NJ],2)+e*fele{i}(1)*[-1;-1];
    XYa1{i}=[XYo(NI,:);XYa{i}(1,:)];
    XYa2{i}=[XYo(NJ,:);XYa{i}(2,:)];
end

%% Graficos
figure
for i=1:size(CONN,1)
    NI=find(CONN(i,2)==XY(:,1));
    NJ=find(CONN(i,3)==XY(:,1));
    %Grafico de la armadura original
    plot([XYo(NI,1),XYo(NJ,1)],[XYo(NI,2),XYo(NJ,2)],'-k'); hold on
%     %Grafico de la armadura deformada
%     plot([XYd(NI,1),XYd(NJ,1)],[XYd(NI,2),XYd(NJ,2)],'-b'); hold on
%     %Grafico de fuerza axial
%     plot(XYa{i}(:,1),XYa{i}(:,2),'-r'); hold on; grid on;
%     plot(XYa1{i}(:,1),XYa1{i}(:,2),'-r'); hold on
%     plot(XYa2{i}(:,1),XYa2{i}(:,2),'-r'); hold on
end

