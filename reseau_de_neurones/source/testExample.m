% clear all;
% P=[-0.6 -0.7 0.8;0.9 0 1];    %输入向量，即训练集
% T=[1 1 0];                    %输出向量
%% load data and define dataset
clc; clear all; close all;
addpath datasets
% load mnist_all.mat
load letter.mat
P = data(:,end-1);
T = data(:,end);

%% Test

net=newp([-1 1;-1 1],1);      %生成感知器，net是返回参数
%返回划线的句柄，下一次绘制分类线时%将旧的删除
he=plotpc(net.iw{1},net.b{1});
net.trainParam.epochs=15;     %设置训练次数最大是15
net=train(net,P,T);           %利用训练集对感知器进行训练
Q=[0.5 0.8 -0.2;-0.2 -0.6 0.6];
Y=sim(net,Q)                  %Y是利用感知器net对Q进行分类的结果
figure;
plotpv(Q,Y);                  %画出输入的结果表示的点
he=plotpc(net.iw{1},net.b{1},he)%画出分类线