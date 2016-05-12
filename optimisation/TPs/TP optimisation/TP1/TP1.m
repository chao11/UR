%% TP1
clc; clear all; close all;

z = [-2.5 -2 0 0.5 1 5 6];
yp = [-1.6 -1.8 3 0.15 -1.3 -0.9 -0.7]';

%% 1. calculer l'estimation et l'erreur residuelle 
x1 =  1./(1+z.^2/2) ;
x2 = log10(1+abs(z)).*x1;
X = [x1;x2]';
[ theta ,Ym ] = mc( X,yp );

plot(yp,'b')
hold on 
plot(Ym,'r')
legend('yp','Ym')
% L'erreur d'estimation vaut : YS- YMMC = (1-Q)YS 
% Q = X*inv(X'*X)*X';
J = sum((Ym-yp).^2);   % e = 0.0693
%% 2. utiliser comme critere relative,normaliser chaque mesure d'erreur par valer obs
% Jnorm = sum(((Ym-yp)./yp).^2);  % e_normaliser =0.5011

Jnorm = zeros(size(z));
figure
for i = 1:length(z)
    
   zr = z(1:i);
   yr = yp(1:i);
   x1 =  1./(1+zr.^2/2) ;
   x2 = log10(1+abs(zr)).*x1;
   X = [x1;x2]';
   [ theta_r ,Ymr ] = mc( X,yr );
   Jnorm(i)= sum(((Ymr-yr)./yr).^2);
   
plot(yr,'b')
hold on 
plot(Ymr,'r')
legend('yp','Ymr')
title('utiliser le critere une erreur relative')
end

figure;plot(Jnorm); title('erreurs residuelles')

%% 3.& 4. on considere maintenant que le modele est ¨¤ trois param¨¨tre a,b,c
%   on ne peut pas ecrire Y = theta * X donc on ne peut pas utiliser la
%   methode de MC pour estimer ces 3parametre
%% 5. re-ecriture du modele:  (1+c*z.^2)*ym = a+b*log(1+|z|)
z = [-2.5 -2 0 0.5 1 5 6]; % É¾³ýz=0
yp = [-1.6 -1.8 3 0.15 -1.3 -0.9 -0.7]';
% z = 0---> ym = a;X = [1 0 0 ]theta = [ym 0 0 ]

x1 =  1./(1+ z.^2) ;
x2 = log10(1+abs(z)).*x1;
x3 = yp'.*x1;
X = [x1;x2;x3]';
[ theta2 ,Ym2 ] = mc( X,yp );

figure
plot(yp,'b')
hold on 
plot(Ym,'r')
legend('yp','Ym')
title('re-ecrire le model et afficher les resultats')
c = -1/theta(3);
a = theta(1)*c;
b = theta(2)*c;

J2 = sum((Ym-yp).^2);   % e = 0.0047

%% 6. corriger les parametre pour integrer une nouvelle information
%   MC recursif

Znew = 8;
yp_new = -0.46;
x_new = [1/Znew^2; log10(1+abs(Znew))/Znew^2 ; yp_new/Znew]