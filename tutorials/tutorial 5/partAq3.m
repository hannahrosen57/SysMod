N = 3;
gq = CreateGQScheme(3);
w = gq.gsw;
x = gq.xipts;
f = x.^5 - 3*x.^4 + 2*x.^3 + x.^2 + 4*x + 8;
S = sum(w.*f);

% find analytical solution to check
syms xa
% define analytical f(x)
fa = xa.^5 - 3*xa.^4 + 2*xa.^3 + xa.^2 + 4*xa + 8;
% find indefinite integral
faInt = int(fa);
% find definite integral
faIntD = int(fa, [-1,1]);
Sa = double(faIntD);

% compare
tol = 1e-4;
assert(abs(S-Sa)<tol)