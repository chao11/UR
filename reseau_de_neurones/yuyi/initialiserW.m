function [ W ] = initialiserW( nbSortie, nbEntree )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a = -1;
b = 1;
% Ajouter la pondération des bias : nbEntree+1
W = (b-a).*rand(nbSortie,nbEntree+1) + a;
end

