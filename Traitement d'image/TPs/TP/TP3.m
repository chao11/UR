%% TP3 Comptage de cellules dans une image de microscpe
clc; clear all; close all;
addpath 'tpimages'
I = imread('sickle1a.png');
figure;subplot(121); imshow(I); title('image originale');
subplot(122); imhist(I); 
title('histogramme de l''image');

%% methode otsu   
[seuil,imageBW] = otsu( I );
figure;
subplot(121); imshow(imageBW,[]); title('image binarise par la methode Otsu');

% matlab fonction
level = graythresh(I);  
imagBW2=im2bw(I,level);  
subplot(122); imshow(imagBW2,[]); title('image binarise par graythresh');
imageBW = ~imageBW; 

%% labeliser et marquer les centroides des cellules
% removes from a binary image all connected components (objects) that have fewer than P pixels,
BW2 = bwareaopen(imageBW, 15);
figure;imshow(BW2); title('n¨¦gliger les petits composants');

% compter tous les composants avant pretraitement 
[L, num] = bwlabel(BW2,8); 
stats = regionprops(L, 'basic');
hold on
for i = 1 : num
   temp = stats(i).Centroid;
   text(temp(1), temp(2), num2str(i), 'color', 'r');
end
title(sprintf('composant total est %d', num), 'FontWeight', 'Bold');
set(gcf, 'Position', get(0, 'ScreenSize'));

%% essayer de s¨¦parer les composants collant
figure;
% cr¨¦er un ¨¦l¨¦ment structurant
SE3=strel('square',3); 
SE5=strel('square',5);
% SE2=strel('disk',2); 

% dilatation
BW = imdilate(BW2,SE3);
subplot(221);imshow(BW);title('dilate')
% erosion
BW = imerode(BW2,SE3);
subplot(222);imshow(BW);title('erosion')
% ouvert
BW = imopen(BW2,SE3);
subplot(223);imshow(BW);title('ouvert')
% fermeture 
BW = imclose(BW2,SE3);
subplot(224);imshow(BW);title('fermeture')
