clearvars

nl = false;          % non-linear toggle

%% basic parameters
m1 = 250;           % body mass
m2 = 20;            % wheel mass
ks = 2e4;           % suspension spring stiffness
cs_c = 1000;        % suspension damping parameter (compression)
ktc = 14e4;         % tyre spring parameter (compression)
g = 9.81;           % gravity

%% non-linear parameters
if nl           % if non-linear is switched on...
    kstiff = 20*ks; % suspension shock absorber (spring stiffening)
    x0 = 0.2;       % spring stiffening x value
    cs_e = 2*cs_c;  % suspension damping parameter (extension)
    kte = 0;        % tyre spring parameter (extension)
else            % otherwise...
    kstiff = ks;    % suspension shock absorber (spring stiffening)
    x0 = 0.2;       % spring stiffening x value
    cs_e = cs_c;    % suspension damping parameter (extension)
    kte = ktc;      % tyre spring parameter (extension)
end

%% calculating expected values for verification tests
[fan,~] = freq(m2,ktc,1);

s2_predicted = -(m1+m2) * g / ktc;       % wheel displacement
s1_predicted = -m1*g/ks + s2_predicted; % body displacement

[fbn,~] = freq(m1+m2,ktc,1);
[fcn,fcd] = freq(m1,ks,cs_c);

function [fn,fd] = freq(m,k,c)
% function to find natural frequency and damped frequency from m, k, and c

wn = sqrt(k/m);         % natural frequency
zeta = c/(2*sqrt(k*m)); % damping coefficient

if zeta > 1
    wd = wn * sqrt(zeta^2 - 1);
elseif zeta == 1
    wd = 0;
elseif zeta < 1
    wd = wn * sqrt(1-zeta^2);
end

fn = wn/(2*pi);
fd = wd/(2*pi);

end
