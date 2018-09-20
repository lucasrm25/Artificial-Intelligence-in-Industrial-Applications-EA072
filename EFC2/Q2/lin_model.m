% FEEC/Unicamp
% 03/09/2017
% lin_model.m
% Synthesis of a linear model for MNIST
% CER: Classification Error Rate
%
clear all;
load data;
[nl,nc] = size(X);
X1 = [X ones(nl,1)];
load test;
[nlt,nct] = size(Xt);
n_classes = length(St(1,:));
Xt1 = [Xt ones(nlt,1)];
reg_par = [0.0000001;0.01;1;10;50;300;1000;3000];
v_CER_mean = [];
for k = 1:length(reg_par),
    p = (X1'*X1+reg_par(k)*eye(nc+1))\X1'*S;
    S_lin = Xt1*p;
    CER = zeros(n_classes,1);
    for i=1:nlt,
        [val,ind] = max(S_lin(i,:));
        if abs(St(i,ind)) < 0.05,
            [val,ind] = max(St(i,:));
            CER(ind,1) = CER(ind,1)+1;
        end
    end
    for i = 1:n_classes,
        tot_class(i,1) = sum(St(:,i));
        error_per_class(1,i) = CER(i,1)/tot_class(i,1);
    end
    CER_mean = sum(error_per_class)/n_classes;
    v_CER_mean = [v_CER_mean;CER_mean];
end
plot(v_CER_mean);hold on;plot(v_CER_mean,'*r');hold off;
set(gca,'XTickLabel',{'0.0000001';'0.01';'1';'10';'50';'300';'1000';'3000'});
title('Evolution of the CER with the regularization parameter');
