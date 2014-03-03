function [T,Event_List, trace, nomad_moves, con_signal]=event1(T,Event_List, trace, C, L, move_style, pace, Grid_Connectivity, nomad_moves, con_signal) %nomad moves

T=Event_List(2,1);
disp('---------')
disp('Event 1')
fprintf('time %d\n', T)
fprintf('nomad id %d\n', Event_List(3,1))

if move_style == 1 %random movement
    for steps = 1 : pace
        r = rand(); %path probability
        
        if r <= 0.25 %move north
            if trace(1, Event_List(3,1)) > 1 %there is space   
                disp('go north')
                trace(1, Event_List(3,1)) = trace(1, Event_List(3,1)) - 1; %moves north
                trace(2, Event_List(3,1)) = trace(2, Event_List(3,1))
                
                nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                    con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
                end
            else %edge of the world reached
                disp('no more NORTH left') %you will fall
            end            

        elseif r <= 0.5 %move east
            if trace(2, Event_List(3,1)) < C %there is space
                disp('go east')
                trace(2, Event_List(3,1)) = trace(2, Event_List(3,1)) + 1; %moves east
                trace(1, Event_List(3,1)) = trace(1, Event_List(3,1));
                
                nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                    con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
                end
            else
                disp('no more EAST left')
            end
            
        elseif r <= 0.75 %move south
            if trace(1, Event_List(3,1)) < L
                disp('go south')
                trace(1, Event_List(3,1)) = trace(1, Event_List(3,1)) + 1;
                trace(2, Event_List(3,1)) = trace(2, Event_List(3,1));
                
                nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2,Event_List(3,1))) == 1
                    con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
                end
            else
                disp('no more SOUTH left')
            end
            
        elseif r <= 1%move west
            if trace(2, Event_List(3,1)) > 1
                disp('go west')
                trace(2, Event_List(3,1)) = trace(2, Event_List(3,1)) - 1;
                trace(1, Event_List(3,1)) = trace(1, Event_List(3,1));
                
                nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                    con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
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
                
                step_prob = abs( (ceil(L/2) - trace(2, Event_List(3,1)) ) / ( ceil(L/2) - 1 ));
                if step_prob == 0 %move W
                    if trace(2, Event_List(3,1)) > 1
                        disp('go west')
                        trace(2,Event_List(3,1)) = trace(2, Event_List(3,1)) - 1; %col
                        trace(1,Event_List(3,1)) = trace(1, Event_List(3,1));
                        
                        nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                        if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                            con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
                        end
                    end
                    
                elseif step_prob > 0 %move E
                    if trace(2, Event_List(3,1)) < C
                        disp('go east')
                        trace(2, Event_List(3,1)) = trace(2, Event_List(3,1)) + 1;
                        trace(1, Event_List(3,1)) = trace(1, Event_List(3,1));
                        
                        nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                        if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                            con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
                        end
                    else
                        disp('no more E left')
                    end
                end
                
            elseif hor_or_ver <= 1 %vertical
                step_prob = abs( (ceil(L/2) - trace(1, Event_List(3,1)) ) / ( ceil(L/2) - 1) ); %north or south prob
                
                if step_prob == 0 %move N
                    if trace(1, Event_List(3,1)) > 1
                        disp('go north')
                        trace(1, Event_List(3,1)) = trace(1, Event_List(3,1)) - 1; %line
                        trace(2, Event_List(3,1)) = trace(2, Event_List(3,1));
                        
                        nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                        if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                            con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
                        end
                    end
                    
                elseif step_prob > 0 %move S
                    %check if any S left
                    if trace(2, Event_List(3,1)) < L %move South
                        disp('go south')
                        trace(1, Event_List(3,1)) = trace(1, Event_List(3,1)) + 1;%line
                        trace(2, Event_List(3,1)) = trace(2, Event_List(3,1));
                        
                        nomad_moves(Event_List(3,1)) = nomad_moves(Event_List(3,1)) + 1;
                        if Grid_Connectivity(trace(1, Event_List(3,1)), trace(2, Event_List(3,1))) == 1
                            con_signal(Event_List(3,1)) = con_signal(Event_List(3,1)) + 1;
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
Event_List(3, end) = Event_List(3, 1);    
end