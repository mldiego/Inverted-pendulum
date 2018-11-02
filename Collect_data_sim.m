%% Run Simulink model and collect data
% set the solver and simulation options 

%% Generate training data
clc;clear
opt = simset('solver','ode4','SrcWorkspace','Current');

for i=1:200
    rng(1); %set the seed for reproducible results
    x0 = rand-0.5; %have a inital position between [-0.5,0.5]
    rng(1); %set the seed for reproducible results
    theta0 = rand*0.4-0.2; % have a initial angle between [-0.2,0.2]
    [T,X] = sim('ClosedLoop_Kcont',[0 15],opt); %simulate system and record data
    
%     x1(:,i) = X(:,1);
    x1(:,i) = xx;
%     x2(:,i) = X(:,2);
    x2(:,i) = xxdot;
%     x3(:,i) = X(:,3);
    x3(:,i) = xtheta;
%     x4(:,i) = X(:,4); 
    x4(:,i) = xthetadot;
    x5(:,i) = u;

end
x = reshape(x1,[],1);
xdot = reshape(x2,[],1);
theta = reshape(x3,[],1);
thetadot = reshape(x4,[],1);
force = reshape(x5,[],1);

in = [x xdot theta thetadot]'; %input matrix for controller
out = force'; %output matrix for controller

clearvars -except in out;
save('invpend_data','in','out'); 

%% Generate training data
clc;clear
opt = simset('solver','ode4','SrcWorkspace','Current');

for i=1:50
    rng(2); %set the seed for reproducible results
    x0 = rand-0.5; %have a inital position between [-0.5,0.5]
    rng(2); %set the seed for reproducible results
    theta0 = rand*0.4-0.2; % have a initial angle between [-0.2,0.2]
    [T,X] = sim('ClosedLoop_Kcont',[0 15],opt); %simulate system and record data
    
%     x1(:,i) = X(:,1);
    x1(:,i) = xx;
%     x2(:,i) = X(:,2);
    x2(:,i) = xxdot;
%     x3(:,i) = X(:,3);
    x3(:,i) = xtheta;
%     x4(:,i) = X(:,4); 
    x4(:,i) = xthetadot;
    x5(:,i) = u;

end
x = reshape(x1,[],1);
xdot = reshape(x2,[],1);
theta = reshape(x3,[],1);
thetadot = reshape(x4,[],1);
force = reshape(x5,[],1);

in = [x xdot theta thetadot]'; %input matrix for controller
out = force'; %output matrix for controller

clearvars -except in out;
save('invpend_data_test','in','out'); 
