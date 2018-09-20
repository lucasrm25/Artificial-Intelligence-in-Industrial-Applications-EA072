%rotina que devolve o índice do neurônio vencedor
%padrao = vetor coluna dos atributos da entrada
%W = matriz com os pesos associados a cada neurônio

function [indice, value] = vencedor(padrao,W)

%monta vetor com a distância entre os neurônios e a entrada
d = dist(padrao',W);
%determina o índice do neurônio vencedor
[value,indice] = min(d);
