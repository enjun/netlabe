%simulation 6
function [] = packet_event2( S, B, P1, P2, sim_time )

%frame delivery time for station1
d_t1 = ((P1*8)/B) + (S/(2.5*10^5)); %multiply P*8 to find bits, when bytes are given
d_t2 = ((P2*8)/B) + (S/(2.5*10^5)); %multiply P*8 to find bits, when bytes are given

flag = true;
T=0;
frame_sent1 = 0; %number of frames sent by station 1
frame_sent2 = 0; %number of frames sent by station 2
frame_recv1 = 0; %number of frames received by station 1
frame_recv2 = 0; %number of frames received by station 2

event_list(1,1)=1; %first event
event_list(2,1)=0;
event_list(1,2)=3; %termination event
event_list(2,2)=sim_time;

while flag
    event=event_list(1,1);
    
    if event==1
        [T,event_list, frame_sent1, frame_recv1] = event1(T,event_list, frame_sent1, frame_sent2, frame_recv1, d_t1);
    elseif event == 2
        [T, event_list, frame_sent2, frame_recv2] = event2(T, event_list, frame_sent2, frame_recv2, d_t2);
    elseif event == 3
        [T,flag,event_list]=event3(T,flag,event_list);
    end %end conditions
    
    temp=event_list';
    temp=sortrows(temp,2);
    event_list=temp';    
end %end while loop

fprintf('station 1 sent %d frames\n', frame_sent1)  %
fprintf('station 1 received %d frames\n', frame_recv1)  %
fprintf('station 2 sent %d frames\n', frame_sent2) %
fprintf('station 2 received %d frames\n', frame_recv2) %
end %function


function [T,event_list, frame_sent1, frame_recv1] = event1(T,event_list, frame_sent1, frame_sent2, frame_recv1, d_t1)
T=event_list(2,1);
fprintf('station 1 receives/sends frame, time = %0.3f\n',T);
frame_sent1 = frame_sent1 + 1;
if frame_sent2 ~=0 %this takes care the beggining of the simulation
    frame_recv1 = frame_recv1 + 1; %station 1 recvs frame from 2
end
l=size(event_list);
event_list(1,l(2)+1)=2;
event_list(2,l(2)+1)= T + d_t1;  %event 2 starts when frame from station1 is delivered
event_list(:,1)=[];
end


function [T, event_list, frame_sent2, frame_recv2] = event2(T, event_list, frame_sent2, frame_recv2, d_t2)
T=event_list(2,1);
frame_recv2 = frame_recv2 + 1; %first receivs frame from station 1
fprintf('station 2 receives/sends frame, time = %0.3f\n',T);
frame_sent2 = frame_sent2 + 1; %sends frame to station 1
l=size(event_list);
event_list(1,l(2)+1)=1;
event_list(2,l(2)+1)=T + d_t2; %event 1 statrs when frame from station 2 is delivered
event_list(:,1)=[];
end


function [T,flag,event_list]=event3(T,flag,event_list)
T=event_list(2,1);
flag=false;
disp('simulation end')
end
