function T=computeT(q)
% computeT.m
% T = computeT(q)
% T is the 4x4x6 array of homogeneous transform matrices for all 6 links
%   e.g. T(:,:,3) is the matrix T23 (not T03!)
% q is a 6x1 vector of joint angles for the current time step, in radians

% Unit information:
% ME40331 Robotics Engineering, University of Bath
% Dynamics and Control lab 2016/2017
% Dr. Jon du Bois

%--------------------------------------------------------------------------
% DO NOT MOFIFY ABOVE THIS LINE!!!! YOUR CODE GOES BELOW THIS LINE.
%--------------------------------------------------------------------------

% Date tested:    29/11/2018
% Tested by:      Jeff Lebowski
% Test procedure:
% Ran testComputeT 30 times and gathered the maximum error for each axis 
% using a script.  30 times is appropiate for most normal or binomial data
% according to the central limit theroem.
% 
% Results:
% result =
%   1.0e-15 *
%   0.2498    0.2758    0.2220
%
% Commments:
% - Errors are less than 1.0e-15 in every case, making them dismissable as
% floating point errors (<1.0e-10).
% - The dude abides.

%Initialise T matrices
T=zeros(4,4,6);

%Call functions with hard-coded D-H parameters.
%These parameters are given by the geometry of the robot.
T(:,:,1) = homogeneous_transform(0,0.3,q(1),pi/2);
T(:,:,2) = homogeneous_transform(0.2,0,q(2),0);
T(:,:,3) = homogeneous_transform(0,0,q(3),pi/2);
T(:,:,4) = homogeneous_transform(0,0.2,q(4),-pi/2);
T(:,:,5) = homogeneous_transform(0,0,q(5),pi/2);
T(:,:,6) = homogeneous_transform(0,0.1,q(6),0);

function matrix = homogeneous_transform(a, d, theta, alpha)
%Calculates the homogeneous transform (T) using D-H parameters.
%Returns a 4x4 matrix.
    matrix = [cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);...
              sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);...
              0,          sin(alpha),            cos(alpha),             d;...
              0,          0,                     0,                      1];
end
end
