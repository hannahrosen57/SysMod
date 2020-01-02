function G=computeG(T)
% computeG.m
% G=computeG(T)
% G is a 6x1 vector of torques due to gravity forces for the current
%   timestep.
% T is the 4x4x6 array of link transform matrices for the robot for the
%   current time step.

% Unit information:
% ME40331 Robotics Engineering, University of Bath
% Dynamics and Control lab 2016/2017
% Dr. Jon du Bois

%--------------------------------------------------------------------------
% DO NOT MOFIFY ABOVE THIS LINE!!!! YOUR CODE GOES BELOW THIS LINE.
%--------------------------------------------------------------------------

% Date tested:    29/11/2018
% Tested by:      Jeff Lebowski
% Test procedure: Ran with hold, normal, fast inputs. C & Mqtt element
%deleted. All tests on same computer.

% Results:
% Sums of max errors in each axis: | Simulink processing time
% hold: 1.3897e-13  | t=14.94s
% normal: 0.0015    | t=14.11s
% fast: 0.2659      | t=14.09s
% spin6: 0.1378     | t=14.91s
% Commments: 
% -Compensates for gravity near perfectly(hold) ok-ish for slow motions and
% useless for fast motions.
% -Processing time is between 14 and 15s.
% -The dude abides.   

g=[0,0,-9.81,0]; %Reasonable approximation for accel. due to gravity.
J = returnJ;
G=[0;0;0;0;0;0];

%n is the link index. We start iterating from 2 because the first link
%rotates in a plane which is normal to gravity. Therefore there is no
%gravitational force to compensate for and G(1) = 0 always. So I just
%skipped it.
for n = 2:6
    %iterate over link reference frame
    for i = 1:6
        U = computeUij(T,i,n)
        G(n) = G(n) - g*U*J(:,end,i)
    end
end