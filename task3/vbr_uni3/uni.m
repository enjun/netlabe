function [ packet_size ] = uni( packet_size, m, x_0,  c, a, A, B )

U = []; %the initial array for rng
uniform_numbers = []; 

[U] = rng(m, x_0, c, a, U); %calls rng() ypoxrewtika

uniform_numbers = U * (B-A) + A;
packet_size = uniform_numbers;
    
end

