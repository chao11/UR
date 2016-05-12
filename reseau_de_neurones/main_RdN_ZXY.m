%% --- TP : Réseau de neurones sous matlab ------------------------------ %
% Introduction
% Ce TP a pour but de vous faire développer un réseau de neurones à une
% couche cachée et d'apprendre son apprentissage
clc;
clear all;
close all;

% ajouter l'emplacement
% directory = pwd;
% addpath([directory '\data']);
addpath datasets

% ajouter les données
% load iris.mat;
% load letter.mat;
% load pendigits.mat;
% load segment.mat;
% load vehicle.mat;
% load waveform.mat;
% load mnist_all.mat;

%% --- Travail à faire : MLP -------------------------------------------- %
% ----------------------------------------------------------------------- %
% DATA : letter.mat
% ----------------------------------------------------------------------- %

% --- Transformer le fichier .mat en matrice X et Y --------------------- %
lettre = load('letter.mat');
X = lettre.data(:,1:size(lettre.data, 2)-1);
Y = lettre.data(:,size(lettre.data, 2));

% lettre = load('iris.mat');
% X = lettre.data(:,1:size(lettre.data, 2)-1);
% Y = lettre.data(:,size(lettre.data, 2));


% --- sample d'entrée --------------------------------------------------- %
% on choisit 1/2 pour apprendre, 1/4 pour valider, 1/4 pour tester
% performance de notre système
nb_donnee = size(lettre.data,1);
nb_app = nb_donnee/2;

% construire un réseau à E entrées, J neurones en couche cachée
e = size(lettre.data, 2)-1;
% nombre de neurones caché
j = 30;
s = 26; % une seule sortie

% --- initialisation des poids ------------------------------------------ %
% on prend des valeurs au hasaed entre -1 et 1 pour éviter les problèmes de
% saturation
W_je = (rand(j, e)-0.5)*2;
W_sj = (rand(s, j)-0.5)*2;

% définition des formules
sigmoid =@(x)1./(1+exp(-x));
div_sigmoid = @(x)(1+exp(-x)).^-2.*exp(-x);
% maxsoft =@(x1, x2)exp()/exp(x2);

%% --- partie d'apprentissae -------------------------------------------- %
% pour tous les entrées d'apprentissage
iter_max = 10000;
iter = 1;
erreur_app = [];
erreur_app(1) = 1;
pas = 0.001;

while (erreur_app(iter) > 0.4 && iter < iter_max)
    iter = iter +1;
    fprintf('\niteration : %d', iter);
    for i = 1:nb_app
        Yd = zeros(s,1);
        Yd(Y(i)+1) = 1;
        % calcul de z
        alpha1 = W_je*X(i,:)';
        z = sigmoid(alpha1);
        
        % pour chaque neurone
        alpha2 = W_sj*z;
        
        % softmax
%         Ys = alpha2./sum(alpha2, 1);

        % sigmoïde
        Ys = sigmoid(alpha2);
        
        % calcul des erreurs (Backpropagation)
%         erreur_s = (Yd-Ys).*exp(alpha2)/sum(alpha2,1);
        erreur_s = (Yd-Ys).*div_sigmoid(alpha2);
        %     erreur_j = -sum(Yd-Ys,1).*exp(alpha2)/sum(alpha2,1).*W_sj*W_je'*alpha1;
        erreur_j = W_sj'*((Yd-Ys).*div_sigmoid(alpha2)).*div_sigmoid(alpha1);
        
        % mettre à jour les matrice W_je & W_sj
        temp = zeros(size(W_sj));
        for m = 1:s
            temp(m, :) = z'*erreur_s(m)*pas;
        end
        W_sj = W_sj + temp;
        
        temp = zeros(size(W_je));
        for m = 1:j
            temp(m, :) = X(i, 1:e)*erreur_j(m)*pas;
        end
        W_je = W_je + temp;
    end
    
    erreur_temp = 0;
    for i = 1:nb_app
        alpha1 = W_je*X(i,:)';
        z = sigmoid(alpha1);
        
        % pour chaque neurone
        alpha2 = W_sj*z;
        
        % softmax
%         Ys = alpha2./sum(alpha2, 1);
        Ys = sigmoid(alpha2);
        
        if find(max(Ys) == Ys) ~= Y(i)+1
            erreur_temp = erreur_temp + 1;
        end
        
    end
    erreur_app(iter) = erreur_temp/nb_app;
    fprintf('iteration : %d erreur : %f\n',iter, erreur_app(iter));
end






