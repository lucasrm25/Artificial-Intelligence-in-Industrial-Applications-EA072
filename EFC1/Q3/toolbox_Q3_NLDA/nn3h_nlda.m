% FEEC/Unicamp
% 25/05/2017
% nn3h_nlda.m
% Training of a three hidden layer feedforward neural network (perceptron)
% Activation functions are linear in the output layer and 2nd hidden layer
% Second-order optimization: extended conjugate gradient algorithm
% Exact computation of the Hessian matrix (product H*p)
% Required data for supervised learning
% wine.mat, with X (input matrix) and S (output matrix)
% Auxiliary functions:
% init.m / process.m / m_norm.m / hprocess.m / saveinf.m
%
clear all;
% Gradient norm: minimum value
threshold = 1.0e-5;
rate0 = 0.25;
rate = rate0;
cut = 0.25;
it1 = 0; % for lamb
it2 = 0; % for comp
it1 = it1+1;lamb(it1) = 0.0;
blamb = 0;
% Loading the training data (it is assumed that the range of the
% training data is adequate. If not, they have to be normalized).
% X (input matrix [N]x[m]) and S (output matrix [N]x[n(4)])
load wine;
[N,m] = size(X);
n(1,1) = 15;%input('Number of neurons at the first hidden layer (nonlinear units) = ');
n(2,1) = 2;%input('Number of neurons at the second hidden layer (linear units) = ');
n(3,1) = 15;%input('Number of neurons at the third hidden layer (nonlinear units) = ');
n(4,1) = length(S(1,:));
%
[w1,w2,w3,w4,eq,stw1,stw2,stw3,stw4,n_iter] = init(n,m); % w1:[n(1)]x[m+1] w2:[n(2)]x[n(1)+1] w3:[n(3)]x[n(2)+1] w4:[n(4)]x[n(3)+1]
%
disp(sprintf('Number of input-output patterns = %d',N));
np1 = n(1)*(m+1);np2 = n(2)*(n(1)+1);np3 = n(3)*(n(2)+1);np4 = n(4)*(n(3)+1);
n_weights = np1+np2+np3+np4;disp(sprintf('Number of weights in the neural network = %d',n_weights));
[Ew,dEw] = process(X,S,w1,w2,w3,w4,n,m,N);
eq = [eq;Ew];disp(sprintf('Initial squared error = %.12g',Ew));
iter_minor = 1;
p = -dEw;p_1 = p;r = -dEw;success = 1;
n_epochs = input('Maximum number of training epochs = ');
while m_norm(dEw) > threshold & n_iter < n_epochs,
	if success,
        p1 = reshape(p(1:np1),m+1,n(1))';
        p2 = reshape(p(np1+1:np1+np2),n(1)+1,n(2))';
        p3 = reshape(p(np1+np2+1:np1+np2+np3),n(2)+1,n(3))';
        p4 = reshape(p(np1+np2+np3+1:n_weights),n(3)+1,n(4))';
        s = hprocess(X,S,w1,w2,w3,w4,p1,p2,p3,p4,n,m,N);
        delta = p'*s;
    else
        disp(sprintf('[%s,%d]','Fail',n_iter));
    end
	delta = delta+(lamb(it1)-blamb)*(p'*p);
	if delta <= 0, % Making delta a positive value
		blamb = 2*(lamb(it1)-delta/(p'*p));
		delta = -delta+lamb(it1)*(p'*p);
		it1 = it1+1;lamb(it1) = blamb;
    end
    mi = p'*r;
    alpha = mi/delta;
	vw = [reshape(w1',np1,1);reshape(w2',np2,1);reshape(w3',np3,1);reshape(w4',np4,1)];
	vw1 = vw + alpha*p;
    w11 = reshape(vw1(1:np1),m+1,n(1))';
    w21 = reshape(vw1(np1+1:np1+np2),n(1)+1,n(2))';
    w31 = reshape(vw1(np1+np2+1:np1+np2+np3),n(2)+1,n(3))';
    w41 = reshape(vw1(np1+np2+np3+1:n_weights),n(3)+1,n(4))';
    [Ew1,dEw1] = process(X,S,w11,w21,w31,w41,n,m,N);
    it2 = it2+1;comp(it2) = (Ew-Ew1)/(-dEw'*(alpha*p)-0.5*(alpha^2)*delta);
    if comp(it2) > 0,
        Ew = Ew1;eq = [eq;Ew];
        dEw = dEw1;
        deltaw1 = m_norm(w1-w11);deltaw2 = m_norm(w2-w21);deltaw3 = m_norm(w3-w31);deltaw4 = m_norm(w4-w41);
        stw1 = [stw1;deltaw1];stw2 = [stw2;deltaw2];stw3 = [stw3;deltaw3];stw4 = [stw4;deltaw4];
        w1 = w11;w2 = w21;w3 = w31;w4 = w41;
		n_iter = n_iter+1;
		disp(sprintf('%5d %d %.12g',n_iter,iter_minor,Ew));
		r1 = r;
		r = -dEw;
		blamb = 0;
		success = 1;
		if (iter_minor == n_weights),
			p_1 = p;p = r;
			iter_minor = 1;
			saveinf;
		else
			iter_minor = iter_minor + 1;
			beta = (r'*r-r'*r1)/(r1'*r1); % Polak-Ribiere (Luenberger, pp 253)
			p_1 = p;p = r+beta*p;
		end
		if comp(it2) >= cut,
			it1 = it1+1;lamb(it1) = rate*lamb(it1-1); % /4
			rate = rate*rate0;
		end
	else
		blamb = lamb(it1);
		success = 0;
	end
	if comp(it2) < cut,
		it1 = it1+1;lamb(it1) = lamb(it1-1) + (delta*(1-comp(it2))/(p_1'*p_1));
		rate = rate0;
	end
end
saveinf;
