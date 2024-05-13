 function [CONEX,Mp, Mpl,equalDOF,CONNE,XYE,kr,cr,masterpiso]= rotulas_equaldof1(CONN,XY,PROP,columnasportico,elemrotulas,cm)

CONEX=CONN(:,1:3);
CONEX(:,2:3)=ones(size(CONN,1),2);
% [1 1 columna 
%  1 1] vigas
% 1 existe rotula plastica
% 0 no exite  rotula plastica
Mp=(PROP(:,5).*PROP(:,9));
hmax_ed=find(XY(:,3)==max(XY(:,3)));
piso=[];
%% ----------- MODIFICAR PATO -------------
%for i=1:hmax_ed(1,1);      % MODIFICAR PATO
%    piso(1,i)=XY(i,3);
%end
piso = unique(XY(:,3))';    % Saca alturas del portico
%% ----------------------------------------
lvano_ed=find(XY(:,3)==0);
vano=[];
for i=1:size(lvano_ed,1);
    vano(1,i)=XY(lvano_ed(i,1),2);
end
p=0;                                                 
cnpi=0;
VX=XY(:,2);                                                                 %Obtiene todos los valores de x para la conectividad
VY=XY(:,3);                                                                 %Obtiene todos los calores de y para la conectividad

XYE=[];
CONNE=CONN(:,1:5);
equalDOF=[];
mastervano=[];
Mpl=[];
ncol=columnasportico;
kr={};
cr={};
nodoscol=[];
%% rotulas en columnas
rot_col=elemrotulas(1,:);

if rot_col==[1 0]  %Rotulas en el lado inferior de las columnas
    cnpi=0;
    z=0;
    neq=0;
    p=0;
    
    for i=1:size(vano,2);
        vector=find(VX==vano(1,i)); %Encuentra las posiciones donde  coincide la coordenada x de todos los nodos con la coordenada en x del vano correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi;                                                      
                            %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),XY(vector(j,1),4),XY(vector(j,1),5),XY(vector(j,1),6),XY(vector(j,1),7),XY(vector(j,1),8),XY(vector(j,1),9),0] ;
            nodoscol(j,i)=z;
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),0,0,0,0,0,0,7];
%             nodoaux=z;
            
          if j==1 %Primer nodo 
            master=z-1;
            mastervano(i,1)=master;
          end
          
          if j==(size(vector,1)-1) %Ultimo piso
            z=z+1; XYE(z,:)= [z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),XY(vector(j+1,1),4),XY(vector(j+1,1),5),XY(vector(j+1,1),6),XY(vector(j+1,1),7),XY(vector(j+1,1),8),XY(vector(j+1,1),9),0] ; 
            nodoscol(j+1,i)=z;
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-1;
            CONNE(cnpi,3)=z;
            
            
            %Mp=z.*Fy; k=Mp./(0.005)
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
 
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0 
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end
            krt=[krt;0];
            
            kr{p}=krt;
            cr{p}=cm{cnpi};
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
                                     %Master, Slave, x,y,z
            neq=neq+1; equalDOF(neq,:)=[z-2,z-1,1,1,k];
%             neq=neq+1; equalDOF(neq,:)=[master,z-1,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
                      
           else %Piso intermedio
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z; 
            CONNE(cnpi,3)=z+1;
            %Mp=z.*Fy; k=Mp./(0.005)
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);            
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
 
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end
            krt=[krt;0];
            
            kr{p}=krt;
            cr{p}=cm{cnpi};
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
                                     %Master, Slave, x,y,z
            neq=neq+1; equalDOF(neq,:)=[z-1,z,1,1,k];
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z+1,0,1,0];
           end
                       
        end
    end         
        
elseif rot_col==[0 1] %Rotulas en el lado superior de las columnas
    cnpi=0;
    z=0;
    neq=0;
    p=0;
    for i=1:size(vano,2);                                                       
        vector=find(VX==vano(1,i)); %Encuentra las posiciones donde  coincide la coordenada x de todos los nodos con la coordenada en x del vano correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi; 
                            %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),XY(vector(j,1),4),XY(vector(j,1),5),XY(vector(j,1),6),XY(vector(j,1),7),XY(vector(j,1),8),XY(vector(j,1),9),0];
            nodoscol(j,i)=z;
            z=z+1; XYE(z,:)=[z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),0,0,0,0,0,0,8];
             
          if j==1 %Primer nodo 
            master=z-1;
            mastervano(i,1)=master;
          end
          
          if j==(size(vector,1)-1) %Ultimo nodo
            z=z+1; XYE(z,:)= [z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),XY(vector(j+1,1),4),XY(vector(j+1,1),5),XY(vector(j+1,1),6),XY(vector(j+1,1),7),XY(vector(j+1,1),8),XY(vector(j+1,1),9),0];
            nodoscol(j+1,i)=z;
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-2;
            CONNE(cnpi,3)=z-1;
            
            %Mp=z.*Fy; k=Mp./(0.005)
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
 
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end
            krt=[krt;0];
            
            kr{p}=krt;
            cr{p}=cm{cnpi};
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
            
                                     %Master, Slave, x,y,z  
