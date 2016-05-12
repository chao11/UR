
%%%%%% examples of ensemble strategy (skymss0828@gmail.com,2011.3.12)%%%%%%

clc;
clear;

load blfbreast.mat; %%% input the dataset;
data = [breastsamples,breastlabels];
numbertrn = 100; % the number of training samples;
trainX = data(1:numbertrn,1:end-1);% the training samples;
trainY = data(1:numbertrn,end); % the labels of training samples;
testX = data(1+numbertrn:end,1:end-1);%the testing samples;
testY = data(1+numbertrn:end,end); % the ideal labels of testing samples;
numbertst = size(testY,1);
numberclass = unique(data(:,end));

enway = 1; % the way of ensemble strategy; 
r = 0.75; % the ratio of sampling in ensemble methods
K = 3; % the parameter of Rotation Forest;

L = 15; % the number of ensemble individuals;
for l = 1:L
    [trainXsub,trainYsub,testXnew,trainXnew,trainYnew] = getsubset(trainX,trainY,testX,enway,r,K);
    
    %%%% using the learners to  obtain ensemble individuals %%
    % preY(:,l) = learner(trainXsub,trainYsub,testXnew,parameterL);
    k = 5;
    preY(:,l) =  Nearest_Neighbor(trainXsub,trainYsub,testXnew, k);     
end
%%%% combining the results of ensemble individuals %%%
for i = 1:numbertst
    for c = 1:length(numberclass)
        index(i,c) = length(find(preY(i,:)==c));
    end
    [value(i,:),prelabel(i,:)] = max(index(i,:));
end
%%% output the final result of ensemble %%%
preYen=prelabel; 
