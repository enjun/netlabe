function [ neighbors, next_hop ] = Init( cost_matrix )


size_cost = size(cost_matrix);

neighbors = zeros( size_cost(1) , size_cost(2) );
next_hop = zeros( size_cost(1) , size_cost(2) ); 

for lines = 1 : size_cost(1)
    for rows = 1 : size_cost(2)
        if cost_matrix(lines,rows) ~= 999 && cost_matrix(lines,rows) ~= 0
            neighbors(lines, rows) = 1; 
        end
    end
end


for lines = 1 : size_cost(1)
    for rows = 1 : size_cost(2)
        if cost_matrix(lines,rows) == 999 || cost_matrix(lines,rows) == 0
            next_hop(lines, rows) = cost_matrix(lines, rows);
        else
            next_hop(lines, rows) = rows;
        end
    end
end

end
