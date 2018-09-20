classdef ANN_ELM < handle 
    
    properties
        n           % number of neurons in each layer
        w           % neuron weights - cell array
        C           % reguralization coefficient
        act_fun     % activation function
        w_minmax
        H_fun
        H
        D
        CIW=false
    end
    properties (Dependent)        
    end
    
    methods
        function obj = ANN_ELM(hidden_structure, act_fun, minmax, varargin)
            obj.n = [1 hidden_structure 1];
            obj.act_fun = act_fun;
            obj.H_fun = @(x,w) arrayfun(obj.act_fun ,x*w);
            obj.w_minmax = sort(minmax,'descend');
            if strcmp(varargin,'CIW')
                obj.CIW = true;
            end
        end
        
        function f_t = net(obj,X)
            % Evaluate ANN performance
            H = X;
            for il=1:numel(obj.n)-2
                H = [ones(size(H,1),1) H];
                H = obj.H_fun(H, obj.w{il});
            end
            H = [ones(size(H,1),1) H];
            f_t = H*obj.w{end}; 
        end
        
        function obj = train(obj, X, S)          
            
            obj.n(end) = size(S,2);
            obj.n(1) = size(X,2);
 
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

            % Randomize weights
            for i=1:numel(obj.n)-1
                if i==1 && obj.CIW                   
                    obj.w{i} = (randi([-1 1],obj.n(i+1),size(X,1)) * [ones(size(X,1),1) X])';
                    for j=1:size(obj.w{i},2)
                        obj.w{i}(:,j) = obj.w{i}(:,j)./(sqrt(sum(obj.w{i}(:,j).^2)));
                    end
                else
                    obj.w{i} = rand(obj.n(i)+1,obj.n(i+1))*(obj.w_minmax(1)-obj.w_minmax(2)) + obj.w_minmax(2);
                end
            end
            
            % Create H and s matrices
            H_tr = X_tr;
            H_va = X_va;
            dispstat(sprintf('Calculating H matrix %.1f%%...',0),'keepprev');
            for il=1:numel(obj.n)-2  
                H_tr = [ ones(size(H_tr,1),1) H_tr];
                H_tr = obj.H_fun(H_tr, obj.w{il});
                dispstat(sprintf('Calculating H matrix %.1f%%...',il/2/(numel(obj.n)-2)*100));
                H_va = [ones(size(H_va,1),1) H_va];
                H_va = obj.H_fun(H_va, obj.w{il});
                dispstat(sprintf('Calculating H matrix %.1f%%...',il/(numel(obj.n)-2)*100));
            end
            H_tr = [ones(size(H_tr,1),1) H_tr];
            H_va = [ones(size(H_va,1),1) H_va];


            % Fitness functions
            fun_wk = @(Ck,k) (H_tr'*H_tr + abs(Ck)*eye(obj.n(end-1)+1))\H_tr' * s_tr(:,k);
            MSE_va = @(Ck,k) norm(H_va*fun_wk(Ck,k)-s_va(:,k))^2/numel(s_va(:,k));

            dispstat(sprintf('Calculating Regularization Coefficients %.1f%%...',0),'keepprev');
            obj.C = rand(obj.n(end),1);
            optsoptimset = optimset('Display','off','MaxIter',50,'TolX',1e-6,'TolFun',1e-6,'PlotFcns',{@optimplotfval,@optimplotx });
            for ik=1:obj.n(end)
%                 obj.C(ik) = fminsearch( @(Ck) MSE_va(Ck,ik), obj.C(ik), optsoptimset);
                obj.C(ik) = lsqnonlin( @(Ck) H_va*fun_wk(Ck,ik)-s_va(:,ik), obj.C(ik),[],[],optsoptimset);
%                 obj.C(ik) = fminunc( @(Ck) MSE_va(Ck,ik), obj.C(ik),optsoptimset);                
                dispstat(sprintf('Calculating Regularization Coefficients %.1f%%...',ik/obj.n(end)*100));
            end
            obj.C = abs(obj.C);
            

            %% Train ELM ANN

            % Create H and s matrices
            H = X;
            dispstat(sprintf('Calculating H matrix %.1f%%...',0),'keepprev');
            for il=1:numel(obj.n)-2     
                H = [ones(size(H,1),1) H];
                H = obj.H_fun(H, obj.w{il});
                dispstat(sprintf('Calculating H matrix %.1f%%...',il/(numel(obj.n)-2)*100));
            end
            H = [ones(size(H,1),1) H];
            
            % Determine output layer weights            
            fun_wk = @(Ck,k) (H'*H + abs(Ck)*eye(obj.n(end-1)+1))\H' * S(:,k);
            fun_Dk = @(Ck,k) (H'*H + abs(Ck)*eye(obj.n(end-1)+1))\H';
            for ik=1:obj.n(end)
                obj.D{ik} = fun_Dk(obj.C(ik),ik);
                obj.w{end}(:,ik) = obj.D{ik} * S(:,ik);
            end
            
            obj.H = H;           
            dispstat(sprintf('Finished'),'keepprev','keepthis');
        end
        
        function obj = IR_train(obj, X, S)
            obj.n(end-1) = obj.n(2)+1;
            if obj.CIW                   
                obj.w{end-1}(:,end+1) = (randi([-1 1],1,size(X,1)) * [ones(size(X,1),1) X])';                
                obj.w{end-1}(:,end) = obj.w{end-1}(:,end)./norm(obj.w{end-1}(:,end));
            else
                obj.w{end-1}(:,end+1) = rand(obj.n(1)+1,1)*(obj.w_minmax(1)-obj.w_minmax(2)) + obj.w_minmax(2);
            end                        
            obj.w{end}(end+1,:) = 1;
            v = [ones(size(obj.H,1),1) X];
            v = obj.H_fun(v, obj.w{1}(:,end));
            for ik=1:obj.n(end)                
                M = (v' - v'*obj.H*obj.D{ik}) / ((v' - v'*obj.H*obj.D{ik})*v + obj.C(ik));
                L = obj.D{ik} - obj.D{ik}*v*M;
                obj.D{ik} = [L ; M];         
                obj.w{end}(:,ik) = obj.D{ik} * S(:,ik);
            end
            obj.H = [obj.H v];
        end

    end
end






