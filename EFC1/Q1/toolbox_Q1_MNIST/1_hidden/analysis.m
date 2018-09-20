% FEEC/Unicamp
% 31/05/2017
% Verification of the performance of the individual neural networks
% Use of the weights obtained after training the neural networks
% Presentation of graphical results using the test dataset
%
clear all;
disp('(1) Use weights minimizing the validation error');
disp('(2) Use weights minimizing the training error');
opt = input('Which set of weights you would like to use? ');
k = input('Number of folds: k = ');
error_tot = 0;
load('test.mat');
X = Xt;S = St;
N = length(X(:,1));
disp(sprintf('No. of training patterns = %d',N));
for fold=1:k,
    disp(sprintf('Fold = %d',fold));
    if opt == 1,
        load(strcat('w1v',sprintf('%d',fold)));
        load(strcat('w2v',sprintf('%d',fold)));
    elseif opt == 2,
        load(strcat('w1',sprintf('%d',fold)));
        load(strcat('w2',sprintf('%d',fold)));
    else
        error('Wrong choice for the set of weights.');
    end
    load(strcat('evol',sprintf('%d',fold)));
    n = length(w1(:,1));
    r = length(w2(:,1));
    m = length(w1(1,:))-1;
    np1 = n*(m+1);np2 = r*(n+1);
    n_weights = np1+np2;
    if fold == 1,
        disp(sprintf('No. of hidden layer neurons = %d',n));
        disp(sprintf('Number of weights in the neural network = %d',n_weights));
    end
    if opt == 1,
        disp(sprintf('No. of iterations = %d',n_iter_v));
    elseif opt == 2,
        disp(sprintf('No. of iterations = %d',n_iter));
    end
    x1 = [X ones(N,1)];
    y1 = tanh(x1*w1');
    x2 = [y1 ones(N,1)];
    % Srn_train = tanh(x2*w2');
    Srn_train = x2*w2';
    CERtrainv = zeros(r,1);
    for i=1:N,
        [val,ind] = max(Srn_train(i,:));
        if abs(S(i,ind)) < 0.05,
            [val,ind] = max(S(i,:));
            CERtrainv(ind,1) = CERtrainv(ind,1)+1;
        end
    end
    for i = 1:r,
        tot_class_train(i,1) = sum(S(:,i)~=0);
        error_per_class_train(1,i) = CERtrainv(i,1)/tot_class_train(i,1);
    end
    disp('CER per class (training)');disp(error_per_class_train);
    verro = reshape(S-Srn_train,N*r,1);
    eqf = verro'*verro;
    eqm = sqrt((1/(N*r))*(verro'*verro));
    error_tot = error_tot+eqm;
    disp(sprintf('Fold %d: RMSE = %.12g | Average CER for all classes = %.12g',fold,eqm,sum(error_per_class_train)/r));
end
disp(sprintf('Average mean squared error for the k MLPs in train.mat = %.12g',error_tot/k));
for i=1:r,
    figure(i);
    plot(error_per_class_v(:,i));
    title(sprintf('Evolution of the CER for Class %d (Validation Set)',i));
end
