%% Tp RdN
% Ce TP a pour but de vous faire développer un réseau de neurones ¨¤ une couche
% cachée et d'apprendre ¨¤ contrôler son apprentissage.
% On se propose d'utiliser des données de bases étiquetées connues disponible sur
% le site de l'UCI.

%% load data
clc; clear all; 
% close all;

addpath datasets

%% LETTER / definir les bases d'app et base de test
%{
% load('letter.mat');
% %% normaliser entre [0 1] 
% Xcentra = stantard(data(:,1:end-1)); % entre [0 1]
% centralie = 'centra reduit';
% data = [Xcentra data(:,end)];
% 
% % split data en 3 base et 
% [ train,test,valid ] = splitData( data ); 
% 
% Xtr= train(:,1:end-1);
% Ytr = train(:,end);
% 
% Xvalid = valid(:,1:end-1);
% Yvalid = valid(:,end);
% 
% Xtest = test(:,1:end-1);
% Ytest = test(:,end);
%}
%% load IRIS 
load('iris.mat');

Xcentra = stantard(data(:,1:end-1)); % entre [0 1]
centralie = 'centra reduit';
data = [Xcentra data(:,end)];

%  centralie = 'non centra reduit';

[ Xtr,Ytr,Xvalid,Yvalid,Xtest,Ytest ] = splitIris( data );


%% Première implémentation du réseau------------------------------------------------
validElem = size(Yvalid,1);
testElem = size(Ytest,1);
[trElement, E ] = size(Xtr);


% Construire un réseau  E entrées, J neurones en couche cachée, et 10 sorties.
S = length(unique(Ytr));
% J = round((E+S)/2);  % nombre de neurones en couche cachée,
J = 20;
%% Définir les vecteurs de poid wji et wkj et les initialiser au hasard.
%   Wh: Hidden layer weight matrix. Wx is a (J * e+1) dimensional matrix.
%   Ws: Output layer weight matrix. Wy is a (S * J+1) dimensional matrix.
% initialiser entre -1 et 1
Wje = [];
Wsj = [];

% avec biais 
Wje(:,:,1) = (rand(J, E+1)-0.5)*2;
Wsj(:,:,1) = (rand(S, J+1)-0.5)*2;

%  pour un exemple
pas = 0.1;
iter_max= 1000;
erreur = [];
erreur(1:2,1)=1;
iter = 1;
Yd = zeros(S,1);
tic
while (erreur(2,iter) > 0.3 && iter < iter_max )
 
%     error_app = 0;
    
    for n = 1:trElement
        
        Yd(Ytr(n)+1) = 1; 
        % Compute Z(n) and y(n)
        % f1 sigmoid f2 softmax
        [ y,zj,Alpha_j1,Alpha_s2,deriv_f1, deriv_f2] = compute( Xtr(n,:),Wje(:,:,iter),Wsj(:,:,iter) );
        
        [~,idx] = max(y);
        Ytrain_predit(n) = idx-1;
        
        % compute error
%         ERRs = -(Yd-y).*deriv_f2; % for sigmoid output
        
        ERRs = (Yd-y); % for softmax 

%         ERRj = (ERRs'*Wsj(:,1:end))'.*deriv_f1;
        ERRj = -((Yd-y).*deriv_f2)'*Wsj(:,:,iter).*deriv_f1';
        ERRj = ERRj(2:end)';
                    
        % mis à jour les poids
        for s = 1:S
            delta_Wsj(s,:) = pas*ERRs(s)*zj';
        end  
        Wsj(:,:,iter+1) = Wsj(:,:,iter) + delta_Wsj;
        
        for j = 1:J
            delta_Wje(j,:) = pas*ERRj(j)*[1 Xtr(n,:)]';
        end
        Wje(:,:,iter+1) = Wje(:,:,iter) + delta_Wje;     
 
    end
    
    erreur(1,iter) = sum(Ytrain_predit'~=Ytr)/trElement;
    fprintf('iteration : %d, erreur d''apprentissage : %f , ', iter, erreur(1,iter));

%     Mtr = confusion(Ytr,Ytrain_predit');
%     erreur(1,iter)=1-(sum(diag(Mtr))/sum(Mtr(:)));
    
    
   %% applique les nouveaux W sur la base de validation 
   iter = iter +1;

    for n = 1:validElem
        [ y,zj,~,~,~,~] = compute( Xvalid(n,:),Wje(:,:,iter),Wsj(:,:,iter) );
        [~,idx] = max(y);
        Yvalid_predit(n) = idx-1;
        
    end
    
%     Mvalid= confusion(Yvalid,Yvalid_predit');    
%     erreur(2,iter)=1-(sum(diag(Mvalid))/sum(Mvalid(:)));

erreur(2,iter) = sum(Yvalid_predit'~=Yvalid)/validElem;
%     mse(iter) = mean(mean(error.^2));
fprintf('erreur de validation : %f\n', erreur(2,iter));

   
   
end


toc 

% cherche les W valid et appliquer sur la base de test
[errMin, minidx] = min(erreur(2,:));

for n = 1:testElem
    
    [ y,zj,~,~,~,~] = compute( Xtest(n,:),Wje(:,:,minidx),Wsj(:,:,minidx) );
    [~,idx] = max(y);
    Ytest_predit(n) = idx-1;
    
end

erreur_test = sum(Ytest_predit'~=Ytest)/testElem;
%     mse(iter) = mean(mean(error.^2));
fprintf('erreur de test : %f\n',erreur_test);

% plot resultat
figure;
plot(erreur(1,1:end-1),'g')
hold on
plot(erreur(2,:),'b')
legend('erreur apprentissage',  'erreur de validation')
title(['data ' centralie ', J = ' num2str(J) ', pas=' num2str(pas) ', erreur de test: ' num2str(erreur_test) ])


