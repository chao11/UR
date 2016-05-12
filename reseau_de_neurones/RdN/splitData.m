function [ train,test,valid ] = splitData( data )
% splite the dataset to 3 base 
[Nb_sample,n ] = size(data);

% [~ ,idx] = sort(Y);
% Datasort = data(idx(1:end),:);
% classe = unique(Y); % retour les classes de sortie 
% Nb_classe = length(classe); % nombre total des classes
% 
% Xtr = [ones(a0+a1,1) data([idx_0(1:a0)',idx_1(1:a1)'],1:9)];


% split data en 3 base 
a0=floor(Nb_sample/3);
Xtr = data(1:a0,1:end-1);
Ytr = data(1:a0 ,end);
train = [Xtr,Ytr];

Xvalid = data(a0+1:2*a0,1:end-1);
Yvalid = data( a0+1:2*a0 ,end);
valid = [Xvalid, Yvalid];

Xtest = data(2*a0+1:end,1:end-1);
Ytest = data(2*a0+1:end ,end);
test = [Xtest, Ytest];

end

