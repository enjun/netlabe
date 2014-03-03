function [ total_packets, total_bytes, run_time ] = CBR( sim_time, packet_size, interarrival_time, sim_flag ) 

if sim_flag == 2 % off time station is sleeping
    run_time = sim_time;
    total_packets = 0;
    total_bytes = 0;
    return;
end

flag=true; 
T=0; 
Event_List=[1,2;1,sim_time]; 
total_packets=0; 
total_bytes=0; 
while flag 
    event=Event_List(1,1); 
    if event==1 
         
[T,Event_List,total_packets,total_bytes]=Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time); 
    elseif event==2 
        [T,flag]=Event2(T,flag,Event_List); 
    end 
     
    Event_List(:,1)=[]; 
    Event_List=(sortrows(Event_List',[2,1]))'; 
end 
 %returns
run_time = sim_time;

end 
function [T,Event_List,total_packets,total_bytes] = Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time) 
T=Event_List(2,1); 
total_packets=total_packets+1; 
total_bytes=total_bytes+packet_size; 
L=size(Event_List); 
Event_List(1,L(2)+1)=1; 
Event_List(2,L(2)+1)=T+interarrival_time; 
end 
function [T,flag]=Event2(T,flag,Event_List) 
T=Event_List(2,1); 
flag=false; 
disp('Simulation End') 
end