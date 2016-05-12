%% pima trheshold+ adaboost


clc;
close all;
clear all;

pima = load('pima.mat');

[Nb_sample,attribut] = size(pima.x);
a0=floor(Nb_sample/3);
tr_n = a0*2;
te_n = Nb_sample-tr_n;

% change label de label:1, 'neg' , label:2, 'pos',
pima.y(pima.y == 1)=2;
pima.y(pima.y ==-1)=1;

tr_set = pima.x(1:tr_n,:);
tr_labels = pima.y(1:tr_n);
train = [tr_set,tr_labels];

te_set = pima.x(tr_n+1:end,:);
te_labels = pima.y(tr_n+1:end );
test = [te_set, te_labels];


%% satimag
% satimag = load('satimage.mat');
% tr_set = satimag.xapp;
% Classe =  length(unique(satimag.y));
% 
% % label 1 et 2 one-to-all
% tr_labels  = ones(size(satimag.yapp,1),Classe);
% te_labels  = ones(size(satimag.ytest,1),Classe);
% 
% for c = 1:Classe
%     [idx,~] = find(satimag.yapp==c);
%     tr_labels(idx,c) = 2;
%     
%     [idx,~] = find(satimag.ytest==c);
%     te_labels(idx,c) = 2;
% end


%%
 weak_learner_n = 30;

% Training and testing error rates
tr_error = zeros(1,weak_learner_n);
te_error = zeros(1,weak_learner_n);

for i=1:weak_learner_n
	adaboost_model = ADABOOST_tr(@threshold_tr,@threshold_te,tr_set,tr_labels,i);
	[L_tr,hits_tr] = ADABOOST_te(adaboost_model,@threshold_te,tr_set,tr_labels);
	tr_error(i) = (tr_n-hits_tr)/tr_n;
	[L_te,hits_te] = ADABOOST_te(adaboost_model,@threshold_te,te_set,te_labels);
	te_error(i) = (te_n-hits_te)/te_n;
end

figure;

subplot(1,2,1); 
plot(1:weak_learner_n,tr_error);
axis([1,weak_learner_n,0,1]);
title('Training Error');
xlabel('weak classifier number');
ylabel('error rate');
grid on;

subplot(1,2,2); axis square;
plot(1:weak_learner_n,te_error);
axis([1,weak_learner_n,0,1]);
title('Testing Error');
xlabel('weak classifier number');
ylabel('error rate');
grid on;

