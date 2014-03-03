function [ exponential_numbers ] = expo2( m, x_0,  c, a, l1 )

U = []; %the initial array for rng

exponential_numbers = [];

[U] = rng(m, x_0, c, a, U); %calls rng() ypoxrewtika

exponential_numbers = -(1 / l1) * log(1 - U); %ln() seems to not exists in matlab(R2011a), log is used instead
  
%interarrival_time = exponential_numbers; 

end

