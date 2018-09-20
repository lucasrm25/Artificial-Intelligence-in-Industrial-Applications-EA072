% 15/04/2017 - FEEC/Unicamp
% Sorting of input variables according to the absolute value of the sampled Pearson correlation coefficient
% Vector(s) to be sorted and reference vector are received as input
%
function [] = lin_filter(n_file)
load(n_file);
N_vet = length(X(1,:));
N = length(S(:,1));
disp(sprintf('Number of variables to be sorted = %d',N_vet));
for i=1:N_vet,
    coef(i,1) = abs(calc_cor2(X(:,i),S));
end
[list_ord,ind_ord] = sort(coef,'descend');
list_ord = list_ord(:);ind_ord = ind_ord(:);
list_ord = [1;list_ord];
ind_ord = [0;ind_ord];
disp([ind_ord list_ord]);
x = [0:N_vet];
figure(1);
plot(x,list_ord);hold on;plot(x,list_ord,'*');hold off;
title('Pearson sampled correlation among input vectors and the reference vector');
desloc = 0.05;
for i=2:length(ind_ord),
    text(x(i),list_ord(i)+desloc,num2str(ind_ord(i)));
end
