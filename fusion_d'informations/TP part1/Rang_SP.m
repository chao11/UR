function [ rang_SP,decision_SP, result_top1 , result_top5 ] = Rang_SP( base,n,wj )
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明

data = Matrice_Information(base,n);
decision_typeClaase = data(:, 2*(1:5) );
etique = base{1}(:,1);

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
    
for i =1:5
  % poids somme ponderer 
  SP(i,:) = rang(i,:).*wj(i);      
end

for i = 0:9
   % 查找对应目标分类的投票属于哪个分类器,每一行为一个分类器
    [row,~] = find(decision_typeClaase==i);
   % 不同分类器根据能力分配权重， 求对应目标分类的加权投票结果
    rang_SP(i+1) = sum(SP(row));
end
    
%%
rejet_top1 = 0;
Reco_top1 = 0;
Confu_top1 = 0;
Confu_top5 = 0;
Reco_top5 = 0;
rejet_top5 = 0;

% rang par l'ordre descente
    [vote,idx] = sort(rang_SP,'descend');
    
    decision_SP = [vote;idx-1];
    
    %% calculer la performance en top1 en top5
    % top1
    if length(find(vote == max(vote)))>1 % si les vote des max sont egaux 
         rejet_top1  = 1;
         fprintf('element %d : rejet element \n',n);
    else
        if decision_SP(2,1)==etique(n)
            Reco_top1 = 1;
        else Confu_top1 = 1;
            fprintf('element %d top1 decision faux\n',n);
        end
    end
    
    % top5
   if vote(5)==vote(6) % si les vote des max sont egaux 
         rejet_top5  = 1;
   else
        if ismember(etique(n),idx(1:5)-1)
            Reco_top5 = 1;
        else Confu_top5 = 1;
            fprintf('element %d  top5 decision faux\n',n);

        end
   end
   
result_top1 = [Reco_top1 Confu_top1 rejet_top1];

result_top5 = [ Reco_top5 Confu_top5 rejet_top5];



end

