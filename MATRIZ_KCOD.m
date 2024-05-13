function [K]= MATRIZ_KCOD(XY,CONN,kg)
NGDL=size(XY,1)*3;
K=zeros(NGDL,NGDL);
for i=1:size(CONN,1)
    NI      =   find(CONN(i,2)==XY(:,1));                                  
	NJ      =   find(CONN(i,3)==XY(:,1));
   
    K((3*NI-2):(3*NI),(3*NI-2):(3*NI))=K((3*NI-2):(3*NI),(3*NI-2):(3*NI))+kg{i}((1:3),(1:3));
    K((3*NJ-2):(3*NJ),(3*NJ-2):(3*NJ))=K((3*NJ-2):(3*NJ),(3*NJ-2):(3*NJ))+kg{i}((4:6),(4:6));
    K((3*NI-2):(3*NI),(3*NJ-2):(3*NJ))=K((3*NI-2):(3*NI),(3*NJ-2):(3*NJ))+kg{i}((1:3),(4:6));
    K((3*NJ-2):(3*NJ),(3*NI-2):(3*NI))=K((3*NJ-2):(3*NJ),(3*NI-2):(3*NI))+kg{i}((4:6),(1:3));
     
end

end