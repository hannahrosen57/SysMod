function L = LaplaceElemMatrix(D,eN,mesh)
% function to calculate local element matrix for diffusion term

x = mesh.elem(eN).x;
J = mesh.elem(eN).J;
dXiX = 2/(x(2)-x(1));
dPhiXi = [-1/2 1/2];

if isnumeric(D)
    L = zeros(2,2);
else
    L = sym(zeros(2,2));        % allows for symbolic D if desired
end

for n = 1:2
    for m = 1:2
        L(n,m) = 2*D* dPhiXi(n)*dXiX * dPhiXi(m)*dXiX * J;
    end
end

end