%simulation  4
function [] = packet_event( pt, tt, sim_time )

delivery_time = pt + tt; %frame delivery time
flag = true;
T=0;
frame_sent = 0;
frame_recv = 0;

event_list(1,1)=1; %first event
event_list(2,1)=0;
event_list(1,2)=3; %termination event
event_list(2,2)=sim_time;

while flag
    event=event_list(1,1);
    
    if event==1
        [T, event_list, frame_sent]=event1(T,event_list, frame_sent, delivery_time);
    elseif event == 2
        [T, event_list, frame_recv]=event2(T, event_list, frame_recv, delivery_time);
    elseif event == 3
        [T,flag,event_list]=event3(T,flag,event_list);
    end %end conditions
    
    temp=event_list';
    temp=sortrows(temp,2);
    event_list=temp';    
end %end while loop

fprintf('station 1 sent %d frames\n', frame_sent)
fprintf('station 2 received %d frames\n', frame_recv)
end %function


function [T,event_list, frame_sent] = event1(T,event_list, frame_sent, delivery_time)
T=event_list(2,1);
fprintf('station 1 sends frame time = %0.3f\n',T);
frame_sent = frame_sent + 1;
l=size(event_list);
event_list(1,l(2)+1)=2;
event_list(2,l(2)+1)=T+delivery_time;  %event 2 starts when frame is delivered
event_list(:,1)=[];
end


function [T, event_list, frame_recv] = event2(T, event_list, frame_recv, delivery_time)
T=event_list(2,1);
fprintf('station 2 receives frame time = %0.3f\n',T);
frame_recv = frame_recv + 1;
l=size(event_list);
event_list(1,l(2)+1)=1;
event_list(2,l(2)+1)=T;
event_list(:,1)=[];
end


function [T,flag,event_list]=event3(T,flag,event_list)
T=event_list(2,1);
flag=false;
disp('simulation end')
end
