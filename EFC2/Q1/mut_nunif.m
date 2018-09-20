function [delta] = mut_nunif(ger,intv,max_ger)
p = 3;
r = rand(1,1);
delta = intv*(1-r^((1-(ger/max_ger))^p));
