function [  ] = Final_MultiTraffic( p1, p2 ,p3, p4, lambda1, lambda2, Sim_Time, Stations, Period, Arrival)

%%%%%%%%% station parameters %%%%%%%%%%
station_params = zeros(3,Stations);
for i = 1: Stations %save station ids
    station_params(1, i) = i;
end

for i = 1: Stations
    station_params(2, i) = input('give remove method for station (FIFO, LIFO, FIRO): ');
end

for i = 1: Stations
    station_params(3, i) = input('give average package remove number: ');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flag=true;
T=0;

Event_List=zeros(3,2*Stations+2);
Event_List(1,1:Stations)=1;%Arrival Event for each station
Event_List(2,1:Stations)=0;
Event_List(3,1:Stations)=1:Stations;
Event_List(1,Stations+1:2*Stations)=2;%Departure Event for each station
Event_List(2,Stations+1:2*Stations)=0;
Event_List(3,Stations+1:2*Stations)=1:Stations;
Event_List(1,2*Stations+1)=3;%Calculation Event (periodical event)
Event_List(2,2*Stations+1)=0;
Event_List(1,2*Stations+2)=4;%Simulation Event
Event_List(2,2*Stations+2)=Sim_Time;

Q3D=zeros(4,0,Stations);
Q3D_Index=zeros(1,Stations);

Average_Queue_Size=0;
Average_Packets_per_Station=0;
Calculation_Times=0;

sum_delay=0;
counter_delay=0;
packet_id=1;
sum_delay_per_station=zeros(1,Stations);
counter_delay_per_station=zeros(1,Stations);

while flag
    event=Event_List(1,1);
   
    if event==1
        disp('arrival')
        [T,Event_List,Q3D,Q3D_Index,packet_id] = Event1(T,Event_List,Q3D,Q3D_Index,packet_id, p1, p2 ,p3, p4,Arrival,lambda1);
    elseif event==2
        disp('departure')
        [Q3D,Event_List, sum_delay_per_station , counter_delay_per_station,Q3D_Index,sum_delay,counter_delay,station_params, lambda2 ] = Event2(Q3D,Event_List,Q3D_Index,sum_delay,counter_delay,sum_delay_per_station,counter_delay_per_station,station_params, lambda2);
    elseif event == 3 
        disp('calc')
        [T,Event_List,Average_Packets_per_Station,Average_Queue_Size,Calculation_Times]=Event3(T,Event_List,Stations,Q3D_Index,Average_Packets_per_Station,Average_Queue_Size,Calculation_Times,Period);
    elseif event==4
        [T,flag]=Event4(T,flag,Event_List);
    end
