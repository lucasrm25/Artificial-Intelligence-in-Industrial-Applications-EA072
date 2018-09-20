function [tables] = buildtable(S,data,type)
% [tables] = buildtable(S,data,type)
%
% BUILDTABLE builds a collection of CPTs for a complete network
% structure.
%
% S    -> network structure
% data -> input data samples
% type -> vector with number of discrete values for each variable

for i=1:length(S)
    parents = find(S(i,:)==1);
    tables(i).cpt = CPT(data,parents,i,type);
    for j=1:size(tables(i).cpt,1)
        tables(i).cpt(j,:) = tables(i).cpt(j,:)/sum(tables(i).cpt(j,:));
    end
end
