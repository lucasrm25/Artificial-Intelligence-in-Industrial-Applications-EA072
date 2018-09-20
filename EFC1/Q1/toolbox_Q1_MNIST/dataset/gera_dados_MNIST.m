%Rotina que prepara os dados (MNIST)

function [X_tr,d_tr,X_va,d_va,X_test,d_test] = gera_dados_MNIST()

%Carregamento e preparacao dos dados de treinamento e validacao
imagens = loadMNISTImages('train-images.idx3-ubyte');
rotulos = loadMNISTLabels('train-labels.idx1-ubyte');

%total de amostras de treinamento e validacao
T = length(rotulos);

%monta vetor de saida desejado para cada imagem
d_total = zeros(10,T);
for kk=1:T
    if rotulos(kk) == 0
        d_total(10,kk) = 1;
    else
        d_total(rotulos(kk),kk) = 1;
    end
end

%separacao em conjs. de treinamento e validacao - holdout (1/3)
X_tr = imagens(:,1:2*T/3);
X_va = imagens(:,2*T/3+1:end);
d_tr = d_total(:,1:2*T/3);
d_va = d_total(:,2*T/3+1:end);

%Dados para teste da rede treinada e verificacao de desempenho
X_test = loadMNISTImages('t10k-images.idx3-ubyte');
rotulos_teste = loadMNISTLabels('t10k-labels.idx1-ubyte');
%total de amostras de teste
Ttest = length(rotulos_teste);

%monta o vetor de saida desejado para cada imagem (conjunto de teste)
d_test = zeros(10,Ttest);
for kk=1:Ttest
    if rotulos_teste(kk) == 0
        d_test(10,kk) = 1;
    else
        d_test(rotulos_teste(kk),kk) = 1;
    end
end
