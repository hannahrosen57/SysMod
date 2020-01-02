function [C] = TransientSolver(xmin,xmax,ne,dt,tmax, D,lambda,f,Ct0, DirichletBC, NeumannBC, theta)
%This Function returns the concentration vector 'c' that
%describes concentration over a specified distance. The inputs are as
%follows:
%xmin - Minimum distance, x-max - Maximum distance, ne - Number of elements
%dt - time step
%tmax maximum time (tmin is always 0)
%D - Diffusion co-efficient
%lambda - Linear reaction co-efficient
%f - Source/sink co-efficient
%Ct0 - Initial C vector at time 0.
%DirichletBC - A vector of Dirichlet BCs with true/false to indicate if
%              each term should be used
%                [true/false, c(xmin,t), true/false, c(xmax, t)]
%NeumannBC - A vector of Neumann BCs with true/false to indicate if
%              each term should be used
%                [true/false, d/dt c(xmin, t), true/false, d/dt c(xmax,t)]

%Check BCs are appropiate
if DirichletBC(1)+DirichletBC(3)+NeumannBC(1)+ NeumannBC(3) < 2
    error('You must specify at least two Boundary Conditions')
end

%Use Linear Legrange because I am a failure.

%First generate the mesh:
msh = OneDimLinearMeshGen(xmin,xmax,ne);

% Number of elements = msh.ne,
% Number of nodes = msh.ngn
timesteps = tmax/dt;

%Initialise Matrices:
M = zeros(msh.ngn,msh.ngn);
K = M;
C = zeros(msh.ngn, timesteps);

%C is the 'Global Vector'
C(:,1) = Ct0

%Loop over time:
for t=1:timesteps-1
    for eID = 1:msh.ne
        M(eID:eID+1,eID:eID+1) = localMassMatrix(msh.elem(eID).J);       
    end
    K = DiffusionMatrixGen(msh, D, lambda);
    GlobalMatrix = M + theta*dt*K;
    
    %Sources are constant so Fn = Fn+1
    GlobalVector = (M-(1-theta)*dt*K)*C(:,t) + dt*SourceVectorGen(msh,f);
    
    %Apply Dirichlet BCs
    if DirichletBC(1) == true
        GlobalMatrix(1,:) = zeros;
        GlobalMatrix(1,1) = 1;
        GlobalVector(1) = DirichletBC(2);
    end
    
    if DirichletBC(3) == true
        GlobalMatrix(end,:) = zeros;
        GlobalMatrix(end,end) = 1;
        GlobalVector(end) = DirichletBC(4);
    end
    
    if NeumannBC(1) == true
        GlobalVector(1) = -D*NeumannBC(2);
    end
    
    if NeumannBC(3) == true
        GlobalVector(end) = D*NeumannBC(4);
    end
    
    %Final division.
    C(:,t+1) = GlobalMatrix\GlobalVector;
    
end



end
function [localmat] = localMassMatrix(J)
    localmat = J.* [2/3 , 1/3;
                     1/3, 2/3];
end