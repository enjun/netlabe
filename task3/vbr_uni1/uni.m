function [ packet_size ] = uni( packet_size, m, x_0,  c, a  )

U = []; %the initial array for rng
uniform_numbers = []; 

[U] = rng(m, x_0, c, a, U); %calls rng() ypoxrewtika
       
A = 64;
B = 1518;

uniform_numbers = fix(U * (B-A) + A);
packet_size = uniform_numbers;
    
end

