%rotina que calcula a distancia euclidiana entre dois indivíduos

function dist = distancia(aux, aux1)

%distancia euclidiana entre os indivíduos
dist = sqrt(sum((aux-aux1).^2));
