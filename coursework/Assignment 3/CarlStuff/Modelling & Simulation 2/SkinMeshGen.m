clearvars
xmin = 0;
xmax = 0.01;
ne = 100;
msh = OneDimLinearMeshGen(xmin, xmax, ne);
dt = 0.1;
tmax = 50;

%Values all ordered as Epidermis, Dermis, Subcutaneous
skin = struct(...
    'k',[25.0,40.0,20.0],...
    'G',[0.0,0.0,0.0],...
    'ro', 1200.0,...
    'c', 3300.0,...
    'ro_b', [0.0, 1060, 1060],...
    'c_b', [0.0, 3770, 3770],...
    'T_b', [0.0, 310.15, 310.15],...
    'xranges', [1, find(msh.nvec<xmax/6,1,'last')+1, find(msh.nvec>xmax/6 & msh.nvec<xmax/2,1,'last')+1, length(msh.nvec)]...
    )

  for i = 1:3
      D(skin.xranges(i):skin.xranges(i+1)) = skin.k(i)/(skin.ro*skin.c);
      lambda(skin.xranges(i):skin.xranges(i+1)) =...
          -(skin.G(i)*skin.ro_b(i)*skin.c_b(i)) / (skin.ro*skin.c);
      f(skin.xranges(i):skin.xranges(i+1)) =...
          (skin.G(i)*skin.ro_b(i)*skin.c_b(i)*skin.T_b(i)) / (skin.ro*skin.c);
  end

Ct0 = 310.15*ones(msh.ngn,1);
 C = MultiMeshSolver(msh,dt,tmax,D,lambda,f,Ct0,[true, 393.15, true, 310.15], [false,0,false,0], 1);

TempVector = C(17,:)
TempVector = TempVector(find(TempVector>317.15))

tburn = 50-(dt*(length(TempVector)-1))
t = tburn:dt:50

plot(t, TempVector)


IntVector = 2.0e98* exp(-12017./(TempVector - 273.15))
Gamma = dt*trapz(IntVector)

surf(C)
title('Results including Blood flow effects')
xlabel('Time/s')
ylabel('x Distance/m')
zlabel('Temperature/K')
colormap jet
shading interp

figure(2)
plot(msh.nvec, C(:,2),msh.nvec, C(:, 6), msh.nvec, C(:, 10), msh.nvec, C(:, 20),msh.nvec, C(:, 500))
legend('t=0.2s','t=0.5s','t=1s','t=2s','t=50s','Location','northeast')
title('Results including Blood flow effects')
xlabel('x Distance/m')
ylabel('Temperature/K')
