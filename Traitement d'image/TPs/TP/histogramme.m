function hist = histogramme( image )

[m,n]=size(image);
hist = zeros(1,256);
for i=1:m
    for j= 1:n
      hist(image(i, j)+1)= hist(image(i, j)+1)+1 ;
    end
end

figure;plot(hist);
title('histogramme des niveaux de gris');
xlim([0 256]);

end

