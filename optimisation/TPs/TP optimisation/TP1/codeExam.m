clc;
close all;
clear all;
 
t= [1 2 3 4 5 ]';
X = -1*t;
Y = [ 0.7 0.43  0.32 0.19 0.15]';
Ys = log(Y);
% MC
[ theta ,Ym ] = mc( X,Ys )
Ymodi = exp(Ys);

J = sum((Y-Ymodi).^2)
J2 = sum((Ys-Ym).^2)

% mcR
[ theta,Yest ] = MCR( X,Ys )
Yest_reel = exp(Yest);

figure;
plot(Y,'g')
hold on
plot(Ymodi,'r')
hold on
plot(Yest_reel,'b')