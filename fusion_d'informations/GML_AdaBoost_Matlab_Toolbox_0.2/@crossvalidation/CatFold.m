%   The algorithms implemented by Alexander Vezhnevets aka Vezhnick
%   <a>href="mailto:vezhnick@gmail.com">vezhnick@gmail.com</a>
%
%   Copyright (C) 2005, Vezhnevets Alexander
%   vezhnick@gmail.com
%   
%   This file is part of GML Matlab Toolbox
%   For conditions of distribution and use, see the accompanying License.txt file.

function [Data, Labels] = CatFold(this, Data, Labels, N)

if(N > this.folds)
  error('N > total folds');
end

Data   = cat(2, Data, this.CrossDataSets{N}{1,1});
Labels = cat(2, Labels, this.CrossLabelsSets{N}{1,1});