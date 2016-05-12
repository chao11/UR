%% satimag
clc;
close all;
clear all;

addpath data
satimag = load('satimage.mat');
Xtr = satimag.xapp;
Ytr = satimag.yapp;
Classe =  length(unique(satimag.y));

Xtest = satimag.xtest;
Ytest = satimag.ytest;
N_test = size(Xtest,1);
N_tr =  size(Xtr,1);

%% sans bagging 
k = 1;
predit_tous = KNN( Xtr,Ytr,Xtest,1 );
correct = sum(predit_tous==Ytest)/N_test;
fprintf('le taux de correction avant la methode bagging KNN pour k = %d est %f\n', k,correct);
%% avec bagging
L = 30;
for m = 1:L
    
    indices = randsample(N_tr,N_tr,1);
    Xtrnew = Xtr(indices,:);
    Ytrnew = Ytr(indices);
%     learn(:,m) = KNN( Xtrnew,Ytrnew,Xtrnew,k );
    predit(:,m) = KNN( Xtrnew,Ytrnew,Xtest,k ); 
    error_te(m) = sum(predit(:,m)~=Ytest)/N_test;

end
% décision avec le vote majorité
% [ decision ] = decision_2classe( predit ,L); 
 decision = VoteMaj( predit, Classe,L );
decision = decision';
 % calculer le taux de correction 
T_corrct = sum(decision ==Ytest)/N_test;
T_ambi = sum(decision' ==0)/N_test; 
fprintf('le taux de correction pour la methode bagging KNN pour k = %d est %f, taux de ambi %f \n' ,k, T_corrct, T_ambi);

figure;
plot(1:L, error_te)
title('error de chaque iteration') 


