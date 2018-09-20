% FEEC/Unicamp
% 25/05/2017
% function [Ew,dEw] = process(X,S,w1,w2,w3,w4,n,m,N)
% Output: squared error (Ew) and gradient vector (dEw)
% Presentation of input-output patterns: batch mode
% All neurons have bias
%
function [Ew,dEw] = process(X,S,w1,w2,w3,w4,n,m,N)
x1 = [X ones(N,1)];
y1 = tanh(x1*w1');
x2 = [y1 ones(N,1)];
% y2 = tanh(x2*w2');
y2 = x2*w2';
x3 = [y2 ones(N,1)];
y3 = tanh(x3*w3');
x4 = [y3 ones(N,1)];
% y4 = tanh(x4*w4');
y4 = x4*w4';
erro = y4-S;
% erro4 = erro.*(1.0-y4.*y4);
erro4 = erro;
dw4 = erro4'*x4;
erro3 = (erro4*w4(:,1:n(3))).*(1.0-y3.*y3);
dw3 = erro3'*x3;
% erro2 = (erro3*w3(:,1:n(2))).*(1.0-y2.*y2);
erro2 = erro3*w3(:,1:n(2));
dw2 = erro2'*x2;
erro1 = (erro2*w2(:,1:n(1))).*(1.0-y1.*y1);
dw1 = erro1'*x1;
verro = reshape(erro,N*n(4),1);
Ew = 0.5*(verro'*verro);
dEw = [reshape(dw1',n(1)*(m+1),1);reshape(dw2',n(2)*(n(1)+1),1);reshape(dw3',n(3)*(n(2)+1),1);reshape(dw4',n(4)*(n(3)+1),1)];
