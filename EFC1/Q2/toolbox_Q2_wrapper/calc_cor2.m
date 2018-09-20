% Cálculo do coeficiente de correlação amostral de Pearson entre duas variáveis
% Recebe como entrada dois vetores de mesma dimensão, cada um representando uma das variáveis.
% Uma função similar do Matlab é corrcoef().
% 06/10/2016 - FEEC/Unicamp
%
function [coef] = calc_cor2(v1,v2)
N = length(v1);
X = [v1 v2];
for i=1:2,
    Xmed(1,i) = sum(X(:,i))/(length(X(:,i)));
end
for i=1:2,
    desv(1,i) = sqrt((sum((X(:,i)-Xmed(i)).^2))/(length(X(:,i))-1));
end
cov = (sum((X(:,1)-Xmed(1)).*(X(:,2)-Xmed(2))))/(length(X(:,1))-1);
coef = cov/(desv(1)*desv(2));
