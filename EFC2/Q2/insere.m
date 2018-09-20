%rotina que faz a poda de neurônios que nunca vencem
%parâmetros: W - matriz de pesos - dimensão Nxneuronios
%            wins - vetor que contabiliza as vitórias (1xneuronios)
%            neuronios - número de neurônios no mapa
%            Index - matriz de vizinhança dos neurônios

function [W,wins,neuronios,Index] = insere(W,wins,neuronios,Index)

%número máximo de vitórias
max_wins = max(wins);
%porcentagem do número máximo de vitórias
alpha = 0.5; %controla a qtde de neurônios q é adicionada
te = 1;
%para todos os neurônios do mapa
while te <= neuronios
    %se o neurônio obteve o limiar de vitórias
    if wins(te) > 1 && wins(te) >= alpha*max_wins
        %adiciona coluna no vetor de vitórias
        wins = [wins(:,1:te) (wins(:,te)-1) wins(:,te+1:neuronios)];
        %adiciona coluna na matriz de pesos
        W = [W(:,1:te) (0.02*rand-0.01+W(:,te)) W(:,te+1:neuronios)];
        %aumentamos o número de neurônios
        neuronios = neuronios + 1;
        %aumentamos o índice para pular o neurônio inserido agora
        te = te + 1;
        %ajuste da vizinhança
        Index(1,2)=neuronios; Index(neuronios-1,1)=neuronios; Index(neuronios,:)=[1 neuronios-1];
    end
    %próximo neurônio
    te = te + 1;
end