function [w1,w2 , ys, errorApp] = backpropagation(x,yd,w1,w2)
%
% a1 = [x ones(n,1)]*W1;    z1 = tanh(a1);
% a2 = [z1 ones(n,1)]*W2;   y =  a2;
% ERRs = -(yd-ys).*(1-ys.*ys);
% GradW2 = Zj* ERRs ;
% 
% ERRj = (w2(1:n2-1,:)*ERRs')'.*(1-Zj.*Zj);
% GradW1 = [x ones(n,1)]'* ERRj ;
%

%---------------------------------------------------------------------------------------
pas1 = 0.001;
pas2 = 0.001;
epsilon  = 0.0001;
% errorApp = 100;
[n_exemple,E ]= size(Xtr);    % e+1 

[ ys, Zj ] = compute( x(1,:),w1,w2 );
errorApp = norm (yd - ys);


while (errorApp > epsilon)
    
    for n =1:n_exemple
    % compute z(n) and ys(n)
        [ ys, Zj ] = compute( x(n,:),w1,w2 );  
    % compute errors
        ERRs(n) = -(yd(n)-ys(n)).*(1-ys(n).^2); % scalaire
        GradW2(n,:) = ERRs(n)*Zj(:,n);

        ERRj(n) = sum(ERRs(n)*w2(:,1:end),1)*(1-Zj(:,n).*Zj(:,n));
        GradW1(n,:) = ERRj(n) * x(n,:);
    end


w1 = w1 - pas1 .* GradW1;     
w2 = w2 - pas2 .* GradW2;

errorApp = norm (yd - ys);

end
end