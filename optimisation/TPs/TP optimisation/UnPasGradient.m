function [ tinew,lambda,J,dJ,m] = UnPasGradient( param, tiold,px,py,lambda )
% methode du gradient avec pas adaptatif
p = [px py]';

% sous forme polynominale:
[J,dJ,m]= calculerJ(param,tiold,p);
% update theta:
tinew = tiold - lambda*dJ;


% choix de lambda:
[Jnew,~,m]= calculerJ(param,tinew,p);
if Jnew <= J
    lambda = lambda*1.5;
else lambda = lambda*0.5 ;
end


end




function [ J, dJ ,m] = calculerJ(param,t,p)
T = [t^3 t^2 t 1]';
m = param*T;

d = norm(m-p);

% j = (m-p).^2; % un vecteur
J = d^2;

devT = [3*t^2 2*t 1]';
dev_m = param(:,1:end-1)*devT;
dJ = 2 * (dev_m' * (m-p));

end




