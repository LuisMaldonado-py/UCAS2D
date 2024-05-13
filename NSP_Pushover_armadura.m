% Universidad de Cuenca
% Autores: Pola Mejía y Jorge Rivera
%% Datos Iniciales                                                                  
function [Pv,Rotulas,uf,rotaciones,Maplt,cr,u_lt,cv_hy,Ugeneral,CONNP,XYP,L]= NSP_Pushover_armadura(tol,umax,CONN,XY,PROP,elemenrotulas,columnasportico,cm,Lp,dut)

E=PROP(:,2);                                                               % Modulo de elasticidad del material
A=PROP(:,3);                                                               % Area de la sección
I=PROP(:,4);                                                               % Inercia de la seccion
z=PROP(:,5);

CONEX=CONN(:,1:3);
CONEX(:,2:3)=ones(size(CONN,1),2);

db=CONN(:,4);                                                              %Nodo inicial para area de corte
de=CONN(:,5);                                                              %Nodo final para area de corte
v=PROP(:,5);
fs=PROP(:,6);                                                              %Valor de Poisson
As=(A./fs)*10^15;                                                          %Area de corte
alfa=PROP(:,8);                                                            %Coeficiente termico
rb=CONEX(:,2);                                                             %Resorte inicial
re=CONEX(:,3);                                                             %Resorte final
Fext=[];                                                                   %Fuerzas externas
Rest=[];                                                                   %Fuerzas Resistentes
g=2;

