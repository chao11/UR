%% Préambule 
clc;
clear all;
close all

xi = [0.2 0.3 0.2 0.1 0.1 0.5 0.7 1.1 1.4 1.6];
yi = [-0.4 0.1 1.1 1.1 0.9 0.7 0.9 1.1 1.3 1.5];
plot(xi,yi);
hold on 
plot(xi,yi,'b*');

title('tralectoire des points')


P = [0.1;0.9];

%% partie 1 : descente de gradient et gausse-newton
% t(n+1) = t(n) – alpha_n* gradient(J(tn))
% m(t) = a*t^3+b*t^2 +c*t +d
% initialiser les parameres et pi: 
param = [ 4.2 -3.2 0.4 0.2; 12.3 -20.2 9.9 -0.4] ;
tiold_DG =1 ; tiold_NT =1 ;

lambda(1) = 0.02;
% iteration
% termination tolerance
tol = 1e-6;
% maximum number of allowed iterations
maxiter = 1000;
% minimum allowed perturbation
dtmin = 1e-6;
dJ = inf; i = 1; dt = inf;
% while and(dJ>=tol, and(i <= maxiter, dt >= dtmin))
for i = 1:5
    % descente de gradient 
    [ tinew_DG,lambda(i+1),J_DG(i),dJ(i),m_DG(:,i)] = UnPasGradient( param, tiold_DG,xi(5),yi(5),lambda(i) );
    fprintf('DG: The %dth iteration, J = %f, ',i,J_DG(i));
    tiold_DG = tinew_DG;
    
    % gausse-newton
    [ tinew_NT,J_NT(i),m_NT(:,i) ] = UpPasGaussienNewton( param, tiold_NT,xi(5),yi(5) );
    fprintf('NT: The %dth iteration, J = %f, \n',i,J_NT(i));
    tiold_NT = tinew_NT;


end
%% plot the result: t = tinew;
t =( 0:0.05:1)';
T = [t.^3 t.^2 t ones(size(t))]';
M = param*T;

% distance = sum((pi-M(:,1:end)).^2)
for i = 1:length(t)
distance(i) = norm(P-M(:,i));
end


figure;subplot(221);
plot(M(1,:),M(2,:)); title('courbe m(t):descante du gradient')
xlim(0:1.6)
hold on 
plot(m_DG(1,:),m_DG(2,:),'r*')


subplot(222);
plot(t,distance);
hold on 
plot(tinew_DG,0,'r*')
title('Descante du gradient:évolution de la valeur du critère')

subplot(223);
plot(M(1,:),M(2,:)); title('courbe m(t):gausse-newton')
hold on 
plot(m_NT(1,:),m_NT(2,:),'g*')
xlim(0:1.6)

subplot(224);
plot(t,distance);
hold on 
plot(tinew_NT,0,'g*')
title('gausse-Newton:évolution de la valeur du critère')
xlabel('t')



%% -------------------------------------------------------------------------------
% Partie 2 moidre carree: pour ti fixées
t =( 0.1:0.1:1)';
P =[ xi;yi];

[ param,Jmc ] = Estime_MC( t,P );

CM = param'*T;

figure;
plot(xi,yi,'ro');
hold on 
plot(CM(1,:),CM(2,:)); title(['courbe m(t):moindres carrés,J = ' num2str(Jmc)])

%% ----------------------------------------------------------------------------
% partie 3: MC et NT
% tester les données des exercises précédents 
% initialiser Pxy 
P =[ xi;yi];
% initialiser les ti
t =( 0.1:0.1:1)';
k = 1;
MSE = 1;

while MSE(k)> 0.005
    
    t_optimiser = [];
    
    % calculer les parametre à ti fixés 
    [ param,J(k) ] = Estime_MC( t,P );
    
    T = [t.^3 t.^2 t ones(size(t))]';
    m = param'*T;
    dist1 = sqrt(sum((P-m).^2));
    J = sum(dist1.^2);
    
    MSE1(k) = sum(dist1)/10 ;%mean  distance
    
    % optimiser ti pour las parametre obtenus
    for i = 1:length(t)
        told = t(i);
        
        [ tnew,~,m(:,k+1) ] = UpPasGaussienNewton( param', told ,P(1,i),P(2,i) );
        
        t_optimiser = [t_optimiser tnew];             
    end  
    t = t_optimiser';
    
    T = [t.^3 t.^2 t ones(size(t))]';
    M2 = param'*T;
    dist2 = sqrt(sum((P-M2).^2)); %ditance entre les points fix et les point m(t)
    J(k+1) = sum(dist2.^2);
    
    MSE(k+1) = sum(dist2)/10;

    
    
    if abs(J(k+1)-J(k)) < 10e-3
        t = (0.8+0.4*rand(1))*t;
    end
   t = stantard( t ); % 

if abs(MSE(k+1)-MSE1(k)) <10e-5
    break;
    
end
k = k+1;

end

disp (param')
fprintf('distance moyenne = %f\n', MSE(end));


t =( 0:0.01:1)';
T = [t.^3 t.^2 t ones(size(t))]';
M2 = param'*T;

figure;
subplot(121);
plot(xi,yi,'ro',M2(1,:),M2(2,:)); 
title(['modifié, MSE = ' num2str(MSE(end))])

subplot(122);
plot(MSE(2:end));
title('évolution du MSE entre Pi et m(t)')

%% partie 4 recuit simulé

simulannealbnd

