% Mini projet-1- Am¨¦lioration d'une photo prise sans flash
clc;
clear;
close all;

% laod image
addpath 'tpimages'
% Ireel = imread('photocoul.jpg');
% traitement d'image en niveaux de gris
% Igray = rgb2gray(I);

Igray = imread('lena.jpg');
variance_image = var(double(Igray(:)));

imshow(Igray); title('image originale')
subplot(3,3,1);imshow(Igray); title('image gray')

%% Travail pr¨¦liminaire

% ajouter le bruit gaussien additif .param¨¨tre: variance
I_noise_gaussian = imnoise(Igray,'gaussian',0.1); % parametre: variance
subplot(3,3,2);imshow(I_noise_gaussian);
title('noise gaussian');
variance_gaussian(1) = variance_image;
variance_gaussian(2) = var(double(I_noise_gaussian(:)));

%{
variance++, bruit++, v=1 image invisible variance(tout blanc)
%}

% ajouter le bruit poivre et sel en changant le densit?
I_noise_poivre = imnoise(Igray,'salt & pepper',0.1); % parametre: densit?
subplot(3,3,3);imshow(I_noise_poivre);
title('noise poivre et sel')
variance_poivre(1) = variance_image;
variance_poivre(2) = var(double(I_noise_poivre(:)));

%{
 'salt & pepper' ajoute le bruit blanc et noir
 densit?+, bruit++, image invisible
%}

%% appliquer le filtre gaussien (fspecial: Create predefined 2-D filters.)
%{
h = fspecial('gaussian', hsize, sigma) returns a rotationally symmetric
Gaussian lowpass filter of size hsize with standard deviation sigma(positive).  h is a square matrix. 
The default value for hsize is [3 3]; the default value for sigma is 0.5. 
%}
i=3;
for sigma = 0.3:0.05:2 
    
    F_gaussien = fspecial('gaussian',[3 3],sigma); % creer 2D-filtre gaussien
    
    %pour le bruit gaussian:
    I_noise_gaussian_filtree = imfilter(I_noise_gaussian,F_gaussien);
    subplot(3,3,5);imshow(I_noise_gaussian_filtree); title('Image noise gaussian filtr¨¦e par gaussian')
    % calculer variance des niveaux de gris de l'image
    variance_gaussian(i) = var(double(I_noise_gaussian_filtree(:)));
    
    % pour le bruit poivre et sel:
    I_noise_poivre_filtree_gaus = imfilter(I_noise_poivre,F_gaussien);
    subplot(3,3,6);imshow(I_noise_poivre_filtree_gaus); title('Image noise poivre filtr¨¦e par gaussian')
    % calculer variance des niveaux de gris de l'image
    variance_poivre(i) = var(double(I_noise_poivre_filtree_gaus(:)));
    
     i= i+1;
     pause(0.01)
    
end
%{
% sigma = 0.5,peu de difference; sigma>1 bruit filtre 
% les morceaux du bruit poivre et sel est diminue est diminu?mais le
% resultat est bruit?comme (image originale + noise_gaussien_0.1)
  %}

%% appliquer le filtre gaussien (fspecial: Create predefined 2-D filters.)
I_gausse_filtree_med = medfilt2(I_noise_gaussian);
subplot(3,3,8);imshow(I_gausse_filtree_med); title('Image noise gaussian filtr¨¦e par median')
I_poivre_filtree_med = medfilt2(I_noise_poivre);
subplot(3,3,9);imshow(I_poivre_filtree_med); title('Image noise poivre filtr¨¦e par median')
%{
le filtre médian filter bien le bruit poivre et sel. pour le bruit gaussian
il a presque le même resultat que filtre gaussian
%}

%% observe l'volution de la variance de s niveaux de gris en l'mage en changant sigma de filtre gaussiant
sigma = 0.3:0.05:2;
sigma = [0 0 sigma];
figure;plot(sigma,variance_gaussian,'b'); 
hold on;plot(sigma,variance_poivre,'g');
legend('le bruit gaussian','le bruit poivre et sel poivre');
title('variance des niveaux de gris des images filtr¨¦es par filtre gaussian');
xlabel('sigma');


%--------------------------------------------------------------------------
%% En pratique :
Ireel = imread('photocoul.jpg');
% traitement d'image en niveaux de gris
I = rgb2gray(Ireel);
figure;subplot(1,3,1);imshow(I);
title('photo sans flash');

F_gaussien = fspecial('gaussian',3,0.5);
I_gausse_filtree = imfilter(I,F_gaussien);
subplot(1,3,2);imshow(I_gausse_filtree);
title('filtr¨¦ par gaussian');
I_median_filtree = medfilt2(I);
subplot(1,3,3);imshow(I_median_filtree);
title('filtr¨¦ par m¨¦dian');

DenoisedImg = FAST_NLM_II(im2double(I),5,3,0.15);
figure; subplot(1,2,1); imshow(I);title('photo sans flash');
subplot(1,2,2);imshow(DenoisedImg);title('filtr¨¦ par FAST NLM');


