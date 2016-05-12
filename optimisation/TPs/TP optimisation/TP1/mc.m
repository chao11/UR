function [ theta ,Ym ] = mc( X,Ys )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

theta = inv(X'*X)*X'*Ys;
Ym = X*theta;

end

