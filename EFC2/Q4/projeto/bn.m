function [S,T,type] = bn(data,k)
type = range(data)+1;
ndata = size(data,1);

% K2 ALGORITHM

% initialize variables
S = zeros(size(data,2));
fit = evaluate(S,data,type);
for i=1:length(S)
    table = CPT(data,[],i,type);
    fit(i) = likelihood(table,[],i,type);
    SU(i,i) = 1;
end
lastfit = ones(1,length(fit))*-Inf;
draw_graph(S');
pause(.1);

% search procedure
while sum(fit) > sum(lastfit)
    lastfit = fit;
    [il,ic] = find(SU==0);
    L = []; delta = [];
    for i=1:length(il)
        s = S;
        s(il(i),ic(i)) = 1;
        s = find_cycles(s);
        L(i) = -Inf;
        parents = find(s(il(i),:)==1);
        if (length(find(S==1)) < length(find(s==1))) & ... 
                length(parents) <= k
        % (if there is no cycle & parents < k)
            table = CPT(data,parents,il(i),type);
            L(i) = likelihood(table,parents,il(i),type);
            delta(i) = L(i) - fit(il(i));
        end
    end
    [d,I] = max(delta);
    if d > 0
        fit(il(I)) = L(I);
        S(il(I),ic(I)) = 1; SU(il(I),ic(I)) = 1;
    end
    cla;
    draw_graph(S');
    pause(.1);
end
%draw_graph(S');
%draw_graph(Sn');

% comparing probabilities
%D = distribution(Sn,tables,ndata,type,data);
T = buildtable(S,data,type);
tables2 = buildtable(S,data,type);
%D2 = distribution(S,tables2,ndata,type,[]);
% p = probability(Sn,tables,type);
% p = probability(S,tables2,type);



d = d/ndata;
D = [I,d];
   