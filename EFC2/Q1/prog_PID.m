% Programa vinculado ao EFC2
% EA072 - Inteligência Artificial em Aplicações Industriais
% FEEC/Unicamp
% Prof. Fernando J. Von Zuben
% 07/10/2015
clear all;
close all;
% Define o tamanho da população [tam_pop], como um número par
tam_pop = 100;
% Define as taxas de crossover e de mutação
pc = 0.8;
pm = 0.4;
% Define o intervalo de excursão das variáveis
v_inf = 0.0;
v_sup = 5.0;
% Define o número de gerações
n_ger = 50;
% Estruturas para preservar o melhor indivíduo a cada geração e seu fitness
v_melhor_fitness = [];
v_fitness_medio = [];
v_melhor_ind = [];
% Gera a população inicial. Cada indivíduo é uma linha da matriz [pop].
pop = 5*rand(tam_pop,3);

% Avalia a população inicial
for i=1:tam_pop,
    kp = pop(i,1);
    kd = pop(i,2);
    ki = pop(i,3);
    S = stepinfo(planta(kp,kd,ki));
    [Gm,Pm,Wcg,Wcp] = margin(planta(kp,kd,ki));
    fitness(i,1) = 100/(10*(S.RiseTime+1)+((Pm-60)^2+1));
    if isnan(fitness(i,1)),
        fitness(i,1) = 0;
    end
end

% Loop para gerar a nova população até atingir um número máximo de gerações
[melhor_fitness,melhor_ind] = max(fitness);
v_melhor_fitness = [v_melhor_fitness;melhor_fitness];
v_fitness_medio = [v_fitness_medio;mean(fitness)];
v_melhor_ind = [v_melhor_ind;pop(melhor_ind,:)];
v_delta = [];


for k = 1:n_ger,
    
    %% TORNEIO
    
    % Em lugar da roleta, adota-se torneio de 3, pois deve-se excluir os
    % indivíduos de fitness nulo e a implementação fica melhor
    candidatos = [];
    for i=1:tam_pop,
        if fitness(i,1) > 0,
            candidatos = [candidatos;i];
        end
    end
    n_tam_pop = length(candidatos);
    n_pop = [];
