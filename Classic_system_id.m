%% System Identification for the plant using classical methods
clc;clear
% load data
load('invpend_data');

%% Estimate the state-space model with input force and all 4 outputs
%define the options
opt1 = n4sidOptions('N4weight','SSARX');
opt1.EnforceStability = 1;
opt1.focus='simulation';
opt1.InitialState = 'estimate';
Inv_pend = n4sid(dataf,4,opt1);

opt2 = n4sidOptions('N4weight','SSARX');
opt2.EnforceStability = 1;
opt2.focus='prediction';
opt2.InitialState = 'estimate';
Inv_pend2 = n4sid(dataf,4,opt2);


%% Save the model
%save('Inv_pend_ss','Inv_pend');


%% Convert the systems to continuous time 
Inv_pend_cont = d2c(Inv_pend,'tustin');
Inv_pend_cont2 = d2c(Inv_pend2,'tustin');
%save('Inv_pend_cont_ss','Inv_pend_cont');

%% Test the model
load('invpend_data_test');
out1 = sim(Inv_pend,datatest);
plot(out1.OutputData{4})
hold on;
out2 = sim(Inv_pend2,datatest);
plot(out2.OutputData{4})