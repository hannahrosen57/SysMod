%% Test 1: Sum of Angles
% Test that all angles add up to 180 degrees.
[A,B,C] = rightTri(7,9);
assert(A+B+C == 180)

%% Test 2: Isosceles Triangles
% Test that if sides a and b are equal the angles A and B are also equal.
[A,B,~] = rightTri(4,4);
assert(A == B)

%% Test 3: 3-4-5 Triangle
% Test that if side a is 3 and side b is 4, then side c is 5.
[A,~,~] = rightTri(3,4);
c = 3/sind(A);
assert(isequal(c,5))

%% Test 4: 30-60-90 Triangle
% Test that if side a is 1 and side be is sqrt(3) then the angles A and B
% are 30 and 60 degrees, respectively.
tol = 1e-14;
[A,B,C] = rightTri(1,sqrt(3));
assert(abs(A-30) <= tol)
assert(abs(B-60) <= tol)
