%usage
%>>rand_sime(sim_time)
%where sim_time is the simulation time

function [ ] = print_time( sim_time )

flag = true;
T=0;

event_list(1,1)=1;
event_list(2,1)=0;
event_list(1,2)=2;
event_list(2,2)=sim_time;

while flag
    event=event_list(1,1);
    
    if event==1
        [T,event_list]=event1(T,event_list);
    elseif event == 2
        [T,flag]=event2(T,flag,event_list);
    end %end conditions
    
    temp=event_list';
    temp=sortrows(temp,2);
    event_list=temp';    
end %end while loop

end %end print_time


function [T,event_list] = event1(T,event_list)
T=event_list(2,1);
fprintf('current time = %f\n',T);
%disp(T)
l=size(event_list);
event_list(1,l(2)+1)=1;
event_list(2,l(2)+1)=T+rand()*9+1; % return [1:10] random fix(T+rand()*9+1)
event_list(:,1)=[];
end

function [T,flag]=event2(T,flag,event_list)
T=event_list(2,1);
flag=false;
disp('simulation end')
end
