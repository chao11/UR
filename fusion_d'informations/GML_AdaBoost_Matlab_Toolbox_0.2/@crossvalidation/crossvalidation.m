%   The algorithms implemented by Alexander Vezhnevets aka Vezhnick
%   <a>href="mailto:vezhnick@gmail.com">vezhnick@gmail.com</a>
%
%   Copyright (C) 2005, Vezhnevets Alexander
%   vezhnick@gmail.com
%   
%   This file is part of GML Matlab Toolbox
%   For conditions of distribution and use, see the accompanying License.txt file.

function this = crossvalidation(folds)


this.folds = folds;

this.CrossDataSets   = cell(folds, 1);
this.CrossLabelsSets = cell(folds, 1);

this=class(this, 'crossvalidation') ;