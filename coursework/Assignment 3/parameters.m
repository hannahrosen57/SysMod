clearvars
m1 = 250;                           % body mass
m2 = 20;                            % wheel mass
ks = 2e4; kstiff = ks; x0 = 0.2;    % suspension spring parameters
cs_c = 100000; cs_e = cs_c;         % suspension damper parameters
ktc = 14e4;                         % tyre spring parameter (compression)
kte = ktc;                          % tyre spring parameter (extension)
g = 9.81;                           % gravity

% w = sqrt(kt/m2);
% f = w/(2*pi);

s2_predicted = -(m1+m2) * g / ktc;       % wheel displacement
s1_predicted = -m1*g/ks + s2_predicted; % body displacement

fb = sqrt(ktc/(m1+m2))/(2*pi);
fc = sqrt(ks/m1)/(2*pi);
