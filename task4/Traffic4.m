function [ Q ] = Traffic4( Arrival_List, Size_List, p1, p2 ,p3, p4, l, remove_method)

total_packets = 0; %synolika paketa
total_bytes = 0; %synolika bytes
packets_per_sec = 0;
bytes_per_sec = 0;
total_pack_removed = 0;
total_bytes_removed = 0;

flag=true;
T=0;
%disp('event list')
Event_List=[1, 3 ; Arrival_List(1), exprnd(1/l)];
Q = zeros(4, 0); %line 4 type of service
counter_arrival=1;
id=1;
while flag
    event=Event_List(1,1);
   
    if event==1
        disp('event 1')
        [T,Event_List,Q,id,counter_arrival, total_packets, total_bytes]=Event1(T,Event_List,Q,id,counter_arrival,Arrival_List,Size_List, total_packets, total_bytes,  p1, p2 ,p3, p4);
    elseif event==2
        disp('event 2')
        [T,flag]=Event2(T,flag,Event_List);
    elseif event == 3 %new event exponential execution time
        disp('event 3')
        [Q, total_pack_removed, Event_List, total_bytes_removed] = Event3(remove_method , Q, total_pack_removed, Event_List, l, total_bytes_removed);
    end
Event_List(:,1)=[];
Event_List=(sortrows(Event_List',[2,1]))';
end

fprintf('\narrivals:\ntotal packets: %d\n', total_packets);
fprintf('total bytes: %d\n', total_bytes);
%packets_per_sec = total_packets / Q(3,end);
packets_per_sec = total_packets / Arrival_List(end); %using Arrival_List because Q might be empty at the end of simulation, index out of bounds will arrise
fprintf('packets per second: %f\n', packets_per_sec);
%bytes_per_sec = total_bytes / Q(3,end);
bytes_per_sec = total_bytes / Arrival_List(end);
fprintf('bytes per second: %f\n', bytes_per_sec);
%fprintf('bps: %f\n', ( total_bytes * 8 )/ Q(3,end));
fprintf('bps: %f\n', ( total_bytes * 8 )/ Arrival_List(end));

disp('departures:')
fprintf('total packets removed: %d\n', total_pack_removed);
fprintf('total bytes removed: %d\n', total_bytes_removed );
fprintf('packets per second removed: %f\n', total_pack_removed / Arrival_List(end));
fprintf('bytes per second removed: %f\n', total_bytes_removed / Arrival_List(end));
fprintf('bps remove rate: %f\n', (total_bytes_removed * 8) / Arrival_List(end));

end

function [Q, total_pack_removed, Event_List, total_bytes_removed] = Event3(remove_method , Q, total_pack_removed, Event_List, l, total_bytes_removed);
s = size(Q);

if s(2) == 0
    disp('no packets to remove')
    return;
end

T=Event_List(2,1);
Q
if remove_method == 1 %FIFO
    total_bytes_removed = total_bytes_removed + Q(2, 1);
    Q(:, 1) = [];
    total_pack_removed = total_pack_removed + 1;
    
elseif remove_method == 2 %LIFO
    total_bytes_removed = total_bytes_removed + Q(2, end);
    Q(:, end) = [];
    total_pack_removed = total_pack_removed + 1;
    
elseif remove_method == 3 %FIRO
    temp = size(Q);
    %randint(1,1, temp(2)) + 1;
    del = randint(1,1, temp(2)) + 1;
    %Q(:, randint(1,1, temp(2)) + 1) = [];
    total_bytes_removed = total_bytes_removed + Q(2, del);
    fprintf('going to delete packet id: %d\n\n', Q(1, del));
    Q(:, del) = [];
    total_pack_removed = total_pack_removed + 1;   
end

Event_List(1,end+1)=3;
Event_List(2,end)= T + exprnd(1/l);

end


function [T,Event_List,Q,id,counter_arrival, total_packets, total_bytes] = Event1(T,Event_List,Q,id,counter_arrival,Arrival_List,Size_List, total_packets, total_bytes,  p1, p2 ,p3, p4)

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