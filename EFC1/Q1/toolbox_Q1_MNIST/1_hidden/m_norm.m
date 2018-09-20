% FEEC/Unicamp
% 31/05/2017
% m_norm.m
% Gives a kind of root mean squared error for a matrix
%
function [E] = m_norm(S)
[nr,nc] = size(S);
E = sum(sum(S.*S));
E = sqrt(E/(nr*nc));
