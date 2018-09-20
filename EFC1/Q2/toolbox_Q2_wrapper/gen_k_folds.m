% 15/04/2017 - FEEC/Unicamp
% gen_k_folds.m
% Generation of k folds from a single dataset containing X and S
%
clear all;
filename = 'C:\Users\Renata\Desktop\EA072\Q2\toolbox_Q2_wrapper\train'; %input('Filename root of the folds (use single quotes): ');
% Number of folds for crossvalidation
k = 10; %input('Number of folds: k = ');
load(filename);
N = length(X(:,1));
n_elem = floor(N/k);
excess = mod(N,k);
order = randperm(N);
ind = 1;
excess1 = excess;
for i=1:k,
    for j=1:n_elem,
        Xfold(j,:,i) = X(order(ind),:);
        Sfold(j,:,i) = S(order(ind),:);
        ind = ind+1;
    end
    if excess1 > 0,
        Xfold(n_elem+1,:,i) = X(order(ind),:);
        Sfold(n_elem+1,:,i) = S(order(ind),:);
        ind = ind+1;
        excess1 = excess1-1;
    end
end
excess1 = excess;
if ~isempty(findstr(filename,'.mat')),
    filename = strrep(filename,'.mat','');
end
for i=1:k,
    if excess1 > 0,
        X = Xfold(1:(n_elem+1),:,i);
        S = Sfold(1:(n_elem+1),:,i);
        save(strcat(filename,sprintf('%d',i)),'X','S');
        excess1 = excess1-1;
    else
        X = Xfold(1:(n_elem),:,i);
        S = Sfold(1:(n_elem),:,i);
        save(strcat(filename,sprintf('%d',i)),'X','S');
    end
end
