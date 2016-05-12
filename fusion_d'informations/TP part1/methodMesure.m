function [ decision] = methodMesure( base,n,wj ,option )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

tableau_mesurer = TypeMesure(base,n);
    
switch (option)
    case 'somme'
        somme = sum(tableau_mesurer);
        [P_somme,idx] = sort(somme,'descend');
        decision = [P_somme ; idx-1];
        
    case 'produit'
        produit = prod(tableau_mesurer);
       [P,idx] = sort(produit,'descend');
        decision = [P ; idx-1];
        
    case 'SP'
        for i = 1:5
            SP(i,:) = wj(i)*tableau_mesurer(i,:);
        end
        P_sp = sum(SP)/5;
        [P_somme,idx] = sort(P_sp,'descend');
        decision = [P_somme ; idx-1];
        
    case 'PP'
        for i = 1:5
             PP(i,:) = tableau_mesurer(i,:).^wj(i);
        end
        P_pp = prod(PP);
        [P,idx] = sort(P_pp,'descend');
        decision = [P ; idx-1];
end

end

