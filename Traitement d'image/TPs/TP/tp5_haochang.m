%% TP5 Restauration de code-barre ab?m��  
% outil  utilis�� :morphologie math��matique
clc; clear all; close all;
addpath 'tpimages'

%%
I = imread('codebarre.bmp'); %image uint8
figure; imshow(I);title('code barre');

I= im2bw(I);
figure(1); subplot(221);
imshow(I);title('code barre');

%%
[m,n]=size(I);
% calculer la projection horizonale
for x=1:m
    S2(x)=sum(I(x,:));
end
x=1:m;
figure;plot(x,S2(x));
title('projection horizontale');

% S2 = projection( I,'horizontale' );

% segmenter barre et code
[valeur,idx] = sort(S2);
valeur = unique(valeur);
cutValue = valeur(length(valeur)-1);
cut = find(S2 == cutValue);
numero = I(cut(end):end,:);
barre = I(1:cut(end)-1,:);

figure; 
subplot(211);imshow(barre);title('code barre');
subplot(212);imshow(numero);title('code num�ro');

%% m�rhode morphologie 
% sur le code barre
se = strel('line', 15,90);
barre_dilated = imdilate(imcomplement(barre), se);
barre_dilated = imcomplement(barre_dilated);
figure(1); subplot(222);
imshow(barre_dilated); title('correcter les barres ')
%% completer les barres 
lastLine = size(barre_dilated,1);

for i = 1:lastLine
    if find(barre_dilated(i,:)==0)
        firsitLine = i;
        break;
    end
end

for j = 1:size(barre_dilated,2)
     if barre_dilated(lastLine,j)==0
         barre_dilated(firsitLine:lastLine,j) = 0;
     end
end

subplot(223);
imshow(barre_dilated); title('completer les barres ')

% combiner l'image
I_correct = [barre_dilated;numero];
subplot(224);
imshow(I_correct); title('code barre correct� ')


%% Rotation 
clc;
close all; clear all;

addpath 'tpimages'

I2 =  imread('codebarre.png'); %image uint8
I= im2bw(I2);
figure;imshow(I);

delet = bwareaopen(I,3);
figure;imshow(delet);

Imedian = medfilt2(I);
imshow(Imedian);

%% rotation
I_rotate = imrotate(Imedian, 27);
figure; imshow(I_rotate);

%% ROI

h=imrect;
pos=getPosition(h);
pos = round(pos);
ROI = I_rotate(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3));
figure; 
imshow(ROI);title('code barre');


[m,n]=size(ROI);
% calculer la projection horizonale
for x=1:m
    S2(x)=sum(ROI(x,:));
end
x=1:m;
figure;plot(x,S2(x));
title('projection horizontale');

% S2 = projection( I,'horizontale' );

% segmenter barre et code
[valeur,idx] = sort(S2);
valeur = unique(valeur);
cutValue = valeur(length(valeur)-1);
cut = find(S2 == cutValue);
numero = ROI(cut(end):end,:);
barre = ROI(1:cut(end)-1,:);

figure; 
subplot(211);imshow(barre);title('code barre');
subplot(212);imshow(numero);title('code num�ro');

%% dilatation 
[m,~] = size(barre);
se = strel('line', m/2,90);

barre_dilated = imdilate(imcomplement(barre), se);

barre_dilated = imcomplement(barre_dilated);
figure;imshow(barre_dilated); title('correcter les barres ')

%% erosion
barre_eros = imerode(imcomplement(barre_dilated), se);
barre_eros = imerode(imcomplement(barre_eros), se);
barre_eros = imerode(imcomplement(barre_eros), se);
barre_eros = imerode(imcomplement(barre_eros), se);
barre_eros = imerode(imcomplement(barre_eros), se);
barre_eros = imerode(imcomplement(barre_eros), se);

figure;imshow(barre_eros); title('correcter les barres ')

%%
% combiner l'image
I_correct = [barre_eros;numero];
figure;
imshow(I_correct); title('r�sultat final ')


