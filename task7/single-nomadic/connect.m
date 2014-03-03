function [Grid_Connectivity] = connect(Grid_Connectivity, l, c, L, C, range)
cur_line = l;
cur_col = c;

for up = 1: range
    cur_line = cur_line - 1;
    if cur_line >0
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

cur_line = l;

for down = 1 : range
    cur_line = cur_line + 1;
    if cur_line <= L
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

cur_line = l;

for left = 1: range
    cur_col = cur_col - 1;
    if cur_col > 0
        Grid_Connectivity(cur_line, cur_col) = 1
    else
        break;
    end
end

cur_col = c;

for right = 1 : range
    cur_col = cur_col + 1
    if cur_col <= C
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

cur_col = c;

for ur = 1 : range -1
    cur_line = cur_line - 1;
    cur_col = cur_col + 1;
    if cur_line > 0 && cur_col <= C
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

cur_line = l;
cur_col = c;

for dl = 1 : range - 1
    cur_line = cur_line + 1;
    cur_col = cur_col - 1;
    if cur_line <= L && cur_col > 0
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

cur_line = l;
cur_col = c;

for ul = 1 : range - 1
    cur_line = cur_line - 1;
    cur_col = cur_col - 1;
    if cur_line > 0 && cur_col > 0
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

cur_line = l;
cur_col = c;

for dr = 1 : range - 1
    cur_line = cur_line + 1;
    cur_col = cur_col + 1;
    if cur_line <= L && cur_col <= C
        Grid_Connectivity(cur_line, cur_col) = 1;
    else
        break;
    end
end

end

