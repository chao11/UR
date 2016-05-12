function [ result_top1,result_top5 ] = performance_top1top5( decisions,etique,n )
%   decisions = [ vote classe]

vote = decisions(1,:);
classe = decisions(2,:);

rejet_top1 = 0;
Reco_top1 = 0;
Confu_top1 = 0;
Confu_top5 = 0;
Reco_top5 = 0;
rejet_top5 = 0;

% top1
    if length(find(vote == max(vote())))>1 % si les vote des max sont egaux 
         rejet_top1  = 1;
        
    else
      
        if classe(1)==etique(n)
            Reco_top1 = 1;
        else Confu_top1 = 1;
        end
    end
    
    % top5
    if (vote(5)==vote(6)) && (vote(5)~=0 )% si les vote des max sont egaux
        rejet_top5  = 1;
    else
        if  vote(1)==0
            rejet_top5 = 1;
            
        else
            if ismember(etique(n),classe(1:5))
                Reco_top5 = 1;
            else Confu_top5 = 1;
%                 fprintf('element %d decision faux \n',n)
%                 disp(decisions)
            end
        end
    end
    
result_top1 = [Reco_top1 Confu_top1 rejet_top1];

result_top5 = [ Reco_top5 Confu_top5 rejet_top5];

end

