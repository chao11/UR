function M = confusion( Y,Ypredit )
%UNTITLED Summary of this function goes here

%  verifier que label commencer par 1
if find(unique(Y) == 0)
    Y = Y+1;
    Ypredit = Ypredit+1;
end

[p,q]=size(Y);

M=zeros(3,3);
for i=1:p
    M(Y(i),Ypredit(i))=M(Y(i),Ypredit(i))+1;
end
    
end

