% xmin and xmax values
xmin = 0;
xmax = 1;
ne = 10; %number of nodes

dt=0.001; %time step
tmax = 1; %tmax - 1 sec
timesteps = tmax/dt
lambda = 0; %lambda ignored
D = 1; %it's only the one D actually 
Ct0 = zeros(1,11)

dx = (xmax-xmin)/ne;
x = xmin:dx:xmax;


theta = 0.5; %Solver Method: backward 1, forward 0, crank-nicholson 0.5.

%boundary conditions 0 at startC, the dirichlet boundary at x min and max
DirichletBC = [true,0,true, 1];
NeumannBC = [false, 0, false, 0];

%Run model as chosen
C = TransientSolver(xmin,xmax,ne, dt, tmax, D, 0, 0, Ct0, DirichletBC, NeumannBC,theta);

%Run for second method to compare
theta = 1; %backward 1, forward 0, crank 0.5
C2 = TransientSolver(xmin,xmax,ne, dt, tmax, D, 0, 0, Ct0, DirichletBC, NeumannBC,theta);


%get time vector for plotting
time = zeros(timesteps,1);
for t =1:timesteps
    time(t) = t*dt;
end


figure(1);
% Plotting C against x at different times
plot(x,C(:,timesteps/20),x,C(:,timesteps/10),x,C(:,3*timesteps/10),x,C(:,timesteps));
legend ('Location', 'southeast', 't = 0.05s','t = 0.1s', 't = 0.3s', 't = 1.0s');
title('C against X for various times(t/s).');
xlabel('x/m');
ylabel('C (x,t)');


%Get results at test poitimesteps 0.8
testPoint = 0.8;
testElem = find(x==testPoint);
%Get analytical C results
Ca = zeros(11,1);
for t = 1:timesteps
    Ca(t) = TransientAnalyticSoln(testPoint,time(t));
end


figure(2);
R6 = C(testElem,:);
% Plotting C vs time at testpoint
plot(time, Ca, time, C(testElem,:), time, C2(testElem,:));
legend ('Analytical C','Crank-Nicolson', 'Backwards Euler', 'Location', 'southeast');
title('Comparison of Analytical and Finite Element solutions');
xlabel('Time/s');
ylabel('C(0.8,t)');
