%% Analytical Test 1ci: Laplace's Equation with two Dirichlet BCs
xmin = 0;
xmax = 1;
Ne = 4;
D = 1;
lambda = 0;
F = 0;
BCs = [2 0 NaN NaN]; % dirichlet boundary conditions

[x,c] = FEMsolver(xmin,xmax,Ne,D,lambda,F,BCs);
xA = x; cA = 2*(1-x);

plot(x,c,'x-',xA,cA,'--');
title("Laplace's Equation with Two Dirichlet Boundary Conditions");
xlabel('x'); ylabel('c');
legend('numerical','analytical');
grid on

% save as png
saveas(gcf, 'Test1ci.png')

pause(0.1)

%% Analytical Test 1cii: Laplace's Equation with Dirichlet and Neumann Bxmin = 0;
BCs = [NaN 0 2 NaN]; % one dirichlet and one neumann boundary condition

[x,c] = FEMsolver(xmin,xmax,Ne,D,lambda,F,BCs);

plot(x,c,'x-');
title("Laplace's Equation with Dirichlet and Neumann Boundary Conditions");
xlabel('x'); ylabel('c');
grid on

% save as png
saveas(gcf, 'Test1cii.png')

pause(0.1)

%% Analytical Test 1ciii: Diffusion-Reaction Equation
Ne = [2 3 4 5 50];  % different numbers of elements to test effect of mesh density
lambda = -9; % reaction coefficient
BCs = [0 1 NaN NaN]; % dirichlet boundary conditions

% plot analytical solution
xA = 0:0.01:1;
cA = (exp(3) / (exp(6)-1)) * (exp(3*xA) - exp(-3*xA)); 
plot(xA,cA,'k','Linewidth',1);
grid on
ylim([0 1])
hold on 

labels{1} = 'analytical';
for i = 1:length(Ne)    % plot numerical solution with different mesh resolutions
   [x,c] = FEMsolver(xmin,xmax,Ne(i),D,lambda,F,BCs); 
   plot(x,c,'--');
   labels{i+1} = num2str(Ne(i), '%d elements');
end
legend(labels,'Location','northwest')
title("Diffusion-Reaction Equation with Different Mesh Resolutions");
xlabel('x'); ylabel('c');

% save as png
saveas(gcf, 'Test1ciii.png')

pause(0.1)
close
clearvars
