function [ theta,Yesti ] = MCR( X,Ys )

% moidre carre recursif
[M,N] = size(X);
n = length(Ys);

P(1) = 100* eye(N);
Pstore = zeros(N,n-1); 

X = [0;X];
Ys = [0;Ys];
theta(1) = 0;

for n = 2:M+1    
K(n) = P(n-1)*X(n)*inv(X(n)'*P(n-1)*X(n)+1);
P(n) = P(n-1)*(1-K(n)*X(n)');
theta(:,n) = theta(:,n-1)+K(n)*(Ys(n)-X(n)'*theta(:,n-1));
end

theta = theta';
Yesti = X.*theta;
Yesti = Yesti(2:end);
end

