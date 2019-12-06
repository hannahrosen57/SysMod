function [S] = sumSqrs(x)
    N = length(x);
    S = sum((x.^2)/N);
end