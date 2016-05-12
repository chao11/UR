function [ X_train,Y_train,X_valid,Y_valid,X_test,Y_test ] = splitIris( data )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[m,n]=size(data);
X=[ones(m,1) data(:,1:4)];
Y=data(:,5);
idx_0=find(Y==0);
idx_1=find(Y==1);
idx_2=find(Y==2);

n_0=length(idx_0); % nombre de element de classe0
n_1=length(idx_1);
n_2=length(idx_2);

split_0=floor(n_0/2); % aroundir entier inferieur(1/2 base de'entrainement)
split_1=floor(n_1/2);
split_2=floor(n_2/2);

unquart0=floor(3*n_0/4); % aroundir entier inferieur(1/2 base de'entrainement)
unquart1=floor(3*n_1/4);
unquart2=floor(3*n_2/4);

% base d'entrainement
idx_train=[idx_0(1:split_0) ;idx_1(1:split_1);idx_2(1:split_2) ];
idx_valid=[idx_0((split_0+1):unquart0) ;idx_1((split_1+1):unquart1);idx_2((split_2+1):unquart2)];
idx_test=[idx_0((unquart0+1):end) ;idx_1((unquart1+1):end);idx_2((unquart2+1):end)];

X_train=X(idx_train,:);
Y_train=Y(idx_train,:);

X_valid=X(idx_valid,:);
Y_valid=Y(idx_valid,:);

X_test=X(idx_test,:);
Y_test=Y(idx_test,:);


end

