
%%% using the ensemble strategy to gain the subset of individual classifiers  %%%%
function  [Asub,labelsub,targetnew,Anew,labelTnew]=getsubset(A,labelT,target,enway,r,K,selectway,classlabel,numbernot,Tclass)

%%%%%%%%%% skymss. 2011.3.10 (skymss0828@gmail.com) %%%%%%%%%%%%
% getsubset: obtain the sub-training set of individual by ensemble strategy;
%
% Usage: [Asub,labelsub,dataset,datalabel]=getsubset(A,labelT,selectway,enway,r,classlabel,numbernot)
%
% Input:       A : input samples;
%          labelT: the labels of samples A;
%          target: the testing samples;
%           enway: the way of ensemble strategy used; 
%               '1'----- random select samples from original samples A;
%               '2'----- using bagging strategy;
%               '3'----- using random subspace strategy;
%               '4'----- using Rotation Forest strategy;
%              r : the ratio of sampling from original samples A;
%              K : the number of subset in Rotation Forest ensemble;
%       selectway: the way of initialization of samples A;
%               '1'----- the samples A inputed by a cell;
%               '2'----- the samples A inputed by a matrix
%      classlabel: the serial number of samples of every class;
%       numbernot: the way of classification for samples A;
%               '1'----- one against one;
%           'other'----- one against all;
%          Tclass: class of the classified samples in multi-class classification;


% Output:    Asub: the new sample subsets for ensemble individuals obtain by ensemble strategies;
%        labelsub: the labels of Asub;
%       targetnew: the new target samples by ensemble strategies;
%            Anew: the new samples of orginal samples A by ensemble strategies;
%       labelTnew: the labels of Anew;
%
% Author: Mao Shasha (skymss0828@gmail.com),2011.3.10 %

if (nargin<5 || nargin>9)
    help getsubset
else

    Anew=[];
    labelTnew=[];
    dataset=[];
    datalabel=[];
    
    if (nargin<7)
        selectway=2;
    end
    if (enway~=4)
        K=0;
    end

    switch lower(selectway)
        case 1 %%% multi-class
            if (numbernot==1)  % one-one
                dataset=[A(classlabel{Tclass(1),1},:);A(classlabel{Tclass(2),1},:)];
                labelTnew=[labelT(classlabel{Tclass(1)});labelT(classlabel{Tclass(2),1});];
                numberTclassone=length(classlabel(Tclass(1)));
                labelTnew(1:numberTclassone)=1;
                labelTnew(1+numberTclassone:end)=-1;
                datalabel=labelTnew;
               
            else  % one-all
                indexone=[];
                indexone= find(labelT==Tclass);
                indexall=[];
                indexall=find(labelT~=Tclass);
                dataset=[A(indexone,:);A(indexall,:);];
                labelTnew=labelT;
                labelnew(indexone)=1;
                labelnew(indexall)=-1;
                datalabel=labelnew;
            end
        case 2 %%% two class
            dataset=A;
            datalabel=labelT;
            
    end

    switch lower(enway)
        case 1 %%% random samples
            [Asub,labelsub]=rdsample(dataset,datalabel,r);
            targetnew=target;
            Anew=dataset;
        case 2 %%% bagging 
            [Asub,labelsub,indexselect]=bootstrapal(dataset,datalabel,r);
            targetnew=target;
            Anew=dataset;
        case 3 %%% random subspace
            [Asub,labelsub,targetnew]=rsm(dataset,datalabel,target,r);
            dataset=[];
            Anew=Asub;
        case 4 %%% Rotation forest
            if (K~=0)
                [R_new,R_coeff,datasetrfnew,targetXrfnew]=RotationFal(dataset,datalabel,target,K,r); 
                Asub=datasetrfnew;  
                targetnew=targetXrfnew;
                labelsub=datalabel;
                Anew=datasetrfnew;
            else
                Asub=[];
                labelsub=[];
                targetnew=[];
                Anew=[];
            end
            
    end
    labelTnew=datalabel;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% random samples %%%%
function [Asub,labelsub]=rdsample(dataset,datalabel,r)

Asub=[];
labelsub=[];

numberrd=ceil(size(datalabel,1)*r);
[label_new index]=array_hang(datalabel);
indexrd=index(1:numberrd);
labelsub=datalabel(indexrd,:);
if (find(labelsub~=label_new(1:numberrd,:))~=0)
    fprintf('the error of random samples')
    Asub=[];
else
    Asub=dataset(indexrd,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% random subspace algorithm %%%%
function [Asub,labelsub,targetnew]=rsm(dataset,datalabel,target,r)

Asub=[];
labelsub=[];

[numberd,numberfeature]=size(dataset);
numberfs=ceil(numberfeature*r);
indexf=[];
indexf=randperm(numberfeature);
Asub=dataset(:,indexf(1:numberfs));
labelsub=datalabel;
targetnew=[];
targetnew=target(:,indexf(1:numberfs));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
































