% clear all;
% P=[-0.6 -0.7 0.8;0.9 0 1];    %������������ѵ����
% T=[1 1 0];                    %�������
%% load data and define dataset
clc; clear all; close all;
addpath datasets
% load mnist_all.mat
load letter.mat
P = data(:,end-1);
T = data(:,end);

%% Test

net=newp([-1 1;-1 1],1);      %���ɸ�֪����net�Ƿ��ز���
%���ػ��ߵľ������һ�λ��Ʒ�����ʱ%���ɵ�ɾ��
he=plotpc(net.iw{1},net.b{1});
net.trainParam.epochs=15;     %����ѵ�����������15
net=train(net,P,T);           %����ѵ�����Ը�֪������ѵ��
Q=[0.5 0.8 -0.2;-0.2 -0.6 0.6];
Y=sim(net,Q)                  %Y�����ø�֪��net��Q���з���Ľ��
figure;
plotpv(Q,Y);                  %��������Ľ����ʾ�ĵ�
he=plotpc(net.iw{1},net.b{1},he)%����������