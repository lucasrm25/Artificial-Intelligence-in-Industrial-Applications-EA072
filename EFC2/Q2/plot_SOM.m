%rotina que exibe a disposição de um mapa de Kohonen (unidimensional)
%parâmetros: X - matriz com os dados de entrada - N (atributos) x M (padrões)
%            W - matriz de pesos - N x neuronios
%            neuronios - número de neurônios presentes no mapa

function plot_SOM(X, W, neuronios)
clf;
%ao final, temos o conjunto de pesos em W
plot(X(1,:), X(2,:),'r*'); hold on;
plot(W(1,:), W(2,:),'bo'); plot(W(1,:), W(2,:),'b');
%linha que conecta o primeiro ao último neurônio
line([W(1,1) W(1,neuronios)],[W(2,1) W(2,neuronios)]);