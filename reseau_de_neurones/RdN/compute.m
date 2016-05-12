function [ Ys, Zj,Alpha_j1,Alpha_s2, deriv_f1, deriv_f2] = compute( Xe,Wje,Wsj )
%compute permettant de propager les entrées vers la sortie, pour un exemple
%   Xe: entree d'un exemple
%   Ye: sortie de l'exemple
%   Wje: poids entre les x et la couche cachee
%   Wsj: poids entre la couche cachee et sortie

bias = ones(size(Xe,1),1);
Xe = [bias Xe];  % ajoute biaise b dans le premiere colonne qu'on suppose Xo=1
[N,E] = size(Xe);
[J,E] = size(Wje);
[S,J] = size(Wsj);


% Propagation d'un exemple

Alpha_j1 = Wje*Xe';  % colonne de Aj pour un exemple

% Zj = tanh(Alpha_j1);    % returns the hyperbolic tangent of one element of X
Zj =  sigmoid(Alpha_j1) ;    % returns the hyperbolic tangent of one element of X

Alpha_s2 = Wsj * [1 ; Zj ];  % ajouter 1 pour biase 

%% 
%  Ys = sigmoid(Alpha_s2);
Ys = softmax(Alpha_s2); % sum=1

% calculer les dérivés 
Zj = [1; Zj];

deriv_f1= Zj.*(1-Zj); % sigmoid
% deriv_f1 = 1-Zj.^2; %tanh
deriv_f2= Ys.*(1-Ys); % softmax et sigmoid

% deriv_f2 = divSoftmax(Ys,S);
end




function y = sigmoid(x)
    y =1./(1+exp(-x));
end


% softmax:
% y = softmax(n) = exp(n)/sum(exp(n));


function derive_softmax = divSoftmax(y,S)
I = eye(size(y,1));

for k = 1:S
    for j = 1:S
        if k==j
            derive_softmax(k) = y(k)*(1-y(j));
            break;
        else derive_softmax(k) = -y(k)*y(j);
            break;
        end
        %                     derive_softmax(k,j)= y(k)*(I(k,j)-y(j)) ;
    end
end
derive_softmax = derive_softmax';
end

%         deriv_tanh = 1-y.^2
