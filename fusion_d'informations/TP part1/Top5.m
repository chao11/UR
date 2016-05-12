function [T ] = Top5( data )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

conf = 0;
reco = 0;
N_element = size(data,1);

for i = 1:N_element
   
    if (ismember(data(i,1),data(i,[2 4 6 8 10]))) % mauvais decision
        reco = reco+1;
    else conf = conf+1; % bonne decision
    end
  
end

Conf = round(conf/N_element*100);
Reco  = round(reco/N_element*100);
Ambi = 0;
T = [Ambi;Conf;Reco];

end

