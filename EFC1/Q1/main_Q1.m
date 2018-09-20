clearvars; close all; clc

addpath(genpath('C:\Users\Renata\Desktop\EA072\Q1'));

gen_data


%% Part 1 - Linear Neural Network

act_fun = @(x,m) x(:,mod(m-1,size(x,2))+1).^ceil(m/size(x,2));  % Activation function
m       = 4*784;                                                % Number of hidden layer neurons

linear = ANN_lin(m,act_fun);
linear.train(X,S);

f_t = linear.net(Xt);
[~,I_f_t] = max(f_t,[],2);
[~,I_St] = max(St,[],2);
CER = sum(I_f_t==I_St)/numel(I_f_t)


figure('Color','w')
bar(linear.C)
title('Regularization Coefficients for the Linear Neural Network')
xlabel('Class')
ylabel('C')

fig = figure('Color','w','Position',[103 116 1173 833]);
for i=1:10
    subplot(3,4,i)
    cdata = reshape(linear.w(1:784,i),[28,28]);
    imagesc(cdata,[-0.1 0.2])
%     contourf(cdata, [-0.1 -0.05 0 0.05 0.1 0.15 0.2])
    title(sprintf('Class %d',i))
end
colorbar('Location','eastoutside')
colormap(fig,jet);

fig2 = figure('Color','w','Position',[680   776   308   202])
scatter([784 784*2 784*3 784*4],[14 11 10 10],'filled')
xlabel('Number of Hidden Layer Neurons')
ylabel('CER [%]')
ylim([0 15])
grid on


%% Part 2 - ELM
clc

% act_fun = @(f) 1/(1+exp(-1*f));         % Activation function
act_fun = @(f) tanh(f);                 % Activation function
m = [10];                         % Number of hidden layer neurons
w_minmax = [1 -1];

tic
ELM = ANN_ELM(m,act_fun,w_minmax,'CIW');
ELM.train(X,S);
ptime = toc;

f_t = ELM.net(Xt);
[~,I_f_t] = max(f_t,[],2);
[~,I_St] = max(St,[],2);
CER = sum(I_f_t==I_St)/numel(I_f_t)

dispstat('','init');
while m(end) < 2000
    if m(end) < 180
        add = 10;
    elseif m(end) < 2000
        add = 100;
    end
    tic
    for j=1:add
        dispstat(sprintf('Incrementing %d/%d Neuron... Total of %d',j,add,m(end)));
        ELM.IR_train(X,S);        
    end
    ptime(end+1) = toc/add;
    m(end+1)     = ELM.n(end-1);
    
    f_t = ELM.net(Xt);
    [~,I_f_t] = max(f_t,[],2);
    [~,I_St] = max(St,[],2);
    CER(end+1) = sum(I_f_t==I_St)/numel(I_f_t);
    dispstat(sprintf('%f',CER(end)),'keepthis','keepprev');
end



%%
colors = colormap('lines');

IR = load('IR_ELM.mat');
CIW = load('CIW_ELM.mat');


CIW.ptime(1) = IR.ptime(1);
for i=2:numel(IR.ptime)
    IR.ptime(i) = IR.ptime(i)*(IR.m(i)-IR.m(i-1)) + IR.ptime(i-1);
end
for i=2:numel(CIW.ptime)
    CIW.ptime(i) = CIW.ptime(i)*(CIW.m(i)-CIW.m(i-1)) + CIW.ptime(i-1);
end

