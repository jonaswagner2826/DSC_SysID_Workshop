function sysID_est(y,u,time)

dt = 0.01;

expData = iddata(y, u, dt);


est_delay = delayest(expData);
est_delay_m = median(est_delay);


%% Input Delay correction
fprintf('Estimated input delay = %.2f samples\n', est_delay_m);
est_delay_samples = round(est_delay_m);  % integer samples for shifting

% Shift input backward to preserve output
u_shifted = [zeros(est_delay_samples,1); u(1:end-est_delay_samples)];
y_shifted = y;  % keep full output
fit_data_delaycorrected = iddata(y_shifted, u_shifted, dt);


%% Fit State-Space Model
Gss = ssest(fit_data_delaycorrected, 1:4);

% Build transfer function model with delay
s = tf('s');
Gest = tf(Gss) * exp(-est_delay_samples*dt*s);

%Gest_best = tf(G1_Num, G1_Den)* exp(-est_delay_samples*dt*s);


figure;
for k = 1:numel(fit_data_delaycorrected)   % correctedData = delay-corrected iddata cell array
    opt = compareOptions;
    opt.InitialCondition = 'z';
    subplot(numel(fit_data_delaycorrected),1,1)
    compare(fit_data_delaycorrected, Gss, Gest, opt);
    title(sprintf('Trial %d Fit'));
end


%% Extract input and time vector
u_test = expData.u(:);      % numeric input
y_test = expData.y(:);      % numeric output
Ts = expData.Ts;
time_test = (0:length(u_test)-1)*Ts;

% Simulate output (lsim automatically handles TF + delay)
y_model = lsim(Gest, u, time_test);

%% Residuals tests

figure;
resid(Gest,expData)

% System dimensions
nx = 4; % Number of states
nu = 1; % Number of inputs (controllable)
nd = 2; % Number of disturbances
ny = 3; % Number of outputs

% Model parameters
Ks = 900;    % Suspension Stiffness (N/m) 
Kus = 0; %1250;  % Tire stiffness (N/m)
Ms = 2.45;   % Sprung Mass (kg) 
Mus = 1;     % Unsprung Mass (kg)
Bs = 7.5;    % Suspension Inherent Damping coefficient (sec/m)
Bus = 0; %5;     % Tire Inherent Damping coefficient (sec/m)

% Model Definition
Ac = [0 1 0 0
      -(Kus/Mus) -(Bs +Bus)/Mus (Ks/Mus) (Bs/Mus)
      0 -1 0 1
      0 (Bs/Ms) -(Ks/Ms) -(Bs/Ms)];   % State Matrix
Bc = [0; -(1/Mus); 0; (1/Ms)];        % Input Matrix
Vc = [-1 0
      (Bus/Mus) 0
      0 0
      0 0];                           % Disturbance
C = [1 0 0 0
     1 0 1 0
     0 (Bs/Ms) -(Ks/Ms) -(Bs/Ms)];    % Output
D = [0;0;(1/Ms)];                     % Feed-through
W = [0 1
     0 1
     0 0];                            % Output Disturbance
 
 
 Glin = ss(Ac,[Bc Vc],C,[D W]);
 
 udot = [diff(u); 0];
 ulin = [zeros(size(u,1),1) udot u];
 
 y_lin = lsim(Glin, ulin, time_test);


%% Plot comparison
figure;
plot(time_test, y_test, 'k', 'LineWidth', 1.5);
hold on;
plot(time_test, y_model, 'b--', 'LineWidth', 1.5);
plot(time_test, y_lin(:,2), 'r--', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Output');
title(sprintf('Comparison: Model vs Untested Trial #%d'));
legend('Measured Output', 'Estimated Model Output', 'Physics-based Model');
grid on;
hold off;
end

