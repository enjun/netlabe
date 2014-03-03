function [ ] = my_ALOHA( Sim_Time, Random_Timeslots, Stations, Timeslot_Length, Lambda)

flag=true;
T=0;

col_num = 0; 

Event_List=zeros(3,Stations+2);
Event_List(1,1:Stations)=1;
Event_List(1,Stations+1)=3;
Event_List(2,1:Stations)=0;
Event_List(2,Stations+1)=0;
Event_List(3,[1:Stations]) = [1:Stations];
Event_List(1, Stations+2) =4;
Event_List(2,Stations+2) = Sim_Time;

Collision_Count = 0;
Succesful_Transmissions = 0;
Throughput = 0;

%STATES
%0 : idle (den exei paketo)
%1 : busy (einai na steilei h stelnei)
%2 : collided (collision perimenei random time slot gia na steilei)
Station_State=zeros(1,Stations);

while flag
    event=Event_List(1,1);
    if event==1
        disp('event 1')
        [T,Event_List, Timeslot_Length, Stations]=Event1(T,Event_List,Lambda, Timeslot_Length, Stations);
        
    elseif event==2
        disp('event 2')
        % Add Event2 here.
        [T, Event_List, Station_State] = Event2(T, Event_List, Station_State);
    
    elseif event==3
        disp('event 3')
        % Add Event3 here.
        [T, Event_List,Station_State,Random_Timeslots, Stations, Timeslot_Length, col_num, Collision_Count, Succesful_Transmissions] = Event3(T, Event_List,Station_State,Random_Timeslots, Stations, Timeslot_Length, col_num, Collision_Count, Succesful_Transmissions);
    elseif event==4
        
        [T,flag]=Event4(T,flag,Event_List);
        
    end
    
    Event_List(:,1)=[];
    Event_List=(sortrows(Event_List',[2,1]))';
    
end
%%%%%RESULTS%%%%%
Throughput = Succesful_Transmissions / Sim_Time;
fprintf('\nthroughput = %f\n', Throughput);
fprintf('collsion count %d\n', Collision_Count);
fprintf('Succesful Transmissions count %d\n', Succesful_Transmissions);
end

function [T,Event_List, Timeslot_Length,Stations]=Event1(T,Event_List,Lambda, Timeslot_Length, Stations)

T=Event_List(2,1);
fprintf('time %f\n', T);

Event_List(1,end+1)=2;
Event_List(2,end)=T+exprnd(1/Lambda,1,1);
Event_List(3,end)=Event_List(3,1); 

end


function [T, Event_List, Station_State] = Event2(T, Event_List, Station_State)

T=Event_List(2,1);
fprintf('time : %f\n', T);
fprintf('packet arrived for station %d\n', Event_List(3,1));

Station_State(Event_List(3,1)) = 1; %changed idle ---> busy
  
%Event_List(3,end) = Event_List(3, 1);
end

function [T, Event_List,Station_State,Random_Timeslots, Stations, Timeslot_Length, col_num, Collision_Count, Succesful_Transmissions] = Event3(T, Event_List,Station_State,Random_Timeslots, Stations, Timeslot_Length, col_num, Collision_Count, Succesful_Transmissions)

T=Event_List(2,1);
fprintf('time %f\n', T);

for counter_stations=1:Stations
    if Station_State(counter_stations)==1
        col_num = col_num + 1;
        if col_num > 1
            for i=1:Stations
                if Station_State(i) == 1
                    Station_State(i) = 2; %collided 
                end
            end
        end
    end
end

if col_num > 1 %collision detected
    disp('collision detected event3')
    Collision_Count = Collision_Count + 1;
    for each_station = 1: Stations
        if Station_State(each_station) == 2
            Event_List(1,end+1)=2;
            Event_List(2,end) = T + round(rand()*Random_Timeslots * Timeslot_Length);
            Event_List(3,end) = each_station;
            %Event_List
            Station_State(each_station) = 0;
            %Event_List(2,each_station) = Random_Timeslots * Timeslot_Length;
        end
    end
    
elseif col_num <= 1 % no collision detected
    disp('no collision event3')
    %Station_State
    sucess = find( Station_State == 1 ); %aytos metedwse swsta
    if sucess ~0
        Succesful_Transmissions = Succesful_Transmissions + 1;
        %call event1 now
        Event_List(1, end+1 ) = 1;
        Event_List(2, end ) = T;
        Event_List(3,end)= sucess;
        Station_State(sucess) = 0; %return to idle
    else 
        disp('no tramsmission')
    end
end

Event_List(1,end+1) = 3;
Event_List(2,end) = T + Timeslot_Length;
%%Event_List(2,end) = T + exprnd(1/Lambda,1,1);
%Event_List(3,end) = Event_List(3, 1);
col_num = 0;
end


function [T,flag]=Event4(T,flag,Event_List)

T=Event_List(2,1);
flag=false;
disp('Simulation End')

end
