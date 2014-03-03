function [ U ] = rng( m, x_0, c, a, U )

prev=x_0; %x_i-1 prohgoumeno stoixeio
x_i=[x_0]; %pinakas ton x
u=[];   %pinakas pou me touys tuxaious

for i = 2 : m
    x=mod(a*prev + c, m); %epomeno stoixeio
    prev=x;
    l=size(x_i);
    x_i(1,l(2)+1)=x; %apo8ikeyse to twrino stoixeio
end

u=x_i/m ; %o pinakas pou xreiazomaste

U=u;

end

