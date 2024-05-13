function [kg,B,T,R]= MATRICES_K(rb,re,L,E,I,a,db,de,v,A,As)

B={};
kl={};
kg={};

for i=1:size(a)
 
    if rb(i)==1
        rb(i)=1;
    elseif rb(i)==0
        rb(i)=0;
    else
        kb(i)=rb(i);
        rb(i)=(kb(i)*L(i))/(E(i)*I(i)+kb(i)*L(i));
    end
    
    if re(i)==1
        re(i)=1;
    elseif re(i)==0
        re(i)=0;
    else
        ke(i)=re(i);
        re(i)=(ke(i)*L(i))/(E(i)*I(i)+ke(i)*L(i));
    end
    
    R(i)=12-8*rb(i)-8*re(i)+5*rb(i)*re(i);
    
    B{i}=[cos(a(i)),sin(a(i)),0,0,0,0
         -sin(a(i)),cos(a(i)),0,0,0,0
          0,0,1,0,0,0
          0,0,0,cos(a(i)),sin(a(i)),0
          0,0,0,-sin(a(i)),cos(a(i)),0
          0,0,0,0,0,1];
    T{i}=[1,0,0,0,0,0
          0,1,0,0,0,0
          0,(db(i)),1,0,0,0
          0,0,0,1,0,0
          0,0,0,0,1,0
          0,0,0,0,-(de(i)),1];
    G(i)=E(i)/(2*(1+v(i)));
    Bs(i)=(12*E(i)*I(i))/(G(i)*As(i)*(L(i)^2));
  
    klo{i}(1,:)=((E(i)*I(i))/((L(i)^3)*R(i)*(1+Bs(i))))*[(A(i)*R(i)*(L(i)^2)*(1+Bs(i)))/I(i),0,0,-(A(i)*R(i)*(L(i)^2)*(1+Bs(i)))/I(i),0,0];
    klo{i}(2,:)=((E(i)*I(i))/((L(i)^3)*R(i)*(1+Bs(i))))*[0,12*(rb(i)+re(i)-rb(i)*re(i)),6*L(i)*rb(i)*(2-re(i)),0,-12*(rb(i)+re(i)-rb(i)*re(i)),6*L(i)*re(i)*(2-rb(i))];
    klo{i}(3,:)=((E(i)*I(i))/((L(i)^3)*R(i)*(1+Bs(i))))*[0,6*L(i)*rb(i)*(2-re(i)),(L(i)^2)*(4+Bs(i))*rb(i)*(3-2*re(i)),0,-6*L(i)*rb(i)*(2-re(i)),(L(i)^2)*(2-Bs(i))*(rb(i)*re(i))];
    klo{i}(4,:)=((E(i)*I(i))/((L(i)^3)*R(i)*(1+Bs(i))))*[-(A(i)*R(i)*(L(i)^2)*(1+Bs(i)))/I(i),0,0,(A(i)*R(i)*(L(i)^2)*(1+Bs(i)))/I(i),0,0];
    klo{i}(5,:)=((E(i)*I(i))/((L(i)^3)*R(i)*(1+Bs(i))))*[0,-12*(rb(i)+re(i)-rb(i)*re(i)),-6*L(i)*rb(i)*(2-re(i)),0,12*(rb(i)+re(i)-rb(i)*re(i)),-6*L(i)*re(i)*(2-rb(i))];
    klo{i}(6,:)=((E(i)*I(i))/((L(i)^3)*R(i)*(1+Bs(i))))*[0,6*L(i)*re(i)*(2-rb(i)),(L(i)^2)*(2-Bs(i))*(rb(i)*re(i)),0,-6*L(i)*re(i)*(2-rb(i)),(L(i)^2)*(4+Bs(i))*re(i)*(3-2*rb(i))];
    kl{i}=T{i}*klo{i}*T{i}.';
    kg{i}=(B{i})'*kl{i}*B{i};
end

end