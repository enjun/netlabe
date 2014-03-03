function [ ] = Routing( cost_matrix, delay_matrix, inter_control_time, display_time, sim_time, random_connection_failure, random_connection_recovery, maximum_failures )
flag=true;
T=0;
S=size(cost_matrix);
routers=S(1);
Event_List=zeros(4,routers+3);
Event_List(1,1:routers)=1;
Event_List(2,1:routers)=0;
Event_List(3,1:routers)=[1:routers];
Event_List(1, routers+1) = 3;
Event_List(2, routers+1) = 0;
Event_List(1,routers+2)=10;
Event_List(2,routers+2)=sim_time;

Event_List(1, routers+3) = 4; %connection failure event
Event_List(2, routers+3) = random_connection_failure;

final_cost=cost_matrix;
total_updates=0;
update_time = 0;
the_fallen = zeros(4,0);
conn_fail_num = 0;
counter_routers=0;

[ neighbors, next_hop ] = Init( cost_matrix );


while flag
    event=Event_List(1,1);
    
    if event==1 %sends routing tables
        disp(' ')
        disp('-----------')
        disp('event 1')
        T=Event_List(2, 1);
        disp('time')
        disp(T)
        
        for counter_routers = 1:routers
            if neighbors(Event_List(3, 1), counter_routers) == 1 %if it's a neighbor
                Event_List(1 ,end + 1) = 2;
                Event_List(2,end)=T+delay_matrix(Event_List(3,1),counter_routers);
                Event_List(3,end)=Event_List(3,1); %source router
                Event_List(4,end)=counter_routers; %destination router
                update_time = update_time + delay_matrix(Event_List(3,1),counter_routers); %total update time
            end
        end
        %Event_List
        
    elseif event==2 %updates routing tables
        disp(' ')
        disp('-----------')
        disp('event 2')
        T = Event_List(2,1);
        disp('time')
        disp(T)
        %Event_List
        flag_change = false;
        for counter_routers = 1 : routers
            %counter_routers
            %cost_matrix
            %costA = cost_matrix(Event_List(3,1), counter_routers) + cost_matrix(Event_List(3,1), Event_List(4,1))  
            %costB = cost_matrix(Event_List(4,1), counter_routers)
            if cost_matrix(Event_List(3,1), counter_routers) < 0
                fprintf('%d,%d link down\n', Event_List(3,1), counter_routers);
                continue;
            elseif cost_matrix(Event_List(3,1), Event_List(4,1)) < 0
                fprintf('%d,%d link down\n', Event_List(3,1), Event_List(4,1));
                continue;
            end
            
            if cost_matrix(Event_List(3,1), counter_routers) + cost_matrix(Event_List(3,1), Event_List(4,1)) < cost_matrix(Event_List(4,1), counter_routers)
                %disp('change cost')
                cost_matrix(Event_List(4,1), counter_routers) = cost_matrix(Event_List(3,1), counter_routers) + cost_matrix(Event_List(3,1), Event_List(4,1));
                flag_change = true; %routing table updated
                next_hop(Event_List(4,1), counter_routers) = next_hop(Event_List(4,1), Event_List(3,1));
                %cost_matrix
                total_updates = total_updates + 1;
            end
        end
        %flag_change
        if flag_change == true %routing tables changed, put event1 again
        %disp('send')
        Event_List(1,end + 1) = 1;
        Event_List(2, end) = T + inter_control_time;
        Event_List(3, end) = Event_List(4,1);
        end
        %Event_List
                           
    %other events  
    elseif event == 3
        disp(' ')
        disp('-----------')
        disp('event 3')
        T = Event_List(2,1);
        disp('time')
        disp(T)
        disp('current routing tables')
        disp(cost_matrix)
        Event_List(1, end+1) = 3;
        Event_List(2, end) = T + display_time;
        
    elseif event == 4
        disp(' ')
        disp('-----------')
        disp('event 4')
        T = Event_List(2,1);
        disp('time')
        disp(T)
        
        if conn_fail_num ~= maximum_failures
            [i,j] = find(neighbors==1);
            l = size(i); %array size
            the_chosen = randint(1,1, l(1)) + 1; %the chosen must fall
            the_fallen(1,end+1) = i(the_chosen); %routerA
            the_fallen(2,end) = j(the_chosen); %routerB
            the_fallen(3,end) = cost_matrix(i(the_chosen), j(the_chosen) ); %previous cost
            the_fallen(4,end) = cost_matrix(j(the_chosen), i(the_chosen) ); %previous cost
            %---------------%
            cost_matrix( i(the_chosen), j(the_chosen) ) = -1; %fail now
            cost_matrix( j(the_chosen), i(the_chosen) ) = -1; %fail now
            %---------------%
            conn_fail_num = conn_fail_num + 1;
            Event_List(1, end+1) = 5; %recovery
            Event_List(2, end) = T + random_connection_recovery; %rec time
            fprintf('link down %d,%d %d,%d\n', i(the_chosen),j(the_chosen),j(the_chosen),i(the_chosen));
            fprintf('link failures %d\n', conn_fail_num);
            
        else
            disp('max failures reached')
        end
        Event_List(1, end+1) = 4;
        Event_List(2, end) = T + random_connection_failure;
        
        
    elseif event == 5
        disp(' ')
        disp('-----------')
        disp('event 5')
        T = Event_List(2,1);
        disp('time')
        disp(T)
        %---------------%
        cost_matrix( the_fallen(1,1), the_fallen(2,1) ) = the_fallen(3,1); %the fallen
        cost_matrix( the_fallen(2,1), the_fallen(1,1) ) = the_fallen(4,1); %shall rise again
        %---------------%
        conn_fail_num = conn_fail_num - 1;
        fprintf('link up %d,%d %d,%d\n', the_fallen(1,1), the_fallen(2,1),the_fallen(2,1), the_fallen(1,1));
        fprintf('link failures %d\n', conn_fail_num);
        the_fallen(:,1) = [];
        
    elseif event==10
        T=Event_List(2,1);
        flag=false;
        disp('Simulation End')         
    end
    
    Event_List(:,1)=[];
    Event_List=(sortrows(Event_List',[2,1]))';
    
end
disp(' ')
disp('final cost matrix')
disp(cost_matrix)
fprintf('total updates %d\n', total_updates);
fprintf('average update time %f\n', update_time/total_updates);

end

