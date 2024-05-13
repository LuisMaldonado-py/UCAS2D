function [K]= MATRIZ_K(XY,CONN,kg,g)
NGDL=size(XY,1)*g;
K=zeros(NGDL,NGDL);
if g==1;
    n=0;
    
elseif g==2;
    n=1;
elseif g==3;
    n=2;
    
end
for i=1:size(CONN,1)
    NI      =   find(CONN(i,2)==XY(:,1));                                  
	NJ      =   find(CONN(i,3)==XY(:,1));
   
    K((g*NI-n):(g*NI),(g*NI-n):(g*NI))=K((g*NI-n):(g*NI),(g*NI-n):(g*NI))+kg{i}((1:g),(1:g));
    K((g*NJ-n):(g*NJ),(g*NJ-n):(g*NJ))=K((g*NJ-n):(g*NJ),(g*NJ-n):(g*NJ))+kg{i}((g+1:2*g),(g+1:2*g));
    K((g*NI-n):(g*NI),(g*NJ-n):(g*NJ))=K((g*NI-n):(g*NI),(g*NJ-n):(g*NJ))+kg{i}((1:g),(g+1:2*g));
    K((g*NJ-n):(g*NJ),(g*NI-n):(g*NI))=K((g*NJ-n):(g*NJ),(g*NI-n):(g*NI))+kg{i}((g+1:2*g),(1:g));
     
end

end