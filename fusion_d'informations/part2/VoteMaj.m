function [ decision ] = VoteMaj( predit_claffisieurs, Nb_classe ,L)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N_test = size(predit_claffisieurs,1);

vote = zeros(N_test,Nb_classe);
% correct = 0;

for j = 1:N_test
    for i = 1:Nb_classe
        vote(j,i) = sum(predit_claffisieurs(j,:)==i);
    end 
    [maxVOTE, idx] = max(vote(j,:));
    if maxVOTE > L/2  
%         correct = correct+1;
        decision(j) = idx;
    end
        
end

end

