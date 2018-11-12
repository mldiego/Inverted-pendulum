%% System Identification for the plant using classical methods with open loop data
clc;clear
% load data
load('inv_openloop_sine');
force = openloop(6,:);
states = openloop(2:5,:);
%% Estimate the state-space model with input force and all 4 outputs
% create iddata object 
data = iddata(states',force',0.001);
%define the options
opt = n4sidOptions;
% opt.EnforceStability = 1;
opt.focus='prediction';
opt.InitialState = 'estimate';
Inv_pend = n4sid(data,10,opt);
% estimate the output of the Vx_model
out = lsim(Inv_pend,data.InputData);
% Compute the mean square error for the data used to estimate the model parameters
mse = mean((states'-out).^2)

%Plot the x-position graph
t = 0:0.001:(length(force)*0.001-0.001);
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
% Inv_pend_cont = d2c(Inv_pend,'tustin');
% save('Inv_pend');
% save('Inv_pend_cont');