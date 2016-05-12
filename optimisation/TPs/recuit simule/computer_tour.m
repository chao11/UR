function len=computer_tour(point,n)   
%   calculer la distance entre le point actuel et son voisin
    len=0;
    for i=1:n-1
        len=len+sqrt((point(i).x-point(i+1).x)^2+(point(i).y-point(i+1).y)^2);        
    end
    len=len+sqrt((point(n).x-point(1).x)^2+(point(n).y-point(1).y)^2);
end
