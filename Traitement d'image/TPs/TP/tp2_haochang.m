%% TP2  Restauration d'une vielle photo

clc;
clear;
close all;

%% laod image
addpath 'tpimages'
Igray_lena = imread('lena.jpg');
imshow(Igray_lena);
hist_lena = histogramme(Igray_lena);% calculer l'histogramme des niveaux de gris

I2 = imread('route_itineraire.jpg');
Igray_route = rgb2gray(I2);
figure
imshow(Igray_route);
hist_route = histogramme(Igray_route);title('route');

I3 = imread('image_sombre.jpg');
Igray_sombre = rgb2gray(I3);
figure;imshow(Igray_sombre);
hist_sombre = histogramme(Igray_sombre);% calculer l'histogramme des niveaux de gris
title('sombre');

I4 = imread('nature.jpg');
Igray_nature = double(rgb2gray(I4));
figure;imshow(Igray_nature);
hist_nature = histogramme(Igray_nature);% calculer l'histogramme des niveaux de gris
title('nature');

I5 = imread('claire.jpg');
Igray_claire = rgb2gray(I5);
figure;subplot(121);imshow(I5);subplot(122);imshow(Igray_claire);
hist_claire = histogramme(Igray_claire);% calculer l'histogramme des niveaux de gris
title('image claire');

%% choissir une image bien constratée  :  lena

I_add = Igray_lena+50;
figure;imshow(I_add);title('image ajoute une valeur:50');
hist_lena = histogramme(I_add);% calculer l'histogramme des niveaux de gris
title('histogramme de l''image ajoute une valeur:50');

I_retrancher = Igray_lena-50;
figure;imshow(I_retrancher);title('retrancher une valeur:50');
hist_lena = histogramme(I_retrancher);% calculer l'histogramme des niveaux de gris
title('histogramme de l''image -50');

%% extension dynamique 

Vmin = min(min(Igray_claire))
Vmax = max(max(Igray_claire))

for i = 1:size(Igray_claire,1)
    for j = 1:size(Igray_claire,2)
        Igray_claire_modi(i,j) = 255/(Vmax-Vmin)*(Igray_claire(i,j)-Vmin);
    end
end
figure;imshow(Igray_claire_modi);title('image apr¨¨s l''extension de dynamique');
hist_Igray_claire_modi = histogramme(Igray_claire_modi);% calculer l'histogramme des niveaux de gris
title('histogramme de l''image apr¨¨s l''extension de dynamique');

J = histeq(Igray_claire);
figure; imshow(J)
title('iamge apr¨¨s l''¨¦galisation d''histogramme')
figure; % imhist(J)
hist = histogramme(J);
title('histogramme apr¨¨s l''¨¦galisation d''histogramme')

%% ameliorer la vielle photo
I = imread('02av.jpg');
figure;subplot(121);imshow(I);title('image origine');
Igray = rgb2gray(I);
subplot(122);imshow(Igray);title('image NdG');
figure;imhist(Igray);title('histgramme de la vielle photo');

Imodi = histeq(Igray);
figure; imshow(Imodi);title('am¨¦liorer la photo par l''¨¦galisation d''histogramme ')
figure;imhist(Imodi);title('histgramme apr¨¨s ¨¦galisation ');


Vmin = min(min(Igray))
Vmax = max(max(Igray))

for i = 1:size(Igray,1)
    for j = 1:size(Igray,2)
        Igray_modi(i,j) = 255/(Vmax-Vmin)*(Igray(i,j)-Vmin);
    end
end
figure;imshow(Igray_modi);title('image apr¨¨s l''extension de dynamique');
hist_Igray_modi = histogramme(Igray_modi);% calculer l'histogramme des niveaux de gris
title('histogramme de l''image apr¨¨s l''extension de dynamique');

