%treinamento de um mapa de Kohonen - arranjo unidimensional - anel
%mecanismos de poda e inserção automática de neurônios
%matriz X - colunas representam os padrões de entrada(N atributos x M padrões)

function [W,Index,neuronios] = kohonen(X,neuronios,gama_inicial,radius_inicial,LIMIAR,LIMITE_TAXA,PERIODO,MAX_ITERATION)

%N = número de componentes e M = número de dados (padrões) de entrada
[~,M] = size(X);

%número de iterações
iteration = 1;
%taxa de aprendizado
gama = gama_inicial; 
%radius definirá a vizinhança - no início, ambos vizinhos são afetados
%conforme o número de iterações aumenta, não teremos mais o ajuste
radius = radius_inicial;

%matriz com o índice dos vizinhos topológicos - anel
vetor = (1:neuronios)';
Index = [circshift(vetor,-1) circshift(vetor,1)];
%vetor que contabiliza as vitórias dos neurônios
wins = zeros(1,neuronios);

%inicialização da matriz de pesos
W = inicializa_pesos(X,neuronios);
%exibe configuração inicial - pesos e dados
figure(1); plot_SOM(X,W,neuronios);
title('Configuração inicial dos neurônios(o)');

%contador do número de neurônios próximos aos padrões
cont = 0; 

%critério de parada:
%   número máximo de épocas
%   contador do número de neurônios que se encontram muito próximos aos
%   dados - ou seja, cuja dist. ao dado (cidade) mais próximo é inferior ao
%   LIMIAR
%   taxa de aprendizado maior que um valor mínimo permitido

while iteration < MAX_ITERATION && cont < M && gama > LIMITE_TAXA
    
    %a cada PERIODO iterações, zeramos o contador de vitórias
    if(mod(iteration,PERIODO)==0)
        wins = zeros(1,neuronios);
    end
    
    %ordena aleatoriamente os padrões de entrada
    X = X(:,randperm(M));
    %contador do número de neurônios próximos aos padrões
    cont = 0;
   
    %apresenta os M padroes
    for i=1:1:M
        %determinamos o neurônio vencedor
        [indice, value] = vencedor(X(:,i),W);
        %contabiliza uma vitória para o neurônio "indice"
        wins(indice) = wins(indice) + 1;
        if value < LIMIAR
           %se todos os neurônios estão com proximidade menor que um LIMIAR
           cont = cont + 1;
        end
        %ajustamos os pesos do vencedor e dos neurônios vizinhos
        W = ajuste_peso(W, X, Index, indice, gama, i, radius);
    end
    
    %ajusta a taxa de aprendizado gama e a vizinhança
    gama = gama_inicial*exp(-(iteration)/MAX_ITERATION);  %const de tempo
    radius = radius_inicial*exp(-(iteration)/MAX_ITERATION);
    
    %a cada PERIODO iterações, fazemos as operações de poda e inserção de neurônios
    if(mod(iteration,PERIODO)==0)
        %etapa de poda - neurônios que nunca vencem
        [W,wins,neuronios,Index] = poda(W,wins,neuronios,Index);
        %etapa de inserção - próximo a neurônios que vencem muito
        [W,wins,neuronios,Index] = insere(W,wins,neuronios,Index);
    end
    %exibição dos parâmetros
    fprintf('Iteracao:%d \t Taxa (Gama):%1.4f \t Raio:%d \t N:%d\n',iteration,gama,round(radius),neuronios);
    figure(2); plot_SOM(X,W,neuronios); title(['Configuração dos neurônios - iteração ' num2str(iteration)]); drawnow;
    iteration = iteration + 1;
end