% FEEC/Unicamp
% 31/05/2017
% nn2h_k_folds.m
% Training of a two hidden layer feedforward neural network (perceptron)
% Second-order optimization: extended conjugate gradient algorithm
% Exact computation of the Hessian matrix (product H*p)
% Required data for supervised learning
% data.mat, with X (input matrix) and S (output matrix)
% Prepared for the MNIST dataset
% Learning with k-folds cross-validation
% Auxiliary functions:
% init_k_folds.m / process.m / m_norm.m / hprocess.m / qmean2.m
% CER: Classification Error Rate
%
clear all;
% Gradient norm: minimum value
threshold = 1.0e-5;
rate0 = 0.25;
rate = rate0;
cut = 0.25;
it1 = 0; % for lambda
it2 = 0; % for comp
it1 = it1+1;lambda(it1) = 0.0;
blambda = 0;
% Loading the training data (it is assumed that the range of the
% training data is adequate. If not, they have to be normalized).
% X (input matrix [N]x[m]) and S (output matrix [N]x[n_out])
filename = input('Filename root of the folds (use single quotes): ');
load data;
% Number of folds for crossvalidation
k = input('Number of folds: k = ');
[N,m] = size(X);
n(1,1) = input('Number of neurons at the first hidden layer (nonlinear units) = ');
n(2,1) = input('Number of neurons at the second hidden layer (linear units) = ');
disp('(1) Generate w10 and w20, and save');
disp('(2) Copy existing w10 and w20');
disp('(3) Copy existing w1 and w2');
resp = input('Type of weight generation: ');
fig = 0;
for fold=1:k,
    disp(sprintf('Fold = %d',fold));
    Xacc = [];Sacc = [];
    for i=1:k,
        if i~=fold,
            load(strcat(filename,sprintf('%d',i)));
            Xacc = [Xacc;X];Sacc = [Sacc;S];
        else
            load(strcat(filename,sprintf('%d',i)));
            Xv = X;
            Sv = S;
        end
    end
    X = Xacc;S = Sacc;
    % X (input matrix [N]x[n_in]) and S (output matrix [N]x[n_out])
    % Xv (input matrix [Nv]x[n_in]) and Sv (output matrix [Nv]x[n_out])
    n_in = length(X(1,:));
    n_out = length(S(1,:));
    N = length(X(:,1));disp(sprintf('Number of input-output patterns (training) = %d',N));
    Nv = length(Xv(:,1));disp(sprintf('Number of input-output patterns (validation) = %d',Nv));
    [w1,w2,w3,eq,CERv,stw1,stw2,stw3,rms_w,CER_min,n_iter_v,n_iter,n_itermax,error_per_class_v] = init_k_folds(n_in,n,n_out,fold,resp);
    if fold == 1,
        disp(sprintf('Number of inputs = %d',m));
        np1 = n(1)*(m+1);np2 = n(2)*(n(1)+1);np3 = n_out*(n(2)+1);
        n_weights = np1+np2+np3;disp(sprintf('Number of weights in the neural network = %d',n_weights));
    end
    rms_w = [rms_w;qmean2(w1,w2,w3)];
    [Ew,dEw,eqm,CER,error_per_class] = process(X,S,Xv,Sv,w1,w2,w3);
    error_per_class_v = [error_per_class_v;error_per_class];
    eq = [eq;Ew];%disp(sprintf('Initial squared error (training) = %.12g',Ew));
    CERv = [CERv;CER];disp(sprintf('Initial CER (validation) = %.12g',CER));
    if isempty(CER_min),
        CER_min = CER;
    end
    iter_minor = 1;
    p = -dEw;p_1 = p;r = -dEw;success = 1;
    while m_norm(dEw) > threshold & n_iter < n_itermax,
        if success,
            p1 = reshape(p(1:np1),m+1,n(1))';
            p2 = reshape(p(np1+1:np1+np2),n(1)+1,n(2))';
            p3 = reshape(p(np1+np2+1:np1+np2+np3),n(2)+1,n_out)';
            s = hprocess(X,S,w1,w2,w3,p1,p2,p3);
            delta = p'*s;
        else
            disp(sprintf('[%s,%d]','Fail',n_iter));
        end
        delta = delta+(lambda(it1)-blambda)*(p'*p);
        if delta <= 0, % Making delta a positive value
            blambda = 2*(lambda(it1)-delta/(p'*p));
            delta = -delta+lambda(it1)*(p'*p);
            it1 = it1+1;lambda(it1) = blambda;
        end
        mi = p'*r;
        alpha = mi/delta;
        vw = [reshape(w1',np1,1);reshape(w2',np2,1);reshape(w3',np3,1)];
        vw1 = vw + alpha*p;
        w11 = reshape(vw1(1:np1),m+1,n(1))';
        w21 = reshape(vw1(np1+1:np1+np2),n(1)+1,n(2))';
        w31 = reshape(vw1(np1+np2+1:np1+np2+np3),n(2)+1,n_out)';
        [Ew1,dEw1,eqm1,CER1,error_per_class1] = process(X,S,Xv,Sv,w11,w21,w31);
        it2 = it2+1;comp(it2) = (Ew-Ew1)/(-dEw'*(alpha*p)-0.5*(alpha^2)*delta);
        %	In replacement to comp(it2) = 2*delta*(Ew-Ew1)/(mi^2); (is the same)
        if comp(it2) > 0,
            Ew = Ew1;eq = [eq;Ew];
            if CER1 < CER_min,
                CER_min = CER1;
                w1_prov = w1;w2_prov = w2;w3_prov = w3;
                w1 = w11;w2 = w21;w3 = w31;
                save(strcat('w1v',sprintf('%d',fold)),'w1');
                save(strcat('w2v',sprintf('%d',fold)),'w2');
                save(strcat('w3v',sprintf('%d',fold)),'w3');
                w1 = w1_prov;w2 = w2_prov;w3 = w3_prov;
                n_iter_v = n_iter;
            end
            CER = CER1;CERv = [CERv;CER];
            dEw = dEw1;
            deltaw1 = m_norm(w1-w11);deltaw2 = m_norm(w2-w21);deltaw3 = m_norm(w3-w31);
            stw1 = [stw1;deltaw1];stw2 = [stw2;deltaw2];stw3 = [stw3;deltaw3];
            rms_w = [rms_w;qmean2(w11,w21,w31)];
            w1 = w11;w2 = w21;w3 = w31;
            error_per_class_v = [error_per_class_v;error_per_class1];
            eqm_fim = eqm1;
            n_iter = n_iter+1;
            disp(sprintf('%5d %d %.12g',n_iter,iter_minor,Ew));
            r1 = r;
            r = -dEw;
            blambda = 0;
            success = 1;
            if (iter_minor == n_weights),
                p_1 = p;p = r;
                iter_minor = 1;
            else
                iter_minor = iter_minor + 1;
                beta = (r'*r-r'*r1)/(r1'*r1); % Polak-Ribiere (Luenberger, pp 253)
                p_1 = p;p = r+beta*p;
            end
            if comp(it2) >= cut,
                it1 = it1+1;lambda(it1) = rate*lambda(it1-1); % /4
                rate = rate*rate0;
            end
        else
            blambda = lambda(it1);
            success = 0;
        end
        if comp(it2) < cut,
            it1 = it1+1;lambda(it1) = lambda(it1-1) + (delta*(1-comp(it2))/(p_1'*p_1));
            rate = rate0;
        end
    end
    disp(sprintf('Final mean squared error (training) = %.12g at iteration %d',eqm_fim,n_iter));
    disp(sprintf('Final CER (validation) = %.12g at iteration %d',CER_min,n_iter_v));
    save(strcat('w1',sprintf('%d',fold)),'w1');
    save(strcat('w2',sprintf('%d',fold)),'w2');
    save(strcat('w3',sprintf('%d',fold)),'w3');
    save(strcat('evol',sprintf('%d',fold)),'eq','CERv','stw1','stw2','stw3','rms_w','n_iter','lambda','comp','CER_min','n_iter_v','error_per_class_v');
    fig = fig+1;figure(fig);plot(CERv);title(sprintf('Evolution of the Classification Error Rate along training - Fold = %d',fold));xlabel('Epochs');ylabel('CER');
    fig = fig+1;figure(fig);plot(eq);title(sprintf('Evolution of the quadratic error along training - Fold = %d',fold));xlabel('Epochs');ylabel('Quadratic error');
    drawnow;
end
