function [s] = find_cycles(s)
n = length(s);
% find input nodes (there must exist at least one)
in = [];
for i=1:n
    if isempty(find(s(i,:)==1))
        in = [in;i];
    end
end
% if there is no input, create one
if isempty(in)
    in = ceil(rand*n);
end
v = in(1);
k = 1:n; %nodes to visit
k(v) = []; k = [v,k];
while ~isempty(k)
    v = k(1);
    [s,r,u] = dfs(s,v,[]);
    k = setdiff(k,u);
    s(find(s==2)) = 1;
end

function [s,r,u]  = dfs(s,v,r)
r = [r;v];
u = v;
edges = find(s(:,v)==1);
while ~isempty(edges)
    e = edges(1); edges(1) = [];
    f = find(r==e);
    if ~isempty(f)
        s(e,v) = 0;
    else
        s(e,v) = 2; % mark used edge
        [s,tmp,u2] = dfs(s,e,r);
        u = [u;u2];
        u = unique(u);
    end
end