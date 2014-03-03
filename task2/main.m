function [ ] = main( m, x_0,  c, a )

U = []; %the initial array for rng
uniform_numbers = []; 
exponential_numbers = [];

if mod(c, 2) == 0
    disp('incremental is not odd number')
    return;
end

if mod(a-1, 4) ~= 0
    disp('multiplier -1 is not divisible by 4')
    return;
end

if x_0 > m
    disp('seed is bigger than m...converting to m-1');
    x_0 = m - 1; 
end

[U] = rng(m, x_0, c, a, U); %calls rng() ypoxrewtika

choice =0; %menu choices
while choice ~= 6 % gia na exitarei

choice = menu('ENTER THE MATRIX','plot RNG', 'uniform', 'exponential', 'normal', 'poisson', 'exit');

    if choice == 1
        figure(1);
        plot([1:m],U); %plots rng()
        figure(2);
        plot([1:m],sort(U)); %plots sorted
        
    elseif choice == 2 %uniform
        A = input('enter limit A\n');
        B = input('enter limit B\n');
        uniform_numbers = U * (B-A) + A;
        figure(1);
        plot([1:m], uniform_numbers); %non sorted
        figure(2);
        plot([1:m], sort(uniform_numbers)); %sorted
    
    elseif choice == 3 %exponential
        l1 = input('enter random positive number\n'); 
        exponential_numbers = -(1 / l1) * log(1 - U); %ln() seems to not exists in matlab(R2011a), log is used instead
        figure(1);
        plot([1:m], exponential_numbers); %non soted
        figure(2);
        plot([1:m], sort(exponential_numbers));  %sorted
        
    elseif choice == 4 %normal
        normal(m, U);
        
    elseif choice == 5 %poisson
        poisson(m, U);
       
    end%end if
end %while
    
end

