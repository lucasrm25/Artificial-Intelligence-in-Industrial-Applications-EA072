function [table] = CPT(data,parents,child,type)
% [table] = CPT(data,parents,child,type)
%
% CPT builds the Conditional Probability Table 'table' for a given 
% bayesian network family.
%
% data    -> input data samples
% parents -> parent nodes
% child   -> current node
% type    -> vector with number of discrete values for each variable

rows = prod(type(parents));
table = zeros(rows,type(child));
for i=1:size(data,1)
    d = data(i,[parents,child]);
    siz = type(parents);
    I = index(siz,d(1:end-1));
    table(I,d(end)) = table(I,d(end)) + 1;
end
