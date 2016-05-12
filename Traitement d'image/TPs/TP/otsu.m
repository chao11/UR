function [seuil, I_BW] = otsu(I)
% OTSU automatic thresholding method

% obtenir la figure d'histogramme d'image
count = imhist(I,256);
[m,n]=size(I);
total = m*n;

sumB = 0;
wB = 0;
maximum = 0.0;
threshold1 = 0.0;
threshold2 = 0.0;
sum1 = sum((1:256).*count.'); % la moyenne 
for ii=1:256
    wB = wB + count(ii);
    if (wB == 0)
        continue;
    end
    wF = total - wB;
    if (wF == 0)
        break;
    end
    sumB = sumB +  ii * count(ii);
    uB = sumB / wB; % la moyenne de niveau de gris de C1
    uF = (sum1 - sumB) / wF; % la moyenne de niveau de gris de C2
    V_inter = wB * wF * (uB - uF) * (uB - uF);
    if ( V_inter >= maximum )
        threshold1 = ii;
        if ( V_inter > maximum )
            threshold2 = ii;
        end
        maximum = V_inter;
    end
end
seuil = (threshold1 + threshold2 )/(2);

for i=1:m   
    for j=1:n   
        if I(i,j)>seuil 
            I(i,j)=255;   
        else   
            I(i,j)=0;   
        end   
    end   
end    

I_BW = I;
% imshow(I_BW);
end