Event_List(:,1)=[];
Event_List=(sortrows(Event_List',[2,1]))';
disp(Event_List);
end

fprintf('average packets per station = %f\n', Average_Packets_per_Station/Calculation_Times);
fprintf('average queue size = %f\n', Average_Queue_Size/Calculation_Times);

fprintf('average delay = %f\n', sum_delay/counter_delay);
disp('average delay per station:')
avg_delay_per_stat(1:Stations) = sum_delay_per_station(1:Stations)/counter_delay_per_station(1:Stations);
avg_delay_per_stat(1:Stations)

end

function [Q3D,Event_List, sum_delay_per_station , counter_delay_per_station,Q3D_Index,sum_delay,counter_delay,station_params, lambda2 ] = Event2(Q3D,Event_List,Q3D_Index,sum_delay,counter_delay,sum_delay_per_station,counter_delay_per_station,station_params, lambda2)
T=Event_List(2,1);

packs2rem = poissrnd( station_params(3,Event_List(3,1)) ); % how many packets to remove
fprintf('going to remove %d packets\n', packs2rem);

if station_params(2,Event_List(3,1)) == 1 %FIFO
    for i = 1 : packs2rem    
        if Q3D_Index(Event_List(3,1))>0
            
            sum_delay=sum_delay+T-Q3D(2,1,Event_List(3,1));
            counter_delay=counter_delay+1;
            
            sum_delay_per_station(Event_List(3,1))=sum_delay_per_station(Event_List(3,1))+T-Q3D(2,1,Event_List(3,1));
            counter_delay_per_station(Event_List(3,1))=counter_delay_per_station(Event_List(3,1))+1;
    
            Q3D(1,1,Event_List(3,1))=0;
            Q3D(2,1,Event_List(3,1))=0;
            Q3D(3,1,Event_List(3,1))=0;
            Q3D(4,1,Event_List(3,1))=0;
            
            Q3D_Index(Event_List(3,1))=Q3D_Index(Event_List(3,1))-1;
            Q3D(:,[1:Q3D_Index(Event_List(3,1))],Event_List(3,1))=Q3D(:,[2:Q3D_Index(Event_List(3,1))+1],Event_List(3,1));
            Q3D(:,Q3D_Index(Event_List(3,1))+1,Event_List(3,1))=0;
        else
            disp('no packets to remove')
            break;
        end    
    end
    
elseif station_params(2,Event_List(3,1)) == 2 %LIFO
    for i = 1 : packs2rem
        if Q3D_Index(Event_List(3,1))>0
            
            sum_delay=sum_delay+T-Q3D(2,Q3D_Index(Event_List(3,1)),Event_List(3,1));
            counter_delay=counter_delay+1;
            
            sum_delay_per_station(Event_List(3,1))=sum_delay_per_station(Event_List(3,1)) + T - Q3D(2,Q3D_Index(Event_List(3,1)),Event_List(3,1));
            counter_delay_per_station(Event_List(3,1))=counter_delay_per_station(Event_List(3,1))+1;
                
            Q3D(1,Q3D_Index(Event_List(3,1)),Event_List(3,1))=0;
            Q3D(2,Q3D_Index(Event_List(3,1)),Event_List(3,1))=0;
            Q3D(3,Q3D_Index(Event_List(3,1)),Event_List(3,1))=0;
            Q3D(4,Q3D_Index(Event_List(3,1)),Event_List(3,1))=0;
            Q3D_Index(Event_List(3,1))=Q3D_Index(Event_List(3,1))-1;
        else
            disp('no packets to remove')
            break;
        end
    end
    
elseif station_params(2,Event_List(3,1)) == 3 %FIRO
    for i = 1 : packs2rem
        if Q3D_Index(Event_List(3,1))>0
            random_value=round(rand()*(Q3D_Index(Event_List(3,1))-1)+1);
            
            sum_delay=sum_delay+T-Q3D(2,random_value,Event_List(3,1));
            counter_delay=counter_delay+1;
            
            sum_delay_per_station(Event_List(3,1))=sum_delay_per_station(Event_List(3,1)) + T - Q3D(2,random_value,Event_List(3,1));
            counter_delay_per_station(Event_List(3,1))=counter_delay_per_station(Event_List(3,1))+1;
            
            Q3D(1,random_value,Event_List(3,1))=0;
            Q3D(2,random_value,Event_List(3,1))=0;
            Q3D(3,random_value,Event_List(3,1))=0;
            Q3D(4,random_value,Event_List(3,1))=0;
            Q3D_Index(Event_List(3,1))=Q3D_Index(Event_List(3,1))-1;
    
    
    
            Q3D(:,[random_value:Q3D_Index(Event_List(3,1))],Event_List(3,1))=Q3D(:,[random_value+1:Q3D_Index(Event_List(3,1))+1],Event_List(3,1));
            Q3D(:,Q3D_Index(Event_List(3,1))+1,Event_List(3,1))=0;
        else
            disp('no packet to remove')
            break;
        end   
        
    end

end

Event_List(1,end+1)=2;
Event_List(2,end)=T+exprnd(1/lambda2,1,1);
Event_List(3,end)=Event_List(3,1); 

end


function [T,Event_List,Q3D,Q3D_Index,packet_id] = Event1(T,Event_List,Q3D,Q3D_Index,packet_id, p1, p2 ,p3, p4,Arrival,lambda1)

T=Event_List(2,1);
type = rand();

Q3D(1,Q3D_Index(Event_List(3,1))+1,Event_List(3,1))=packet_id; %puts the id
packet_id=packet_id+1;
Q3D_Index(Event_List(3,1))=Q3D_Index(Event_List(3,1))+1;
Q3D(2,Q3D_Index(Event_List(3,1)),Event_List(3,1))=T; %arrival time

if type <= p1 %(0 ,p1]
    Q3D(3,Q3D_Index(Event_List(3,1)),Event_List(3,1)) = 1;
elseif p1 < type && type <= p1 + p2 %(p1, p1+p2]
    Q3D(3,Q3D_Index(Event_List(3,1)),Event_List(3,1)) = 2;
elseif p1 + p2 < type && type <= p1+p2+p3 %(p1+p2, p1+p2+p3]
    Q3D(3,Q3D_Index(Event_List(3,1)),Event_List(3,1)) = 3;
elseif p1 + p2 + p3 < type && type <= 1 %(p1+p2+p3, 1]
    Q3D(3,Q3D_Index(Event_List(3,1)),Event_List(3,1)) = 4;
end

Q3D(4,Q3D_Index(Event_List(3,1)),Event_List(3,1))= (64 + (1518-64).*rand(1,1)); %size

if Arrival == 1 %exponential
    Event_List(1,end+1)=1;
    Event_List(2,end)=T+exprnd(1/lambda1,1,1);
    Event_List(3,end)=Event_List(3,1);
    
elseif Arrival == 2 %poisson
    Event_List(1,end+1)=1;
    Event_List(2,end)=T+poissrnd(lambda1,1,1);
    Event_List(3,end)=Event_List(3,1);
end
end

function [T,Event_List,Average_Packets_per_Station,Average_Queue_Size,Calculation_Times]=Event3(T,Event_List,Stations,Q3D_Index,Average_Packets_per_Station,Average_Queue_Size,Calculation_Times,Period)

T=Event_List(2,1);

Average_Packets_per_Station=Average_Packets_per_Station+sum(Q3D_Index)/Stations;
Average_Queue_Size=Average_Queue_Size+sum(Q3D_Index);
Calculation_Times=Calculation_Times+1;

Event_List(1,end+1)=3;
Event_List(2,end)=T+Period;

end


function [T,flag]=Event4(T,flag,Event_List)

T=Event_List(2,1);
flag=false;
disp('Simulation End')

end