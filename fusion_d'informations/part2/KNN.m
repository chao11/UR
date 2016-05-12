function Ytest = KNN( Xtr,Ytr,Xtest,k )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(Xtr);
[o,p]=size(Xtest);
classe=unique(Ytr);%retrour que les valeurs unique exmeple:0 1 
Ytest=zeros(o,1);

for i=1:o
    Xtest_i=Xtest(i,:);
    % methode1
%      Xtest_m=Xtest_i(ones(m,1),:);
    % methode2
    Xtest_m=zeros(m,n);
    for j=1:m
        Xtest_m(j,:)=Xtest_i;
    end
    
    dist=sqrt(sum((Xtr-Xtest_m).^2,2)); % sum les carrée en ligne
    [~,idx]=sort(dist); %retrouve l'indice des vecteur triée, en croissance
    Yknn=Ytr(idx(1:k),:);% k voisin
    
    w=hist(Yknn,classe); % nombre des elements dans les classes 
    [~,idx_cl]=max(w); % retrourne la classe les plus nombre proche que test  
    Ytest(i)=classe(idx_cl);
    
end

