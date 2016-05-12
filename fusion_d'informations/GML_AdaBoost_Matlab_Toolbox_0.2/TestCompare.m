MaxIter = 60; % boosting iterations
CrossValidationFold = 3; % number of cross-validation folds

load ionosphere

weak_learner = tree_node_w(3); % constructing weak learner

% initializing matrices for storing step error
RAB_control_error = zeros(1, MaxIter);
MAB_control_error = zeros(1, MaxIter);

x = 0:0.01:1;

% constructing object for cross-validation
CrossValid = crossvalidation(CrossValidationFold); 

% initializing it with data
CrossValid = Initialize(CrossValid, FullData, FullLabels);

NuWeights = [];

% for all folds
for n = 1 : CrossValidationFold    
    TrainData = [];
    TrainLabels = [];
    ControlData = [];
    ControlLabels = [];
    
    % getting current fold
    [ControlData ControlLabels] = GetFold(CrossValid, n);
    
    % concatinating other folds into the training set
    for k = 1:CrossValidationFold
        if(k ~= n)
            [TrainData TrainLabels] = CatFold(CrossValid, TrainData, TrainLabels, k); 
        end
    end
        
    Learners = [];
    Weights = [];
    NuLearners = [];
    NuWeights = [];
    
    MA_final_hyp = TrainLabels.*0;
    RE_final_hyp = TrainLabels.*0;
    
    %training and storing the error for each step
    for lrn_num = 1 : MaxIter

        clc;
        disp(strcat('Cross-validation step: ',num2str(n), '/', num2str(CrossValidationFold), '. Boosting step: ', num2str(lrn_num),'/', num2str(MaxIter)));
        
        [Learners Weights RE_final_hyp] = GentleAdaBoost(weak_learner, TrainData, TrainLabels, 1, Weights, Learners, RE_final_hyp);
        
        Control = sign(Classify(Learners, Weights, ControlData));
        
        RAB_control_error(lrn_num) = RAB_control_error(lrn_num) + sum(Control ~= ControlLabels) / length(ControlLabels); 

        [NuLearners NuWeights MA_final_hyp] = ModestAdaBoost(weak_learner, TrainData, TrainLabels, 1, NuWeights, NuLearners, MA_final_hyp);

        NuControl = sign(Classify(NuLearners, NuWeights, ControlData));
               
        MAB_control_error(lrn_num) = MAB_control_error(lrn_num) + sum(NuControl ~= ControlLabels) / length(ControlLabels);
                
    end    
end

% displaying graphs
figure, plot(RAB_control_error / CrossValidationFold );
hold on;
plot(MAB_control_error / CrossValidationFold , 'r');
hold off;

legend('Gentle AdaBoost', 'Modest AdaBoost');
title(strcat('UCI ',name, ' Dataset -',' ', num2str(CrossValidationFold), ' fold cross-validation'));
xlabel('Iterations');
ylabel('Test Error');