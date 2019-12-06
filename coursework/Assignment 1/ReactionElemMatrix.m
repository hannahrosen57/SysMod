function R = ReactionElemMatrix(lambda,eN,mesh)
% function to calculate local element matrix for diffusion term

J = mesh.elem(eN).J;
Int = [2/3 1/3; 1/3 2/3];

R = J * lambda * Int;

end