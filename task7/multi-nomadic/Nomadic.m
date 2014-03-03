function [] = Nomadic( L,C,pace,move_style,sim_time, Nomads, Stations, range )
flag=true;
T=0;

con_signal = zeros(1, Nomads);
nomad_moves = zeros(1, Nomads);

trace = zeros(2, Nomads); %current nomad position
trace(1, 1:Nomads) = ceil(L/2); %initial line
trace(2, 1:Nomads) = ceil(C/2); %initial column

Event_List=zeros(3, Nomads + 1);
Event_List(1,1:Nomads) = 1;
Event_List(2, 1:Nomads) = 0;
Event_List(3, 1:Nomads) = 1 : Nomads;
Event_List(1, Nomads + 1)=10;
Event_List(2,Nomads + 1)=sim_time;

Grid_Connectivity=zeros(L,C);
station_pos = zeros(2,0);

for st = 1: Stations
    l = randint(1, 1, L) + 1;
    c = randint(1, 1, C) + 1;
    if ( find(station_pos==l) == find(station_pos==c) )%same position
        st = st - 1;
    else
        station_pos(1, end+1) = l;
        station_pos(2, end) = c;
        Grid_Connectivity(l, c) = 1;
        [Grid_Connectivity] = connect(Grid_Connectivity, l, c, L, C, range);
    end
end

while flag
    event=Event_List(1,1);
    
    if event==1
        [T,Event_List, trace, nomad_moves, con_signal ]=event1(T,Event_List, trace, C, L, move_style, pace, Grid_Connectivity, nomad_moves, con_signal );
        
    % other events
    % what events ???
        
    elseif event==10
        
        [T,flag]=Event10(T,flag,Event_List);
        
    end
    
    Event_List(:,1)=[];
    Event_List=(sortrows(Event_List',[2,1]))';
    
end
disp('last position')
disp(trace)
disp('times moved')
disp(nomad_moves)
disp('moved with signal')
disp(con_signal)
disp('station positions')
disp(station_pos)
disp('connectivity ratio')
for n = 1 : Nomads
fprintf('%f\n', con_signal(n) / nomad_moves(n))
end

end



function [T,flag]=Event10(T,flag,Event_List)
T=Event_List(2,1);
flag=false;
disp(' ')
disp('Simulation End')
end
