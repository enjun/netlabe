function [ ] = print_time( sim_time )

flag = true;
T=0;

event_list(1,1)=1;
event_list(2,1)=0;
event_list(1,2)=3;
event_list(2,2)=sim_time;

while flag
    event=event_list(1,1);
    
    if event==1
        [T,event_list]=event1(T,event_list);
    elseif event == 2
        [T,event_list]=event2(T,event_list);
    elseif event == 3
        [T,flag,event_list]=event3(T,flag,event_list);
    end %end conditions
    
    temp=event_list';
    temp=sortrows(temp,2);
    event_list=temp';    
end %end while loop

end %end print_time


function [T,event_list] = event1(T,event_list)
T=event_list(2,1);
fprintf('i am event 1 time = %d\n',T);
%disp(T)
l=size(event_list);
event_list(1,l(2)+1)=2;
event_list(2,l(2)+1)=T+5;  %event 2 in T+5 time units
event_list(:,1)=[];
end

function [T,flag,event_list]=event3(T,flag,event_list)
T=event_list(2,1);
flag=false;
disp('simulation end')
end

function [T,event_list] = event2(T,event_list)
T=event_list(2,1);
fprintf('i am event 2 time = %d\n',T);
%disp(T)
l=size(event_list);
event_list(1,l(2)+1)=1;
event_list(2,l(2)+1)=T+5;
event_list(:,1)=[];
end
