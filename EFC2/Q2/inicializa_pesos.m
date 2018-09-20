%rotina que inicializa os pesos - arranjo unidimensional em anel
%parâmetros: X - matriz dos dados de entrada - NxM

%Esta inicialização visa minimizar a violação topológica na construção do
%mapa, ou seja, esperamos que após a auto-organização do mapa, neurônios
%vizinhos no mapa tenham vetores de pesos próximos no espaço dos dados

function W = inicializa_pesos(X, neuronios)

%N = número de componentes e M = número de dados (padrões) de entrada
[N,M] = size(X);
%ponto médio dos dados - centro do anel
medio = mean(X,2)'; 
%limitantes dos padrões de entrada
limite_max=max(max(X));
limite_min=min(min(X));
%forçamos os dados de entrada terem média zero
Xmz = X - repmat(medio',1,M);
%matriz de autocorrelação - PCA
R = Xmz*Xmz';
%autovalores e autovetores
[V,~] = eig(R);
%dois maiores autovalores definem as duas componentes principais
direcao = [V(:,N-1) V(:,N)];
%raio do anel
raio = abs(0.2*(limite_max - limite_min));
%ângulo de variação
angles = linspace(0,2*pi,neuronios);
%montamos a matriz dos pesos dos neurônios - um anel no espaço dos dados
W = cos(angles)'*raio*direcao(:,1)'+sin(angles)'*raio*direcao(:,2)'+repmat(medio',1,neuronios)';
W = W'; %manter coerência entre as rotinas
