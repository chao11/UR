%% TP-1 Optimisation 
clc;
clear all;
close all;
%% initialiser N points
% N_points = 5;
% x=round(rand(N_points,1)*100); 
% y=round(rand(N_points,1)*100);
% 
x=[1 0 -1 0 -sqrt(2)/2]
y = [0 1 0 -1 sqrt(2)/2]
N_points = 5
figure
plot (x,y, '+r');
% xlim([0 max(x)+10]);
% ylim([0 max(y)+10]);
grid on
hold on;

[R,A,B]=conic_fitting(x,y,N_points);

t = linspace(0,2*pi);
x = R*cos(t) + A;
y = R*sin(t) + B;
plot(x,y)
axis equal
hold off;

%% matrice

x=[1 0 -1 0 -sqrt(2)/2]';
y = [0 1 0 -1 sqrt(2)/2]';
N_points = 5;
X = [2*x 2*y ones(N_points,1)];
Ys = x.^2+y.^2;

theta = inv(X'*X)*X'*Ys
R = abs(sqrt(theta(1).^2+theta(2).^2-theta(3)))

Ym = X*theta;

figure
plot (x,y, '+r');
grid on
hold on;

t = linspace(0,2*pi);
xm = R*cos(t) + theta(1);
ym = R*sin(t) + theta(2);
plot(xm,ym)
axis equal
hold off;

