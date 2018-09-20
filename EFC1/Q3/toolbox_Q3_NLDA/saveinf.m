% FEEC/Unicamp
% 25/05/2017
% saveinf.m
%
disp(sprintf('Current root mean squared error = %.12g',eq(n_iter+1)));
disp(sprintf('No. of iterations = %d',n_iter));
save w1 w1;save w2 w2;save w3 w3;save w4 w4;
save evol eq stw1 stw2 stw3 stw4 n_iter lamb comp;
