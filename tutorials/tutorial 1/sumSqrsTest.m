%% Test 1: Six Positive Integers
x = [1 2 3 4 5 6];
S = sumSqrs(x);
dec = 4;
S = round(S*10^dec)/10^dec;
assert(S == 15.1667)

%% Test 2: 6 Integers, some negative
x = [-3 -2 -1 4 5 6];
S = sumSqrs(x);
S_pos = sumSqrs(abs(x));
assert(S == S_pos);

%% Test 3: Different N values
x1 = [1 2 3 4];
x2 = [5 6];

S1 = sumSqrs(x1);
S2 = sumSqrs(x2);

S12 = sumSqrs([x1 x2]);
S1S2 = (S1*length(x1) + S2*length(x2))/length([x1 x2]);

tol = 1e-14;
assert(abs(S12-S1S2) <= tol);