function [ tinew,J ,m] = UpPasGaussienNewton( param, t,px,py )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
p = [px py]';
T = [t^3 t^2 t 1]';
m = param*T;

d = norm(m-p); % distance entre le point pi et m(ti)

J = d^2;

devT = [3*t^2 2*t 1]';
dev_m = param(:,1:end-1)*devT;
dev2_m = param(:,1:2) * [6*t 2]';

dJ = 2 * (dev_m' * (m-p));

H =2*( dev2_m' * (m-p) + dev_m'*dev_m) ;
tinew = t -(1/H)*dJ;


[ Jnew ] = calculerJ(param,tinew,p);

end

function [ J ] = calculerJ(param,t,p)
T = [t^3 t^2 t 1]';
m = param*T;

d = norm(m-p);
J = d^2;
end