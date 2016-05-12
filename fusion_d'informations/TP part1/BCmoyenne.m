function [ vote_rang,result_top1,result_top5 ] = BCmoyenne( baseApp,n )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

rejet_top1 = 0;
Reco_top1 = 0;
Confu_top1 = 0;
Confu_top5 = 0;
Reco_top5 = 0;
rejet_top5 = 0;

    dataApp = Matrice_Information(baseApp,n);
    decision_typeClaase = dataApp(:, 2*(1:5) );
    etique = baseApp{1}(:,1);
    % deduir les rang 
%     rang = [10:-1:1]/10;
%      rang = [5:-1:1]/5;

rang = zeros(5,5);
    for i =1:5
      size = length(find(isnan(decision_typeClaase(i,:))==0));
      for j = 1:5
        rang(i,j) = size;       
        size = size-1;
        if size==0
            break
        end
      end
      rang(i,:) = rang(i,:)/(rang(i,1));
    end
    

%  score = [5 4 3 2 1; 5 4 3 2 1 ; 5 4 3 2 1 ; 5 4 3 2 1 ; 5 4 3 2 1  ];
    % somme des rang
    for classe = 0:9 
%           [row,col]= find(decision_typeClaase==classe);
        idx = find(decision_typeClaase==classe);
        somme_rang = sum( rang(idx));
        % BCmoyenne
        MBC(classe+1) = somme_rang/length(idx);
%          MBC(classe+1) = somme_rang;
    end
    % IF is nan, the classe is not exist the score is 0
    MBC(isnan(MBC))=0;
    
    
    
    % rang par l'ordre descente
    [vote,idx] = sort(MBC,'descend');
    vote_rang = [vote;idx];
    % top1
    if length(find(vote == max(vote)))>1 % si les vote des max sont egaux 
         rejet_top1  = 1;
        decision_TOP1(n) = nan;   
    else
        decision_TOP1(n) = idx(1)-1;
        if decision_TOP1(n)==etique(n)
            Reco_top1 = 1;
        else Confu_top1 = 1;
        end
    end
    
    % top5
   if vote(5)==vote(6)&& vote(5)~=0 % si les vote des max sont egaux 
         rejet_top5  = 1;
   else
        if ismember(etique(n),idx(1:5)-1)
            Reco_top5 = 1;
        else Confu_top5 = 1;
        end
   end
result_top1 = [Reco_top1 Confu_top1 rejet_top1];

result_top5 = [ Reco_top5 Confu_top5 rejet_top5];



