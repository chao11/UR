function [ data ] = Matrice_Information(baseApp,n)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

   for i = 1:5
    data(i,:) = baseApp{i}(n,:);
   end
end

