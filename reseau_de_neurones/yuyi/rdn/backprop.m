function [ W1,W2 ] = backprop(Xapp,yapp,W1,W2,pas )
%UPDATEW Summary of this function goes here
%   Detailed explanation goes here
n=size(yapp,1);
S=size(W2,1);
for i = 1:n
        Ytmp = zeros(S,1);
        Ytmp(yapp(i)+1) = 1;
        % calculer alpha1 et alpha2
        alpha1 = W1*Xapp(i,:)';
        z = 1./(1+exp(-alpha1));
        alpha2 = W2*z;
        
        % softmax
        Ys = exp(alpha2)./sum(exp(alpha2), 1);

        % sigmoïde
        %Ys = 1./(1+exp(-alpha2));
        
        % calcul des erreurs (Backpropagation)
        % erreur_s = (Yd-Ys).*exp(alpha2)/sum(alpha2,1);
        erreurS = (Ytmp-Ys).*(1+exp(-alpha2)).^-2.*exp(-alpha2);
        % erreur_j = -sum(Yd-Ys,1).*exp(alpha2)/sum(alpha2,1).*W_sj*W_je'*alpha1;
        erreurJ = W2'*(erreurS).*(1+exp(-alpha1)).^-2.*exp(-alpha1);
        
        % mettre à jour les matrices W
        W2 = W2 + erreurS*z'*pas;
        W1 = W1 + erreurJ*Xapp(i,:)*pas;
end

end

