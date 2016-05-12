%% TP fusion d'information
% 5 classifiers
% 10 classes
% 10*1000 donnees chaque fichier,1000 éléments/classe

clc;
close all;
clear all;
addpath data

%% load data 

baseApp = cell(1,5);
baseTest = cell(1,5);
directer = [pwd '\data\'];
for i = 1:5
     filename_app = [directer 'cl', num2str(i), '.app.txt'];
     filename_test = [directer 'cl', num2str(i), '.test.txt'];
     baseApp{i} = data_reader( filename_app ); 
     baseTest{i} = data_reader( filename_test );  
end

etique = baseApp{1}(:,1);

% cl1_app = cell2mat(cl1_app);
N_element = size(etique,1);
N_classifier = 5;

%% calculer la performance de top1
tic
% RecoTop1 = nombre d'elements pour lesquels la bonne solution apparait en 1ere 
% proposition/  nombre total d'elements
for i = 1:5
    T_top1(:,i) = Top1_classifieur(baseApp{i} );
end
Ambi_top1  = T_top1(1,:);
Reco_top1 = T_top1(end,:);

for i = 1:5
%     fprintf('les taux de ambiguite des classifieurs %d pour top1 sont: %d \n' ,i, Ambi_top1(i)); 
    fprintf('les taux de rejet des classifieurs %d pour top1 sont: %d \n' ,i, Ambi_top1(i)); 
end

toc

coeffs_top1 = Reco_top1./(100-Ambi_top1);
wj = coeffs_top1./sum(coeffs_top1); 

%% calculer la performance de top5
for i = 1:5
    T_top5(:,i) = Top5( baseApp{i} );
end

Ambi_top5  = T_top5(1,:);
Reco_top5 = T_top5(end,:);

for i = 1:5
%     fprintf('les taux de ambiguite des classifieurs %d pour top1 sont: %d \n' ,i, Ambi_top1(i)); 
    fprintf('les taux de reco des classifieurs %d pour top1 sont: %d \n' ,i, Reco_top5(i)); 
end
disp(T_top5)
disp('----------------------------------------------------------------------------------')

coeffs_top5 = Reco_top5./(100-Ambi_top5);
wjTop5 = coeffs_top5./sum(coeffs_top5);


%% Méthodes de combinaison de type "Classe"--------------------------------------------
% 1.	Méthodes non paramétriques: vote à la pluralité et la majorite
% %  计算分别5个classifieur中每一行的结果计票 票数最大的为finale， 票数相同则rejet
% On ne prendra donc en compte ici que la première solution fournie par le classifieur 

resultat_M = [0 0 0];
resultat_P = [0 0 0];

for n =1:N_element
%  for n =9994:9999

    data = Matrice_Information(baseTest,n);
%    dataTest = Matrice_Information(baseTest,n);

   [decision_final_majorite(n) ,decision_final_pluralite(n), vote, M, P] ...
    = methodeClasseNonParametre( data,etique ,n);
    
    resultat_M = resultat_M + M;
    resultat_P = resultat_P + P;
    
end
figure;subplot(121);pie(resultat_M)
title('résultat pour la methode de vote a la majorité')
subplot(122);pie(resultat_P)
title('résultat pour la methode de vote a la pluralité')

tauxReco_M = resultat_M(1)/N_element;
fprintf('le taux de Reco pour la methode de vote a la majorite est %f \n' ,tauxReco_M );

tauxReco_P = resultat_P(1)/N_element;
fprintf('le taux de Reco pour la methode de vote a la pluralité est %f \n' ,tauxReco_P );
disp('----------------------------------------------------------------------------------')

% table_classe_vote = [classe, vote];
% %   
% 
%% 2.	Méthodes paramétriques ： Programmer l'opérateur "vote pondéré". 
% deterniner les poids des classifieurs sur leur base d'apprentissage respective 

% coeffs_top5 = Reco_top5./(100-Ambi_top5);
% wj = coeffs_top5./sum(coeffs_top5); 
% 
decision = [];
result = [0 0 0];

for n =1:N_element
% n =9525;

   % calculer le vote avec la ponderation
    [decision(n),result_element] = VotePondereeClasse( baseTest,n,wj );
%     [decision(n),result_element] = VotePondereeClasse( baseTest,etique,n,wj );

    % reconstruire la matrice de decision du classe 0-9 du classifieur 
     result = result + result_element;
end
result_taux = result./N_element;
fprintf('vote pondere: taux de correction: %f , le taux de rejet: %f \n' ,result_taux(1),result_taux(3) );
disp('----------------------------------------------------------------------------------')
figure;pie(result)
title('résultat pour la methode de vote pondere sur la base de test')

%% Méthodes de combinaison de type "Rang"----------------------------------------------
% 1. methode non parametrique : Programmer les opérateurs "borda count moyenne"

result_top1 = [ 0 0 0];
result_top5 = [ 0 0 0];
for n =1:N_element
    [ vote_rang, top1, top5 ] = BCmoyenne( baseApp,n );

    result_top1 = result_top1 + top1;
    result_top5 = result_top5 + top5;
  
end
result_top1
result_top5
fprintf('borda count moyenne:En Top1: taux de correction: %f , nombre de rejet: %d , fiabilide %f \n' ,result_top1(1)/N_element, result_top1(3), result_top1(1)/(N_element-result_top1(3)));
fprintf('borda count moyenne:En Top5: taux de correction: %f , nombre de rejet: %d ,fiabilide %f \n' ,result_top5(1)/N_element,result_top5(3),result_top5(1)/(N_element-result_top5(3)) );
fprintf('----------------------------------------------------------------------------------\n')
   
figure;subplot(121);pie(result_top1)
title('borda count moyenne en top1')
legend('reconnaissance','confusion','rejet')

subplot(122);pie(result_top5)
title('borda count moyenne en top5')
legend('reconnaissance','confusion','rejet')
%% methode non parametrique: meilleur rang
close all;
clc;

decisionMR = nan(N_element,5);
result_top1 = [ 0 0 0];
result_top5 = [ 0 0 0];

for n =1:N_element
    [ decisionMR,top1,top5 ]  = MeilleurRang( baseTest,n );
    result_top1 = result_top1 + top1;
    result_top5 = result_top5 + top5; 
end
result_top1
result_top5

fprintf('meilleur rang En Top1: taux de reconnaissance: %f , nombre de rejet: %d ,fiabilite %f\n' ,result_top1(1)/N_element, result_top1(3), result_top1(1)/(N_element-result_top1(3)) );
fprintf('meilleur rang En Top5: taux de reconnaissance: %f , nombre de rejet: %d , fiabilite %f\n' ,result_top5(1)/N_element, result_top5(3), result_top5(1)/(N_element-result_top5(3)) );
fprintf('----------------------------------------------------------------------------------\n')

figure;subplot(121);pie(result_top1)
title('meilleur rang en top1')
legend('reconnaissance','confusion','rejet')

subplot(122);pie(result_top5)
title('meilleur rang en top5')
legend('reconnaissance','confusion','rejet')

%% 2.	Méthodes paramétriques Programmer l'opérateur "somme pondérée"

SP_top1 = [ 0 0 0 ];
SP_top5 = [ 0 0 0 ];

for n =1:N_element
    [rang_SP(n,:),decision_SP, top1,top5]  = Rang_SP( baseTest,n,wjTop5 );
    SP_top1 = SP_top1 + top1;
    SP_top5 = SP_top5 + top5;  
end
fprintf('Somme ponderer En Top1: taux de reconnaissance: %f , nombre de rejet: %d \n' ,SP_top1(1)/N_element, SP_top1(3) );
fprintf('Somme ponderer En Top5: taux de reconnaissance: %f , nombre de rejet: %d \n' ,SP_top5(1)/N_element,SP_top5(3) );
fprintf('----------------------------------------------------------------------------------\n')

fprintf('taux fiabilite top1 %f',SP_top1(1)/(N_element-SP_top1(3)))
fprintf('taux fiabilite top5 %f \n',SP_top5(1)/(N_element-SP_top5(3)))

figure;subplot(121);pie(SP_top1)
title('somme pondere en top1')
legend('reconnaissance','confusion','rejet')

subplot(122);pie(SP_top5)
title('somme pondere en top5')
legend('reconnaissance','confusion','rejet')


%% Méthodes de combinaison de type "Mesure"--------------------------------------------
% 1.	Méthodes non paramétriques : somme
clc;close all;
produit_top1 = [ 0 0 0 ];
produit_top5 = [ 0 0 0 ];
somme_top1 = [ 0 0 0 ];
somme_top5 = [ 0 0 0 ];

for n =1:N_element
   [ decision_somme] = methodMesure( baseTest ,n ,wjTop5,'somme');
      [ resultSomme_top1,resultSomme_top5 ] = performance_top1top5( decision_somme,etique,n );
   somme_top1 = somme_top1 + resultSomme_top1;
   somme_top5 = somme_top5 + resultSomme_top5; 
   
   
    [ decision_produit] = methodMesure( baseTest ,n ,wjTop5,'produit');
    [ ptop1,ptop5 ] = performance_top1top5( decision_produit,etique,n );
    produit_top1 = produit_top1 + ptop1;
    produit_top5 = produit_top5 + ptop5; 
    
end

fprintf('Méthodes non paramétriques : somme\n')
fprintf(' En Top1: taux de reconnaissance: %f , nombre de rejet: %d \n' ,somme_top1(1)/N_element, somme_top1(3) );
fprintf(' En Top5: taux de reconnaissance: %f , nombre de rejet: %d \n' ,somme_top5(1)/N_element,somme_top5(3) );
fprintf('taux fiabilite en top1 %f , ',somme_top1(1)/(10000-somme_top1(3)))
fprintf('taux fiabilite en top5 %f \n',somme_top5(1)/(10000-somme_top5(3)))
fprintf('----------------------------------------------------------------------------------\n')

figure;subplot(221);pie(somme_top1)
title('operateur somme  en top1')
legend('reconnaissance','confusion','rejet')
subplot(222);pie(somme_top5)
title('operateur somme  en top5')
legend('reconnaissance','confusion','rejet')


fprintf('Méthodes non paramétriques : produit\n')
fprintf(' En Top1: taux de reconnaissance: %f , nombre de rejet: %d \n' ,produit_top1(1)/N_element, produit_top1(3) );
fprintf(' En Top5: taux de reconnaissance: %f , nombre de rejet: %d \n' ,produit_top5(1)/N_element,produit_top5(3) );
fprintf('taux fiabilite en top1 %f , ',produit_top1(1)/(10000-produit_top1(3)))
fprintf('taux fiabilite en top5 %f \n',produit_top5(1)/(10000-produit_top5(3)))
fprintf('----------------------------------------------------------------------------------\n')

subplot(223);pie(produit_top1)
title('operateur produit  en top1')
legend('reconnaissance','confusion','rejet')
subplot(224);pie(produit_top5)
title('operateur produit  en top5')
legend('reconnaissance','confusion','rejet')



%% 2.	Méthodes paramétriques
% Programmer les opérateurs "somme pondérée" et "produit prondéré". 
sommeP_top1 = [ 0 0 0];
sommeP_top5 = [ 0 0 0];
for n = 1:N_element
    decisionSommePond = methodMesure( baseTest,n,wjTop5 ,'SP' );
    [ resultSomme_top1,resultSomme_top5 ] = performance_top1top5( decisionSommePond,etique,n );
    sommeP_top1 = sommeP_top1 + resultSomme_top1;
    sommeP_top5 = sommeP_top5 + resultSomme_top5; 

end
sommeP_top1
sommeP_top5
fprintf('Méthodes paramétriques : somme pondérée\n')
fprintf(' En Top1: taux de reconnaissance: %f , nombre de rejet: %d \n' ,sommeP_top1(1)/N_element, sommeP_top1(3) );
fprintf(' En Top5: taux de reconnaissance: %f , nombre de rejet: %d \n' ,sommeP_top5(1)/N_element,sommeP_top5(3) );
fprintf('taux fiabilite en top1 %f , ',sommeP_top5(1)/(10000-sommeP_top1(3)))
fprintf('taux fiabilite en top5 %f \n',sommeP_top5(1)/(10000-sommeP_top5(3)))
fprintf('----------------------------------------------------------------------------------\n')

figure;subplot(221);pie(sommeP_top1)
title('operateur somme pondere en top1')
legend('reconnaissance','confusion','rejet')
subplot(222);pie(sommeP_top5)
title('operateur somme pondere  en top5')
legend('reconnaissance','confusion','rejet')



%% 
PP_top1 = [ 0 0 0];
PP_top5 = [ 0 0 0];
for n = 1:N_element
    decisionProduitPond = methodMesure( baseTest,n,wjTop5 ,'PP' );
    [ resultPP_top1,resultPP_top5 ] = performance_top1top5( decisionProduitPond,etique,n );
    PP_top1 = PP_top1 + resultPP_top1;
    PP_top5 = PP_top5 + resultPP_top5; 

end
PP_top1
PP_top5

fprintf('Méthodes paramétriques : produit pondérée\n')
fprintf(' En Top1: taux de reconnaissance: %f , nombre de rejet: %d \n' ,PP_top1(1)/N_element, PP_top1(3) );
fprintf(' En Top5: taux de reconnaissance: %f , nombre de rejet: %d \n' ,PP_top5(1)/N_element,PP_top5(3) );
fprintf('taux correction en top1 %f , ',PP_top1(1)/(10000-PP_top1(3)))
fprintf('taux correction en top5 %f \n',PP_top5(1)/(10000-PP_top5(3)))
fprintf('----------------------------------------------------------------------------------\n')

subplot(223);pie(PP_top1)
title('operateur produit pondere  en top1')
legend('reconnaissance','confusion','rejet')
subplot(224);pie(PP_top5)
title('operateur produit pondere  en top5')
legend('reconnaissance','confusion','rejet')

