function [  ] = poisson( m, U )

l2 = input('enter l for poisson distribution\n');

L = exp(-l2); % the target to reach
poisson = [];
i = 1; %main counter. don't touch
ii=1; %in case you run out of bounds, i 'll save you
while i <= m
    k = 0;
    p = 1;
    while p > L % while p is bigger than target
        k = k + 1;
        if ii > m %or ii > length(U)
            ii=1;
        end
        p = p * U(ii);
        ii = ii + 1;
        %disp(p)
    end %while
    l=size(poisson);
    poisson(1, l(2) + 1) =  k - 1;
    i = i + 1;        
end
figure(1);
plot([1:m], sort(poisson));
figure(2);
plot([1:m], poisson);

end

