function [ output ] = stantard( x )
% centreliser et reduit les donnéesentre[0 1]

% [M,N] = size(x);

Max = repmat(max(x),size(x,1),1);
Min = repmat(min(x),size(x,1),1);

output = (x-Min)./(Max-Min);

end

