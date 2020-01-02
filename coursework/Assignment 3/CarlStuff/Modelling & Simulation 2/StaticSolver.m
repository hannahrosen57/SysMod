function [c] = StaticSolver(xmin,xmax,ne,D,lambda,f,CaseBC,BC1,BC2)
%StaticSolver: This Function returns the concentration vector 'c' that
%describes concentration over a specified distance. The inputs are as
%follows:
%xmin - Minimum distance, x-max - Maximum distance, ne - Number of elements
%D - Diffusion co-efficient
%lambda - Linear reaction co-efficient
%f - Source/sink co-efficient
%CaseBC - Descriptor of the boundary conditions (Neumann or Dirichlet),
%must be 'DD', 'ND', or 'DN'
%BC1 - Boundary Condition 1, BC2 - Boundary Condition 2

%First generate the mesh:
msh = OneDimLinearMeshGen(xmin,xmax,ne);

%Get the Global Matrix (sum of Reaction and Diffusion terms) and the Source
%vector
GlobalMatrix = DiffusionMatrixGen(msh,D,lambda);
GlobalVector = SourceVectorGen(msh,f);

%Use a switch/case to apply boundary conditions as appropiate.
switch CaseBC
    case 'NN'
        error('There must be at least one Dirichlet BC')
    case 'DD'
        GlobalMatrix(1,1:end) = [1, zeros(1,msh.ngn-1)];
        GlobalVector(1) = BC1;
       
        GlobalMatrix(end,1:end) = [zeros(1,msh.ngn-1),1];
        GlobalVector(end) = BC2;
        
    case 'ND'
        GlobalVector(1) = GlobalVector(1) - (D*BC1);
        
        GlobalMatrix(end,1:end) = [zeros(1,msh.ngn-1),1];
        GlobalVector(end) = BC2;        
       
    case 'DN'
        GlobalMatrix(1,1:end) = [1, zeros(1,msh.ngn-1)];
        GlobalVector(1) = BC1;
        
        GlobalVector(end) = GlobalVector(end) + (D*BC2);
        
    otherwise
        error('Boundary Condition Case must be of the form ''DD'', ''DN'' or ''ND''.')        
end

%Return c as a vector
c = GlobalMatrix\GlobalVector;
end

