Function grad = retropropag(x,yd,w1,w2)

....

a1 = [x ones(n,1)]*W1;    x1 = tanh(a1);
a2 = [x1 ones(n,1)]*W2;   y =  a2;

ERRk = -(yd-y).*(1-y.*y);
GradW2 = [x1 ones(n,1)]'* ERRk ;
ERRj = (w2(1:n2-1,:)*ERRk')'.*(1-x1.*x1);
GradW1 = [x ones(n,1)]'* ERRj ;

w1 = w1 - pas1 .* GradW1;     
w2 = w2 - pas2 .* GradW2;

