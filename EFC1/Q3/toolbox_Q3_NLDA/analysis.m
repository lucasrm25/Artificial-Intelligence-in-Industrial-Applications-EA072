% FEEC/Unicamp
% 25/05/2017
% Verification of the performance of the neural network
% Use of the weights obtained after training the neural network
% Presentation of graphical results
% Wine Data Set (UCI Machine Learning Repository)
%
clear all;
load w1;load w2;load w3;load w4;load evol;
load wine; % Training data
N = length(X(:,1));
n(1,1) = length(w1(:,1));
n(2,1) = length(w2(:,1));
n(3,1) = length(w3(:,1));
n(4,1) = length(w4(:,1));
r = n(4);
m = length(w1(1,:))-1;
np1 = n(1)*(m+1);np2 = n(2)*(n(1)+1);np3 = n(3)*(n(2)+1);np4 = n(4)*(n(3)+1);
n_weights = np1+np2+np3+np4;
disp(sprintf('No. of training patterns = %d',N));
disp(sprintf('No. of hidden layer neurons = [%d,%d,%d]',n(1),n(2),n(3)));
disp(sprintf('No. of weights = %d',n_weights));
disp(sprintf('No. of iterations = %d',n_iter));
% Srn = [tanh([tanh([tanh([X ones(N,1)]*w1') ones(N,1)]*w2') ones(N,1)]*w3') ones(N,1)]*w4';
Srn = [tanh([[tanh([X ones(N,1)]*w1') ones(N,1)]*w2' ones(N,1)]*w3') ones(N,1)]*w4';
verro = reshape(S-Srn,N*r,1);
eqf = 0.5*(verro'*verro);
disp(sprintf('Final squared error = %.12g',eqf));
for k=1:r,
	figure(k);subplot(111);plot(S(:,k),'r');hold on;plot(S(:,k),'*r');
	plot(Srn(:,k),'g');plot(Srn(:,k),'*g');hold off;
    title('Desired (r)  NN (g)');
    xlabel(sprintf('Output %d',k));
end
for k=(r+1):(r+r),
	figure(k);subplot(111);plot(S(:,k-r)-Srn(:,k-r),'r');
	hold on;plot(S(:,k-r)-Srn(:,k-r),'*g');hold off;
	title('Error = Desired-NN');
    xlabel(sprintf('Output %d',k-r));
end
for k=1:r,
	Smean(1,k) = (1/N)*S(:,k)'*ones(N,1);
end
den = 0;num = 0;
for l=1:N,
	for k=1:r,
		num = num+(S(l,k)-Srn(l,k))^2;
		den = den+(S(l,k)-Smean(1,k))^2;
	end
end
fvu = num/den;
disp(sprintf('FVU = %.12g',fvu));
figure(r+r+1);subplot(111);plot(eq);title('Squared error');
figure(r+r+2);subplot(411);plot(stw1);title('Change in weights along training');
subplot(412);plot(stw2);subplot(413);plot(stw3);subplot(414);plot(stw4);
