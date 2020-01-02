function U=computeUijk(T,i,j,k)
% computeUijk.m
% U=computeUijk(T,i,j,k)
% U is a 4x4 matrix describing the second derivative of the transform from
%   the base frame to the ith link with respect to the jth and kth
%   generalised coordinates.
% T is a 4x4x6 array of link transform matrices for the robot for the
%   current time step.
% i defines the link
% j  defines the first generalised coordinate
% k  defines the second generalised coordinate

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
% Ran testComputeUijk 30 times and gathered the maximum acceleration of all 
% axes for each link using a script.  
% 30 times is appropiate for most normal or binomial data
% according to the central limit theroem.
%
% Results:
% result =

%     0    1.0120    1.0120    0.0039    0.0039    0.0020
     
% Commments: 
% There were some pretty large errors in acceleration, but on closer
% inspection they appear to be due to singularities in the finite
% difference method. They seem to only happen for links 2 and 3.
% A visual inspection of 30 generated figures indicated that the majority
% of errors were less than 1.0e-4. Whilst not small enough to be down to
% floating point alone this is still fit for purpose.
%-The dude abides.

%Need to make U an identity matrix to begin so we can use it as a
%cumulative product (avoid 0*x = 0).
U=eye(4,4);

%Check the link in question is actually affected.
if j<=i && k<=i 
    %The hardcoded matrices are the equivalent of differentiating a T
    %matrix once.
    T(:,:,j) = [0,-1,0,0;1,0,0,0;0,0,0,0;0,0,0,0] * T(:,:,j);
    %By not combining these two into one statement we avoid having to do an
    %if/else check every iteration in case j=k. Assuming every link will be 
    %polled in series this is a minor optimisation. (one extra 
    %multiplication 1/6 of the time is cheap)
    T(:,:,k) = [0,-1,0,0;1,0,0,0;0,0,0,0;0,0,0,0] * T(:,:,k);
    %Collect the cumulative product from base link to i'th link.
    for x = 1:i
        U = U*T(:,:,x);
    end
else %i'th link is unaffected, so no acceleration. d2T/dQ2 = 0.
    U = zeros(4,4);
end

