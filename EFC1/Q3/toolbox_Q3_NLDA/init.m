% FEEC/Unicamp
% 25/05/2017
% Random generation of the neural network weights, with
% uniform distribution on the interval [-0.1,+0.1]
% function [w1,w2,w3,w4,eq,stw1,stw2,stw3,stw4,n_iter] = init(n,m)
% m = no. of inputs
% n = no. of neurons in the hidden and output layers -> n = [n(1);n(2);n(3);n(4)]
% w1, w2, w3, w4: weight matrices (one for each layer)
% w1:[n(1)]x[m+1]   w2:[n(2)]x[n(1)+1]   w3:[n(3)]x[n(2)+1]   w4:[n(4)]x[n(3)+1]
% Type of weight generation:
% Option 1 -> Start the training from a random initial condition
% Option 2 -> Restart the training from the same initial condition
% Option 3 -> Restart the training from the last set of weights obtained
%             after training
%
function [w1,w2,w3,w4,eq,stw1,stw2,stw3,stw4,n_iter] = init(n,m)
disp('(1) Generate w10, w20, w30 and w40, and save');
disp('(2) Copy existing w10, w20, w30 and w40');
disp('(3) Copy existing w1, w2, w3 and w4');
resp = 1;%input('Type of weight generation: ');
if resp == 1;
	w1 = -0.1 + 0.2*rand(n(1),m+1);
	w2 = -0.1 + 0.2*rand(n(2),n(1)+1);
	w3 = -0.1 + 0.2*rand(n(3),n(2)+1);
	w4 = -0.1 + 0.2*rand(n(4),n(3)+1);
	save w10 w1;save w20 w2;save w30 w3;save w40 w4;
	eq = [];stw1 = [];stw2 = [];stw3 = [];stw4 = [];n_iter = 0;
elseif resp == 2,
	load w10;load w20;load w30;load w40;
	eq = [];stw1 = [];stw2 = [];stw3 = [];stw4 = [];n_iter = 0;
elseif resp == 3,
	load w1;load w2;load w3;load w4;
	load evol;
else
	error('Not a valid option!');
end
