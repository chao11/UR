function [ decision_final_pluralite, decision_final_majorite,...
    tauxCorrect_P, tauxCorrect_M, s] = classe_Vote( input_args )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

rejet = 0;
reco_pluralite = 0;
reco_majorite = 0;
s = {}; % information des decision des 5 classifier pour les elements 

for n = 1:N_element
   
   CL(1,:) = cl1_app(n,:);
   CL(2,:) = cl2_app(n,:);
   CL(3,:) = cl3_app(n,:);
   CL(4,:) = cl4_app(n,:);
   CL(5,:) = cl5_app(n,:);
% les decisions des 5 classifier 
%    disp ('les decision des 5 classifiers pour l''element');
   decision_5classifiers = CL(:, 2*(1:5) );
   s{n} = decision_5classifiers; % enregistre les decision dees 5 classifier pour cet elements
   
   table_classe_vote = tabulate(decision_5classifiers(:));
   
   vote = table_classe_vote(:,2); 
   [vote,idx] = max(vote);
   classe = idx-1; % le nombre de vote max 
   
   if length(find(vote == max(vote)))>1 % si les vote des max sont egaux 
       rejet = rejet+1;
       decision_final_pluralite(n) = nan;
       decision_final_majorite(n) = nan;
   else
       decision_final_pluralite(n) = classe;
       reco_pluralite = reco_pluralite+1;
       if vote>N_classifier/2
            decision_final_majorite(n) = classe;
            reco_majorite = reco_majorite+1;

       else rejet= rejet+1;
           decision_final_majorite(n) = nan;
       end
   end
   
end

decision_final_majorite = decision_final_majorite';
correct_maj = length(find(decision_final_majorite == cl1_app(:,1)));
tauxCorrect_M = correct_maj/N_element;
fprintf('le taux de correction pour le methode de vote a la majorite est %f' ,tauxCorrect_M );

decision_final_pluralite = decision_final_pluralite';
correct_plur = length(find(decision_final_pluralite == cl1_app(:,1)));
tauxCorrect_P = correct_plur/N_element;
fprintf('le taux de correction pour le methode de vote a la pluralité est %f' ,tauxCorrect_P );


end

