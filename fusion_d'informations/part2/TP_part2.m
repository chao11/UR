%% bagging boosting RSM  pour ler données pima

clc;
close all;
clear all;

addpath data
pima = load('pima.mat');

%% séparer les donées 
[Nb_sample,attribut] = size(pima.x);
a0=floor(Nb_sample/3);
N_tr = a0*2;
N_test = Nb_sample-N_tr;

% change label 
% pima.y(pima.y ==-1)=2;

Xtr = pima.x(1:N_tr,:);
Ytr = pima.y(1:N_tr);
train = [Xtr,Ytr];

Xtest = pima.x(N_tr+1:end,:);
Ytest = pima.y(N_tr+1:end );
test = [Xtest, Ytest];

%% pima bagging -kppv, L=10
K = [1 5 7 15];
L = 30; % iteration L

learn = zeros(N_tr,L);

for k = 1:4
    
    predit_tous(:,k) = KNN( Xtr,Ytr,Xtest,K(k) );
    correct(k) = sum(predit_tous(:,k)==Ytest)/N_test;
    fprintf('le taux de correction avant la methode bagging KNN pour k = %d est %f\n' ,K(k),correct(k));
    
    for m = 1:L
        indices = randsample(N_tr,N_tr,1);
        Xtrnew = Xtr(indices,:);
        Ytrnew = Ytr(indices);
    %     learn(:,m) = KNN( Xtrnew,Ytrnew,Xtrnew,k );
        predit(:,m) = KNN( Xtrnew,Ytrnew,Xtest,K(k) ); 
        error_te(m) = sum(predit(:,m)~=Ytest)/N_test;

    end
    % décision avec le vote majorité
    [ decision ] = decision_2classe( predit ,L); 
    % calculer le taux de correction 
    T_corrct = sum(decision ==Ytest)/N_test;
    T_ambi = sum(decision' ==0)/N_test; 
    fprintf('le taux de correction pour la methode bagging KNN pour k = %d est %f, taux de ambi %f \n' ,K(k), T_corrct, T_ambi);

    figure;
    plot(1:L, error_te)
    title('error de chaque iteration') 
end
%% bagging -SVM, L=10
 SVMStruct_sansBag= svmtrain(Xtr,Ytr);
 decision_sansBag = svmclassify(SVMStruct_sansBag,Xtest);
 error_test = 1- sum(decision_sansBag==Ytest)/N_test;
 fprintf('l''erreur de SVM sans bagging est %f,\n' ,error_test);

L = 10;

for m = 1:L
    indices = randsample(N_tr,N_tr,1);
    SVMStruct(m)= svmtrain(Xtr(indices,:),Ytr(indices));
    Group(:,m) = svmclassify(SVMStruct(m),Xtest);
    error_test(m) = 1- sum(Group(:,m)==Ytest)/N_test;
    fprintf('l''erreur de SVM sur la base de test est %f,\n' ,error_test);

end

[ decisionSVM ] = decision_2classe( Group ,L);
T_corrct = sum(decisionSVM ==Ytest)/N_test;
T_ambi = sum(decisionSVM' ==0)/N_test;
fprintf('le taux de correction pour la methode bagging est %f, taux de ambi %f \n' ,T_corrct, T_ambi);

figure;
plot(1:L, error_test)
title('erreur de chaque iteration de SVM bagging pour PIMA')

%% RSM - kppv L = 10,P=3
p = 3;
L = 10;
% k = 1;
% predit_tous = KNN( Xtr,Ytr,Xtest,1 );
% correct = sum(predit_tous==Ytest)/N_test;
% fprintf('le taux de correction avant la methode bagging KNN pour k = %d est %f\n' ,k,correct);
error_te = [];
% k = 1;
for m = 1:L
    indices = randsample(size(Xtr,2),p);
    Xtrnew = Xtr(:,indices);
    Ytrnew = Ytr;
    
%     for k = 1:10
%         learn2(:,k) = KNN( Xtrnew,Ytrnew,Xtrnew,k );
%         error_tr(m,k) = sum(learn2(:,k)~=Ytr)/N_tr;
% %     end
%     [~,kmin(m)]=min(error_tr(m,:));
    
    test2(:,m) = KNN( Xtrnew,Ytrnew,Xtest(:,indices),5 );
    error_te(m) = sum(test2(:,m)~=Ytest)/N_test;
end

[ decision2 ] = decision_2classe( test2 ,L);
T_corrct = sum(decision2 ==Ytest)/N_test;
T_ambi = sum(decision2 ==0)/N_test;

figure;
plot(1:L, error_te)

fprintf('le taux de correction pour la methode RSM est %f,\n taux de ambi %f \n' ,T_corrct, T_ambi);


%% ----------------------------------------------------------------------------
% Pima adaboost knn
L = 10;

N_tr = size(Xtr,1);
samples_weight = [];
samples_weight(:,1) = ones(N_tr,1)/N_tr;
Alpha = zeros(L,1);


for i= 1:L
    % train a classifier:
    train(:,i) = KNN( Xtr,Ytr,Xtr,5 );
    [idx,~] = find(train(:,i)~=Ytr);
    error(i) = sum(samples_weight(idx,i));

 Alpha(i) = 0.5 * log((1-error(i))/ error(i));
 % update W
 samples_weight(idx,i+1) = samples_weight(idx,i)*exp(- Alpha(i));
 idx_correct = setdiff( 1:512 ,idx);
 samples_weight(idx_correct,i+1) = samples_weight(idx_correct,i)*exp(Alpha(i));

 samples_weight(:,i+1) = samples_weight(:,i+1)/sum(samples_weight(:,i+1));
 
 Alpha = Alpha/sum(Alpha);

 test(:,i) = KNN( Xtr,Ytr,Xtest,5 );
 
 decision = sign(test(1:end,:)*Alpha);
 
error_Adaboost(i) = sum(decision==Ytest)/N_test;


end 

plot(1:L,error_Adaboost); 

 
% decision = sign(test(1:end,:)*Alpha);
%  
% error_Adaboost = sum(decision==Ytest)/N_test;

%% adaboost threshold
L = 10;
for i = 1:L
    adaboost_model  = ADABOOST_tr( @threshold_tr,@threshold_te,Xtr, Ytr ,i );
    
    [L_tr,hits_tr] = ADABOOST_te(adaboost_model,@threshold_te,Xtr,Ytr);
    
    tr_error(i) = (N_tr-hits_tr)/N_tr;
    [L_te,hits_te] = ADABOOST_te(adaboost_model,@threshold_te,Xtest,Ytest);
    te_error(i) = (N_test-hits_te)/N_test;


end

figure;
subplot(2,1,1); 
plot(1:L,tr_error); 
axis([1,L,0,1]); 
title('Training Error'); 
xlabel('weak classifier number'); 
ylabel('error rate'); 
grid on; 

subplot(2,1,2); axis square; 
plot(1:L,te_error); 
axis([1,L,0,1]); 
title('Testing Error'); 
xlabel('weak classifier number'); 
ylabel('error rate'); 
grid on;
  

