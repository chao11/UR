function [ T ] = Top_n( top,data )
%UNTITLED5 此处显示有关此函数的摘要
%   T: tableau de reco, confusion, ambi
N_element = size(data,1);

ambi = 0;
conf = 0;
reco = 0;
data = data(:,[1 (1:top+1)*2] );


for i = 1:N_element
    if top==5
        ambi = 0;
    elseif (data(i,2*top+1)==data(i,2*(top+1)+1))
        ambi = ambi+1;
    elseif (ismember(data(i,1),data(i,2:end))) % mauvais decision
            reco = reco+1;
    else conf = conf+1; % bonne decision
    end  
end

Ambi = round(ambi/N_element*100);
Conf = round(conf/N_element*100);
Reco = round(reco/N_element*100);

T = [Ambi;Conf;Reco];

end

