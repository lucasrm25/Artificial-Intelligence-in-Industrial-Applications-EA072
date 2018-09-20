% 15/04/2017 - FEEC/Unicamp
% wrapper_nlin_regr.m
% Wrapper with backward elimination to select inputs from a set of candidates
% Nonlinear models are considered (Extreme Learning Machines - ELMs)
% Learning with k-folds cross-validation
% The number of delays and the number of random inputs are defined by the user
%
clear all;
% Vector of candidate values for the ELM regularization parameter
reg_par = [0 0.0001 0.001 0.005 0.01 0.1 1];
choice_reg_par = zeros(7,1);
filename = 'C:\Users\Renata\Desktop\EA072\Q2\toolbox_Q2_wrapper\train'; %input('Filename root of the folds (use single quotes): ');
delays = 20;%input('Number of delays to be considered = ');
aleat = 5;%input('Number of random inputs to be considered = ');
% Number of folds for crossvalidation
k = 10;%input('Number of folds: k = ');
no_neurons = 120;%input('Number of neurons at the hidden layer of the ELM = ');
entradas = [1:(delays+aleat)];
seq_saida = [];
nc = delays+aleat;
seq_RMSpnl = [];
while nc > 1,
    mRMSpnl = [];
    for i=1:nc,
        RMSpnl = zeros(k,1);
        for fold = 1:k,
            Xacc = [];Sacc = [];
            for j=1:k,
                if j~=fold,
                    load(strcat(filename,sprintf('%d',j)));
                    Xacc = [Xacc;X];Sacc = [Sacc;S];
                else
                    load(strcat(filename,sprintf('%d',j)));
                    Xv = X;
                    Sv = S;
                end
            end
            X = Xacc;S = Sacc;
            entradas_aux = [];
            for r=1:length(entradas),
                if r ~= i,
                    entradas_aux = [entradas_aux entradas(r)];
                end
            end
            X_aux = [];Xv_aux = [];
            for r=1:length(entradas_aux),
                X_aux = [X_aux X(:,entradas_aux(r))];
                Xv_aux = [Xv_aux Xv(:,entradas_aux(r))];
            end
            nl = length(X_aux(:,1));
            nlv = length(Xv_aux(:,1));
            X = [X_aux ones(nl,1)];Xv = [Xv_aux ones(nlv,1)];
            P = rand(length(X(1,:)),no_neurons)-0.5;
            Y = tanh(X*P);
            [nlY,ncY] = size(Y);
            Y = [Y ones(nlY,1)];
            ncY = ncY + 1;
            nlYY1 = length(Y(1,:));
            nlYY2 = length(Y(:,1));
            Yv = tanh(Xv*P);
            [nlYv,ncYv] = size(Yv);
            Yv = [Yv ones(nlYv,1)];
            for jj=1:length(reg_par),
                if nlY >= ncY,
                    b = (Y'*Y+reg_par(jj)*eye(nlYY1))\Y'*S;
                else
                    b = (Y'/(Y*Y'+reg_par(jj)*eye(nlYY2)))*S;
                end
                S_ELM = Yv*b;
                Ntot = length(S_ELM);
                RMS_ELM(jj,1) = sqrt(((Sv-S_ELM)'*(Sv-S_ELM))./Ntot);
            end
            [minRMS_ELM,i_min] = min(RMS_ELM);
            choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
            RMSpnl(fold,1) = minRMS_ELM;
        end
        mRMSpnl(i,1) = mean(RMSpnl);
    end
    [minRMS,i_perm] = min(mRMSpnl);
    seq_saida = [seq_saida;entradas(i_perm)];
    seq_RMSpnl = [seq_RMSpnl;minRMS];
    entradas_aux = [];
    for r=1:length(entradas),
        if r ~= i_perm,
            entradas_aux = [entradas_aux entradas(r)];
        end
    end
    entradas = entradas_aux;
    nc = nc-1;
end
seq_saida = [seq_saida;entradas]; % Include the last input, which remains as input
disp('Sequence of inputs that left the nonlinear model')
disp(seq_saida');
% All the inputs together must be considered as well
RMSpnl = zeros(k,1);
for fold = 1:k,
    Xacc = [];Sacc = [];
    for j=1:k,
        if j~=fold,
            load(strcat(filename,sprintf('%d',j)));
            Xacc = [Xacc;X];Sacc = [Sacc;S];
        else
            load(strcat(filename,sprintf('%d',j)));
            Xv = X;
            Sv = S;
        end
    end
    X = Xacc;S = Sacc;
    nl = length(X(:,1));
    nlv = length(Xv(:,1));
    X = [X ones(nl,1)];Xv = [Xv ones(nlv,1)];
    P = rand(length(X(1,:)),no_neurons)-0.5;
    Y = tanh(X*P);
    [nlY,ncY] = size(Y);
    Y = [Y ones(nlY,1)];
    ncY = ncY + 1;
    nlYY1 = length(Y(1,:));
    nlYY2 = length(Y(:,1));
    Yv = tanh(Xv*P);
    [nlYv,ncYv] = size(Yv);
    Yv = [Yv ones(nlYv,1)];
    for jj=1:length(reg_par),
        if nlY >= ncY,
            b = (Y'*Y+reg_par(jj)*eye(nlYY1))\Y'*S;
        else
            b = (Y'/(Y*Y'+reg_par(jj)*eye(nlYY2)))*S;
        end
        S_ELM = Yv*b;
        Ntot = length(S_ELM);
        RMS_ELM(jj,1) = sqrt(((Sv-S_ELM)'*(Sv-S_ELM))./Ntot);
    end
    [minRMS_ELM,i_min] = min(RMS_ELM);
    choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
    RMSpnl(fold,1) = minRMS_ELM;
end
seq_RMSpnl = [mean(RMSpnl);seq_RMSpnl];
disp('RMS error evolution along the model pruning');
disp(seq_RMSpnl');
[min_RMSpnl,ind_min_RMSpnl] = min(seq_RMSpnl);
disp(sprintf('The minimum RMS error is %.10g, produced after pruning %d candidate inputs.',min_RMSpnl,ind_min_RMSpnl-1));
figure(1);
x = [1:(delays+aleat)];
x = (delays+aleat+1)-x;
plot(x,seq_RMSpnl);grid;
set(gca,'XDir','reverse');
title('RMS evolution along the model pruning');
xlabel('Number of inputs of the nonlinear model');
ylabel('RMS error');

mRMSpnl = [];
RMSpnl = zeros(k,1);
for fold = 1:k,
    Xacc = [];Sacc = [];
    for j=1:k,
        if j~=fold,
            load(strcat(filename,sprintf('%d',j)));
            Xacc = [Xacc;X];Sacc = [Sacc;S];
        else
            load(strcat(filename,sprintf('%d',j)));
            Xv = X;
            Sv = S;
        end
    end
    X = Xacc;S = Sacc;
    X_aux = X(:,16:20);Xv_aux = Xv(:,16:20);
    nl = length(X_aux(:,1));
    nlv = length(Xv_aux(:,1));
    X = [X_aux ones(nl,1)];Xv = [Xv_aux ones(nlv,1)];
    P = rand(length(X(1,:)),no_neurons)-0.5;
    Y = tanh(X*P);
    [nlY,ncY] = size(Y);
    Y = [Y ones(nlY,1)];
    ncY = ncY + 1;
    nlYY1 = length(Y(1,:));
    nlYY2 = length(Y(:,1));
    Yv = tanh(Xv*P);
    [nlYv,ncYv] = size(Yv);
    Yv = [Yv ones(nlYv,1)];
    for jj=1:length(reg_par),
        if nlY >= ncY,
            b = (Y'*Y+reg_par(jj)*eye(nlYY1))\Y'*S;
        else
            b = (Y'/(Y*Y'+reg_par(jj)*eye(nlYY2)))*S;
        end
        S_ELM = Yv*b;
        Ntot = length(S_ELM);
        RMS_ELM(jj,1) = sqrt(((Sv-S_ELM)'*(Sv-S_ELM))./Ntot);
    end
    [minRMS_ELM,i_min] = min(RMS_ELM);
    choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
    RMSpnl(fold,1) = minRMS_ELM;
end
mRMSpnl_prop = mean(RMSpnl);
disp('RMS error considering a model with the 5 inputs with highest correlation');
disp(mRMSpnl_prop);

mRMSpnl = [];
RMSpnl = zeros(k,1);
for fold = 1:k,
    Xacc = [];Sacc = [];
    for j=1:k,
        if j~=fold,
            load(strcat(filename,sprintf('%d',j)));
            Xacc = [Xacc;X];Sacc = [Sacc;S];
        else
            load(strcat(filename,sprintf('%d',j)));
            Xv = X;
            Sv = S;
        end
    end
    X = Xacc;S = Sacc;
    X_aux = X(:,16:25);Xv_aux = Xv(:,16:25);
    nl = length(X_aux(:,1));
    nlv = length(Xv_aux(:,1));
    X = [X_aux ones(nl,1)];Xv = [Xv_aux ones(nlv,1)];
    P = rand(length(X(1,:)),no_neurons)-0.5;
    Y = tanh(X*P);
    [nlY,ncY] = size(Y);
    Y = [Y ones(nlY,1)];
    ncY = ncY + 1;
    nlYY1 = length(Y(1,:));
    nlYY2 = length(Y(:,1));
    Yv = tanh(Xv*P);
    [nlYv,ncYv] = size(Yv);
    Yv = [Yv ones(nlYv,1)];
    for jj=1:length(reg_par),
        if nlY >= ncY,
            b = (Y'*Y+reg_par(jj)*eye(nlYY1))\Y'*S;
        else
            b = (Y'/(Y*Y'+reg_par(jj)*eye(nlYY2)))*S;
        end
        S_ELM = Yv*b;
        Ntot = length(S_ELM);
        RMS_ELM(jj,1) = sqrt(((Sv-S_ELM)'*(Sv-S_ELM))./Ntot);
    end
    [minRMS_ELM,i_min] = min(RMS_ELM);
    choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
    RMSpnl(fold,1) = minRMS_ELM;
end
mRMSpnl_prop1 = mean(RMSpnl);
disp('RMS error considering a model with the 5 inputs with highest correlation + 5 random inputs');
disp(mRMSpnl_prop1);
figure(2);
bar(choice_reg_par);
set(gca,'XTickLabel',{'0';'0.0001';'0.001';'0.005';'0.01';'0.1';'1'});
title('Distribution of the times a regularization value is used');
