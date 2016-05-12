function [ Ylabel ] = getYlabel( Y )
n=size(Y,1);
Ylabel = zeros(n,1);
for i = 1:n
    tmp = find(Y(i,:)==max(Y(i,:)));
    if(length(tmp)==1)
        Ylabel(i)=tmp;
    else
        Ylabel(i)=tmp(1);
    end
end
end

