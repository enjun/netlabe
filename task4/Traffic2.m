function [ Q ] = Traffic2( Arrival_List, Size_List )

total_packets = 0; %synolika paketa
total_bytes = 0; %synolika bytes
packets_per_sec = 0;
bytes_per_sec = 0;

flag=true;
T=0;
Event_List=[1;Arrival_List(1)];
Q = zeros(3, 0);
counter_arrival=1;
id=1;
while flag
    event=Event_List(1,1);
    if event==1
        [T,Event_List,Q,id,counter_arrival, total_packets, total_bytes]=Event1(T,Event_List,Q,id,counter_arrival,Arrival_List,Size_List, total_packets, total_bytes);
    elseif event==2
        [T,flag]=Event2(T,flag,Event_List);
    end
Event_List(:,1)=[];
Event_List=(sortrows(Event_List',[2,1]))';
end

fprintf('\n total packets: %d\n', total_packets);
fprintf('\n total bytes: %d\n', total_bytes);
packets_per_sec = total_packets / Q(3,end);
fprintf('packets per second: %f\n', packets_per_sec);
bytes_per_sec = total_bytes / Q(3,end);
fprintf('bytes per second: %f\n', bytes_per_sec);
fprintf('bps: %f\n', ( total_bytes * 8 )/ Q(3,end));

end

function [T,Event_List,Q,id,counter_arrival, total_packets, total_bytes]=Event1(T,Event_List,Q,id,counter_arrival,Arrival_List,Size_List, total_packets, total_bytes)
T=Event_List(2,1);
disp('Arrival at time')
disp(Arrival_List(counter_arrival))
Q(1,end+1)=id;
id=id+1;
Q(2,end)=Size_List(counter_arrival);
total_bytes = total_bytes + Size_List(counter_arrival);
Q(3,end)=Arrival_List(counter_arrival);
total_packets = total_packets + 1; %increase total packets
counter_arrival=counter_arrival+1;
if counter_arrival<=length(Arrival_List)
    Event_List(1,end+1)=1;
    Event_List(2,end)=Arrival_List(counter_arrival);
else
    Event_List(1,end+1)=2;
    Event_List(2,end)=T;
end
end

function [T,flag]=Event2(T,flag,Event_List)
    T=Event_List(2,1);
    flag=false;
disp('Simulation End')
end