function [ total_packets, total_bytes, run_time  ] = VBR_UNIFORM1( sim_time, interarrival_time, sim_flag ) 

if sim_flag == 2 % off time station is sleeping
    total_packets = 0;
    total_bytes = 0;
    run_time = sim_time;
    return;
end

flag=true; 
T=0; 
Event_List=[1,2;1,sim_time]; 
total_packets=0; 
total_bytes=0; 
packet_size = [];

[ packet_size ]=uni( packet_size, sim_time, 13,  5, 5 ); %1024 anti sim_time


while flag 
    event=Event_List(1,1); 
    if event==1 
         
[T,Event_List,total_packets,total_bytes]=Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time); 
    elseif event==2 
        [T,flag]=Event2(T,flag,Event_List); 
    end 
     
    Event_List(:,1)=[]; 
    Event_List=(sortrows(Event_List',[2,1]))'; 
end %end looop


run_time = sim_time;

end %end func


function[T,Event_List,total_packets,total_bytes] = Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time) 
T=Event_List(2,1); 
total_packets=total_packets+1; 
total_bytes=total_bytes + packet_size(T); 
L=size(Event_List); 
Event_List(1,L(2)+1)=1; 
Event_List(2,L(2)+1)=T+interarrival_time; 
end 

function [T,flag]=Event2(T,flag,Event_List) 
T=Event_List(2,1); 
flag=false; 
disp('Simulation End') 
end