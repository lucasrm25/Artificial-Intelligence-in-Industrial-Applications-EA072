% 15/04/2017 - FEEC/Unicamp
% wrapper_lin_regr.m
% Wrapper with backward elimination to select inputs from a set of candidates
% Linear models are considered
% Learning with k-folds cross-validation
% The number of delays and the number of random inputs are defined by the user
%
clear all;
% Vector of candidate values for the regularization parameter
reg_par = [0 0.0001 0.001 0.005 0.01 0.1 1];
choice_reg_par = zeros(7,1);
filename = 'C:\Users\Renata\Desktop\EA072\Q2\toolbox_Q2_wrapper\train'; %input('Filename root of the folds (use single quotes): ');
delays = 20;%input('Number of delays to be considered = ');
aleat = 5;%input('Number of random inputs to be considered = ');
% Number of folds for crossvalidation
k = 10;%input('Number of folds: k = ');
entradas = [1:(delays+aleat)];
seq_saida = [];
nc = delays+aleat;
seq_RMSpl = [];
while nc > 1,
    mRMSpl = [];
    for i=1:nc,
        RMSpl = zeros(k,1);
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
            [nlX,ncX] = size(X);
            for jj=1:length(reg_par),
                if nlX >= ncX,
                    b = (X'*X+reg_par(jj)*eye(ncX))\X'*S;
                else
                    b = (X'/(X*X'+reg_par(jj)*eye(nlX)))*S;
                end
                S_pl = Xv*b;
                Ntot = length(S_pl);
                RMS_pl(jj,1) = sqrt(((Sv-S_pl)'*(Sv-S_pl))./Ntot);
            end
            [minRMS_pl,i_min] = min(RMS_pl);
            choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
            RMSpl(fold,1) = minRMS_pl;
        end
        mRMSpl(i,1) = mean(RMSpl);
    end
    [minRMS,i_perm] = min(mRMSpl);
    seq_saida = [seq_saida;entradas(i_perm)];
    seq_RMSpl = [seq_RMSpl;minRMS];
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
disp('Sequence of inputs that left the linear model')
disp(seq_saida');
% All the inputs together must be considered as well
RMSpl = zeros(k,1);
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
    [nlX,ncX] = size(X);
    for jj=1:length(reg_par),
        if nlX >= ncX,
            b = (X'*X+reg_par(jj)*eye(ncX))\X'*S;
        else
            b = (X'/(X*X'+reg_par(jj)*eye(nlX)))*S;
        end
        S_pl = Xv*b;
        Ntot = length(S_pl);
        RMS_pl(jj,1) = sqrt(((Sv-S_pl)'*(Sv-S_pl))./Ntot);
    end
    [minRMS_pl,i_min] = min(RMS_pl);
    choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
    RMSpl(fold,1) = minRMS_pl;
end
seq_RMSpl = [mean(RMSpl);seq_RMSpl];
disp('RMS error evolution along the model pruning');
disp(seq_RMSpl');
[min_RMSpl,ind_min_RMSpl] = min(seq_RMSpl);
disp(sprintf('The minimum RMS error is %.10g, produced after pruning %d candidate inputs.',min_RMSpl,ind_min_RMSpl-1));
figure(1);
x = [1:(delays+aleat)];
x = (delays+aleat+1)-x;
plot(x,seq_RMSpl);grid;
set(gca,'XDir','reverse');
title('RMS evolution along the model pruning');
xlabel('Number of inputs of the linear model');
ylabel('RMS error');

mRMSpl = [];
RMSpl = zeros(k,1);
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
    [nlX,ncX] = size(X);
    for jj=1:length(reg_par),
        if nlX >= ncX,
            b = (X'*X+reg_par(jj)*eye(ncX))\X'*S;
        else
            b = (X'/(X*X'+reg_par(jj)*eye(nlX)))*S;
        end
        S_pl = Xv*b;
        Ntot = length(S_pl);
        RMS_pl(jj,1) = sqrt(((Sv-S_pl)'*(Sv-S_pl))./Ntot);
    end
    [minRMS_pl,i_min] = min(RMS_pl);
    choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
    RMSpl(fold,1) = minRMS_pl;
end
mRMSpl_prop = mean(RMSpl);
disp('RMS error considering a model with the 5 inputs with highest correlation');
disp(mRMSpl_prop);

mRMSpl = [];
RMSpl = zeros(k,1);
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
    [nlX,ncX] = size(X);
    for jj=1:length(reg_par),
        if nlX >= ncX,
            b = (X'*X+reg_par(jj)*eye(ncX))\X'*S;
        else
            b = (X'/(X*X'+reg_par(jj)*eye(nlX)))*S;
        end
        S_pl = Xv*b;
        Ntot = length(S_pl);
        RMS_pl(jj,1) = sqrt(((Sv-S_pl)'*(Sv-S_pl))./Ntot);
    end
    [minRMS_pl,i_min] = min(RMS_pl);
    choice_reg_par(i_min) = choice_reg_par(i_min) + 1;
    RMSpl(fold,1) = minRMS_pl;
end
mRMSpl_prop1 = mean(RMSpl);
disp('RMS error considering a model with the 5 inputs with highest correlation + 5 random inputs');
disp(mRMSpl_prop1);
figure(2);
bar(choice_reg_par);
set(gca,'XTickLabel',{'0';'0.0001';'0.001';'0.005';'0.01';'0.1';'1'});
title('Distribution of the times a regularization value is used');
