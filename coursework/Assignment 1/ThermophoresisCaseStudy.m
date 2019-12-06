% This script was written to model and simulate the behaviour of a
% thermophoresis system.

%% defining parameters
xmin = 0;
xmax = 0.01;
Ne = 500;

Tout = 323.15;
Tin = 293.15;
BCs = [Tout Tin NaN NaN];

k = 1.01e-5;

Q = 0.5:0.25:1.5;
Tl = 294.15:7:322.15;

%% modelling effects of varying flow rate Q 
cQ = zeros(Ne+1,length(Q),3);
for i = 1:length(Q)
    % min Tl
    F = Q(i)*min(Tl);
    [x, cQ(:,i,1)] = FEMsolver(xmin,xmax,Ne,k,-Q(i),F,BCs);
    % mean Tl
    F = Q(i)*mean(Tl);
    [~, cQ(:,i,2)] = FEMsolver(xmin,xmax,Ne,k,-Q(i),F,BCs);
    % max Tl
    F = Q(i)*max(Tl);
    [~, cQ(:,i,3)] = FEMsolver(xmin,xmax,Ne,k,-Q(i),F,BCs);
end
% cQ(:,(length(Q)+1)/2,:) = [];

%% modelling effects of varying liquid temp Tl
cTl = zeros(Ne+1,length(Tl),3);
for i = 1:length(Tl)
    % min Q
    F = Tl(i)*min(Q);
    [~, cTl(:,i,1)] = FEMsolver(xmin,xmax,Ne,k,-min(Q),F,BCs);
    % mean Q
    F = Tl(i)*mean(Q);
    [~, cTl(:,i,2)] = FEMsolver(xmin,xmax,Ne,k,-mean(Q),F,BCs);
    % max Q
    F = Tl(i)*max(Q);
    [~, cTl(:,i,3)] = FEMsolver(xmin,xmax,Ne,k,-max(Q),F,BCs);
end

%% comparing linear or constant source term
cS = zeros(Ne+1,2);
a = 1; b = 4;
% min Q, Tl
F = [a*min(Q)*min(Tl) b*min(Q)*min(Tl)];
[~, cS(:,1,1)] = FEMsolver(xmin,xmax,Ne,k,-min(Q),F(1),BCs); % constant
[~, cS(:,2,1)] = FEMsolver(xmin,xmax,Ne,k,-min(Q),F,BCs); %linear
% mean Q,Tl
F = [a*mean(Q)*mean(Tl) b*mean(Q)*mean(Tl)];
[~, cS(:,1,2)] = FEMsolver(xmin,xmax,Ne,k,-mean(Q),F(1),BCs);
[~, cS(:,2,2)] = FEMsolver(xmin,xmax,Ne,k,-mean(Q),F,BCs);
% max Q, Tl
F = [a*max(Q)*max(Tl) b*max(Q)*max(Tl)];
[~, cS(:,1,3)] = FEMsolver(xmin,xmax,Ne,k,-max(Q),F(1),BCs);
[~, cS(:,2,3)] = FEMsolver(xmin,xmax,Ne,k,-max(Q),F,BCs);

%% varying source term parameters (with mean Q and Tl)
a = 1; b = [8 4 0 -4 -8];
cSp = zeros(Ne+1,length(b));

for i = 1:length(b)
    F = [a*mean(Q)*mean(Tl) b(i)*mean(Q)*mean(Tl)];
    [~, cSp(:,i)] = FEMsolver(xmin,xmax,Ne,k,-mean(Q),F,BCs);
end

% to do: -generate labels -calculate grad and curv -plot trio and save

%% generate labels for legends
% varying Q
Qlabels = string([]);
for i = 1:length(Q)
    Qlabels(i) = strcat("Q = ", num2str(Q(i)));
end

% varying Tl
Tlabels = string([]);
for i = 1:length(Tl)
    Tlabels(i) = strcat("Tl = ", num2str(Tl(i)));
end

% varying source term
Slabels = {'constant(min Q&Tl)', 'linear(minQ&Tl)',...
    'constant(mean Q&Tl)','linear(mean Q&Tl)',...
    'constant(max Q&Tl)', 'linear(max Q&Tl)'};

% varying source term parameters
Splabels = {};
for i = 1:length(b)
    Splabels{i} = num2str(b(i),'f = QT_l + %dQT_l x');
end

%% plot results
% varying Q
figure('units','normalized','outerposition',[0 0 1 1]) % maximise figure

subplot(2,3,1); % min Tl
plot(x,cQ(:,:,1));
grid on
title('Effects on Temperature of Varying Q (min Tl)')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Qlabels)

subplot(2,3,2); %mean Tl
plot(x,cQ(:,:,2));
grid on
title('Effects on Temperature of Varying Q (mean Tl)')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Qlabels)

subplot(2,3,3); % max Tl
plot(x,cQ(:,:,3));
grid on
title('Effects on Temperature of Varying Q (max Tl)')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Qlabels)

% varying Tl
subplot(2,3,4); % min Q
plot(x,cTl(:,:,1));
grid on
title('Effects on Temperature of Varying Tl (min Q)')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Tlabels)

