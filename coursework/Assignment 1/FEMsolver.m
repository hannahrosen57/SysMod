function [x,c] = FEMsolver(xmin,xmax,Ne,D,lambda,F,BCs)
% FEM solver. 

% initialise mesh
mesh = OneDimLinearMeshGen(xmin, xmax, Ne);

% create and initialise global matrix and vector
M = zeros(mesh.ngn, mesh.ngn);
f = zeros(mesh.ngn,1);

%loop over elements
for i = 1:Ne
    % calculate local element matrices and add to global matrix
    L = LaplaceElemMatrix(D,i,mesh);
    R = ReactionElemMatrix(lambda,i,mesh);
    M(i:i+1, i:i+1) = M(i:i+1, i:i+1) + L - R;
    % calculate local element vectors and add to global vector
    f(i:i+1) = f(i:i+1) + ElemVector(F,i,mesh);
end

% apply boundary conditions

% first, neumann
if ~isnan(BCs(3))   % at xmin
   f(1) = f(1) - BCs(3);
end
if ~isnan(BCs(4))   % at xmax
    f(mesh.ngn) = f(mesh.ngn) + BCs(4);
end

% then, dirichlet
if ~isnan(BCs(1))   % at xmin
   M(1,:) = 0;
   M(1,1) = 1;
   f(1) = BCs(1);
end
if ~isnan(BCs(2))   % at xmax
   M(mesh.ngn,:) = 0;
   M(mesh.ngn,mesh.ngn) = 1;
   f(mesh.ngn) = BCs(2);
end

% solve the final matrix system
c = M \ f;
x = mesh.nvec';
% plot the solution vector

end