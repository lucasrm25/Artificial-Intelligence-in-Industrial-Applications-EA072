clearvars; close all; clc

addpath(genpath('C:\Users\Renata\Desktop\EA072\Q2'));

pre_proc

%%
figure('Color','w')
anos = (1:numel(series))/12 + 1749;
mancha = sunspot(:,2:end);
mancha = reshape(mancha',[1 numel(mancha)]);
plot(anos,mancha)
xlim([1749 2010])
xlabel('Ano')
ylabel('Numero de Manchas Solares Registrados')

figure('Color','w')
sunspot_fft = fft(mancha);
dt = 1/12;
freq_min = 1/(N*dt)*2;           %Hz
freq_max = 1/dt;        %Hz
N = length(mancha);
N1 = floor(freq_min*N*dt);        % N1 = freq_min, N = 1/dt, 1 = 1/(N.dt)
N2 = floor(freq_max*N*dt);
FreqData = (1:N)/(N*dt);
FreqData = FreqData(N1:N2);
sunspot_fft = sunspot_fft(N1:N2);
plot(1./FreqData,abs(sunspot_fft))
xlabel('T=1/f [anos]')
ylabel('Amplitude [n de manchas]')


%% PEARSON

lin_filter('train')

%% LINEAR WRAPPER

gen_k_folds

wrapper_lin_regr

figure('Color','w')
plot(seq_RMSpl);hold on;plot(seq_RMSpl,'*');hold off;
title('RMS evolution along the model pruning');
desloc = 0.00005;
for i=1:length(seq_RMSpl)
    if seq_saida(i) >= 21
        tcolor = 'r';
    else
        tcolor = 'k';
    end
    text(i,seq_RMSpl(i)+desloc,num2str(seq_saida(i)), 'Color',tcolor);
end
grid on

%% NONLINEAR WRAPPER

wrapper_nlin_regr

figure('Color','w')
plot(seq_RMSpnl);hold on;plot(seq_RMSpnl,'*');hold off;
title('RMS evolution along the model pruning');
desloc = 0.00005;
for i=1:length(seq_RMSpnl)
    if seq_saida(i) >= 21
        tcolor = 'r';
    else
        tcolor = 'k';
    end
    text(i,seq_RMSpnl(i)+desloc,num2str(seq_saida(i)), 'Color',tcolor);
end
grid on

