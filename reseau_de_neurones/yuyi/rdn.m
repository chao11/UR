% Réseaux de neuronnes : MLP(Multi-Layer Perceptron)
clear all;
close all;

%% Prétraitement de données : letter.mat
load('letter.mat');
X = data(:,1:16);
y = data(:,17);
% Centré-réduire X
X = standardizeCols(X);
% Split data en 3 parties : p.apprentissage,p.validation,p.test
% [Xapp, yapp, Xreste, yreste] = splitdata(X, y, 0.2);
% [Xval, yval, Xtest, ytest] = splitdata(Xreste, yreste, 0.5);

[ train,test,valid ] = splitData( data );
Xapp = train(:,1:end-1);
yapp = train(:,end);

% 
%% Construire le réseaux de neuronnes avec une couche cachée
%nb d'entrée : dimension du problème
E=16;
%nb de sortie = nb de classe
S=26;
%nb de neuronne dans la couche caché (linéairement: fonctionne bien, expérimental)
J=round((E+S)/2);

[n,p]=size(Xapp);
% Initialiser les wje et wsj : valeurs entre -1 et 1 au harsard pour éviter
% la saturation
Wje = initialiserW(J,E);
Wsj = initialiserW(S,J);

%Paramétrage : pas, seuil, nbItération
pas=0.00001;
seuil=0.5;
N=500;

%Initialisation
Wje = initialiserW(J,E);
Wsj = initialiserW(S,J);
[Y,Z]=compute(Xapp,Wje,Wsj);
Ylab= getYlabel(Y);
errorApp=norm(yapp-Ylab);

%%
for i=2:100
    [ERRk,ERRj] = errorDataset(yapp,Y,Z,Wje,Wsj);
    GradW2 = Z'* ERRk ;
    GradW1 = [Xapp ones(n,1)]'* ERRj ;

    Wje = Wje-pas.*GradW1';     
    Wsj = Wsj-pas.*GradW2';
  
    [Y,Z]=compute(Xapp,Wje,Wsj);
    Ylab= getYlabel(Y);
    err = norm(yapp-Ylab);
    errorApp=[errorApp,norm(yapp-Ylab)];
end
%%
figure;
plot(1:length(yapp),yapp,'r');
hold on;
plot(1:length(yapp),Ylab,'b');

%%
figure(1)
plot(1:length(errorApp),errorApp,'-');

