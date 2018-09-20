function p = LogFactorial(n)
%LogFactorial - Returns natural log of the factorial of n

[R,C]=size(n);

if R==1 & C==1
   p=sum(log(1:n));
   return
end

if min(R,C)==1
   
   for i = 1:length(n)
      p(i)=sum(log(1:n(i)));
   end
   return
end

error('LogFactorial requires scalar or 1-d vector input!')

