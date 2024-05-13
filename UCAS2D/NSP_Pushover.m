% Universidad de Cuenca
% Autores: Pola Mejía y Jorge Rivera
%% Datos Iniciales                                                                  
function [Pv,Rotulas,uf,rotaciones,Maplt,cr,u_lt,cv_hy,Ugeneral,CONNP,XYP,L,equalDOF]= NSP_Pushover(tol,umax,CONN,XY,PROP,elemenrotulas,columnasportico,cm,Lp,dut)
PROP(:,3)=PROP(:,3)*10000;                                                  % Área de las Secciones Ocupadas             
g=3;                                                                        % Grados de libertad de cada nodo
E=PROP(:,2);                                                                % Módulo de Elasticidad del Material
A=PROP(:,3);                                                                % Área de la Sección
I=PROP(:,4);                                                                % Inercia de la seccion
z=PROP(:,5);                                                                % Módulo de Sección Plástica
if size(Lp,1)==size(find(Lp(:,1)==0));                                      % Comprueba si el usuario coloco cargas gravitacionales o no
    Lp=[];                                                                  % Lp: Vector de cargas gravitacionales del sistema                                  
end
[CONEX,Mp, Mpl,equalDOF,CONN,XY,kr,cr,masterpiso]= rotulas_equaldof1(CONN,XY,PROP,columnasportico,elemenrotulas,cm);
                                                                            % CONEX: Matriz de desface de conexiones. Mp: Vector de Momentos plasticos de los elementos
                                                                            % Mpl: Momentos plasticos en los resortes rotacionales. CONN:Matriz de conecciones de los elementos
                                                                            % XY: Matriz de cordenadas de los nodos. kr: Rigidez de los resortes. cr: comportamiento de los resortes
                                                                            % equalDOF: Matriz de nodos Master y Slave
