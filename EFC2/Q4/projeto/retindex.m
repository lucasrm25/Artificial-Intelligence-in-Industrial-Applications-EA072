function out = retindex(siz,ndx)
% RETINDEX receives a linear matrix index and returns its matrix
% indices. The matrix indices follows binary growing.
% Example:
% siz = [3 3];
% retindex(siz,[1 1]) => 1
% retindex(siz,[1 2]) => 2
% retindex(siz,[1 3]) => 3
% retindex(siz,[2 2]) => 5

siz = siz(length(siz):-1:1);
n = length(siz);
k = [1 cumprod(siz(1:end-1))];
ndx = ndx - 1;
for i = n:-1:1,
  out(i) = floor(ndx/k(i))+1;
  ndx = rem(ndx,k(i));
end
out = out(length(out):-1:1);