%% tp6 matrice de coocurrence

clc; clear all; close all;
addpath 'tpimages'
offset = [ 0 2;-2 2;-2 0; -2 -2];

for i = 1:4
    image = imread(['texture' num2str(i) '.jpg']);
    subplot(1,4,i);imshow(image);title('Texture');
    
    [glcm(:,:,i), SI] = graycomatrix(image,'offset',offset(4,:));
    stats(i) = graycoprops(glcm(:,:,i));
end

