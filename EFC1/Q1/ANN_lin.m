classdef ANN_lin < handle

    properties
        m           % number of hidden neurons
        w           % neuron weights
        act_fun     % activation function
        k           % number of outputs   
        n           % number of inputs
        C           % regularization coefficients
    end
    
    methods
        function obj = ANN_lin(m, act_fun)
            obj.m = m;
            obj.act_fun = act_fun;
        end
        
        function f_t = net(obj,X)
            % Evaluate ANN performance
            N = size(X,1);
            H = ones(N,obj.m+1);
            dispstat('','init');
            for im=1:obj.m
                dispstat(sprintf('Calculating H matrix %.1f%%',im/obj.m*100));
                H(1:N,im+1) = obj.act_fun(X,im);
            end
            f_t = H*obj.w;            
        end
        
        function obj = train(obj, X, S)          
            
            obj.k = size(S,2);
            obj.n = size(X,2);

            %% Adjust regulatization coefficient
            
            % Define training and validation data for the regularization coefficient training
            porc_tr_RC = 0.8;
            idx_tr  = randperm(size(X,1));
            X_tr = X(idx_tr(1:floor(porc_tr_RC*numel(idx_tr))),:);
            s_tr = S(idx_tr(1:floor(porc_tr_RC*numel(idx_tr))),:);
            X_va = X(idx_tr(floor(porc_tr_RC*numel(idx_tr))+1:end),:);
            s_va = S(idx_tr(floor(porc_tr_RC*numel(idx_tr))+1:end),:);

            N_tr = size(X_tr,1);        % Number of training data
            N_va = size(X_va,1);        % Number of training data

            % Create H and s matrices
            dispstat('','init');
            H_tr = ones(N_tr,obj.m+1);
            H_va = ones(N_va,obj.m+1);
            for im=1:obj.m
                dispstat(sprintf('Calculating H matrix %.1f%%',im/obj.m*100));
                H_tr(1:N_tr,im+1) = obj.act_fun(X_tr,im);        % H(iN,im) = h_im(X_iN)
                H_va(1:N_va,im+1) = obj.act_fun(X_va,im);
            end

            % Fitness functions
            fun_wk = @(Ck,k) (H_tr'*H_tr + abs(Ck)*eye(obj.m+1))\H_tr' * s_tr(:,k);
            MSE_va = @(Ck,k) norm(H_va*fun_wk(Ck,k)-s_va(:,k))^2/numel(s_va(:,k));

            dispstat(sprintf('Calculating Regularization Coefficients %.1f%%...',0),'keepprev');
            obj.C = rand(obj.k,1);
            optsoptimset = optimset('Display','off', 'TolX', 1e-6, 'TolFun', 1e-6, 'MaxIter',50,'PlotFcns',{@optimplotfval,@optimplotx });
            for ik=1:obj.k
%                 obj.C(ik) = fminsearch( @(Ck) MSE_va(Ck,ik), obj.C(ik),optsoptimset);
                obj.C(ik) = lsqnonlin( @(Ck) H_va*fun_wk(Ck,ik)-s_va(:,ik), obj.C(ik),[],[],optsoptimset);
%                 obj.C(ik) = fminunc( @(Ck)MSE_va(Ck,ik), obj.C(ik),optsoptimset);
                dispstat(sprintf('Calculating Regularization Coefficients %.1f%%...',ik/obj.k*100));
            end
            
            %% Train linear ANN
            H  = [H_tr ; H_va];
            Sh = [s_tr; s_va];

            % Fitness functions
            fun_wk = @(Ck,k) (H'*H + abs(Ck)*eye(obj.m+1))\H' * Sh(:,k);
            dispstat('','init');
            obj.w = zeros(obj.m+1,obj.k);
            for ik=1:obj.k
                dispstat(sprintf('Calculating ANN weight vector %.1f%%\n',ik/obj.k*100));
                obj.w(:,ik) = fun_wk(obj.C(ik),ik);
            end
        end
    end
    
end

%             N = size(X,1);
%             % Create H and s matrices
%             dispstat('','init');
%             H = ones(N,obj.m+1);
%             for im=1:obj.m
%                 dispstat(sprintf('Calculating H matrix %.1f%%',im/obj.m*100));
%                 H(1:N,im+1) = obj.act_fun(X,im);
%             end