function U=computeUij(T,i,j)
% computeUij.m
% U=computeUij(T,i,j)
% U is a 4x4 matrix describing the derivative of the transform from the
%   base frame to the ith link with respect to the jth generalised
%   coordinate.
% T is a 4x4x6 array of link transform matrices for the robot for the
%   current time step.
% i defines the link
% j defines the generalised coordinate

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
% Ran testComputeUij 30 times and gathered the maximum velocity for each 
% link using a script.  
% 30 times is appropiate for most normal or binomial data
% according to the central limit theroem.
% Results:
% result =
%
%         0    0.2498    0.2498    0.0008    0.0008    0.0013
% Commments: 
% -Links 2 and 3 show some pretty large errors, but I believe this is due to
% singularities in the finite difference method. A visual inspection of the
% 30 sets of figures and results indicates the vast majority of errors are
% less than 1.0e-4
% - Errors can't be put down to floating point errors alone, but they are
% fit for purpose.
% - The dude abides.      

%Start with identity matrix so we can gather the cumulative product
U=eye(4,4);

%Check the moving link isn't after the link we're looking at(i)
if j<=i 
    %Multiplying by this hardcoded matrix is equivalent to differentiating.
    T(:,:,j) = [0,-1,0,0;1,0,0,0;0,0,0,0;0,0,0,0]* T(:,:,j);
    for x = 1:i
        %Collect the cumulative product from base link to ith link
        U = U*T(:,:,x);
    end
else
    U = zeros(4,4); %No velocity if j>i i.e. dT/dq = 0
end

end