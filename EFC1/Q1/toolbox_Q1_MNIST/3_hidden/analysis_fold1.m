% FEEC/Unicamp
% 31/05/2017
% Verification of the performance of a individual neural network
% Use of the weights obtained after training the neural network
% Presentation of graphical results using the test dataset
%
clear all;
error_tot = 0;
load('test.mat');
X = Xt;S = St;
N = length(X(:,1));
disp(sprintf('No. of training patterns = %d',N));
fold = 1;
load(strcat('w1v',sprintf('%d',fold)));
load(strcat('w2v',sprintf('%d',fold)));
load(strcat('w3v',sprintf('%d',fold)));
load(strcat('w4v',sprintf('%d',fold)));
n(1,1) = length(w1(:,1));
n(2,1) = length(w2(:,1));
n(3,1) = length(w3(:,1));
r = length(w4(:,1));
m = length(w1(1,:))-1;
np1 = n(1)*(m+1);np2 = n(2)*(n(1)+1);np3 = n(3)*(n(2)+1);np4 = r*(n(3)+1);
n_weights = np1+np2+np3+np4;
disp(sprintf('No. of hidden layer neurons = [%d %d %d]',n(1),n(2),n(3)));
disp(sprintf('Number of weights in the neural network = %d',n_weights));
x1 = [X ones(N,1)];
y1 = tanh(x1*w1');
x2 = [y1 ones(N,1)];
y2 = tanh(x2*w2');
% y2 = x2*w2';
x3 = [y2 ones(N,1)];
y3 = tanh(x3*w3');
x4 = [y3 ones(N,1)];
% y4 = tanh(x4*w4');
Srn_train = x4*w4';
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
disp(sprintf('RMSE = %.12g | Average CER considering all the classes = %.12g',eqm,sum(error_per_class_train)/r));
