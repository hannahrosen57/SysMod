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

% Date tested:    -/-/2018
% Tested by:      Joe Bloggs
% Test procedure:
% Results:
J=zeros(4,4,6);  % initialise pseudo inertia matrix array
density = 7850 %kg/m^3
%%
%Link 1: Cylinder
% m(1) = density*0.3*pi*0.02^2

depthWidthHeight = [0.02, 0.02, 0.3;... Depth Width and Height for (:,i)^th link
                    0.01, 0.03, 0.2;...
                    0.03, 0.03, 0.03;...
                    0.01, 0.01, 0.2;...
                    0.03, 0.03, 0.03;...
                    0.01, 0.01, 0.1];

%CoM(:,i) records xyz centre of mass of link i in i^th co-ordinate system.
CoM = [0,     -0.15, 0;...
       -0.01, 0,     0;...
       0,     0,     0;...
       0,     0.1,   0;...
       0,     0,     0;...
       0,     0,     -0.05];


caseVariable = ['cylinder'; 'cuboid'; 'cuboid'; 'cylinder'; 'cuboid';...
    'cylinder'];

for i = 1:6
    switch caseVariable(i)
        case 'cylinder'
            m(i) = density* pi* depthWidthHeight(1,i)^2 * depthWidthHeight(3,i);
            
        case 'cuboid'
            m(i) = density* depthWidthHeight(1,i) * depthWidthHeight(2,i) * ...
                depthWidthHeight(3,i);
            
        otherwise
            error('caseVariable must be either''cylinder'' or ''cuboid''.')
    end
    
    Ixx(1) = 0.5*m(1)*0.02^2 + sqrt(CoM(2,1)^2 + CoM (3,1)^2);
    Iyy(1) = Izz(1) + (m*(y(1)^2))
    Izz(1) = (1/12)*m(1)*((3*0.02^2)+0.3^2)
    %All of the products of inertia happen to be 0 due to symmetry.
    
    J(:,:,i) = diag(0.5.*[-Ixx(i)+Iyy(i)+Izz(i),...
        Ixx(i)-Iyy(i)+Izz(i),...
        Ixx(i)+Iyy(i)-Izz(i),...
        0])
end


end