subplot(2,3,5); % mean Q
plot(x,cTl(:,:,2));
grid on
title('Effects on Temperature of Varying Tl (mean Q)')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Tlabels)

subplot(2,3,6); % max Q
plot(x,cTl(:,:,3));
grid on
title('Effects on Temperature of Varying Tl (max Q)')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Tlabels)

% save as png
saveas(gcf,'parameter_space_temp.png')
pause(0.1); close

% varying source term
figure('units','normalized','outerposition',[0.25 0.25 0.5 0.5]) % resize figure
subplot(1,1,1);
plot(x,cS(:,1,1),'r:',x,cS(:,2,1),'b:'); 
hold on
grid on
plot(x,cS(:,1,2),'r-.',x,cS(:,2,2),'b-.');
plot(x,cS(:,1,3),'r--',x,cS(:,2,3),'b--'); 

title('Effects on Temperature of Linear Source Term')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Slabels, 'Location','southwest')

% save as png
saveas(gcf,'source_term_temp.png')
pause(0.1); close

%% finding gradients
h = x(2)-x(1);
% varying Q
cQgrad = zeros(Ne+1,length(Q) ,3);
cQgrad2 = zeros(Ne+1,length(Q) ,3);
for i = 1:length(Q)
    for j = 1:3
        cQgrad(:,i,j) = gradient(cQ(:,i,j),h);
        cQgrad2(:,i,j) = gradient(cQgrad(:,i,j),h);
    end
end 

% varying Tl
cTlgrad = zeros(Ne+1,length(Tl),3);
cTlgrad2 = zeros(Ne+1,length(Tl),3);
for i = 1:length(Tl)
    for j = 1:3
        cTlgrad(:,i,j) = gradient(cTl(:,i,j),h);
        cTlgrad2(:,i,j) = gradient(cTlgrad(:,i,j),h);
    end
end  

% varying source term
cSgrad = zeros(Ne+1,2,size(cS,3));
cSgrad2 = zeros(Ne+1,2,size(cS,3));
for i = 1:2
    for j = 1:size(cS,3)
        cSgrad(:,i,j) = gradient(cS(:,i,j),h);
        cSgrad2(:,i,j) = gradient(cSgrad(:,i,j),h);
    end
end

% varying source term parameters
cSpgrad = zeros(Ne+1,length(b));
cSpgrad2 = zeros(Ne+1,length(b));
for i = 1:length(b)   
    cSpgrad(:,i) = gradient(cSp(:,i),h);
    cSpgrad2(:,i) = gradient(cSpgrad(:,i),h);
end

%% plot gradients
% varying Q
figure('units','normalized','outerposition',[0 0 1 1]) % maximise figure
subplot(2,3,1); % min
plot(x,cQgrad(:,:,1));
grid on
title('Effects on Temperature Gradient of Varying Q (min Tl)')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Qlabels,'Location','south')

subplot(2,3,2); %mean
plot(x,cQgrad(:,:,2));
grid on
title('Effects on Temperature Gradient of Varying Q (mean Tl)')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Qlabels,'Location','south')

subplot(2,3,3); % max
plot(x,cQgrad(:,:,3));
grid on
title('Effects on Temperature Gradient of Varying Q (max Tl)')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Qlabels,'Location','south')

% varying Tl
subplot(2,3,4); % min
plot(x,cTlgrad(:,:,1));
grid on
title('Effects on Temperature Gradient of Varying Tl (min Q)')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Tlabels,'Location','south')

subplot(2,3,5);
plot(x,cTlgrad(:,:,2));
grid on
title('Effects on Temperature Gradient of Varying Tl (mean Q)')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Tlabels,'Location','south')

subplot(2,3,6);
plot(x,cTlgrad(:,:,3));
grid on
title('Effects on Temperature Gradient of Varying Tl (max Q)')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Tlabels,'Location','south')

% save as png
saveas(gcf, 'parameter_space_grad.png')
pause(0.1); close

% varying source term
figure('units','normalized','outerposition',[0.25 0.25 0.5 0.5]) % resize figure
subplot(1,1,1);
plot(x,cSgrad(:,1,1),'r:',x,cSgrad(:,2,1),'b:'); 
hold on
grid on
plot(x,cSgrad(:,1,2),'r-.',x,cSgrad(:,2,2),'b-.');
plot(x,cSgrad(:,1,3),'r--',x,cSgrad(:,2,3),'b--');  

title('Effects on Temperature Gradient of Linear Source Term')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Slabels,'Location','south')

% save as png
saveas(gcf, 'source_term_grad.png')
pause(0.1); close

%% plot curvatures
% varying Q
figure('units','normalized','outerposition',[0 0 1 1]) % maximise figure
subplot(2,3,1); % min
plot(x,cQgrad2(:,:,1));
grid on
title('Effects on Temperature Curvature of Varying Q (min Tl)')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Qlabels)

subplot(2,3,2); %mean
plot(x,cQgrad2(:,:,2));
grid on
title('Effects on Temperature Curvature of Varying Q (mean Tl)')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Qlabels)

