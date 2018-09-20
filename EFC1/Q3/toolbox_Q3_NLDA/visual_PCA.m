% FEEC/Unicamp
% 25/05/2017
% Visualization of the results produced by the first two PCA components
% Wine Data Set (UCI Machine Learning Repository) after [pre_proc_wine.m]
%
clear all;
load wine; % Training data
N = length(X(:,1));
PCA = princomp(X);
figure(1);
ptos = [X*PCA(:,1) X*PCA(:,2)];
for i=1:N,
    if S(i,1) == 1,
        plot(ptos(i,1),ptos(i,2),'*r');hold on;
    elseif S(i,2) == 1,
        plot(ptos(i,1),ptos(i,2),'*k');hold on;
    else
        plot(ptos(i,1),ptos(i,2),'*b');hold on;
    end
end
hold off;
title('Visualization of the results produced by the first two PCA components');
