% 15/04/2017 - FEEC/Unicamp
clear all;
load('sunspot.txt');
MAX = 0.2;
[nl,nc] = size(sunspot);
series = [];
for i=1:nl,
    series = [series;sunspot(i,2:13)'];
end
delays = 20;%input('Number of delays to be considered = ');
aleat = 5;%input('Number of random inputs to be considered = ');
v_max = max(series);
% Rescale the time series to fit the [0.0;MAX] interval
series = MAX*(series./v_max);
[nl] = length(series);
data = [];
for j=(delays+1):nl,
    data = [data;series((j-delays):j,1)'];
end
X = data(:,1:delays);
nl = length(X(:,1));
X = [X MAX*rand(nl,aleat)];
S = data(:,(delays+1));
save train X S delays aleat;
