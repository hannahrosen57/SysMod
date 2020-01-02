function Mqtt=computeMqtt(J,T,qtt)
% computeMqtt.m
% Mqtt=computeMqtt(J,T,qtt)
% Mqtt is a 6x1 vector of torques due to joint acceleration forces for the
%      current timestep.
% J    is a 4x4x6 array of pseudo-inertia matrices for the robot links.
% T    is a 4x4x6 array of link transform matrices for the robot for the
%      current time step.
% qtt  is a 6x1 vector of joint accelerations (angluar accelerations) for
%      the current time step, in radians/s^2.

% Unit information:
% ME40331 Robotics Engineering, University of Bath
% Dynamics and Control lab 2016/2017
% Dr. Jon du Bois

%--------------------------------------------------------------------------
% DO NOT MOFIFY ABOVE THIS LINE!!!! YOUR CODE GOES BELOW THIS LINE.
%--------------------------------------------------------------------------

% Date tested:    29/11/2018
% Tested by:      Jeff Lebowski
% Test procedure: Ran with slow, normal, fast, and spin6 inputs. C
% element deleted. All tests on same computer.
% Results:
% Sums of max errors in each axis: | Simulink processing time
% Normal: 0.004  | t=15.23s
% Fast: 0.0817   | t=14.78s
% Spin6: 0.1247  | t=15.03s
% Commments: 
% -One order of magnitude worse than with no C. Better than Just-G so long
% as there's not large spins involved.
% Speed of motion correlated with accuracy.Slower the
% better.
% -Processing time constant at ~15s average.
%-The dude abides.

%Initialise M matrix:
M=zeros(6,6);

%Iterate over links in n, j, and k
for n = 1:6
    for j = 1:6
        for i = 1:6
            %Cumulative sum at M(n,j) as defined in notes.
            M(n,j) = M(n,j) + trace(computeUij(T,i,j)*J(:,:,i)*...
                computeUij(T,i,n)');
        end
    end
end
%Get component of Force vector Qn, Mqtt, by multiplying torques and joint 
%accelerations.
Mqtt=M*qtt;