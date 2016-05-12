function Y= compute( X,W1,W2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n=size(X,1);
J=size(W1,1);
S=size(W2,1);
Z=zeros(n,J);
Y=zeros(n,S);
for i = 1:n 
    alpha1 = W1*X(i,:)';
    z = 1./(1+exp(-alpha1'));

    % pour chaque neurone
    alpha2 = W2*z';

    % softmax
   Y(i,:) = exp(alpha2)./sum(exp(alpha2), 1);
     %Y(i,:)=1./(1+exp(-alpha2'));

end
Y=getYlabel(Y);
end

    