%    [[1:tam_pop]' pop fitness]
    for i=1:tam_pop,
        torneio = randi(n_tam_pop,[3 1]);
        c_fitness(1,1) = fitness(candidatos(torneio(1,1),1),1);
        c_fitness(2,1) = fitness(candidatos(torneio(2,1),1),1);
        c_fitness(3,1) = fitness(candidatos(torneio(3,1),1),1);
        [v_max,ind_max] = max(c_fitness);
        n_pop = [n_pop;pop(candidatos(torneio(ind_max,1),1),:)];
    end
    
    
    %% CROSSOVER
    % Aplicação de crossover onde for escolhido
    for j=1:(tam_pop/2),
        if rand(1,1) <= pc,
            % 50% de chance de ocorrer o crossover aritmético
            if rand(1,1) <= 0.5,
                a = rand(1,1);
                n_pop1 = a*n_pop(2*(j-1)+1,:)+(1-a)*n_pop(2*(j-1)+2,:);
                n_pop2 = (1-a)*n_pop(2*(j-1)+1,:)+a*n_pop(2*(j-1)+2,:);
                n_pop(2*(j-1)+1,:) = n_pop1;
                n_pop(2*(j-1)+2,:) = n_pop2;
            else
                % 50% de chance de ocorrer o crossover uniforme
                for z=1:3,
                    if rand(1,1) <= 0.5;
                        n_pop1(1,z) = n_pop(2*(j-1)+1,z);
                        n_pop2(1,z) = n_pop(2*(j-1)+2,z);
                    else
                        n_pop1(1,z) = n_pop(2*(j-1)+2,z);
                        n_pop2(1,z) = n_pop(2*(j-1)+1,z);
                    end
                end
                n_pop(2*(j-1)+1,:) = n_pop1;
                n_pop(2*(j-1)+2,:) = n_pop2;
            end
        end
    end
    
    
    %% MUTACAO
    % Aplicação de mutação não-uniforme onde for escolhido
    n_mut = round(tam_pop*3*pm);
    bits_mutados = randi([1 tam_pop*3],n_mut,1);
    for i=1:n_mut,
        if rem(bits_mutados(i),3) == 0,
            linha = fix(bits_mutados(i)/3);
            coluna = 3;
        else
            linha = fix(bits_mutados(i)/3)+1;
            coluna = rem(bits_mutados(i),3);
        end
        if rand(1,1) <= 0.5,
            delta = mut_nunif(k,v_sup-n_pop(linha,coluna),n_ger);
            v_delta = [v_delta;delta];
            n_pop(linha,coluna) = n_pop(linha,coluna) + delta;
        else
            delta = mut_nunif(k,n_pop(linha,coluna)-v_inf,n_ger);
            v_delta = [v_delta;delta];
            n_pop(linha,coluna) = n_pop(linha,coluna) - delta;
        end
    end
    
    
    %% Avaliação da nova população
    for i=1:tam_pop,
        kp = n_pop(i,1);
        kd = n_pop(i,2);
        ki = n_pop(i,3);
        S = stepinfo(planta(kp,kd,ki));
        [Gm,Pm,Wcg,Wcp] = margin(planta(kp,kd,ki));
        fitness(i,1) = 100/(10*(S.RiseTime+1)+((Pm-60)^2+1));
        if isnan(fitness(i,1)),
            fitness(i,1) = 0;
        end
    end
    
    
    % Preservação do melhor indivíduo da geração anterior, se melhor que o
    % melhor da nova geração
    melhor_fitness1 = melhor_fitness;
    melhor_ind1 = melhor_ind;
    [melhor_fitness,melhor_ind] = max(fitness);
    if melhor_fitness1 > melhor_fitness,
        [pior_fitness,pior_ind] = min(fitness);
        n_pop(pior_ind,:) = pop(melhor_ind1,:);
        fitness(pior_ind,1) = melhor_fitness1;
        melhor_fitness = melhor_fitness1;
        melhor_ind = pior_ind;
    end
    pop = n_pop;
    v_melhor_fitness = [v_melhor_fitness;melhor_fitness];
    v_fitness_medio = [v_fitness_medio;mean(fitness)];
    v_melhor_ind = [v_melhor_ind;pop(melhor_ind,:)];
    kp = pop(melhor_ind,1);
    kd = pop(melhor_ind,2);
    ki = pop(melhor_ind,3);
    figure(1);step(planta(kp,kd,ki));drawnow;
    S = stepinfo(planta(kp,kd,ki));
    [Gm,Pm,Wcg,Wcp] = margin(planta(kp,kd,ki));
    disp(sprintf('Geração %d: T_sub = %g | T_acom = %g | Sobrs = %g | Margfase = %g',k,S.RiseTime,S.SettlingTime,S.Overshoot,Pm));
    disp(sprintf('Geração %d: Os melhores valores encontrados foram: k_p = %g; k_d = %g; k_i = %g',k,kp,kd,ki));
    disp(sprintf('Geração %d: Fitness deste melhor indivíduo = %g',k,melhor_fitness));
end
figure(2);plot(v_melhor_fitness,'k');hold on;plot(v_fitness_medio,'r');hold off;
title('Melhor fitness (preto) e fitness médio (vermelho) da população ao longo das gerações');
figure(3);plot(v_melhor_ind(:,1),'k');hold on;plot(v_melhor_ind(:,2),'r');plot(v_melhor_ind(:,3),'b');hold off;
title('Evolução dos ganhos do controlador PID: k_p (preto) | k_d (vermelho) | k_i (azul)');
xlabel('Número de gerações');
figure(4);plot(v_delta);
title('Intensidade da mutação não-uniforme ao longo das gerações');

