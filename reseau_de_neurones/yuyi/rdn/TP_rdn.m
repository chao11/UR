%% Réseaux de neuronnes : MLP(Multi-Layer Perceptron)
clear all;
close all;

% Prétraitement de données : letter.mat
load('letter.mat');
X = data(:,1:16);
y = data(:,17);

% Centré-réduire X
X = standardizeCols(X);
% Split data en 3 parties : p.apprentissage,p.validation,p.test
[Xapp, yapp, Xreste, yreste] = splitdata(X, y, 0.2);
[Xval, yval, Xtest, ytest] = splitdata(Xreste, yreste, 0.5);

% Construire le réseaux de neuronnes avec une couche cachée
%nb d'entrée : dimension du problème
E=16;
%nb de sortie = nb de classe
S=26;
%nb de neuronne dans la couche caché (linéairement: fonctionne bien, expérimental)
J=35;

[n,p]=size(Xapp);
[nv,pv]=size(Xval);
[nt,pt]=size(Xtest);


%% Apprentissage sur Xapp
% Initialiser les wje et wsj : valeurs entre -1 et 1 au harsard pour éviter
% la saturation
J=35;
pas=0.1;
N=1000;
Wje = initialiserW(J,E);
Wsj = initialiserW(S,J);
Erreur=zeros(1,N);
Erreurv=zeros(1,N);

i=1;
seuil=0.00001;
while (i<=3|| Erreur(i-2)-Erreur(i-1)>seuil || Erreur(i-3)-Erreur(i-2)>seuil ||  Erreurv(i-2)-Erreurv(i-1)>seuil || Erreurv(i-3)-Erreurv(i-2)>seuil)
    fprintf('\niteration : %d', i);
    [ Wje,Wsj] = updateW(Xapp,yapp,Wje,Wsj,pas);
    Ylab=compute(Xapp,Wje,Wsj);
    Ylabv=compute(Xval,Wje,Wsj);
    err=length(find(Ylab~= yapp+1));
    errv=length(find(Ylabv~=yval+1));
    Erreur(i)=err/n; 
    Erreurv(i)=errv/nv;
    fprintf('	erreur : %f\n', err/n);
    i=i+1;
end

N=length(find(Erreur~=0));
figure(2);
plot(1:N,Erreur(1:N),'b');
hold on;

plot(1:N,Erreurv(1:N),'r');
title('Evolution du taux d''erreur : pas=0.1|J=35|seuil=0.00001');

%% Tester sur Xtest
% Initialiser les wje et wsj : valeurs entre -1 et 1 au harsard pour éviter
% la saturation
J=35;
pas=0.1;
N=1000;
Wje = initialiserW(J,E);
Wsj = initialiserW(S,J);
Erreur=zeros(1,N);
Erreurv=zeros(1,N);

i=1;
seuil=0.00001;
while (i<=3|| Erreur(i-2)-Erreur(i-1)>seuil || Erreur(i-3)-Erreur(i-2)>seuil ||  Erreurv(i-2)-Erreurv(i-1)>seuil || Erreurv(i-3)-Erreurv(i-2)>seuil)
    fprintf('\niteration : %d', i);
    [ Wje,Wsj] = backprop(Xtest,ytest,Wje,Wsj,pas);
    Ylab=compute(Xtest,Wje,Wsj);
    err=length(find(Ylab~= ytest+1));
    Erreur(i)=err/nt; 
    fprintf('	erreur : %f\n', err/nt);
    i=i+1;
end
N=length(find(Erreur~=0));
figure (3);
plot(1:N,Erreur(1:N));
title('Base test : Evolution du taux d''erreur ,pas=0.1|J=35');
%% Amélioration -apprentissage stochastique
J=35;
pas=0.1;
N=3000;
Wje = initialiserW(J,E);
Wsj = initialiserW(S,J);
Erreur=zeros(1,N);
Erreurv=zeros(1,N);

i=1;
m=10;
for i=1:N
    fprintf('\niteration : %d', i);
    tmpWje={};
    tmpWsj={};
    tmperr=[];
    for j=1:m
        indices = randperm(n,20);
        [ Wjet,Wsjt] = backprop(Xapp(indices,:),yapp(indices),Wje,Wsj,pas);
        tmpWje{j}=Wjet;
        tmpWsj{j}=Wsjt;
        Ylab=compute(Xapp(indices,:),Wjet,Wsjt);
        err=length(find(Ylab~= yapp(indices)+1))/20;
        tmperr=[tmperr,err];
    end
    indice=find(tmperr==min(tmperr),1);
    err=tmperr(indice);
    Wje=tmpWje{indice};
    Wsj=tmpWsj{indice};
    Ylab=compute(Xapp,Wje,Wsj);
    err=length(find(Ylab~= yapp+1));
    Ylabv=compute(Xval,Wje,Wsj);
    errv=length(find(Ylabv~=yval+1));
    Erreur(i)=err/n; 
    Erreurv(i)=errv/nv;
    fprintf('	erreur : %f\n', err/n);
end
%%
N=length(find(Erreur~=0));
figure(3);
plot(1:N,Erreur(1:N),'b');
hold on;

plot(1:N,Erreurv(1:N),'r');
title('Evolution du taux d''erreur : pas=0.1|J=35|seuil=0.00001');