Mapl=zeros(size(Mpl));                                                      % Vector de los Momentos Aplicados
db=CONN(:,4);                                                               % Nodo Inicial para Área de Corte
de=CONN(:,5);                                                               % Nodo Final para Área de Corte
fs=PROP(:,7);                                                               % Factor de Forma de la Sección. Para secciones W Fs=1
v=PROP(:,6);                                                                % Módulo de Poisson
As=(A./fs)*10^15;                                                           % Área de Corte
alfa=PROP(:,8);                                                             % Coeficiente Termico
rb=CONEX(:,2);                                                              % Parametro de rigidez inicial
re=CONEX(:,3);                                                              % Parametro de rigidez final
Fext=[];                                                                    % Vector de Fuerzas Externas
Rest=[];                                                                    % Vector de Fuerzas Resistentes
for i=1:size(XY,1);
    Fext=[Fext;(XY(i,7:9))'];                                               % Los valores XY(i,7:9) contienen los valores de fuerzas
    Rest=[Rest;(XY(i,4:6))'];                                               % Los valores XY(i,4:6) contienen las restricciones del nodo
end
s=find(Rest);                                                               % Grados de libertad Conocidos
p=find(~(Rest));                                                            % Grados de libertad Desconocidos

hmax=max(XY(:,3));                                                          % hmax:Obtiene la altura máxima del pórtico
p_hmax=find(XY(:,3)==hmax);                                                 % p_hmax:Obtiene un vector con las posiciones de los nodos con altura máxima 
p_hmax_p=find(XY(p_hmax,10)==0);                                            % p_hmax_p: Obtiene un vector cons las posiciones de los nodos principales con la altura máxima
t=p_hmax(p_hmax_p(1,1),1)*3-2;                                              % t: Encuentra el grado de libertad en x del Nodo de Control

%% Precalculos
for i=1:size(CONN,1)
    NI=find(CONN(i,2)==XY(:,1));                                            % Posición del nodo inicial
    NJ=find(CONN(i,3)==XY(:,1));                                            % Posición del nodo final
    Lo(i)=sqrt((XY(NI,2)-XY(NJ,2))^2+(XY(NI,3)-XY(NJ,3))^2);                % Vector de Longitud inicial de los elementos
    L(i)=Lo(i)-de(i)-db(i);                                                 % Vector de Longitud libre del elemento
    a(i)=atan((XY(NJ,3)-XY(NI,3))/(XY(NJ,2)-XY(NI,2)));                     % Vector de angulos de los elementos
    if XY(NJ,3)-XY(NI,3)>0 && XY(NJ,2)-XY(NI,2)<0                           % Segundo cuadrante
        a(i)  = a(i)+pi();                                                  % Vector de angulos de los elementos
    elseif XY(NJ,3)-XY(NI,3)<0 && XY(NJ,2)-XY(NI,2)<0                       % Tercer cuadrante
        a(i)  = a(i)-pi();                                                  % Vector de angulos de los elementos
    end
end
L=L';                                                                       % Vector de longitudes
a=a';                                                                       % Vector de angulos
%% Matriz de Rigidez Global
[kg,B,T,R]=MATRICES_K(rb,re,L,E,I,a,db,de,v,A,As);                          % kg: Matriz de los elementos. B: Matriz de Transformacióin de Ejes
                                                                            % T: Matriz de Transformación de conecciones de desface. R: Parametro de rigidez
[K]= MATRIZ_KJ(XY,CONN,kg,g);                                                % Matriz de rigidez global elástica de la estructura

%Efectos P-Delta
if size(Lp,1)~=0 
    masterpiso(1)=1;
    Kg=zeros(size(K));                                                      % Matriz de rigidez Geométrica
    for i=1:(size(masterpiso,1))-1
        pd{i}= Matriz_Pdelta(Lp(i),L(i),E(i),A(i));                         % Coeficientes de rigidez de la matriz geométrica 
        NI=masterpiso(i);                                                   % NI: Posición del nodo inicial
        NJ=masterpiso(i+1);                                                 % NJ: Posición del nodo final
        Kg((3*NI-2):(3*NI),(3*NI-2):(3*NI))=Kg((3*NI-2):(3*NI),(3*NI-2):(3*NI))+pd{i}((1:3),(1:3)); %Coloca el coeficiente de rigidez geométrica en la Matriz geométrica
        Kg((3*NJ-2):(3*NJ),(3*NJ-2):(3*NJ))=Kg((3*NJ-2):(3*NJ),(3*NJ-2):(3*NJ))+pd{i}((4:6),(4:6));
        Kg((3*NI-2):(3*NI),(3*NJ-2):(3*NJ))=Kg((3*NI-2):(3*NI),(3*NJ-2):(3*NJ))+pd{i}((1:3),(4:6));
        Kg((3*NJ-2):(3*NJ),(3*NI-2):(3*NI))=Kg((3*NJ-2):(3*NJ),(3*NI-2):(3*NI))+pd{i}((4:6),(1:3));     
    end
    K=K+Kg;                                                                 % K: Matriz de rigidez global de la estructura 
end

[K2,Fext2,gS,gM,KS,uf]= MATRIZ_EQUAL1(K,Fext,equalDOF);                     % Fext2: Vector de Fuerzas puntuales. gS: Grados Slave. gM: Grados Master. KS: Matriz de los resortes
                                                                            % uf: Vector de conección de los resortes. K2: Matriz de rigidez global simplificada
p2=p;                                                                       % Grados de libertad desconocidos del equaldoff
for i=1:length(gS)
    p2(find(gS(i)==p2))=[];                                                 % Vector con los grados de libertad
end
cro={};                                                                     % Comportamiento completo de los resortes rotacionales
for i=1:size(KS,2)
    FSac{i}=zeros(2,1);
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
ks=100000;                                                                  % Rigidedz del resorte en el nodo de control
K2(t,t)=K2(t,t)+ks;                                                         % Se coloca el resorte en la matriz de rigidez
F2=Fext2;                                                                   % Fuerzas Externas simplificadas por equalDOF
F=F2(p2,1);                                                                 % Patron de fuerzas externas unitarias simplificadas por equalDOF

a=find(p2(:,1)==t);                                                         % Posición del grado de libertad longitudinal del Nodo de Control

%% Datos Iniciales del NSP
cr=cro;                                                                     % Comportamiento de las rotulas del material completo
n=1;                                                                        % Contador del vector de resultados Pv
Pv=[];                                                                      % Vector de resultados Fuerza/Desplazamiento/Subiteraciones/Indicador si el determinante es negativo
Pv(1,:)=[0,0,0];                                                          
m=0;                                                                        % Contador de todas las iteraciones del programa y la matriz de desplazamientos de los nodos
Rotulas={};                                                                 % Vector de posición de Resortes    
rotaciones=[];                                                              % Vector que guarda las rotaciones de todos los resortes
Maplt=[];                                                                   % Vector que guarda los momentos de todos los resortes 
Cposant=ones(size(uf,2),1);Cposact=ones(size(uf,2),1);                      % Vectores que indican el cambio de pendiente en el comportamiento del material,Cposant: Comportamiento anterior, Cposact: Comportamiento actual
diract=ones(size(uf,2),1);                                                  % Indicador si el resorte esta en tensión o compresión
Fr=zeros(size(p2));                                                         % Fuerzas Resistentes
Fa=zeros(size(p2));                                                         % Fuerzas Actuantes
u2=zeros(3*size(XY,1),1);                                                   % Vector de desplazamientos por iteración de todos los grados de libertad del sistema
utot=zeros(size(XY,1)*3,1);                                                 % Vector de desplazamientos acomuados de todos los grados del sistema      
giro=zeros(size(uf,2),1);                                                   % Obtiene las rotaciones de los resortes de la viga y columnas
U=zeros(size(p2));                                                          % Vector de desplazamientos de todos los grados de libertad Principales (Master) del sistema
Ut=0;                                                                       % Desplazamiento en el nodo de control
lambda=0;                                                                   % Coeficiente de relación entre fuerzas externas y resistentes
est_rot=zeros(size(cr,2),1);                                                % Vector que evita que el codigo considere nuevamente la formación de la rótula plastica en el mismo resorte
comp_est_rot=est_rot;                                                       % 
cv_hy={};                                                                   % Comportamiento de cada resorte rotacional de la estructura
Ugeneral=XY(:,1);                                                           % Denominacion de los resortes y desplazamientos durante cada iteración/ guarda cada iteración
NGDL=size(XY,1)*3;                                                          % Variable que cuenta el número de grados de libertad
%Variable de almacenamiento de desplazamientos 
%% Algoritmo del analisis NSP
 while Ut<umax 
    Ut=Ut+dut;                      
    Fs=ks*dut;                                                              % Fuerza resisitente del resorte
    Fa(a,1)=Fa(a,1)+Fs;                                                     % Fuerzas Actuantes en la Estructura
    deltaF=Fa+Fr;                                                           % Vector de fuerzas desbalanceado
    pos1=[];                                                                %  
    w=0;                                                                    % No. iteraciones para igualarse las fuerzas internas con las externas
    while norm(deltaF)>tol                                                  % Se obtiene la euclaniana del vector desbalaceado y se compara con la tolerancia     
        w=w+1;                                                              % Acomulador de iteraciones
        Kpp=K2(p2,p2);                                                      % Matriz de rigidez de los grados de libertad desconocidos del equalDOF (Master)
        Uu=inv(Kpp)*deltaF;                                                 % Vector de desplazamientos debido al desbalance
        Uf=inv(Kpp)*F;                                                      % Vector de desplazamientos debido a las fuerzas unitarias
        Ru=ks*((U(a,1)+Uu(a,1))-Ut);                                        % Fuerzas que absorbe la estructura en el nodo de control
        Rf=ks*(Uf(a,1));                                                    % Fuerzas que actuan en el nodo de control                                         
        dlambda=-(Ru/Rf);                                                   % Factor escalar debido a la relación fuerzas que absorve la estructura y las fuerzas que actuan en la misma con respecto al nodo de control
        lambda=lambda+dlambda;                                              % Variable acomulativa del factor escalar debido a la relación de fuerzas
        Uu=Uu+dlambda*Uf;                                                    
        U=U+Uu;                                                             
        Fa=lambda*F;                                                                                                          
        Fa(a,1)=Fa(a,1)+ks*Ut;                                              
        u2(p2,1)=Uu;                                                        
        for i=size(gM,2):-1:1
            u2(gS(i),1)=u2(gM(i),1);                                        
        end
        utot=utot+u2; 
        fele2={}; pele2={}; fele2x={}; pele2x={};                           
        Fint=zeros(NGDL,1);
        for i=1:size(CONN,1)
            NI=CONN(i,2);                                               
            NJ=CONN(i,3);                                               
            fele2x{i}=kg{i}*[utot(3*NI-2:3*NI);utot(3*NJ-2:3*NJ)];          % Fuerzas internas de los elementos en cordenadas globales con el desface
            pele2x{i}=B{i}*fele2x{i};                                       % Fuerzas internas de los elementos en cordenadas locales con el desface
            pele2{i}=inv(T{i})*pele2x{i};                                   % Fuerzas internas de los elementos en cordenadas locales sin el desface
            fele2{i}=inv(B{i})*pele2{i};                                    % Fuerzas internas de los elementos en cordenadas globales sin el desface
            Fint(3*NI-2,1)=Fint(3*NI-2,1)+fele2x{i}(1,1);                   % Vector de fuerzas internas generales de los elementos
            Fint(3*NI-1,1)=Fint(3*NI-1,1)+fele2x{i}(2,1);
            Fint(3*NI,1)=Fint(3*NI,1)+fele2x{i}(3,1);
            Fint(3*NJ-2,1)=Fint(3*NJ-2,1)+fele2x{i}(4,1);
            Fint(3*NJ-1,1)=Fint(3*NJ-1,1)+fele2x{i}(5,1);
            Fint(3*NJ,1)=Fint(3*NJ,1)+fele2x{i}(6,1);       
        end
        %% Fuerza en los resortes - comportamiento del material 
        for i=1:size(uf,2)
                giro(i)=utot(uf{i}(1,1))-utot(uf{i}(2,1));                  
                dgiro(i)=u2(uf{i}(1,1))-u2(uf{i}(2,1));                     % Incremental del giro de los resortes
                if dgiro(i)>0;
                    diract(i)=1;                                            % Si el giro va hacia la derecha se coloca 1 Tension
                else
                    diract(i)=-1;                                           % Si el giro va hacia la izquierda se coloca -1 Compresion
                end
                if n==1
                    Cposact(i)=Cposact(i)*diract(i);
                    dirant(i)=diract(i);
                    Cposant(i)=Cposact(i);
                end
                O=(((size(cr{i},1))-1)/2)+1;                                % Indica la posición del punto 0 en el comportamiento de los resortes
                if dirant(i)~=diract(i) && abs(Cposant(i))==2
                    if diract(i)==-1
                        ingiro=giro_a(i)-cro{i}(O+1,2);                     % Incremento positivo
                        inMom=(ingiro)*(kr{i}(abs(Cposant(i)),1));          % Incremento negativo si la pendiente disminuye                        
                        Cposact(i)=1;
                    end
                    if diract(i)==1
                        ingiro=giro_a(i)-cro{i}(O-1,2);                     % Incremento negativo
                        inMom=(ingiro)*(kr{i}(abs(Cposant(i)),1));          % Incremento positivo si la pendiente disminuye
                        Cposact(i)=-1;
                    end
                    cr{i}(:,1)=cro{i}(:,1)+ones(size(cr{i},1),1)*inMom;     % cro: Comportamiento del resorte con desface cuando hay un ciclo de descarga
                    cr{i}(:,2)=cro{i}(:,2)+ones(size(cr{i},1),1)*ingiro;    % cr: Comportamiento del resorte.
                end
                
                for j=1:(size(cr{i},1)-1)
                    if giro(i)>cr{i}(j,2) && giro(i)<cr{i}(j+1,2)
                        Cposact(i)=j-O;
                        if Cposact(i)>=0
                           Cposact(i)=Cposact(i)+1;
                        end
                        j=(size(cr{i},1)-1);
                    end
                end
                M=cr{i}(O+(Cposact(i))-(abs(Cposact(i))/(Cposact(i))),1);   % Momentos dependiendo del tramo
                if abs(Cposact(i))>1                                    
                  g=((Cposact(i))/(Cposact(i)))*(giro(i)-cr{i}(O+(Cposact(i))-(abs(Cposact(i))/(Cposact(i))),2));% Giro dependiendo del tramo
                else
                    g=(giro(i)-cr{i}(O+(Cposact(i))-(abs(Cposact(i))/(Cposact(i))),2));
                end
                C=abs(Cposact(i));                                          % Tramo del comportamiento del resorte
                
                kp=kr{i}(C,1);                                              % Pendiente dependiendo tramo del resorte
                Mapl(i)=M+(g)*kp;                                           % Momento aplicado en el resorte
                FS{i}=[Mapl(i);-Mapl(i)];                                   % Momentos generados en el grado de libertad rotacional del resorte            
                
                Fint(uf{i}(1,1),1)=Fint(uf{i}(1,1),1)+FS{i}(1,1);           % Coloca los momentos generados en el vector de fuerzas internas de la estructura
                Fint(uf{i}(2,1),1)=Fint(uf{i}(2,1),1)+FS{i}(2,1);
                
                if Cposact(i)~=Cposant(i)
                    Knant=kr{i}(abs(Cposant(i)),1);                         % Pendiente anterior dependiendo tramo del resorte                          
                    Kn=kr{i}(abs(Cposact(i)),1);                            % Pendiente actual dependiendo tramo del resorte 
                    %Kn=0.00000001;
                    KS{i}=[Kn,-Kn;-Kn,Kn];                                  % Rigidez de los resortes rotacionales
                    K2(uf{i}(1,1),uf{i}(1,1))=K2(uf{i}(1,1),uf{i}(1,1))- Knant+Kn;  % Incorporación de la rigidez de los resortes en la matriz de rigidez de la estructura
                    K2(uf{i}(1,1),uf{i}(2,1))=K2(uf{i}(1,1),uf{i}(2,1))+ Knant-Kn;
                    K2(uf{i}(2,1),uf{i}(1,1))=K2(uf{i}(2,1),uf{i}(1,1))+ Knant-Kn;
                    K2(uf{i}(2,1),uf{i}(2,1))=K2(uf{i}(2,1),uf{i}(2,1))- Knant+Kn;
                    if abs(Cposact(i))==2                                   % Selecciona solo la primera ves que el resorte rotacional se convierte en una rótula plástica
                        idct=1;
                        if est_rot(i)==0;
                            est_rot(i)=idct;
                            pos1=[pos1,i];
                        end   
                    end                       
                end
        end
        %Se suman en los gdl master las fuerzas de los gdl slave            
        for i=1:size(gM,2)
            Fint(gM(i),1)=Fint(gM(i),1)+Fint(gS(i),1); Fint(gS(i),1)=0;
        end
        %Efectos P-Delta-Vector de cargas gravitacionales
        if size(Lp,1)~=0 
            for i=1:size(masterpiso,1)
                if i==1
                NI=(masterpiso(i))*3-2;
                NJ=(masterpiso(i+1))*3-2;
                Fint(NI,1)=Fint(NI,1)+Kg(NI,NI)*utot(NI)+Kg(NI,NJ)*utot(NJ);

                elseif i==size(masterpiso,1)
                NH=(masterpiso(i-1))*3-2;
                NI=(masterpiso(i))*3-2;
                Fint(NI,1)=Fint(NI,1)+Kg(NI,NH)*utot(NH)+Kg(NI,NI)*utot(NI);

                else
                NH=(masterpiso(i-1))*3-2;
                NI=(masterpiso(i))*3-2;
                NJ=(masterpiso(i+1))*3-2;
                Fint(NI,1)=Fint(NI,1)+Kg(NI,NH)*utot(NH)+Kg(NI,NI)*utot(NI)+Kg(NI,NJ)*utot(NJ);
                end
            end
        end
        Fr=-Fint(p2,1);
        Fr(a,1)=Fr(a,1)-ks*U(a,1);
        deltaF=Fa+Fr;
        
        Mapl_a=Mapl;
        giro_a=giro;
        dirant=diract;
        Cposant=Cposact;
    end
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
%    Paux=lambda*F(a,1);
    Paux=lambda;                                                            % Fuerza longitudinal en el nodo de control
 %Suma cada incremento de fuerza
  %Suma cada incremento en el nodo de control 
    n=n+1;Pv(n,:)=[Paux,Ut,w];                                              
    Xx=[];                                                                  % Desplazamiento en x de cada nodo
    Yy=[];                                                                  % Desplazamiento en y de cada nodo
    Zz=[];                                                                  % Rotación de cada nodo
   for i=1:size(XY,1)
        Xx=[Xx;utot((i*3)-2,1)];  
        Yy=[Yy;utot((i*3)-1,1)];
        Zz=[Zz;utot((i*3),1)];      
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
end
