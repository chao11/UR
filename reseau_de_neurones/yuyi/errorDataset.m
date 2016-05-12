function [ errorS,errorJ ] = errorDataset(yd,Y,Z,Wje,Wsj)
%ERRORDATA Summary of this function goes here
%   Detailed explanation goes here
n=size(Y,1);
S=size(Wsj,1);
errorS=zeros(n,S);
J=size(Wje,1);
errorJ=zeros(n,J);
for i=1:n
    [errorS(i,:),errorJ(i,:)]= errorSample(yd(i),Y(i,:),Z(i,:),Wsj);
end
end

