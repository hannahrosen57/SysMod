% testComputeUijk
% ME40331 Robotics Engineering
% Dynamics and Control lab 2016/2017
% written by: Jon du Bois, University of Bath
%
% Script to test the performance of the computeUijk() function by comparing the
% accelerations it computes with those found using finite differences of the
% link transforms.
%

traj=generateTrajectory;       % generate a random trajectory
nt=numel(traj.time);           % determine the number of time steps
v2=zeros(nt,3,6);              % initialise storage for the link velocities (in Cartesian coordinates)
a1=zeros(nt,3,6); a2=a1;       % initialise storage for the link accelerations (in Cartesian coordinates)
p=zeros(nt,3,6);               % initialise storage for the link positions (in Cartesian coordinates)
for t=1:nt                       % loop for each time step
    T=computeT(traj.q(t,:).');   % compute transforms for current time step
    T0=zeros(size(T));           % initialise storage for link transforms from base frame
    T0(:,:,1)=T(:,:,1);          % transform of first link is already in base frame so just copy across
    for ii=2:6,                  % loop to compute base frame transforms for remaining links
        T0(:,:,ii)=T0(:,:,ii-1)*T(:,:,ii);
    end
    for ii=1:6                     % loop for each link to determine positions and velocities
        p(t,1:3,ii)=T0(1:3,4,ii);  % extract position of link from full link transform
        for jj=1:6,                % loop for each joint and add its contribution to the velocity of the link
            a1(t,1:3,ii)=a1(t,1:3,ii)+traj.qdd(t,jj)*([eye(3) [0;0;0]]*computeUij(T,ii,jj)*[0;0;0;1]).';
            for kk=1:6,
                a1(t,1:3,ii)=a1(t,1:3,ii)+traj.qd(t,jj)*traj.qd(t,kk)*([eye(3) [0;0;0]]*computeUijk(T,ii,jj,kk)*[0;0;0;1]).';
            end
        end
    end
end
v2=diff(p)/diff(traj.time([1 2]));     % finite difference of position to give velocity
a2=diff(v2)/diff(traj.time([1 2]));    % finite difference of velocity to give acceleration
t2=traj.time(2:end-1);                 % corresponding timesteps

% compute absoulte accelerations (scalar acceleration)
s1=squeeze(sum(a1.^2,2).^.5);
s2=squeeze(sum(a2.^2,2).^.5);

% plot comparison of accelerations
figure;
subplot(1,2,1); % main figure: scalar acceleration
plot(t2,s2(:,1),'r-');
hold on;
plot(t2,s2(:,2),'g-');
plot(t2,s2(:,3),'b-');
plot(t2,s2(:,4),'m-');
plot(t2,s2(:,5),'c-');
plot(t2,s2(:,6),'k-');
plot(traj.time,s1(:,1),'r--','linewidth',2);
plot(traj.time,s1(:,2),'g--','linewidth',2);
plot(traj.time,s1(:,3),'b--','linewidth',2);
plot(traj.time,s1(:,4),'m--','linewidth',2);
plot(traj.time,s1(:,5),'c--','linewidth',2);
plot(traj.time,s1(:,6),'k--','linewidth',2);
legend('link 1 FD','link 2 FD','link 3 FD','link 4 FD','link 5 FD','link 6 FD','link 1 Uijk','link 2 Uijk','link 3 Uijk','link 4 Uijk','link 5 Uijk','link 6 Uijk');
xlabel('time (s)');ylabel('scalar acceleration (m/s^2)');

subplot(3,2,2); % x-direction
plot(t2,a2(:,1,1),'r-');
hold on;
plot(t2,a2(:,1,2),'g-');
plot(t2,a2(:,1,3),'b-');
plot(t2,a2(:,1,4),'m-');
plot(t2,a2(:,1,5),'c-');
plot(t2,a2(:,1,6),'k-');
plot(traj.time,a1(:,1,1),'r--','linewidth',2);
plot(traj.time,a1(:,1,2),'g--','linewidth',2);
plot(traj.time,a1(:,1,3),'b--','linewidth',2);
plot(traj.time,a1(:,1,4),'m--','linewidth',2);
plot(traj.time,a1(:,1,5),'c--','linewidth',2);
plot(traj.time,a1(:,1,6),'k--','linewidth',2);
%title('Comparison of link x acceleration');
xlabel('time (s)');ylabel('x-acceleration (m/s^2)');

subplot(3,2,4); % y-direction
plot(t2,a2(:,2,1),'r-');
hold on;
plot(t2,a2(:,2,2),'g-');
plot(t2,a2(:,2,3),'b-');
plot(t2,a2(:,2,4),'m-');
plot(t2,a2(:,2,5),'c-');
plot(t2,a2(:,2,6),'k-');
plot(traj.time,a1(:,2,1),'r--','linewidth',2);
plot(traj.time,a1(:,2,2),'g--','linewidth',2);
plot(traj.time,a1(:,2,3),'b--','linewidth',2);
plot(traj.time,a1(:,2,4),'m--','linewidth',2);
plot(traj.time,a1(:,2,5),'c--','linewidth',2);
plot(traj.time,a1(:,2,6),'k--','linewidth',2);
%title('Comparison of link y acceleration');
xlabel('time (s)');ylabel('y-acceleration (m/s^2)');

subplot(3,2,6); % z-direction
plot(t2,a2(:,3,1),'r-');
hold on;
plot(t2,a2(:,3,2),'g-');
plot(t2,a2(:,3,3),'b-');
plot(t2,a2(:,3,4),'m-');
plot(t2,a2(:,3,5),'c-');
plot(t2,a2(:,3,6),'k-');
plot(traj.time,a1(:,3,1),'r--','linewidth',2);
plot(traj.time,a1(:,3,2),'g--','linewidth',2);
plot(traj.time,a1(:,3,3),'b--','linewidth',2);
plot(traj.time,a1(:,3,4),'m--','linewidth',2);
plot(traj.time,a1(:,3,5),'c--','linewidth',2);
plot(traj.time,a1(:,3,6),'k--','linewidth',2);
%title('Comparison of link z acceleration');
xlabel('time (s)');ylabel('z-acceleration (m/s^2)');

suptitle('Comparison of accelerations computed with finite difference (FD) and transform derivatives (Uijk)');
set(gcf,'units','normalized','position',[0 0 1 1]); % expand figure to fill screen