figure('Color','w','Position',[789   443   521   280])
yyaxis left
plot(IR.m,(1-IR.CER)*100,'-',...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
ylabel('CER [%]')
hold on
yyaxis right
plot(IR.m,IR.ptime,'LineWidth',2)
ylabel('Processing Time [s]')
xlabel('Number of Hidden Layer Neurons')
grid on

figure('Color','w','Position',[789   443   521   280])
yyaxis left
plot(IR.m,(1-IR.CER)*100,'-',...
     'Color',colors(1,:),...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
 hold on
 plot(CIW.m,(1-CIW.CER)*100,'--',...
     'Color',colors(1,:),...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
ylabel('CER [%]')
hold on
yyaxis right
plot(IR.m,IR.ptime,'-','LineWidth',2)
hold on
plot(CIW.m,CIW.ptime,'--','LineWidth',2)
ylabel('Processing Time [s]')
xlabel('Number of Hidden Layer Neurons')
grid on
legend({'IR-ELM','CIW-IR-ELM'})
xlim([-Inf 2200])


figure('Color','w','Position',[789   443   521   280])
plot((1-IR.CER)*100,IR.ptime,'-',...
     'Color',colors(1,:),...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
 hold on
 plot((1-CIW.CER)*100,CIW.ptime,'--',...
     'Color',colors(1,:),...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
xlabel('CER [%]')
ylabel('Processing Time [s]')
grid on
legend({'IR-ELM','CIW-IR-ELM'})


figure('Color','w','Position',[789   443   521   280])
plot(IR.ptime,(1-IR.CER)*100,'-',...
     'Color',colors(1,:),...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
 hold on
 plot(CIW.ptime,(1-CIW.CER)*100,'--',...
     'Color',colors(1,:),...
     'LineWidth',2,...
     'MarkerSize',2,...
     'MarkerFaceColor', 'b')
ylabel('CER [%]')
xlabel('Processing Time [s]')
grid on
legend({'IR-ELM','CIW-IR-ELM'})



%% Part 3 - MLP

gen_k_folds('data',k);

% Option 1 -> Start the training from a random initial condition
% Option 2 -> Restart the training from the same initial condition
% Option 3 -> Restart the training from the last set of weights obtained after training

resp = 1;
filename = pwd;
k = 5;

m_test = [100 300 500 1000];% 100 300 500 1000];
for i_test=1:numel(m_test);
    n = m_test(i_test);
    n_itermax = 300; % niterad  = 200;

    tic
    nn1h_k_folds
    ptime(i_test) = toc;
    analysis_fold1
    CER_test(i_test) = sum(error_per_class_train)/r;
end

m_test = [10 50 100 300 500 1000 2000];
ptime  = [350.7507  495.0725  1987.9    4658.8    7300.2    4592.2   24940];
CER_test = [0.1045    0.0709  0.0459    0.0379    0.0444    0.0586   0.0300]*100;

ptime  = [350.7507  495.0725  1987.9    4658.8    7300.2    12092.2   24940];
CER_test = [0.1045    0.0709  0.0459    0.0379    0.0354    0.0326   0.0300]*100;


figure('Color','w','Position',[789   443   521   280])
yyaxis left
plot(m_test,CER_test,'-','LineWidth',2)
hold on
scatter(m_test,CER_test,40,'filled')
ylabel('CER [%]')
hold on
yyaxis right
plot(m_test,ptime,'-','LineWidth',2)
hold on
scatter(m_test,ptime,40,'filled')
ylabel('Processing Time [s]')
xlabel('Number of Hidden Layer Neurons')
grid on
% legend({'IR-ELM','CIW-IR-ELM'})
% xlim([-Inf 2200])

% After training, you can run analysis.m using
% w1k.mat and w2k.mat (best performance for the training dataset)
% or using
% w1vk.mat and w2vk.mat (best performance for the validation dataset)
% [k] here is the fold number.

% analysis_fold1
% analysis




%% Radial Basis

% k = 100;
% [idx] = kmeans(X,k);
% for i=1:k
%     CenterK(i,:) = mean(X(idx==i,:));
% end
% dmax=1;
% r = dmax/(2*k)^0.5;
% act_fun = @(x,m,N) exp(-norm(x(N,:)-CenterK(m,:))^2/r);  % Activation function
% act_fun_rb = @(x,m) arrayfun(@(n) act_fun(x,m,n), [1:size(x,1)]');
% m  = k;                                                % Number of hidden layer neurons
% 
% linear = ANN_lin(m,act_fun_rb);
% linear.train(X,S);
% 
% f_t = linear.net(Xt);
% [~,I_f_t] = max(f_t,[],2);
% [~,I_St] = max(St,[],2);
% CER = sum(I_f_t==I_St)/numel(I_f_t)





%%
% clearvars w_interval mu sigma prob80
% for i=1:100
%     n(i) = i*10;
%     w_interval(i) = 15/n(i)^0.5;
%     data = sum(w_interval(i)*(2*rand([50000 n(i)])-1)/2,2);
%     mu(i) = mean(data);
%     sigma(i) = std(data);
%     prob80(i) = 1.28*sigma(i);
% end
% figure
% plot(n,prob80)
%
% 
% figure
% histogram(data,'Normalization','pdf')
% hold on
% y = min(data):0.1:max(data);
% f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
% plot(y,f,'LineWidth',1.5)
% title(sprintf('mean=%f  sigma=%f',mu,sigma))
% xlabel(sprintf('80%%=%f',1.28*sigma))


