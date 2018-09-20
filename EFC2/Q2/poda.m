%rotina que faz a poda de neurônios que nunca vencem
%parâmetros: W - matriz de pesos - dimensão Nxneuronios
%            wins - vetor que contabiliza as vitórias (1xneuronios)
%            neuronios - número de neurônios no mapa
%            Index - matriz de vizinhança dos neurônios

function [W,wins,neuronios,Index] = poda(W,wins,neuronios,Index)

%para todos os neurônios do mapa
te = neuronios;
while te >= 1
    %checa se o neurônio nunca venceu
    if(wins(te) == 0)
        W(:,te) = []; %mata coluna correspondente ao neurônio
        wins(:,te) = []; %elimina coluna correspondente ao neurônio
        neuronios = neuronios - 1; %reduz o número de neurônios no mapa
        %ajuste da vizinhança
        Index(1,2)=neuronios; Index(neuronios,1)=1; Index(neuronios+1,:)=[];
    end
    te = te - 1;
end