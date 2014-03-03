function [ output_args ] = main1( sim_time, station_number )

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

for station_counter = 1 : station_number
    func2run = randint(1,1,6); %return random integer in range [0,5]
    fprintf('\n');
    fprintf('station %d ', station_counter);
    
    if func2run == 0 %CBR here
        disp('will run CBR')
        addpath('..');
        CBR(sim_time, packet_size, interarrival_time);
        rmpath('..');
        
    elseif func2run == 1 %uni1
        disp('will run vbr_uni1')
        addpath('..\vbr_uni1\');
        VBR_UNIFORM1( sim_time, interarrival_time );
        rmpath('..\vbr_uni1\');
        
    elseif func2run == 2 %uni2
        disp('will run vbr_uni2')
        addpath('..\vbr_uni2\');
        VBR_UNIFORM2( sim_time );
        rmpath('..\vbr_uni2\');
        
    elseif func2run == 3 %uni3
        disp('will run vbr_uni3')
        addpath('..\vbr_uni3\');
        VBR_UNIFORM3( sim_time, A, B, C, D );
        rmpath('..\vbr_uni3\');
        
    elseif func2run == 4 %expo1
        disp('will run vbr_expo1')
        addpath('..\vbr_expo1\');
        VBR_EXPO1(sim_time, A, B, l1 );
        rmpath('..\vbr_expo1\');
        
    elseif func2run == 5 %poiss1
        disp('will run vbr_poiss1')
        addpath('..\vbr_poiss1\\');
        VBR_POISS1( sim_time, A, B, l2 );
        rmpath('..\vbr_poiss1\');
        
    end
    fprintf('\n');    
end

end

