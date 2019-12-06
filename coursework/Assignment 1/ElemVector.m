function f = ElemVector(F,eN,mesh)
% function to calculate local element matrix for diffusion term

x0 = mesh.elem(eN).x(1);
x1 = mesh.elem(eN).x(2);
J = mesh.elem(eN).J;

switch length(F)
    case 1
        f = [F;F] * J;
    case 2
        A = [F(1);F(1)] * J;
        B = [(2*x0 + x1)*F(2)/3 ; (x0 + 2*x1)*F(2)/3] * J;
        f = A + B;
    otherwise
        error('Invalid source term')
end

end