function [ ] = normal( m, U )

U1 = [];
U2 = [];
temp = [];
X1 = [];
X2 = [];
Z1 = [];
Z2 = [];

U1 = U; %first U is the original RNG

disp('going to create U2 now')
x_0 = input('input the seed\n');
c = input('input the incremental\n');
a = input('input the multiplier\n');
temp = rng( m, x_0, c, a, temp);
U2 = temp; %output second U

A = input('enter limit A\n');
B = input('enter limit B\n');

X1 = ((-2 .* log(U1)).^(1/2)) .* cos(2 * pi .* U2);
X2 = ((-2 .* log(U1)).^(1/2)) .* sin(2 * pi .* U2);

m = input('enter average \n'); %mesi timi
s = input('enter dispersion \n'); %diaspora

Z1 = m + s .* X1; %use X1 this time
Z2 = m + s .* X2; %use X2 this time

figure(1);
plot([1 : length(Z1)], sort(Z1)); %using Z1 only
figure(2);
plot([1 : length(Z2)], sort(Z2)); %using Z2 only

end

