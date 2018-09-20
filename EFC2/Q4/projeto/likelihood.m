function [L] = likelihood(table,parents,child,type)
% [L] = likelihood(table,parents,child,type)
%
% LIKELIHOOD calculates the local likelihood for a given family
% whith CPT 'table'.
%
% tables -> conditional probability table for the family
% parents -> parent nodes
% child -> current node
% type -> vector with number of discrete values for each variable

L = 0;
for i=1:size(table,1)
    P1 = 0;
    for j=1:type(child)
        x = table(i,j);
        P1 = P1+LogFactorial(x);
    end
    L = L+P1+(LogFactorial(type(child)-1)) - (LogFactorial(sum(table(i,:))+type(child)-1));
end