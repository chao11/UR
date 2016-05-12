function [ T ,ambi] = Top1_classifieur(data )
% calculer la performance de top n
% RecoTop1 = nombre d'elements pour lesquels la bonne solution apparait en 1ere 
% proposition  nombre total d'elements
% ambi: nombre de ambiguite
N_element = size(data,1);

ambi = 0;
conf = 0;
reco = 0;
for i = 1:N_element
    
    % trouver les donnees qui ont l'equi-proba pou top1 et ,ce sont les ambiguit¨¦
    if (data(i,3)==data(i,5))
        ambi = ambi+1;
    else
        
        if (data(i,1)~=data(i,2)) % mauvais decision
            conf = conf+1;
        else reco = reco+1; % bonne decision
        end
        
    end
end

Ambi = round(ambi/N_element*100);
Conf = round(conf/N_element*100);
Reco = round(reco/N_element*100);

T = [Ambi;Conf;Reco];

end