%             neq=neq+1; equalDOF(neq,:)=[master,z-1,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
             neq=neq+1; equalDOF(neq,:)=[z,z-1,1,1,k];
                      
           else %Nodo intermedio
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-1;
            CONNE(cnpi,3)=z;
            
            %Mp=z.*Fy; k=Mp./(0.005)
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);            
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
  
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end
            krt=[krt;0];
            kr{p}=krt;
            cr{p}=cm{cnpi};
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
                                     %Master, Slave, x,y,z
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z+1,0,1,0];
            neq=neq+1; equalDOF(neq,:)=[z+1,z,1,1,k];
           end         
      end
    end  
    
elseif rot_col==[1 1] %Rotulas en el lado inferior - superior de las columnas
    cnpi=0;
    z=0; 
    neq=0;
    p=0;
    for i=1:size(vano,2);                                                       
        vector=find(VX==vano(1,i)); %Encuentra las posiciones donde  coincide la coordenada x de todos los nodos con la coordenada en x del vano correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi; 
                            %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),XY(vector(j,1),4),XY(vector(j,1),5),XY(vector(j,1),6),XY(vector(j,1),7),XY(vector(j,1),8),XY(vector(j,1),9),0] ;
            nodoscol(j,i)=z;
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),0,0,0,0,0,0,7];
            z=z+1; XYE(z,:)=[z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),0,0,0,0,0,0,8];  
            
          if j==1 %Primer nodo 
            master=z-2;
            mastervano(i,1)=master;
          end
          
          if j==(size(vector,1)-1) %Ultimo nodo
%             z=z+1; XYE(z,:)= [z,XY(vector(j+1,1),2),XY(vector(j+1,1),3)];   
            z=z+1; XYE(z,:)= [z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),XY(vector(j+1,1),4),XY(vector(j+1,1),5),XY(vector(j+1,1),6),XY(vector(j+1,1),7),XY(vector(j+1,1),8),XY(vector(j+1,1),9),0];
            nodoscol(j+1,i)=z;
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-2;
            CONNE(cnpi,3)=z-1;
            
            %Mp=z.*Fy; k=Mp./(0.005)
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
  
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end   
            krt=[krt;0];
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9); kr{p}=krt;cr{p}=cm{cnpi};
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9); kr{p}=krt;cr{p}=cm{cnpi};        
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
                                     %Master, Slave, x,y,z  
%             %neq=neq+1; equalDOF(neq,:)=[master,z-2,0,1,0];
%             %neq=neq+1; equalDOF(neq,:)=[master,z-1,0,1,0];
%             %neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
            
            neq=neq+1; equalDOF(neq,:)=[z-3,z-2,1,1,k];
            neq=neq+1; equalDOF(neq,:)=[z,z-1,1,1,k]; 
            
           else %Nodo intermedio
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-1;
            CONNE(cnpi,3)=z;
            
            %Mp=z.*Fy; k=Mp./(0.005)
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end    
            krt=[krt;0];
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9); kr{p}=krt;cr{p}=cm{cnpi};
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9); kr{p}=krt;cr{p}=cm{cnpi};         
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
                                     %Master, Slave, x,y,z
%             neq=neq+1; equalDOF(neq,:)=[master,z-1,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z+1,0,1,0];
            
            neq=neq+1; equalDOF(neq,:)=[z-2,z-1,1,1,k];
            neq=neq+1; equalDOF(neq,:)=[z+1,z,1,1,k];
           end        

        end
    end
