function [L] = evaluate(s,data,type)
% network likelihood
L = 0;
for i=1:length(s)
    parents = find(s(i,:)==1);
    table = CPT(data,parents,i,type);
    l = likelihood(table,parents,i,type);
    L = L + l;
end