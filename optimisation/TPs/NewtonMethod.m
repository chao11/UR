function NewtonMethod

%p est un vecteur de dimension 2x1 contenant les parametres

p(1,1) = 0.8;
p(2,1) = 0.4;

%F = y - (p(1).*t)./(p(2)+t); -> forme de l'equation a minimiser

%dF1 = -t./(p(2)+t);          -> forme de la premiere derivee en p(1)
%dF2 = p(1)*x./((p(2)+t).^2); -> forme de la seconde derivee en p(2)

%donnees experimentales
t = [0.038 ; 0.194 ; 0.425 ; 0.626 ; 1.253 ; 2.500 ; 3.740];
D = [0.050 ; 0.127 ; 0.094 ; 0.2122 ; 0.2729 ; 0.2665 ; 0.3317];

%il y aura 5 iterations
for inc = 1:5
    
    %calcul du jacobien
    J(1:length(t),1) = -t./(p(2)+t);
    J(1:length(t),2) = p(1)*t./((p(2)+t).^2);
    
    %calcul des residus
    F = D-(p(1).*t)./(p(2)+t);
    
    %il y a plusieurs manieres de calculer
    %l'incrementation Delta
    Delta = -inv(J.'*J)*(J.'*F);
    %celle-ci est la plus simple sous MATLAB :
    %Delta = -J\F;
    
    %incrementation des parametres
    p = p+Delta;
    
end

%calcul de la RMSE
rmse = (sum(F.^2)/length(F))^0.5;

%calcul de l'ecart type (standard deviation)
stdv = (sum(F.^2)/(length(F)-length(p)))^0.5;

%evalutation des donnees ajustees
ta = 0:0.01:4;
Da = (p(1).*ta)./(p(2)+ta);

%affichage des resultats
fprintf('\nB1 = %f\nB2 = %f\n\n', p);
fprintf('rmse = %f\n', rmse);
fprintf('stdv = %f\n\n', stdv);

%affichage du graphique
figure

h = plot(t, D, 'or', ta, Da, 'b');

legend(h, {'Donnees experimentales' 'Meilleur ajustement'}, 'location', 'southeast')

title('Ajustement avec la methode de Gauss-Newton');
xlabel('t');
ylabel('Donnees a ajuster');
