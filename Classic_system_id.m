%% System Identification for the plant using classical methods
clc;clear
% load data
d = load('invpend_data');
force = d.out;
states = d.in;
%% Estimate the state-space model with input force and all 4 outputs
% create iddata object 
data = iddata(states',force',0.02);
%define the options
opt = n4sidOptions;
% opt.EnforceStability = 1;
opt.focus='simulation';
opt.InitialState = 'estimate';
Inv_pend = n4sid(data,4,opt);
% estimate the output of the Vx_model
out = lsim(Inv_pend,data.InputData);
% Compute the mean square error for the data used to estimate the model parameters
mse = mean((states'-out).^2)

%Plot the x-position graph
t = 0:0.02:(length(force)*0.02-0.02);
figure();
plot(t,states(1,:));
title('x position');
hold on;
plot(t,out(:,1));
legend('Simulink', 'Estimated');
xlabel('Time (s)');
ylabel('Position (cm)');

%Plot the angle graphs
figure();
plot(t,states(3,:));
title('Angle');
hold on;
plot(t,out(:,3));
legend('Simulink', 'Estimated');
xlabel('Time (s)');
ylabel('Position (cm)');

%% Save the model
% convert the systems to continuous time 
Inv_pend_cont = d2c(Inv_pend,'tustin');
save('Inv_pend');
save('Inv_pend_cont');