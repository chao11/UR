% HAO Chang
%% TP4 detection de contour et de point 

clc; clear all; close all;
addpath 'tpimages'
I = imread('lena.jpg');
subplot(221);imshow(I,[]);title('lena');

%% appliquer les operatuers de detection de contour matlab
Isobel = edge(I,'sobel');
subplot(222);imshow(Isobel,[]); title('sobel');
Iprewitt = edge(I,'prewitt');
subplot(223);imshow(Iprewitt,[]); title('prewitt');
Irobert = edge(I,'roberts');
subplot(224);imshow(Irobert,[]); title('robert');

%% appliquer un filter gradient sur l'image avec fonction matlab
[Gmag,Gdir] = imgradient(I,'roberts');
figure; imshowpair(Gmag,Irobert,'montage');
title('Roerts£ºGradient et contour (fonction Matlab imgradient)');
%% appliquer un filter gradient sur l'image fspecial et imfilter
G_lap  = filtre_gradient( I,'laplacian' );
G_mavo =  filtre_gradient( I,'MavoVassy' );
G_roberts =  filtre_gradient( I,'roberts' );
G_sobel =  filtre_gradient( I,'sobel' );
G_prewitt =  filtre_gradient( I,'prewitt' );
figure;
subplot(2,3,1),imshow(I,[]); title('original');
subplot(2,3,2),imshow(G_lap,[]);title('laplacian');
subplot(2,3,3),imshow(G_mavo,[]);title('mavo');
subplot(2,3,4),imshow(G_roberts,[]);title('roberts');
subplot(2,3,5),imshow(G_sobel,[]);title('sobel');
subplot(2,3,6),imshow(G_prewitt,[]);title('prewitt');

% level_roberts = graythresh(G_roberts);  
% imagBW2=im2bw(I,level_roberts);  
% figure; imshow(~imagBW2,[]); title('contour d¨¦tect¨¦ par robert');
% 

%% détecteur de moravec
% clear all;close all;clc
% 
% img=double(imread('lena.jpg'));
% img = moravec( img );
Lenna = imread('lena.jpg');

% initialisation la matrice de E
I = double(Lenna);
[M,N] =size(I);
E = zeros(M, N);

u = 5;
v = 7;
% calcul  E
for x = u+1 : M-u
    for y = v+1 : N-v
        diff = I(x-u:x+u, y-v:y+v) - I(x,y)*ones(2*u+1,2*v+1);
        E(x,y) = sum(sum(diff.^2));
    end
end

% afficher le résultat
figure
subplot(1,2,1)
imshow(Lenna)
title('image original')

subplot(1,2,2)
imshow(mat2gray(E));
title('le résultat de détecteur de Moravec')

