function [ output_args ] = main2( station_number )

%for each station 
tot_packs = 0; %total packets
tot_b = 0; %total bytes 
tot_time = 0; % time each station ran

station_results = zeros(5,1); %4 results
station_results(1,1) = 1;
for i = 2: station_number
    station_results(1,end+1) = i; %adds all the stations
end

on_off = [];
ans = input('1 :uniform on/off distribution\n2 :exponential on/off distribution');
if ans == 1
    [ on_off ] = sort( uni1(input('give m '), input('seed '), input('increment '), input('multiplier '), input('limit A '), input('limit B ')) );
elseif ans == 2
    [ on_off ] = sort( expo2( input('give m '), input('seed '), input('increment '), input('multiplier '), input('l1 ')) );
else
    disp('invalid input')
    return;
end

sim_time_counter = 1;
st_sim_time = []; %station simulation time
for i =2 : length(on_off)
    st_sim_time(end + 1) = on_off(i) - on_off(i - 1); %how much time each station will run
end

station_counter = 1;
func2run = -1;

packet_size = input('provide packet size(CBR only): ');
fprintf('\n');
disp('CBR, uni1')
interarrival_time = input('provide interarrival time: ');

fprintf('\n');
disp('uniform, exponential and poisson distributions ')
A = input('give limit A for packet size: '); %64
B = input('give limit B for packet size: '); %1518

fprintf('\n');
disp('uniform distribution limits')
C = input('give limit A for interarrival time: '); %1
D = input('give limit B for interarrival time: '); %10

fprintf('\n');
disp('exponential distribution')
l1 = input('give average interarrival time: ');

fprintf('\n');
disp('poisson distribution')
l2 = input('give average packet arrival number per second: ');

T = 0;
flag = true;

if randint(1,1,11) <= 5 % simulation starts with on time first
    Event_List=[1, 2, 3; 0, 1, length(st_sim_time)];
    
else %simulation starts with off time first
    Event_List=[2, 1, 3; 0, 1, length(st_sim_time)];
end

%which distribution each station will run
for k = 1 : station_number
    func2run = randint(1,1,6);
    station_results(5, k) = func2run; % each station will run on function on each ON period    
end


sim_flag = -1;

while flag
    event = Event_List(1, 1);
    
    if event == 1 %1st event
        T = Event_List(2,1);
        sim_flag = 1; %it's on time now
        
        for station_counter = 1 : station_number
            fprintf('\n');
            fprintf('station %d ', station_counter);
            
            func2run = station_results(5, station_counter);
            
            if func2run == 0 %CBR here
                disp('will run CBR')
                [ tot_packs, tot_b, tot_time ] = CBR(st_sim_time(sim_time_counter), packet_size, interarrival_time, sim_flag);
                station_results(2, station_counter) = station_results(2, station_counter) + tot_packs; %update total packets counter
                station_results(3, station_counter) = station_results(3, station_counter) + tot_b; %update total bytes
                station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time
                
            elseif func2run == 1 %uni1
                disp('will run vbr_uni1')
                addpath('vbr_uni1\');
                [ tot_packs, tot_b, tot_time ] = VBR_UNIFORM1( st_sim_time(sim_time_counter), interarrival_time, sim_flag );
                station_results(2, station_counter) = station_results(2, station_counter) + tot_packs; %update total packets counter
                station_results(3, station_counter) = station_results(3, station_counter) + tot_b; %update total bytes
                station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time
                rmpath('vbr_uni1\');
                
            elseif func2run == 2 %uni2
                disp('will run vbr_uni2')
                addpath('vbr_uni2\');
                [ tot_packs, tot_b, tot_time ] = VBR_UNIFORM2( st_sim_time(sim_time_counter), sim_flag );
                station_results(2, station_counter) = station_results(2, station_counter) + tot_packs; %update total packets counter
                station_results(3, station_counter) = station_results(3, station_counter) + tot_b; %update total bytes
                station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time
                rmpath('vbr_uni2\');
                
            elseif func2run == 3 %uni3
                disp('will run vbr_uni3')
                addpath('vbr_uni3\');
                [ tot_packs, tot_b, tot_time ] = VBR_UNIFORM3( st_sim_time(sim_time_counter), A, B, C, D, sim_flag );
                station_results(2, station_counter) = station_results(2, station_counter) + tot_packs; %update total packets counter
                station_results(3, station_counter) = station_results(3, station_counter) + tot_b; %update total bytes
                station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time
                rmpath('vbr_uni3\');
                
            elseif func2run == 4 %expo1
                disp('will run vbr_expo1')
                addpath('vbr_expo1\');
                [ tot_packs, tot_b, tot_time ] = VBR_EXPO1(st_sim_time(sim_time_counter), A, B, l1, sim_flag );
                station_results(2, station_counter) = station_results(2, station_counter) + tot_packs; %update total packets counter
                station_results(3, station_counter) = station_results(3, station_counter) + tot_b; %update total bytes
                station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time
                rmpath('vbr_expo1\');
                
            elseif func2run == 5 %poiss1
                disp('will run vbr_poiss1')
                addpath('vbr_poiss1\\');
                [ tot_packs, tot_b, tot_time ] = VBR_POISS1( st_sim_time(sim_time_counter), A, B, l2, sim_flag );
                station_results(2, station_counter) = station_results(2, station_counter) + tot_packs; %update total packets counter
                station_results(3, station_counter) = station_results(3, station_counter) + tot_b; %update total bytes
                station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time                
                rmpath('vbr_poiss1\');    
            end
            fprintf('\n');
        end
        sim_time_counter = sim_time_counter + 1; %next simulation time to run
        Event_List(1, end + 1) = 1; %renew event 
        Event_List(2, end) = T + 1; %run next time unit
        
    elseif event == 2
        T = Event_List(2,1);
        sim_flag = 2; %it's off time now
        
        for station_counter = 1 : station_number
            station_results(4, station_counter) = station_results(4, station_counter) + tot_time; %update total run time
        end
        Event_List(1, end + 1) = 2;
        Event_List(2, end) = T + 1;  
        
    elseif event==3
        flag=false;
        disp('Simulation End')
    end
    
    Event_List(:,1) = [];
    Event_List=sortrows(Event_List',2)';
end %while looop ends

%results
results_size = size( station_results );
lin = results_size(1);
col = results_size(2);
for st = 1: station_number
    fprintf('results\n');
    fprintf('station %d\n', st);
    fprintf('distribution: %d\n', station_results(5, st));
    fprintf('packets per second: %f\n', station_results(2, st) / station_results(4, st));
    fprintf('total packets: %d\n', station_results(2, st));
    fprintf('total bytes: %d\n', station_results(3, st));
    fprintf('bps: %f\n', (station_results(3, st) * 8 )/(station_results(4, st)));   
    fprintf('\n');
end


end







