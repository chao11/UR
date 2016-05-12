function [decision_final_majorite,...
    decision_final_pluralit, vote,resultat_M, resultat_P ] ...
    = methodeClasseNonParametre( data,etique,element )

%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

N_classifier = 5;

rejet_P = 0; rejet_M = 0;
correct_P = 0;     correct_M = 0;
faux = 0;

decision_final_majorite = 0;
decision_final_pluralit = 0;
 
n = element;

% les decisions des 5 classifier 
   decision_5classifiers = data(:, 2*(1:5) );
%    fprintf ('les decision des 5 classifiers pour l''element %d est:\n',element);
%    disp(decision_5classifiers)
   
% On ne prendra donc en compte ici que la première solution fournie par le classifieur 
   table_classe_vote = tabulate(decision_5classifiers(:,1));

   vote = table_classe_vote(:,2); 
   if length(find(vote == max(vote)))>1 % si les vote des max sont egaux 
       rejet_P = 1;
       rejet_M = 1;  
%        fprintf('rejet element : %d\n',element);
       decision_final_pluralit = nan;
       decision_final_majorite = nan;
       
   else
       
        [vote,idx] = max(vote);
        classe = table_classe_vote(idx,1); % le nombre de vote max 

%         fprintf('decision finale :%d, ',classe);
        decision_final_pluralit = classe;
        decision_final_majorite = classe;
        
        if classe==etique(n)

            % vote a la plurarite
%             decision_final_pluralit = classe;
            correct_P = 1;
%             fprintf('decision vote a la plurarite correcte\n');
                   
            % vote a la majorite
            if vote>=(N_classifier+1)/2
               % decision_final_majorite = classe;
                correct_M = 1;
%                 fprintf('decision vote a la majorite correcte\n');
            else
                rejet_M = 1;
%                fprintf('rejet element pour la vote plurarite: %d \n',element);
               decision_final_majorite = nan;
            end
            
       else
           faux = 1;
%            fprintf('element %d decision faux\n',element);
            
       end
       
       
   end
   

% decision_final_majorite = decision_final_majorite';
% decision_final_pluralite = decision_final_pluralite';

% tauxCorrect_M = correct_M;
% fprintf('le taux de correction pour le methode de vote a la majorite est %f \n' ,tauxCorrect_M );
% 
% tauxCorrect_P = correct_P/5;
% fprintf('le taux de correction pour le methode de vote a la pluralité est %f \n' ,tauxCorrect_P );

resultat_M = [correct_M ,faux,rejet_M];
resultat_P = [correct_P ,faux,rejet_P];

end

