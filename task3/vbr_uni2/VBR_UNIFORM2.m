function [ ] = VBR_UNIFORM2( sim_time ) 
flag=true; 
T=0; 
Event_List=[1,2;1,sim_time]; 
total_packets=0; 
total_bytes=0; 

%custom entries
packet_size = [];
interarrival_time = [];
time_counter = 1;
size_counter = 1;

[ packet_size ]=uni( packet_size, sim_time, 13,  5, 5, 64, 1518 ); %sim_time sto mikos pinaka
[ interarrival_time ] = uni(interarrival_time, sim_time, 13,  5, 5, 1, 10 ); %sim_time gia to mikos

packet_size = fix(packet_size); %packet size must be fixed

while flag 
    event=Event_List(1,1); 
    if event==1    
[T,Event_List,total_packets,total_bytes, size_counter, time_counter]=Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time, time_counter, size_counter); 

    elseif event==2 
        [T,flag]=Event2(T,flag,Event_List); 
        
    end 
     
    Event_List(:,1)=[]; 
    Event_List=(sortrows(Event_List',[2,1]))'; 
end %end looop

fprintf('packets per second = %f \n', total_packets/T);
fprintf('bsp = %f\n', total_bytes*8/T); 
fprintf('total packets = %d\n', total_packets);
fprintf('total bytes = %d\n', total_bytes);

end %end func


function[T,Event_List,total_packets,total_bytes, size_counter, time_counter] = Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time, time_counter, size_counter) 
T=Event_List(2,1); 
total_packets=total_packets+1; 
total_bytes=total_bytes + packet_size(size_counter); 
size_counter = size_counter + 1;
L=size(Event_List); 
Event_List(1,L(2)+1)=1; 
Event_List(2,L(2)+1)=T+interarrival_time(time_counter); 
time_counter = time_counter + 1;
end 

function [T,flag]=Event2(T,flag,Event_List) 
T=Event_List(2,1); 
flag=false; 
disp('Simulation End') 
end