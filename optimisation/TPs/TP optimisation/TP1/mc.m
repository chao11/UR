function [ theta ,Ym ] = mc( X,Ys )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

theta = inv(X'*X)*X'*Ys;
Ym = X*theta;

end

