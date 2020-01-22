clearvars

nl = true;          % non-linear toggle

%% basic parameters
m1 = 2600;           % body mass
m2 = 20;            % wheel mass
ks = 15e4;           % suspension spring stiffness
cs_c = 15000;        % suspension damping parameter (compression)
ktc = 35e4;         % tyre spring parameter (compression)
g = 9.81;           % gravity

%% half car parameters
a = 1.14;
b = 1.71;
I = 3380;
v_kph = 60;
v = v_kph * 1000/60^2;
IC = 0; % initial condition

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

s2_predicted = -(m1+2*m2) * g / 2*ktc;       % wheel displacement
s1_predicted = -m1*g/2*ks + s2_predicted; % body displacement

%[fbn,~] = freq(m1+m2,ktc,1);
[fbn,fbd] = freq(m1,2*ks,2*cs_c);

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
