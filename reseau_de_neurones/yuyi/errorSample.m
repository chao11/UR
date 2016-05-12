function [ errorS, errorJ ] = errorSample( yd,y,z,Wsj )
%ERRORSAMPLE Summary of this function goes here
%   Detailed explanation goes here
tmp=find(y==max(y));
if(length(tmp)==1)
    ylabel = tmp;
else
    ylabel = 0;
end
errorS = (-(yd-ylabel).*(1-y.*y)')';
errorJ = errorS*Wsj(:,1:end-1).*(1-z(1:end-1).*z(1:end-1)); 
end

