function [ decisionMR,top1,top5 ] = MeilleurRang( base,n )

data = Matrice_Information(base,n);
decision_typeClaase = data(:, 2*(1:5) );
etique = base{1}(:,1);

    for classe = 0:9      
       [~,col] = find(decision_typeClaase==classe); 
       if isempty(col) % si la classe ci n'est pas dans les liste, 
           MR(classe+1) = nan;
       else
           MR(classe+1) = min(col);
           % verifier si le MR(ci) est situe en premiere position ,
           % 检验他的最高排位是否在第一个，是的话 这个classe 属于最终结果。
           [idx] = find(MR(:) ==1); % 不是第一位则为空。
           decisionMR(1:length(idx)) = idx-1;   
       end
    end
    
%    [rang,idx] = sort(MR,'ascend');
%    classe = idx-1;
%    decisionMR = [rang; classe];          
%    decisionMR(isnan(decisionMR))=0;
   
    rejet_top1 = 0;
    Reco_top1 = 0;
    Confu_top1 = 0;
    Confu_top5 = 0;
    Reco_top5 = 0;
    rejet_top5 = 0;

     % top1
    if length(find(decisionMR(1:length(idx))))>1 % le nombre de decision non nan n'est pas seul
         rejet_top1  = 1;
%         decisionMR_TOP1(n) = nan;   
    else
%         decisionMR_TOP1(n) = decisionMR(n,1);
        if decisionMR(1)==etique(n)
            Reco_top1 = 1;
        else Confu_top1 = 1;
        end
    end
    
    % top5

        if ismember(etique(n),decisionMR)
            Reco_top5 = 1;
        else Confu_top5 = 1;
        end
   

%     if rang(5)==rang(6)&& ~isnan(rang(5)) % si les vote des max sont egaux
%         rejet_top5  = 1;
%     else
%         if ismember(etique(n),classe(1:5))
%             Reco_top5 = 1;
%         else Confu_top5 = 1;
%         end
%     end

top1 = [Reco_top1 Confu_top1 rejet_top1];

top5 = [ Reco_top5 Confu_top5 rejet_top5];

end

