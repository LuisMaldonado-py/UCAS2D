function [K2,Fext2,gS,gM,KS,uf]= MATRIZ_EQUAL1(K,Fext,equalDOF)
K2=K; gM=[]; gS=[]; Fext2=Fext;
KS={};
j=0;
for i=1:size(equalDOF(:,1))
    if equalDOF(i,3)==1
        K2(:,3*equalDOF(i,1)-2)=K2(:,3*equalDOF(i,1)-2)+K2(:,3*equalDOF(i,2)-2); K2(:,3*equalDOF(i,2)-2)=0;
        K2(3*equalDOF(i,1)-2,:)=K2(3*equalDOF(i,1)-2,:)+K2(3*equalDOF(i,2)-2,:); K2(3*equalDOF(i,2)-2,:)=0;
        gM=[gM,3*equalDOF(i,1)-2]; gS=[gS,3*equalDOF(i,2)-2];
        Fext2(3*equalDOF(i,1)-2,1)=Fext2(3*equalDOF(i,1)-2,1)+Fext2(3*equalDOF(i,2)-2,1);     
    end
   
    if equalDOF(i,4)==1
        K2(:,3*equalDOF(i,1)-1)=K2(:,3*equalDOF(i,1)-1)+K2(:,3*equalDOF(i,2)-1); K2(:,3*equalDOF(i,2)-1)=0;
        K2(3*equalDOF(i,1)-1,:)=K2(3*equalDOF(i,1)-1,:)+K2(3*equalDOF(i,2)-1,:); K2(3*equalDOF(i,2)-1,:)=0;
        gM=[gM,3*equalDOF(i,1)-1]; gS=[gS,3*equalDOF(i,2)-1];
        Fext2(3*equalDOF(i,1)-1,1)=Fext2(3*equalDOF(i,1)-1,1)+Fext2(3*equalDOF(i,2)-1,1);
    end

    if equalDOF(i,5)==1
        K2(:,3*equalDOF(i,1))=K2(:,3*equalDOF(i,1))+K2(:,3*equalDOF(i,2)); K2(:,3*equalDOF(i,2))=0;
        K2(3*equalDOF(i,1),:)=K2(3*equalDOF(i,1),:)+K2(3*equalDOF(i,2),:); K2(3*equalDOF(i,2),:)=0;
        gM=[gM,3*equalDOF(i,1)]; gS=[gS,3*equalDOF(i,2)];
        Fext2(3*equalDOF(i,1),1)=Fext2(3*equalDOF(i,1),1)+Fext2(3*equalDOF(i,2),1);
    end
    %ks
%     if 0<equalDOF(i,5)<1
  
    if equalDOF(i,5)~=1 & equalDOF(i,5)~=0
        j=j+1;
        K2(3*equalDOF(i,1),3*equalDOF(i,1))=K2(3*equalDOF(i,1),3*equalDOF(i,1))+ equalDOF(i,5);
        K2(3*equalDOF(i,1),3*equalDOF(i,2))=K2(3*equalDOF(i,1),3*equalDOF(i,2))- equalDOF(i,5);
        K2(3*equalDOF(i,2),3*equalDOF(i,1))=K2(3*equalDOF(i,2),3*equalDOF(i,1))- equalDOF(i,5);
        K2(3*equalDOF(i,2),3*equalDOF(i,2))=K2(3*equalDOF(i,2),3*equalDOF(i,2))+ equalDOF(i,5);
        KS{j}=[equalDOF(i,5),-equalDOF(i,5);-equalDOF(i,5),equalDOF(i,5)];
        %      gdlMaster gdlSlave k
        uf{j}=[3*equalDOF(i,1);3*equalDOF(i,2);equalDOF(i,5)];
    end
end
end