clear all
[X_tr,d_tr,X_va,d_va,X_test,d_test] = gera_dados_MNIST();
X = [X_tr';X_va'];
S = [d_tr';d_va'];
save data X S;
Xt = X_test';
St = d_test';
save test Xt St;
