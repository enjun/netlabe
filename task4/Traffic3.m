function [ Q ] = Traffic3( Arrival_List, Size_List, p1, p2 ,p3, p4)

total_packets = 0; %synolika paketa
total_bytes = 0; %synolika bytes
packets_per_sec = 0;
bytes_per_sec = 0;

flag=true;
T=0;
Event_List=[1;Arrival_List(1)];
Q = zeros(4, 0); %line 4 type of service
counter_arrival=1;
id=1;
while flag
    event=Event_List(1,1);
    if event==1
        [T,Event_List,Q,id,counter_arrival, total_packets, total_bytes]=Event1(T,Event_List,Q,id,counter_arrival,Arrival_List,Size_List, total_packets, total_bytes,  p1, p2 ,p3, p4);
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

function [T,Event_List,Q,id,counter_arrival, total_packets, total_bytes]=Event1(T,Event_List,Q,id,counter_arrival,Arrival_List,Size_List, total_packets, total_bytes,  p1, p2 ,p3, p4)
%disp('type')
type = rand();

T=Event_List(2,1);
disp('Arrival at time')
disp(Arrival_List(counter_arrival))
Q(1,end+1)=id;
id=id+1;

if type <= p1 %(0 ,p1]
    Q(4,end) = 1;
elseif p1 < type && type <= p1 + p2 %(p1, p1+p2]
    Q(4,end) = 2;
elseif p1 + p2 < type && type <= p1+p2+p3 %(p1+p2, p1+p2+p3]
    Q(4, end) = 3;
elseif p1 + p2 + p3 < type && type <= 1 %(p1+p2+p3, 1]
    Q(4, end) = 4;
end

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