for i=1:size(XY,1)
        Fext=[Fext;(XY(i,7:7+(g-1)))'];    %Recoge la 7ma, 8va y 9na columna que estan las fuerzas puntuales aplicadas
        Rest=[Rest;(XY(i,4:4+(g-1)))'];     %Recoge la 4ta, 5ta y 6ta columna que estan las restricciones
end
s=find(Rest);
p=find(~(Rest));
Fmax=max(Fext);
t=find(Fext==Fmax);  %Encuentra el nodo donde se aplica la mayor fuerza 

Fy=PROP(:,9);
Py=(A.*Fy);
def=Fy./E;                                                        %Encuentra el nodo de control


for i=1:size(CONN,1)
    kr_sub=zeros(size(cm{i,1},1),1);
    
    cm_sub=zeros(size(cm{i,1},1),2);
    cm_sub(:,1)=cm{i,1}(:,1)*Fy(i);
    cm_sub(:,2)=cm{i,1}(:,2);
    cr{i}=cm_sub;
    for j=1:size(kr_sub,1)-1
        kr_sub(j,1)=(cr{i}(j+1,1)-cr{i}(j,1))/(cr{i}(j+1,2)-cr{i}(j,2));
    end    
    kr{i}=kr_sub;
end
%% Precalculos
for i=1:size(CONN,1)
    NI      =   find(CONN(i,2)==XY(:,1));                                   % Encuentra la posicion del nodo inicial
	NJ      =   find(CONN(i,3)==XY(:,1));                                   % Encuentra la posicion del nodo final
    Lo(i)  = sqrt((XY(NI,2)-XY(NJ,2))^2+(XY(NI,3)-XY(NJ,3))^2);
    L(i)    = Lo(i)-de(i)-db(i);
    
    a(i)  = atan((XY(NJ,3)-XY(NI,3))/(XY(NJ,2)-XY(NI,2)));
    if XY(NJ,3)-XY(NI,3)>0 && XY(NJ,2)-XY(NI,2)<0                           % Segundo cuadrante
        a(i)  = a(i)+pi();
    elseif XY(NJ,3)-XY(NI,3)<0 && XY(NJ,2)-XY(NI,2)<0                       % Tercer cuadrante
        a(i)  = a(i)-pi();
    end
end
L=L';                                                                      %Vector de longitudes
a=a';                                                                      %Vector de angulos
%% Matriz de Rigidez Global
B={};
kl={};
kg={};
for i=1:size(L)
    if g==1;
    kl{i}=((E(i)*A(i))/L(i))*[1,-1
                          -1,1];
    B{i}= eye(2,2);                
    kg{i}=B{i}*kl{i};
    elseif g==2;
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
    
end

kln=kl;
kgn=kg;

[K]= MATRIZ_KJ(XY,CONN,kg,g);
%         Kpp=K(p,p);
%         Ksp=K(s,p);
%         Kps=K(p,s);
%         Kss=K(s,s);
p2=p;
K2=K;
Fext2=Fext;

 %Se establece las fuerzas igual a cero en los resortes rotacionales
cro={};
for i=1:size(L,1)

    yteta=cr{i}(:,1);
    xteta=cr{i}(:,2);
    %Opensees
    x_op=zeros(size(yteta,1)*2-1,1);
    y_op=zeros(size(yteta,1)*2-1,1);
    cont=1;
        for j=size(yteta,1):-1:1
            x_op(cont,1)=-xteta(j,1);
            y_op(cont,1)=-yteta(j,1);
            if cont~=size(yteta,1);
                x_op(cont+size(yteta,1),1)=xteta(cont+1,1);
                y_op(cont+size(yteta,1),1)=yteta(cont+1,1);
            end
            cont=cont+1;   
        end  
    cro{i}(:,1)=y_op;
    cro{i}(:,2)=x_op;   
end


ks=100000;                                                                 %Rigidedz del resorte
K2(t,t)=K2(t,t)+ks;                                                        %Se coloca el resorte en la matriz de rigidez
F2=Fext2;                                                                  %Fuerzas Esxternas
F=F2(p2,1);                                                                %Patron de fuerzas externas unitarias equaldoff
Fmax=max(F);                                                               %Fuerza maxima del vector de fuerzas unitarias
a=find(F==Fmax);                                                           %Encuentra la posición del nodo de control
%% Datos Iniciales del NSP
cr=cro;                                                                    %Comportamiento de las rotulas del material

n=0;                                                                       %Contador de vectores
Pv=[];                                                                     %Vector de resultados
n=n+1; 
Pv(1,:)=[0,0,0];                                                           %Vector de resultados del pushover 
m=0;
Rotulas={};
Ppos=[];
pos1=[];
rotaciones=[];
Maplt=[];
Cposant=ones(size(L,1),1);Cposact=ones(size(L,1),1);                     %vectores que indican el cambio de pendiente en el comportamiento del material
diract=ones(size(L,1),1);

Fr=zeros(size(p2));                                                        %Fuerzas Resistentes
Fa=zeros(size(p2));                                                        %Fuerzas Actuantes
u2=zeros(g*size(XY,1),1);                                                  %Vector de desplazamientos
utot=zeros(g*size(XY,1),1);
giro=zeros(size(L,1),1);
U=zeros(size(p2));                                                         %Vector de desplazamientos 
Ut=0;                                                                      %Desplazamiento del nodo de control
lambda=0;                                                                  %Coeficiente de relación entre fuerzas externas y resistentes

est_rot=zeros(size(cr,2),1);
comp_est_rot=est_rot;
cv_hy={};
ww=0;
Ugeneral=XY(:,1);                                                           %Denominacion de los puntos
NGDL=size(XY,1)*g;

ct=0;
%Variable de almacenamiento de desplazamientos 
%% Algoritmo del analisis NSP
 while Ut<umax 
    ww=ww+1;
      
    Ut=Ut+dut;                      
    Fs=ks*dut;                                                             %Fuerza resisitente del resorte
    Fa(a,1)=Fa(a,1)+Fs;                                                    %Fuerzas Actuantes
    deltaF=Fa+Fr;                                                          %Vector de fuerzas desbalanceado
    pos1=[];
    w=0;                                                                   % No. iteraciones para igualarse
    Mw=[];
    gw=[];
    if n==499
        v=0;
    end
    while norm(deltaF)>tol                                                 %Se obtiene la euclaniana del vector desbalaceado y se compara con la tolerancia     
        w=w+1;                                                             %Acomulador de iteraciones
        Kpp=K2(p2,p2);
        Uu=inv(Kpp)*deltaF;                                                %Vector de desplazamientos debido al desbalance
        Uf=inv(Kpp)*F;                                                     %Vector de desplazamientos debido a las fuerzas unitarias
        Ru=ks*((U(a,1)+Uu(a,1))-Ut);                                       %Fuerzas internas debido al desbalance
        Rf=ks*(Uf(a,1));                                                   %Fuerzas internas probocadas por desplazameinto                                         
        dlambda=-(Ru/Rf);                                                  %Factor de relación de fuerzas
        lambda=lambda+dlambda;                                             %Factor de acomulación
        Uu=Uu+dlambda*Uf;                                                  %Vector de desplazamientos igualado  
        U=U+Uu;                                                            %Vector de desplazamientos acomulado
        Fa=lambda*F;                                                       %Fuerzas desbalanceadas                                                  
        Fa(a,1)=Fa(a,1)+ks*Ut;                                             %Fuerzas desbalanceadas más resorte
        u2(p2,1)=Uu;                                                        %Vector de desplazamientos totales para cada iteración
        
        utot=utot+u2; 
        
        fele2={}; pele2={}; fele2x={}; pele2x={};                          %Fuerza interna en los elementos
        NGDL=size(XY,1)*g;
        Fint=zeros(NGDL,1);
        for i=1:size(CONN,1)
               
   % NI      =   find(CONN(i,2)==XY(:,1));                                   % Encuentra la posicion del nodo inicial
	%NJ      =   find(CONN(i,3)==XY(:,1));                                   % Encuentra la posicion del nodo final
    %giro(i)  = (sqrt(((XY(NI,2)+utot(g*NI-(g-1)))-(XY(NJ,2)+utot(g*NJ-(g-1))))^2+((XY(NI,3)+utot(g*NI))-(XY(NJ,3)+utot(g*NJ)))^2)-L(i))/L(i);
    %dgiro(i)  = (sqrt(((XY(NI,2)+u2(g*NI-(g-1)))-(XY(NJ,2)+u2(g*NJ-(g-1))))^2+((XY(NI,3)+u2(g*NI))-(XY(NJ,3)+u2(g*NJ)))^2)-L(i))/L(i);
         
            NI=CONN(i,2);                                               
            NJ=CONN(i,3);                                               
            fele{i}=kg{i}*[utot(g*NI-(g-1):g*NI);utot(g*NJ-(g-1):g*NJ)];   
            ul{i}=B{i}*[utot(g*NI-(g-1):g*NI);utot(g*NJ-(g-1):g*NJ)];
            dul{i}=B{i}*[u2(g*NI-(g-1):g*NI);u2(g*NJ-(g-1):g*NJ)];           
            pele{i}=B{i}*fele{i};

            giro(i)=(ul{i}(3,1)-ul{i}(1,1))/L(i);
            dgiro(i)=(dul{i}(3,1)-dul{i}(1,1))/L(i);
                if dgiro(i)>0;
                    diract(i)=1; %Si el giro va hacia la derecha se coloca 1 Tension
                else
                    diract(i)=-1;%Si el giro va hacia la izquierda se coloca -1 Compresion
                end
               
            if n==1
                Cposact(i)=Cposact(i)*diract(i);
                dirant(i)=diract(i);
                Cposant(i)=Cposact(i);
            end
            
            O=(((size(cr{i},1))-1)/2)+1;

            for j=1:(size(cr{i},1)-1)
                if giro(i)>cr{i}(j,2) && giro(i)<cr{i}(j+1,2)
                    Cposact(i)=j-O;
                    if Cposact(i)>=0
                        Cposact(i)=Cposact(i)+1;
                    end
                    j=(size(cr{i},1)-1);
                end
            end
        
             if   giro(i)<cr{i}(1,2)                        
                        Cposact(i)=-O;                        
              elseif giro(i)>cr{i}(size(cr{i},1),2)
                        Cposact(i)=O;
             end
            
            
            M=cr{i}(O+(Cposact(i))-(abs(Cposact(i))/(Cposact(i))),1);
            if abs(Cposact(i))==2
                def=((Cposact(i))/(Cposact(i)))*(giro(i)-cr{i}(O+(Cposact(i))-(abs(Cposact(i))/(Cposact(i))),2));
            else
                def=(giro(i)-cr{i}(O+(Cposact(i))-(abs(Cposact(i))/(Cposact(i))),2));
            end
            C=abs(Cposact(i));

            kp=kr{i}(C,1);
            Mapl(i)=(M+(def)*kp)*A(i);
            
            Pelem{i}=[-Mapl(i);0;Mapl(i);0];
            Felem{i}=inv(B{i})*Pelem{i};

            Fint(g*NI-(g-1):g*NI,1)=Fint(g*NI-(g-1):g*NI,1)+Felem{i}(1:g,1);
            Fint(g*NJ-(g-1):g*NJ,1)=Fint(g*NJ-(g-1):g*NJ,1)+Felem{i}(g+1:2*g,1);
                
            if Cposact(i)~=Cposant(i)
                Knant=kr{i}(abs(Cposant(i)),1)*A(i)/L(i);
                kl{i}=Knant*[1,0,-1,0
                             0,0,0,0
                            -1,0,1,0
                             0,0,0,0];
                kg{i}=(B{i})'*kln{i}*B{i};
                       
                Kn=kr{i}(abs(Cposact(i)),1)*A(i)/L(i);                   
                kln{i}=Kn*[1,0,-1,0
                           0,0,0,0
                          -1,0,1,0
                           0,0,0,0];
                kgn{i}=(B{i})'*kln{i}*B{i};
   
                K2((2*NI-1):(2*NI),(2*NI-1):(2*NI))=K2((2*NI-1):(2*NI),(2*NI-1):(2*NI))-kg{i}((1:2),(1:2))+kgn{i}((1:2),(1:2));
                K2((2*NJ-1):(2*NJ),(2*NJ-1):(2*NJ))=K2((2*NJ-1):(2*NJ),(2*NJ-1):(2*NJ))-kg{i}((3:4),(3:4))+kgn{i}((3:4),(3:4));
                K2((2*NI-1):(2*NI),(2*NJ-1):(2*NJ))=K2((2*NI-1):(2*NI),(2*NJ-1):(2*NJ))-kg{i}((1:2),(3:4))+kgn{i}((1:2),(3:4));
                K2((2*NJ-1):(2*NJ),(2*NI-1):(2*NI))=K2((2*NJ-1):(2*NJ),(2*NI-1):(2*NI))-kg{i}((3:4),(1:2))+kgn{i}((3:4),(1:2));                  
                   
                if abs(Cposact(i))==2
                    idct=1;
                    if est_rot(i)==0;
                        est_rot(i)=idct;
                        pos1=[pos1,i];
                    end   
                end
                
                if abs(Cposact(i))==size(kr{i},1)
                        ct=1;
                        Ut=umax;
                 end
            end
        end
        %Se suman en los gdl master las fuerzas de los gdl slave            
        Fr=-Fint(p2,1);
        Fr(a,1)=Fr(a,1)-ks*U(a,1);
        deltaF=Fa+Fr;
        
        Mapl_a=Mapl;
        giro_a=giro;
        dirant=diract;
        Cposant=Cposact;
    end

   
 %Suma cada incremento de fuerza
  %Suma cada incremento en el nodo de control  
    if ct==0
          giros(n,:)=[giro'];
    momentos(n,:)=[Mapl']; 
    Cpos(n,:)=[Cposact'];
    d(n,:)=[diract'];
    posll=[];
    if size(pos1,2)~=0
        for j=1:size(pos1,2)
           if comp_est_rot(pos1(1,j),1)==0;
               comp_est_rot(pos1(1,j),1)=1;
               posll=[posll,pos1(1,j)];
           end
        end
        pos1=posll;
        m=m+1;
        Rotulas{m}=[Ut,pos1];
        rotaciones=[rotaciones,(giro)];
        Maplt=[Maplt,(Mapl)];
    end 
   Paux=lambda*F(a,1);         
         n=n+1;Pv(n,:)=[Paux,Ut,w]; % Se agrega tanto la fuerza como el desplazamiento en un nod
    end   
    
    
    Xx=[];
    Yy=[];
   for i=1:size(XY,1)
        Xx=[Xx;utot((i*g)-1,1)];
        Yy=[Yy;utot((i*g),1)];
   end 
    Ugeneral=[Ugeneral,Xx,Yy];
    
    if Paux<0
%         Pv(n,:)=[];
        Ut=umax;
    end
    
 end  
 u_lt=0;
 cr=cro;
for i=1:size(cro,2);
    cv_hy{i}(:,1)=giros(:,i);
    cv_hy{i}(:,2)=momentos(:,i);
end
XYP=XY;
CONNP=CONN;
uf={};
for i=1:size(CONN,1);
    uf{i,1}=i;
    uf{i,2}=[XY(CONN(i,2),2),XY(CONN(i,2),3);
             XY(CONN(i,3),2),XY(CONN(i,3),3)];
end
Pvv=[];
   for i=1:size(Rotulas,2)
       Pvv(i,1)=Rotulas{i}(1,1);
       Pvv(i,2)=Pv((find(Pv(:,2)==Pvv(i,1))),1);
   end
Maplt=Maplt';
end
