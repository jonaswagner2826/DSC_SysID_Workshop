function [u_sim] = sysID_setup(input_type,pcheck)


Tend = 50;
dt = 0.01;
time = 0:dt:Tend;

%% signal atributes

if pcheck == 1

    assignin('base','use_actuator_pnoise',false);
    assignin('base','actuator_tf_num',[1]);
    assignin('base','actuator_tf_den',[2*pi 1]);
    assignin('base','actuator_pnoise_pow',10);
    assignin('base','use_roadpos_noise',false);
    assignin('base','use_roadpos_anomalies',false);
    assignin('base','roadpos_noise_pow',1e-7);
    assignin('base','anom_set_size',100);
    assignin('base','use_tire_mnoise',false);
    assignin('base','tire_mnoise_pow',1e-7);
    assignin('base','use_vb_mnoise',false);
    assignin('base','vb_mnoise_pow',1e-7);
    assignin('base','use_input_delay',false);
    assignin('base','input_delay_length',100);
    
end

%% Inputs

ubase = zeros(1,length(time));
if input_type == 1
% Step
ustep = ubase;
ustep(round(length(time)/2):end) = 1;
u = ustep;

elseif input_type == 2
% Impulse
uimp = ubase;
uimp(round(length(time)/2)) = 1;
u = uimp;
elseif input_type == 3
% Sine
u = sin(time*1.8);

elseif input_type == 4
% Chirp (0.1 Hz → 5 Hz over 10 seconds)
f0 = 0.01;     % start frequency (Hz)
f1 = 2;       % end frequency   (Hz)
u = chirp(time, f0, time(end), f1,'linear',90);

elseif input_type == 5
% PRBS (pseudo-random binary sequence) with hold time
prbs_order = 10;                         % order of PRBS
prbs_raw = idinput(2^prbs_order - 1, 'prbs');

hold_time = 100;                         % each bit repeats for this many samples
prbs_long = repelem(prbs_raw', hold_time);

uprbs = prbs_long(1:min(length(prbs_long), length(time)));
if length(uprbs) < length(time)
    u = [uprbs zeros(1, length(time)-length(uprbs))];
else
    uprbs(0:300) = 0;
    u = uprbs; 
end

else
    disp("incorrect input type")
end

u_sim = [time', u'];

end

