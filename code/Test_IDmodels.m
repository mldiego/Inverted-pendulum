%% Test the System id models

%% 1. Load test data
clc;clear
% load data
d = load('../data/invpend_data_test');
force = d.out;
states = d.in;

%% 2. Find initial states
% Load the ss model
load('../data/Inv_pend');

%Test inverted pensulum model
TestData = iddata(states',force',0.02);
%x0 = findstates(Inv_pend,TestData,'estimate'); %find initial states to corresponding input signal
out_test = lsim(Inv_pend,TestData.InputData,[]);%,x0);
mse_test = mean((states'-out_test).^2);


%% 3. Plot results
% Plot position
t = 0:0.02:(length(force)*0.02-0.02);
figure();
plot(t,states(1,:));
title('Test x-position');
hold on;
plot(t,out_test(:,1));
legend('Simulink', 'Estimated');
xlabel('Time (s)');
ylabel('Position (cm)');

% Plot angle of pendulum
figure();
plot(t,states(3,:));
title('Test pendulum angle');
hold on;
plot(t,out_test(:,3));
legend('Simulink', 'Estimated');
xlabel('Time (s)');
ylabel('Angle (radians)');
