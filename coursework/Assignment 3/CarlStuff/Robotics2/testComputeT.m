% testComputeT
% ME40331 Robotics Engineering
% Dynamics and Control lab 2016/2017
% written by: Jon du Bois, University of Bath
%
% Script to test the performance of the computeT() function by comparing it
% with the outputs of generateTrajectory().
%

traj=generateTrajectory;         % generate a random trajectory
nt=numel(traj.time);             % determine number of time steps
xyz=zeros(nt,3);                 % initialise storage for Cartesian end effector positions
for t=1:nt,                      % loop for each time step
    T=computeT(traj.q(t,:).');   % compute transforms for current time step
    T06=eye(4);                  % T06 is the end effector transform from the base frame. Initialised here in preparation for loop below.
    for ii=1:6,
        T06=T06*T(:,:,ii);       % multiply by each link transform in turn
    end
    xyz(t,1:3)=T06(1:3,4);       % extract position of end effector in base frame from full end effector transform
end

% plot comparison of computed trajectory with correct trajectory
figure;
subplot(2,1,1);
plot(traj.time,traj.x(:,1),'r-');
hold on;
plot(traj.time,traj.x(:,2),'b-');
plot(traj.time,traj.x(:,3),'g-');
plot(traj.time,xyz(:,1),'r--','linewidth',2);
plot(traj.time,xyz(:,2),'b--','linewidth',2);
plot(traj.time,xyz(:,3),'g--','linewidth',2);
title('Comparison of computeT() results with true trajectory')
legend('true x','true y','true z','computed x','computed y','computed z');
xlabel('time (s)');ylabel('position (m)');

% plot error in computed trajectory
err=xyz-traj.x;
subplot(2,1,2);
plot(traj.time,err(:,1),'r-');
hold on;
plot(traj.time,err(:,2),'b-');
plot(traj.time,err(:,3),'g-');
legend('x error','y error','z error');
xlabel('time (s)');ylabel('error (m)');

set(gcf,'units','normalized','position',[0 0 1 1]); % expand figure to fill screen