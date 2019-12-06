%% Test 1: test symmetry of the matrix
% Test that this matrix is symmetric
tol = 1e-14;
lambda = 2; % reaction coefficient
eID=1; % element ID
msh = OneDimLinearMeshGen(0,1,10);

elemat = ReactionElemMatrix(lambda,eID,msh);

assert(abs(elemat(1,2) - elemat(2,1)) <= tol)

%% Test 2: test 2 different elements of the same size produce same matrix
% % Test that for two elements of an equispaced mesh, as described in the
% % lectures, the element matrices calculated are the same
tol = 1e-14;
lambda = 5; % reaction coefficient
eID=1; % element ID
msh = OneDimLinearMeshGen(0,1,10);

elemat1 = ReactionElemMatrix(lambda,eID,msh);

eID=2; % element ID

elemat2 = ReactionElemMatrix(lambda,eID,msh);

diff = elemat1 - elemat2;
diffnorm = sum(sum(diff.*diff));
assert(abs(diffnorm) <= tol)

%% Test 3: test that one matrix is evaluted correctly
% % Test that element 1 of the three element mesh problem described in the tutorials
% % the element matrix is evaluated correctly
tol = 1e-14;
lambda = 1; % reaction coefficient
eID=1; % reaction ID
msh = OneDimLinearMeshGen(0,1,3);

elemat1 = ReactionElemMatrix(lambda,eID,msh);

elemat2 = [ 1/9 1/18 ; 1/18 1/9];
diff = elemat1 - elemat2; % calculate the difference between the two matrices
diffnorm = sum(sum(diff.*diff)); % calculates the total squared error between the matrices
assert(abs(diffnorm) <= tol)