% FEEC/Unicamp
% 28/05/2017
% function [Ew,dEw,eqm,CER,error_per_class] = process(X,S,Xv,Sv,w1,w2,w3,w4)
% Output:  Ew: Squared error for the training dataset
%          dEw: Gradient vector for the training dataset
%          Ewv: Squared error for the validation dataset
% Presentation of input-output patterns: batch mode
% All neurons have bias
%
function [Ew,dEw,eqm,CER,error_per_class] = process(X,S,Xv,Sv,w1,w2,w3,w4)
[N,m] = size(X);
n(1,1) = length(w1(:,1));
n(2,1) = length(w2(:,1));
n(3,1) = length(w3(:,1));
n_out = length(S(1,:));
Nv = length(Xv(:,1));
x1 = [X ones(N,1)];
y1 = tanh(x1*w1');
x2 = [y1 ones(N,1)];
y2 = tanh(x2*w2');
% y2 = x2*w2';
x3 = [y2 ones(N,1)];
y3 = tanh(x3*w3');
x4 = [y3 ones(N,1)];
% y4 = tanh(x4*w4');
y4 = x4*w4';
CER = zeros(n_out,1);
for i=1:N,
    [val,ind] = max(y4(i,:));
    if abs(S(i,ind)) < 0.05,
        [val,ind] = max(S(i,:));
        CER(ind,1) = CER(ind,1)+1;
    end
end
for i = 1:n_out,
    tot_class(i,1) = sum(S(:,i));
    error_per_class(1,i) = CER(i,1)/tot_class(i,1);
end
erro = y4-S;
% erro4 = erro.*(1.0-y4.*y4);
erro4 = erro;
dw4 = erro4'*x4;
erro3 = (erro4*w4(:,1:n(3))).*(1.0-y3.*y3);
dw3 = erro3'*x3;
erro2 = (erro3*w3(:,1:n(2))).*(1.0-y2.*y2);
% erro2 = erro3*w3(:,1:n(2));
dw2 = erro2'*x2;
erro1 = (erro2*w2(:,1:n(1))).*(1.0-y1.*y1);
dw1 = erro1'*x1;
verro = reshape(erro,N*n_out,1);
Ew = 0.5*(verro'*verro);
dEw = [reshape(dw1',n(1)*(m+1),1);reshape(dw2',n(2)*(n(1)+1),1);reshape(dw3',n(3)*(n(2)+1),1);reshape(dw4',n_out*(n(3)+1),1)];
eqm = sqrt((1/(N*n_out))*(verro'*verro));

x1v = [Xv ones(Nv,1)];
y1v = tanh(x1v*w1');
x2v = [y1v ones(Nv,1)];
y2v = tanh(x2v*w2');
% y2v = x2v*w2';
x3v = [y2v ones(Nv,1)];
y3v = tanh(x3v*w3');
x4v = [y3v ones(Nv,1)];
% y4v = tanh(x4v*w4');
y4v = x4v*w4';
CERv = zeros(n_out,1);
for i=1:Nv,
    [val,ind] = max(y4v(i,:));
    if abs(Sv(i,ind)) < 0.05,
        [val,ind] = max(Sv(i,:));
        CERv(ind,1) = CERv(ind,1)+1;
    end
end
for i = 1:n_out,
    tot_classv(i,1) = sum(Sv(:,i)~=0);
    error_per_classv(1,i) = CERv(i,1)/tot_classv(i,1);
end
% disp([error_per_class error_per_classv]);
CER = sum(error_per_classv)/n_out;
