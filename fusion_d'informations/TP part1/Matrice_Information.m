function [ data ] = Matrice_Information(baseApp,n)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

   for i = 1:5
    data(i,:) = baseApp{i}(n,:);
   end
end

