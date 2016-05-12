function [ S] = projection( I,direction )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m,n]=size(I);
switch direction
    case 'verticale'
    % calculer la projection verticale
        for y=1:n
             S(y)=sum(I(1:m,y));
        end
        y=1:n;
        figure
        plot(y,S(y));
        title('projection verticale');

    case 'horizonale'
    % calculer la projection horizonale
        for x=1:m
            S(x)=sum(I(x,:));
        end
        x=1:m;
        figure;plot(x,S(x));
        title('projection horizontale');

end


end

