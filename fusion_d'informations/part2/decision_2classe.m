function [ decision ] = decision_2classe( learn,L )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% L  nombre de classifieur
decision = [];
for n = 1: size(learn,1)
    positive = sum(learn(n, :) == 1);
    negative = sum(learn(n, :) == 2);
    if positive > negative && positive> L/2
        decision(n) = 1;
       
    elseif positive < negative
        decision(n) = 2;
    else decision(n) = 0;
    end
end
decision = decision';

end

