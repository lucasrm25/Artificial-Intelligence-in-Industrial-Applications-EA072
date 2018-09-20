function [data] = netsample(S,ndata,tables,type)
% [data] = netsample(S,ndata,tables,type)
%
% NETSAMPLE uses a given bayesian network model to build
% a database 'data' of random samples.
%
% S      -> network structure
% ndata  -> number of data samples
% tables -> collection of CPTs
% type   -> vector with number of discrete values for each variable


input = [];
data = zeros(ndata,length(S));
E = S;

% find input elements of network
for i=1:length(S)
    if isempty(find(S(i,:)==1))
        input = [input;i];
        data(:,i) = gendata(ones(ndata,1),tables(i).cpt,[],type);
        E(find(E(:,i)==1),i) = 2;
    end
end

vet = 1:1:length(S);
vet(input) = [];
while ~isempty(vet)
    for i=1:length(vet)
        parents = find(S(vet(i),:)==1);
        if length(find(E(vet(i),:)==2)) == length(parents)
            E(find(E(:,vet(i))==1),vet(i)) = 2;
            data(:,vet(i))=gendata(data(:,parents),tables(vet(i)).cpt,parents,type);
            vet(i) = 0;
        end
    end
    vet(find(vet==0)) = [];
end

function [value] = gendata(data,cpt,parents,type)   
%siz = ones(1,size(data,2))*type;
siz = type(parents);
for i=1:size(data,1);
    I = index(siz,data(i,:));
    table = cpt(I,:);
    table = cumsum(table);
    table = table/max(table);
    v = find(table>=rand);
    value(i) = v(1);
end
value = value';



