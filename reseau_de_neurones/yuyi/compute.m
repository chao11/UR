function [Y, Z] = compute( X,W1,W2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n=size(X,1);
J=size(W1,1);
S=size(W2,1);
Z=zeros(n,J);
X=[X,ones(n,1)];

for i = 1:n
    alpha1= W1*X(i,:)';
    Z(i,:)=tanh(alpha1');
end
% ajouter les bias pour Z
Z=[Z,ones(n,1)];
Y=zeros(n,S);
for i = 1:n
    alpha2= W2*Z(i,:)';
    if(sum(exp(alpha2))~=0)
        Y(i,:)=exp(alpha2)./sum(exp(alpha2));
    end
end

end

