function [T,Event_List, trace, signal]=event1(T,Event_List, trace, C, L, move_style, pace, signal, Grid_Connectivity) %nomad moves

T=Event_List(2,1);
disp('---------')
disp('Event 1')
disp('time')
disp(T)
if move_style == 1 %random movement
    for steps = 1 : pace
        r = rand(); %path probability
        
        if r <= 0.25 %move north
            if trace(1, end) ~= 1 %there is space   
                disp('go north')
                trace(1, end +1) = trace(1, end) - 1; %moves north
                trace(2, end) = trace(2, end - 1) 
                if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                    signal = signal + 1;
                end
            else %edge of the world reached
                disp('no more NORTH left') %you will fall
            end            

        elseif r <= 0.5 %move east
            if trace(2, end) ~= C %there is space
                disp('go east')
                trace(2, end +1) = trace(2, end) + 1; %moves east
                trace(1, end) = trace(1, end - 1);
                if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                    signal = signal + 1;
                end
            else
                disp('no more EAST left')
            end
            
        elseif r <= 0.75 %move south
            if trace(1, end) ~= L
                disp('go south')
                trace(1, end + 1) = trace(1,end) + 1;
                trace(2, end) = trace(2, end - 1);
                if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                    signal = signal + 1;
                end
            else
                disp('no more SOUTH left')
            end
            
        elseif r <= 1%move west
            if trace(2, end) ~= 1
                disp('go west')
                trace(2, end+1) = trace(2, end) - 1;
                trace(1, end) = trace(1, end - 1);
                if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                    signal = signal + 1;
                end
            else
                disp('no more WEST left')
            end
        end
    end
    
elseif move_style == 2
    for steps = 1 : pace
    move_or_stay = rand(); %decide whether to move or not
    if move_or_stay <= 0.2
        disp('i will stay here')
        
    else %lets move
        %for steps = 1 : pace
            hor_or_ver = rand();
            if hor_or_ver <= 0.5 %horizontal 
                
                step_prob = abs( (ceil(L/2) - trace(2,end) ) / ( ceil(L/2) - 1 ));
                if step_prob == 0 %move W
                    disp('go west')
                    trace(2, end + 1) = trace(2, end) - 1; %col
                    trace(1, end) = trace(1, end - 1);
                    if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                    signal = signal + 1;
                    end
                    
                elseif step_prob > 0 %move E
                    if trace(2, end) ~= C
                        disp('go east')
                        trace(2, end+1) = trace(2,end) + 1;
                        trace(1, end) = trace(1, end - 1);
                        if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                        signal = signal + 1;
                        end
                    else
                        disp('no more E left')
                    end
                end
                
            elseif hor_or_ver <= 1 %vertical
                step_prob = abs( (ceil(L/2) - trace(1,end) ) / ( ceil(L/2) - 1) ); %north or south prob
                
                if step_prob == 0 %move N
                    disp('go north')
                    trace(1, end + 1) = trace(1, end) - 1; %line
                    trace(2, end) = trace(2, end -1);
                    if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                        signal = signal + 1;
                    end
                    
                elseif step_prob > 0 %move S
                    %check if any S left
                    if trace(1, end) ~= L %move South
                        disp('go south')
                        trace(1, end +1) = trace(1,end) + 1;%line
                        trace(2, end) = trace(2, end -1);
                        if Grid_Connectivity(trace(1,end), trace(2,end)) == 1
                        signal = signal + 1;
                        end
                    else
                        disp('no more S left')
                    end 
                end 
            end
    end
    end
    
else
    disp('invalid move style')
    disp('1 or 2 accepted')
end


Event_List(1,end+1) = 1;
Event_List(2,end) = T+1;
    
end