elseif rot_col==[0 0]
    cnpi=0;
    z=0;
    neq=0;
    p=0;
    for i=1:size(vano,2);
        vector=find(VX==vano(1,i)); %Encuentra las posiciones donde  coincide la coordenada x de todos los nodos con la coordenada en x del vano correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi; 
                                                        
                            %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),XY(vector(j,1),4),XY(vector(j,1),5),XY(vector(j,1),6),XY(vector(j,1),7),XY(vector(j,1),8),XY(vector(j,1),9),0] ;
            nodoscol(j,i)=z;
            
          if j==1 %Primer nodo 
            master=z;
            mastervano(i,1)=master;
          end
          
          if j==(size(vector,1)-1) %Ultimo piso
            z=z+1; XYE(z,:)= [z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),XY(vector(j+1,1),4),XY(vector(j+1,1),5),XY(vector(j+1,1),6),XY(vector(j+1,1),7),XY(vector(j+1,1),8),XY(vector(j+1,1),9),0] ; 
            nodoscol(j+1,i)=z;
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-1;
            CONNE(cnpi,3)=z;
            
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
                      
           else %Piso intermedio
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z; 
            CONNE(cnpi,3)=z+1;
            %Mp=z.*Fy; k=Mp./(0.005)
%             neq=neq+1; equalDOF(neq,:)=[master,z+1,0,1,0];
           end
                       
        end
    end
    
elseif rot_col==[2 0]  %Rotulas en el lado inferior de las columnas
    cnpi=0;
    z=0;
    neq=0;
    p=0;
    
    for i=1:size(vano,2);
        vector=find(VX==vano(1,i)); %Encuentra las posiciones donde  coincide la coordenada x de todos los nodos con la coordenada en x del vano correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi;                                                      
                            %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),XY(vector(j,1),4),XY(vector(j,1),5),XY(vector(j,1),6),XY(vector(j,1),7),XY(vector(j,1),8),XY(vector(j,1),9),0] ;
            nodoscol(j,i)=z;
            
%             nodoaux=z;
            
          if j==1 %Primer nodo
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),0,0,0,0,0,0,7];
            master=z-1;
            mastervano(i,1)=master;
            
            %Mp=z.*Fy; k=Mp./(0.005)
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);            
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
 
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end
            krt=[krt;0];
            
            kr{p}=krt;
            cr{p}=cm{cnpi};
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
                                     %Master, Slave, x,y,z
            neq=neq+1; equalDOF(neq,:)=[z-1,z,1,1,k];
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z+1,0,1,0];  
          end
          
          if j==(size(vector,1)-1) %Ultimo piso
            z=z+1; XYE(z,:)= [z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),XY(vector(j+1,1),4),XY(vector(j+1,1),5),XY(vector(j+1,1),6),XY(vector(j+1,1),7),XY(vector(j+1,1),8),XY(vector(j+1,1),9),0] ; 
            nodoscol(j+1,i)=z;
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-1;
            CONNE(cnpi,3)=z;
%             neq=neq+1; equalDOF(neq,:)=[master,z,0,1,0];
                     
           else %Piso intermedio
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z; 
            CONNE(cnpi,3)=z+1;
            %Mp=z.*Fy; k=Mp./(0.005)
%             neq=neq+1; equalDOF(neq,:)=[master,z+1,0,1,0];
           end
                       
        end
    end    
   
end
zf=z;
cnpif=cnpi;


%% rotulas en vigas
nelem=size(CONN,1);
nvigas=nelem-ncol; 

rot_vigas=elemrotulas(2,:);  
if rot_vigas==[1 0] %Rotulas lado izquierdo
    cnpi=cnpif;
    z=zf;
    for i=2:size(piso,2);                                                       
        vector=find(VY==piso(1,i)); %Encuentra las posiciones donde  coincide la coordenada y de todos los nodos con la coordenada en y del piso correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi; 
            
            NI=nodoscol(i,j);
            NJ=nodoscol(i,j+1);
            
            if j==1 %Primer nodo    
                master=NI;
                masterpiso(i,1)=master;
            end            
                          %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),0,0,0,0,0,0,2];
            
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z;
            CONNE(cnpi,3)=NJ;
                                 
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end 
            krt=[krt;0];
            kr{p}=krt;
            cr{p}=cm{cnpi};
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
            
%             neq=neq+1; equalDOF(neq,:)=[master,z,1,0,0]; 
%             neq=neq+1; equalDOF(neq,:)=[master,NJ,1,0,0]; 
            
%             neq=neq+1; equalDOF(neq,:)=[mastervano(j,1),z,0,1,0];
            
            neq=neq+1; equalDOF(neq,:)=[NI,z,1,1,k];            

        end
    end  
