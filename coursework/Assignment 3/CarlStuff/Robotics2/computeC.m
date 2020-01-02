function C=computeC(J,T,qt)
% computeC.m
% C=computeC(J,T,qt)
% C  is a 6x1 vector of torques due to centrifugal, centripetal, Coriolis
%    and precessional forces for the current timestep.
% J  is a 4x4x6 array of pseudo-inertia matrices for the robot links.
% T  is a 4x4x6 array of link transform matrices for the robot for the
%    current time step.
% qt is a 6x1 vector of joint velocities (angluar velocities) for the
%    current time step, in radians/s.

% Unit information:
% ME40331 Robotics Engineering, University of Bath
% Dynamics and Control lab 2016/2017
% Dr. Jon du Bois

%--------------------------------------------------------------------------
% DO NOT MOFIFY ABOVE THIS LINE!!!! YOUR CODE GOES BELOW THIS LINE.
%--------------------------------------------------------------------------

% Date tested:    29/11/2018
% Tested by:      Jeff Lebowski
% Test procedure: Ran with normal, fast, and spin6 inputs. All
% elements connected to Feed Forward controller. All tests on same
% computer.
% Results:
% Sums of max errors in each axis: | Simulink processing time
% Normal: 6.8463e-04 | t=16.33s
% Fast: 9.1209e-04   | t=14.88s
% Spin6: 0.0054      | t=15.67
% Commments: All errors are less than 1e-2, I think this is as good as it
% gets for this system. Processing time is around 15secs, little use in 
% optimising further.
%-The dude abides.


%Initialise C as a 6x1 vector. 1 Value per joint
C=[0;0;0;0;0;0];

%Every one of these for loops iterates over all of the links
for n = 1:6
    for j = 1:6
        for k = 1:6
            for i = 1:6
                %Do a cumulative sum at C(n) according to term C in the notes.
                C(n) = C(n) + trace(computeUijk(T,i,j,k)*J(:,:,i)*...
                    computeUij(T,i,n)')*qt(j)*qt(k);
            end
        end
    end
end