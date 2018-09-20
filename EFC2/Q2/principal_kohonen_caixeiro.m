%Toolbox - Mapa de Kohonen unidimensional aplicado ao problema do caixeiro viajante
%Especificações:
%   vizinhança - unidimensional em anel
%   número de neurônios - controlado dinamicamente por mecanismos de poda e inserção
%   inserção - 
%   poda - 

clear; close all;

%carrega as coordenadas das cidades
load dados.mat

%seleciona a instância do caixeiro viajante
choice = menu('Escolha a instância do caixeiro viajante','Berlin52','Inst. 1 (100 cidades) ','Inst. 2 (100 cidades)');
if choice == 1
    load berlin52
elseif choice == 2
    load inst100x100.mat
else
    load dados.mat;
end

%parâmetros do SOM

%número inicial de neurônios
N = 10;
%número máximo de épocas do processo de auto-organização
max_epoch = 500;
%número de épocas para zerar contador de vitórias e realizar etapas de poda e inserção
PERIODO = 5;
%limiar de proximidade do neurônio vencedor ao padrão
limiar = 0.01;
%taxa de aprendizado inicial
gama = 0.2;
%limiar (valor mínimo permitido) da taxa de aprendizado
limite_taxa = 0.01;
%raio (extensão) da vizinhança - no início, os vizinhos (esquerdo e direito) são afetados de forma mais intensa; conforme o número de épocas aumenta, não teremos mais o ajuste
radius = 1;

%mapa auto-organizável de Kohonen
[W,Index,Nf] = kohonen(X,N,gama,radius,limiar,limite_taxa,PERIODO,max_epoch);

%exibição de resultados
close(2); figure; plot_SOM(X,W,Nf);

%determinamos o percurso a ser realizado

%matriz com as distâncias entre cada neurônio e cidade
mt = dist(W',X);
%matriz com as distâncias entre as cidades
mx = dist(X', X); 
solucao = zeros(1,Nf); d = 0;
%encontramos a primeira cidade
[~,ind] = min(mt(1,:));
solucao(1) = ind;
for k=1:Nf-1
    %ind corresponde ao índice da cidade representada pelo k-ésimo neurônio
    [~,ind] = min(mt(k+1,:));
    %montamos o percurso com a ordem das cidades
    solucao(k+1) = ind;
    %distância entre as cidades é acumulada
    d = d + mx(solucao(k),solucao(k+1));
end
%incluímos também a distância entre a 1a e a última cidade
d = d + mx(solucao(1),solucao(Nf));
title(['Configuração final dos neurônios(o) - Percurso total: ' num2str(d)]);
