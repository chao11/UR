function [ param,J ] = Estime_MC( t,P )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


T = [t.^3 t.^2 t ones(size(t))];

[ theta_x ,Xm ] = mc( T,P(1,:)' );
Jx = sum((P(1,:)'-Xm).^2);

[ theta_y ,Ym ] = mc( T,P(2,:)' );
Jy = sum((P(2,:)'-Ym).^2);
J = Jx+Jy;

param = [theta_x,theta_y];

end


function [ theta ,Ym ] = mc( X,Ys )
theta = inv(X'*X)*X'*Ys;
Ym = X*theta;

end