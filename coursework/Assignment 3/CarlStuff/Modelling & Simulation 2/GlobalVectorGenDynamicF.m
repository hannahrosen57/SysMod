function [GlobalVector] = GlobalVectorGenDynamicF(msh,QTL)
%GLOBALVECTOR Function for deriving the Global Source Vector
vector = zeros(1,msh.ngn);
for i = 1:msh.ngn-1
   localVector(1) = 1 + (8/3)*msh.elem(i).x(1) + (4/3)*msh.elem(i).x(2);
   localVector(2) = 1 + (4/3)*msh.elem(i).x(1) + (8/3)*msh.elem(i).x(2);
   vector(i:i+1) =  vector(i:i+1) + QTL*msh.elem(i).J*localVector;
end
GlobalVector = vector';
end