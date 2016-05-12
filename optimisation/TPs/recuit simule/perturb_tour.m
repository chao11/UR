function point=perturb_tour(point,n)  
    
    %perturb les coordonnées de ces 2point
    % génére perturb aleatoire
    p1=floor(1+n*rand());
    p2=floor(1+n*rand());

    while p1==p2
        p1=floor(1+n*rand());
        p2=floor(1+n*rand());    
    end
    
    tmp=point(p1);
    point(p1)=point(p2);
    point(p2)=tmp;

end