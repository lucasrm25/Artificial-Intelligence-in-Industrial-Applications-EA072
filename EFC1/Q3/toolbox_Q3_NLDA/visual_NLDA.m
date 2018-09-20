% FEEC/Unicamp
% 25/05/2017
% Visualization of the results produced by two nonlinear discriminants
% Use of the weights obtained after training the neural network
% One-hidden layer NN before the bottleneck
% Wine Data Set (UCI Machine Learning Repository) after [pre_proc_wine.m]
%
clear all;
load w1;load w2;load evol;
load wine; % Training data
N = length(X(:,1));
n(1,1) = length(w1(:,1));
n(2,1) = length(w2(:,1));
r = n(2);
m = length(w1(1,:))-1;
np1 = n(1)*(m+1);np2 = n(2)*(n(1)+1);
n_weights = np1+np2;
disp(sprintf('No. of training patterns = %d',N));
disp(sprintf('No. of hidden layer neurons = %d',n(1)));
disp(sprintf('No. of weights = %d',n_weights));
disp(sprintf('No. of iterations = %d',n_iter));
Srn = [tanh([X ones(N,1)]*w1') ones(N,1)]*w2';
figure(2);
for i=1:N,
    if S(i,1) == 1,
        plot(Srn(i,1),Srn(i,2),'*r');hold on;
    elseif S(i,2) == 1,
        plot(Srn(i,1),Srn(i,2),'*k');hold on;
    else
        plot(Srn(i,1),Srn(i,2),'*b');hold on;
    end
end
hold off;
title('Visualization of the results produced by the nonlinear discriminants');
