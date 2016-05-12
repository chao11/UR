function [ decision,result ] = VotePondereeClasse( base, n, wj )
%

rejet = 0;
correct = 0;
faux = 0;

[ data ] = Matrice_Information(base,n);
% les decisions de type classe des 5 classifier 
decision_typeClaase = data(:, 2*(1:5) );
etique = base{1}(:,1);

%  table_classe_vote = tabulate(decision_typeClaase(:,1));
%  vote = table_classe_vote(:,2); 
%  solution = table_classe_vote(:,1); 

 % 只取第一个solution
    for i = 0:9
       % 查找对应目标分类的投票属于哪个分类器,每一行为一个分类器
        [row,~] = find(decision_typeClaase(:,1)==i);
       % 不同分类器根据能力分配权重， 求对应目标分类的加权投票结果
        vote_podere(i+1) = sum(wj(row));
    end

       % 票数最大为投票结果。若无法决定最大职责弃权rejet

    if length(find(vote_podere == max(vote_podere)))>1 % si les vote des max sont egaux 
       rejet = 1;
%         fprintf('element %d : rejet element \n',n);
       decision = nan;

    else
        [voteMax,idx] = max(vote_podere);
        classe = idx-1;
%         fprintf('element %d  decision finale :%d, ',n,classe);
        decision = classe;

        if classe==etique(n)
            correct = 1;
%             fprintf('decision correct \n');

        else
           faux = 1;
%            fprintf('decision faux\n');

        end

    end
    
result = [correct,faux,rejet];

end

