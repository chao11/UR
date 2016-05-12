clc;clear all;close all;

% XOR input for x1 and x2 
input = [0 0; 0 1; 1 0; 1 1]; 
% Desired output of XOR 
output = [0;1;1;0]; 
% Initialize the bias 
bias = [-1 -1 -1]; 
% Learning coefficient
coeff = 0.7; 
% Number of learning iterations 
iterations = 10000;
% Calculate weights randomly using seed. 
rand('state',sum(100*clock)); 
weights = -1 +2.*rand(3,3);
