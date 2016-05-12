% Step1: reading Data from the file
clc;
clear all;
close all

% load diabetes
pima = load('pima.mat');
%%
% Step2: splitting data to training and control set
TrainData   = pima.x(1:2:end,:)';
TrainLabels = pima.y(1:2:end,:)';

ControlData   = pima.x(2:2:end,:)';
ControlLabels = pima.y(2:2:end,:)';

%% Step3: constructing weak learner
weak_learner = tree_node_w(3); % pass the number of tree splits to the constructor

% Step4: training with Real AdaBoost
[RLearners RWeights] = RealAdaBoost(weak_learner, TrainData, TrainLabels, 50);

% Step5: training with Modest AdaBoost
[MLearners MWeights] = ModestAdaBoost(weak_learner, TrainData, TrainLabels, 50);

% Step6: evaluating on control set
ResultR = sign(Classify(RLearners, RWeights, ControlData));

ResultM = sign(Classify(MLearners, MWeights, ControlData));

% Step7: calculating error
ErrorR  = sum(ControlLabels ~= ResultR)

ErrorM  = sum(ControlLabels ~= ResultM)