function tableau_mesurer = TypeMesure(base,n)

data = Matrice_Information(base,n);

decision_typeMesure = data(:, 2*(1:5)+1 );
decision_typeMesure(isnan(decision_typeMesure))=0;

classe = data(:, 2*(1:5));
tableau_mesurer = zeros(5,10); % tableau de mesure: classe-proba pour chaque classifieur
    
for i = 1:5
    for j = 0:9
        idx = find(classe(i,:)==j);
        if ~isempty(idx)
            tableau_mesurer(i,j+1) = decision_typeMesure(i,idx);
        end
    end
end

tableau_mesurer =tableau_mesurer/100;

end