%% Run Simulink model and collect data
% set the solver and simulation options 

%% Generate training data
clc;clear
opt = simset('solver','ode4','FixedStep',0.001);

for i=1:50
    rng(1); %set the seed for reproducible results
    x0 = rand-0.5; %have a inital position between [-0.5,0.5]
    rng(1); %set the seed for reproducible results
    theta0 = rand*0.4-0.2; % have a initial angle between [-0.2,0.2]
    [T,X] = sim('../Simulink/ClosedLoop_Kcont',[0 15],opt); %simulate system and record data
    % Create data object for each iteration
    states = [xx xxdot xtheta xthetadot];
    force = u;
    data = iddata(states,force,0.005);
    % Merge all simulations together
    if i>1
        dataf = merge(dataf,data);
    else
        dataf = merge(data);
    end
end

% clearvars -except dataf;
% save('../data/invpend_data','dataf'); 

%% Generate testing data
clc;clear
opt = simset('solver','ode4','SrcWorkspace','Current');

for i=1:10
    rng(2); %set the seed for reproducible results
    x0 = rand-0.5; %have a inital position between [-0.5,0.5]
    rng(2); %set the seed for reproducible results
    theta0 = rand*0.4-0.2; % have a initial angle between [-0.2,0.2]
    [T,X] = sim('../Simulink/ClosedLoop_Kcont',[0 15],opt); %simulate system and record data
    % Create data object for each iteration
    states = [xx xxdot xtheta xthetadot];
    force = u;
    data = iddata(states,force,0.005);
    % Merge all simulations together
    if i>1
        datatest = merge(datatest,data);
    else
        datatest = merge(data);
    end
end

% clearvars -except datatest;
% save('../data/invpend_data_test','datatest'); 