elseif rot_vigas==[0 1] %Rotulas lado derecho
        cnpi=cnpif;
        z=zf;
        for i=2:size(piso,2);                                                       
            vector=find(VY==piso(1,i)); %Encuentra las posiciones donde  coincide la coordenada y de todos los nodos con la coordenada en y del piso correspondiente
            for j=1:size(vector,1)-1;
                cnpi=1+cnpi; 
                NI=nodoscol(i,j);
                NJ=nodoscol(i,j+1);
                
                if j==1 %Primer nodo    
                    master=NI;
                    masterpiso(i,1)=master;
                end

                              %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
                z=z+1; XYE(z,:)=[z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),0,0,0,0,0,0,3];              
                
                %Matriz de conectividad
                CONNE(cnpi,1)=cnpi;
                CONNE(cnpi,2)=NI;
                CONNE(cnpi,3)=z;
                
                p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);            
                cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
                krt=[];
                for r=1:(size(cm{cnpi},1)-1)
                    if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                        krt=[krt;0];
                    else
                    krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                    end
                end
                krt=[krt;0];
                kr{p}=krt;
                cr{p}=cm{cnpi};
                k=Mp(cnpi,1)./(cm{cnpi}(2,2));

%                 neq=neq+1; equalDOF(neq,:)=[master,z,1,0,0]; 
%                 neq=neq+1; equalDOF(neq,:)=[master,NJ,1,0,0]; 

%                 neq=neq+1; equalDOF(neq,:)=[mastervano(j+1,1),z,0,1,0];

                neq=neq+1; equalDOF(neq,:)=[NJ,z,1,1,k];
                             
            end
        end 
    
elseif rot_vigas==[1 1] %Rotulas ambos lados
    cnpi=cnpif;
    z=zf;
    for i=2:size(piso,2);                                                       
        vector=find(VY==piso(1,i)); %Encuentra las posiciones donde  coincide la coordenada y de todos los nodos con la coordenada en y del piso correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi; 
             NI=nodoscol(i,j);
            NJ=nodoscol(i,j+1);
            
            if j==1 %Primer nodo    
                master=NI;
                masterpiso(i,1)=master;
            end
            
                          %#deNodo,coordenada en x(fila=(posicion donde coincde con la misma coordenada), columna)
            z=z+1; XYE(z,:)=[z,XY(vector(j,1),2),XY(vector(j,1),3),0,0,0,0,0,0,2];
            z=z+1; XYE(z,:)=[z,XY(vector(j+1,1),2),XY(vector(j+1,1),3),0,0,0,0,0,0,3];
          
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=z-1;
            CONNE(cnpi,3)=z;
            
            cm{cnpi}(:,1)=cm{cnpi}(:,1).*Mp(cnpi,1);
            krt=[];
            for r=1:(size(cm{cnpi},1)-1)
                if (cm{cnpi}(r+1,1)-cm{cnpi}(r,1))==0
                    krt=[krt;0];
                else
                krt=[krt;(cm{cnpi}(r+1,1)-cm{cnpi}(r,1))./(cm{cnpi}(r+1,2)-cm{cnpi}(r,2))];
                end
            end   
            krt=[krt;0];
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);kr{p}=krt;cr{p}=cm{cnpi};
            p=p+1; Mpl(p,1)=PROP(cnpi,5).*PROP(cnpi,9);kr{p}=krt;cr{p}=cm{cnpi};       
            k=Mp(cnpi,1)./(cm{cnpi}(2,2));
            
%             neq=neq+1; equalDOF(neq,:)=[master,z-1,1,0,0];
%             neq=neq+1; equalDOF(neq,:)=[master,z,1,0,0]; 
%             neq=neq+1; equalDOF(neq,:)=[master,NJ,1,0,0]; 
            
%             neq=neq+1; equalDOF(neq,:)=[mastervano(j,1),z-1,0,1,0];

%             neq=neq+1; equalDOF(neq,:)=[mastervano(j+1,1),z,0,1,0];
            
            neq=neq+1; equalDOF(neq,:)=[NI,z-1,1,1,k];
            neq=neq+1; equalDOF(neq,:)=[NJ,z,1,1,k];    
        end
    end

elseif rot_vigas==[0 0] %Sin rotulas en vigas
    cnpi=cnpif;
    z=zf;
    for i=2:size(piso,2);                                                       
        vector=find(VY==piso(1,i)); %Encuentra las posiciones donde  coincide la coordenada y de todos los nodos con la coordenada en y del piso correspondiente
        for j=1:size(vector,1)-1;
            cnpi=1+cnpi; 
            NI=nodoscol(i,j);
            NJ=nodoscol(i,j+1); 
            if j==1 %Primer nodo    
                master=NI;
                masterpiso(i,1)=master;
            end
            CONNE(cnpi,1)=cnpi;
            CONNE(cnpi,2)=NI;
            CONNE(cnpi,3)=NJ;
%             neq=neq+1; equalDOF(neq,:)=[master,NJ,1,0,0]; 
  
        end
    end     
end

end