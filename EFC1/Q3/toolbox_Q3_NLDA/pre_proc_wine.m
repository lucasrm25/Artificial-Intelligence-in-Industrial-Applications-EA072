% FEEC/Unicamp
% 25/05/2017
% Preprocessing Wine Data Set (UCI Machine Learning Repository)
%
clear all;
D = load('wine.txt');
X = D(:,2:end);
[nl,nc] = size(X);
for i=1:nc,
    maxX = max(X(:,i));
    minX = min(X(:,i));
    X(:,i) = -1 + 2*(X(:,i)-minX)/(maxX-minX);
end
for i=1:nl,
    if D(i,1) == 1,
        S(i,:) = [1 0 0];
    elseif D(i,1) == 2,
        S(i,:) = [0 1 0];
    elseif D(i,1) == 3,
        S(i,:) = [0 0 1];
    end
end
save wine X S;