subplot(2,3,3); % max
plot(x,cQgrad2(:,:,3));
grid on
title('Effects on Temperature Curvature of Varying Q (max Tl)')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Qlabels)

% varying Tl
subplot(2,3,4); % min
plot(x,cTlgrad2(:,:,1));
grid on
title('Effects on Temperature Curvature of Varying Tl (min Q)')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Tlabels)

subplot(2,3,5);
plot(x,cTlgrad2(:,:,2));
grid on
title('Effects on Temperature Curvature of Varying Tl (mean Q)')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Tlabels)

subplot(2,3,6);
plot(x,cTlgrad2(:,:,3));
grid on
title('Effects on Temperature Curvature of Varying Tl (max Q)')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Tlabels)

% save as png
saveas(gcf, 'parameter_space_curv.png')
pause(0.1); close

% varying source term
figure('units','normalized','outerposition',[0.25 0.25 0.5 0.5]) % resize figure
subplot(1,1,1);
plot(x,cSgrad2(:,1,1),'r:',x,cSgrad2(:,2,1),'b:'); 
hold on
grid on
plot(x,cSgrad2(:,1,2),'r-.',x,cSgrad2(:,2,2),'b-.');
plot(x,cSgrad2(:,1,3),'r--',x,cSgrad2(:,2,3),'b--');  

title('Effects on Temperature Curvature of Linear Source Term')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Slabels, 'Location','southwest')

% save as png
saveas(gcf, 'source_term_curv.png')
pause(0.1); close

%% plotting tiled source term figures - constant/linear

% constant/linear temp
figure('units','normalized','outerposition',[0.33 0 0.33 1]) % resize figure
subplot(3,1,1);
plot(x,cS(:,1,1),'r:',x,cS(:,2,1),'b:'); 
hold on
grid on
plot(x,cS(:,1,2),'r-.',x,cS(:,2,2),'b-.');
plot(x,cS(:,1,3),'r--',x,cS(:,2,3),'b--'); 

title('Effects on Temperature of Linear Source Term')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Slabels, 'Location','southwest')

% constant/linear gradient
subplot(3,1,2);
plot(x,cSgrad(:,1,1),'r:',x,cSgrad(:,2,1),'b:'); 
hold on
grid on
plot(x,cSgrad(:,1,2),'r-.',x,cSgrad(:,2,2),'b-.');
plot(x,cSgrad(:,1,3),'r--',x,cSgrad(:,2,3),'b--');  

title('Effects on Temperature Gradient of Linear Source Term')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Slabels,'Location','south')

% constant/linear curvature
subplot(3,1,3);
plot(x,cSgrad2(:,1,1),'r:',x,cSgrad2(:,2,1),'b:'); 
hold on
grid on
plot(x,cSgrad2(:,1,2),'r-.',x,cSgrad2(:,2,2),'b-.');
plot(x,cSgrad2(:,1,3),'r--',x,cSgrad2(:,2,3),'b--');  

title('Effects on Temperature Curvature of Linear Source Term')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Slabels, 'Location','southwest')

% print A4 size png
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 20 45];
print('source_term_trio.png','-dpng','-r0')

pause(0.1); close

%% plotting tiled source term figures - parameters

% parameter temp
figure('units','normalized','outerposition',[0.33 0 0.33 1]) % resize figure
subplot(3,1,1);
plot(x,cSp); 

title('Effects on Temperature of Source Term Parameters')
xlabel('x (m)'); ylabel('T (Kelvin)');
legend(Splabels, 'Location','southwest')

% parameter gradient
subplot(3,1,2);
plot(x,cSpgrad); 

title('Effects on Temperature Gradient of Source Term Parameters')
xlabel('x (m)'); ylabel('dT/dx (Kelvin/m)');
legend(Splabels, 'Location','southwest')

% parameter curvature
subplot(3,1,3);
plot(x,cSpgrad2); 

title('Effects on Temperature Curvature of Source Term Parameters')
xlabel('x (m)'); ylabel('d^2T/dx^2 (Kelvin/m^2)');
legend(Splabels, 'Location','southwest')

% print A4 size png
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 20 45];
print('source_term__para_trio.png','-dpng','-r0')

pause; close

%% looking at mesh resolution
Ne = [2 3 4 5 10 20];
figure('units','normalized','outerposition',[0.25 0.25 0.5 0.5]) % resize figure
subplot(1,1,1)
for i = 1:length(Ne)
    [x,c] = FEMsolver(xmin,xmax,Ne(i),k,-max(Q),max(Q)*mean(Tl),BCs);
    plot(x,c);
    hold on
    grid on
    Mlabels{i} = num2str(Ne(i),'%d elements');
end
% plot high res for comparison
Ne = 100;
[x,c] = FEMsolver(xmin,xmax,Ne,k,-max(Q),max(Q)*mean(Tl),BCs);
plot(x,c,'k--','Linewidth',1);
Mlabels{i+1} = num2str(Ne,'%d elements');

legend(Mlabels); 
title('Investigating Effects of Mesh Density for mean Tl and max Q')
xlabel('x(m)'); ylabel('T(Kelvin)');

% save as png
saveas(gcf, 'convergence.png')
pause(0.1); close; clearvars

