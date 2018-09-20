function [ndx] = index(siz,ind)
% Receives a matrix index and returns its matrix indices.
% The matrix indices follows binary growing.
% Example:
% siz = [3 3];
% index(siz,1) => [1 1]
% index(siz,2) => [1 2]
% index(siz,3) => [1 3]
% index(siz,5) => [2 2]

siz = siz(length(siz):-1:1);
ind = ind(length(ind):-1:1);
n = length(siz);
if n>length(ind)&~isempty(find(siz==1))&n==2
    ndx = ind;
else
    k = [1 cumprod(siz(1:end-1))];
    ndx = 1;
    for i = 1:n,
        ndx = ndx + (ind(i)-1)*k(i);
    end
end
