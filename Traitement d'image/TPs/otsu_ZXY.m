function level = otsu_ZXY(img_input_gray)
% OTSU automatic thresholding method

% obtenir la figure d'histogramme d'image
histogramCounts = imhist(img_input_gray,256);

total = size(img_input_gray, 1)*size(img_input_gray,2);

sumB = 0;
wB = 0;
maximum = 0.0;
threshold1 = 0.0;
threshold2 = 0.0;
sum1 = sum((1:256).*histogramCounts.'); % the above code is replace with this single line
for ii=1:256
    wB = wB + histogramCounts(ii);
    if (wB == 0)
        continue;
    end
    wF = total - wB;
    if (wF == 0)
        break;
    end
    sumB = sumB +  ii * histogramCounts(ii);
    mB = sumB / wB;
    mF = (sum1 - sumB) / wF;
    between = wB * wF * (mB - mF) * (mB - mF);
    if ( between >= maximum )
        threshold1 = ii;
        if ( between > maximum )
            threshold2 = ii;
        end
        maximum = between;
    end
end
level = (threshold1 + threshold2 )/(2);
end