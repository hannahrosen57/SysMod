function J=returnJ
% returnJ.m
% J=returnJ()
% J  is a 4x4x6 array of pseudo-inertia matrices for the robot links.

% Unit information:
% ME40331 Robotics Engineering, University of Bath
% Dynamics and Control lab 2016/2017
% Dr. Jon du Bois

%--------------------------------------------------------------------------
% DO NOT MOFIFY ABOVE THIS LINE!!!! YOUR CODE GOES BELOW THIS LINE.
%--------------------------------------------------------------------------

% Date tested:    19/11/2018
% Tested by:      Jeff Lebowski
% Test procedure: testReturnJ.p file run.
% Results: " 

%didn't you get this right already?
 
%Your pseudo-inertia matrices are correct, you are awesome, give yourself a hug.
%"

%This is mostly hardcoded for efficieny. Time loss here isn't too dramatic
%since it's only done once.


J=zeros(4,4,6);  % initialise pseudo inertia matrix
density = 7850; %kg/m^3

%% Link 1: Cylinder
 m(1) = density*0.3*pi*0.02^2; %Mass of cylinder
 
 %CoM(i,:) gives the xyz of the i^th centre of mass in the i^th frame.
 CoM(1,:) = [0, -0.15, 0];
 
 %Compute the 3 moments of inertia. Don't bother with Products (Ixy etc.)
 %because they all happen to be 0 in this specific case.
 Iyy(1) = 0.5*m(1)*0.02^2;
 Ixx(1) = (1/12)* m(1) * (3*0.02^2 + 0.3^2)  + (m(1) * CoM(1,2)^2);
 Izz(1) = Ixx(1);
 
%% Link 2: Cuboid Beam
m(2) = density*0.01*0.03*0.2;

CoM(2,:) = [-0.1, 0, 0];
 
Ixx(2) = (1/12)*m(2)*(0.03^2 +0.01^2);
Iyy(2) = (1/12)*m(2)*(0.2^2 + 0.01^2) + (m(2) * CoM(2,1)^2);
Izz(2) = (1/12)*m(2)*(0.2^2 + 0.03^2) + (m(2) * CoM(2,1)^2);

%% Link 3: Cuboid
m(3) = density * 0.03^3;

CoM(3,:) = [0,0,0];

Ixx(3)= (1/12)*m(3)*(0.03^2+0.03^2);
Iyy(3) = Ixx(3);
Izz(3) = Ixx(3);

%% Link 4: cylinder
m(4) = density* 0.2* pi * 0.01^2;
CoM(4,:) = [0,0.1,0];

Iyy(4) = 0.5*m(4)*0.01^2;
Ixx(4) = (1/12)* m(4) * (3*0.01^2 + 0.2^2)  + (m(4) * CoM(4,2)^2);
Izz(4) = Ixx(4);

%% Link 5: Cuboid
m(5) = m(3);

CoM(5,:) = [0,0,0];

Ixx(5) = Ixx(3);
Iyy(5) = Ixx(5);
Izz(5) = Ixx(5);

%% Link 6: Cylinder
m(6) = density*0.1*pi*0.01^2;
CoM(6,:) = [0,0,-0.05];

Izz(6) = 0.5 * m(6) * 0.01^2;
Ixx(6) = (1/12) * m(6) * (3*0.01^2 + 0.1^2) + (m(6)* CoM(6,3)^2);
Iyy(6) = Ixx(6);

%% For loop

%Iterate over every link.
for i = 1:6
    %First get the diagonal right. All products of inertia (e.g. Ixy) are 0
    %due to symmetry. 'diag()' produces a diagonal matrix of whatever 
    %vector it's given (i.e. every non leading-diagonal value = 0)
    J(1:3,1:3,i) = diag(0.5.*...
        [-Ixx(i)+Iyy(i)+Izz(i),...
        Ixx(i)-Iyy(i)+Izz(i),...
        Ixx(i)+Iyy(i)-Izz(i)]);
    
    %Fill in the mass*CoM terms along the last row:
    J(end, :, i) = m(i).*[CoM(i,1), CoM(i,2), CoM(i,3), 1];
    
    %Last column is the same as the last row:
    J(1:3, end, i) = J(end, 1:3, i)';
end