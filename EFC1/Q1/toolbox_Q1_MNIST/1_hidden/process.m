% FEEC/Unicamp
% 31/05/2017
% function [Ew,dEw,eqm,CER,error_per_class] = process(X,S,Xv,Sv,w1,w2)
% Output:  Ew: Squared error for the training dataset
%          dEw: Gradient vector for the training dataset
%          Ewv: Squared error for the validation dataset
% Presentation of input-output patterns: batch mode
% All neurons have bias
%
function [Ew,dEw,eqm,CER,error_per_class] = process(X,S,Xv,Sv,w1,w2)
[N,m] = size(X);
n = length(w1(:,1));
n_out = length(S(1,:));
Nv = length(Xv(:,1));
x1 = [X ones(N,1)];
y1 = tanh(x1*w1');
x2 = [y1 ones(N,1)];
% y2 = tanh(x2*w2');
y2 = x2*w2';
CER = zeros(n_out,1);
for i=1:N,
    [val,ind] = max(y2(i,:));
    if abs(S(i,ind)) < 0.05,
        [val,ind] = max(S(i,:));
        CER(ind,1) = CER(ind,1)+1;
    end
end
for i = 1:n_out,
    tot_class(i,1) = sum(S(:,i));
    error_per_class(1,i) = CER(i,1)/tot_class(i,1);
end
erro = y2-S;
% erro2 = erro.*(1.0-y2.*y2);
erro2 = erro;
dw2 = erro2'*x2;
erro1 = (erro2*w2(:,1:n)).*(1.0-y1.*y1);
dw1 = erro1'*x1;
verro = reshape(erro,N*n_out,1);
Ew = 0.5*(verro'*verro);
dEw = [reshape(dw1',n*(m+1),1);reshape(dw2',n_out*(n+1),1)];
eqm = sqrt((1/(N*n_out))*(verro'*verro));
x1v = [Xv ones(Nv,1)];
y1v = tanh(x1v*w1');
x2v = [y1v ones(Nv,1)];
% y2v = tanh(x2v*w2');
y2v = x2v*w2';
CERv = zeros(n_out,1);
for i=1:Nv,
    [val,ind] = max(y2v(i,:));
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
