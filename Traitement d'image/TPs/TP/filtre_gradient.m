function [ G ] = filtre_gradient( I,method )

switch method
    case { 'sobel','prewitt' }
        h = fspecial(method);
              
    case 'roberts'
        h = [-1 0 0;0 0 0 ; 0 0 1];
       
    case 'MavoVassy' 
        h = [0 1 1 ;-1 0 1; -1 -1 0];
       
    case 'laplacian'
        alpha = input('laplacian: alpha (entre 0~1)= '); 
        % The parameter ALPHA controls the shape of the ...
        % Laplacian and must be in the range 0.0 to 1.0.
        h = fspecial(method,alpha);
        
end

%% affichage des image de gradiant 
switch method
    
    case { 'sobel','prewitt','MavoVassy','roberts' }
        Gx = imfilter(I,h);
        Gy = imfilter(I,h');
%     figure;imshowpair(Gx,Gy,'montage');
%     title([ method, ' Gx (left),Gy t(right)']);
        Gx = double(Gx);
        Gy = double(Gy);
        G = sqrt(Gx.^2 + Gy.^2);
      
    case 'laplacian'
        G = imfilter(I,h);
end
G = mat2gray(G);
% figure;imshow(G);
% title(['filtre gradient de tous directions par ',method]);

end

