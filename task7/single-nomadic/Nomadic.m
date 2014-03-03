function [] = Nomadic( L,C,pace,move_style,sim_time, Stations, range )
flag=true;
T=0;

signal = 0;
trace = zeros(2,1); %path that the nomad follows
trace(1,1) = ceil(L/2); %initial line
trace(2,1) = ceil(C/2); %initial column

Event_List=zeros(2,2);
Event_List(1,1)=1;
Event_List(2,1)=0;
Event_List(1,2)=10;
Event_List(2,2)=sim_time;

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
        [T,Event_List, trace, signal]=event1(T,Event_List, trace, C, L, move_style, pace, signal, Grid_Connectivity);
        
    % other events
        
    elseif event==10
        
        [T,flag]=Event10(T,flag,Event_List);
        
    end
    
    Event_List(:,1)=[];
    Event_List=(sortrows(Event_List',[2,1]))';
    
end
%display stupid stats
a = size(trace);
disp('trace is')
disp(trace)
disp('total moves')
fprintf('\t%d\n\n', a(2));
disp('moves with signal')
disp(signal)
disp('connectivity ratio')
disp(signal / a(2))
end



function [T,flag]=Event10(T,flag,Event_List)
T=Event_List(2,1);
flag=false;
disp(' ')
disp('Simulation End')
end
