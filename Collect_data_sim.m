%% Run Simulink model and collect data
% set the solver and simulation options 
clc;clear
opt = simset('solver','ode4','SrcWorkspace','Current');

for i=1:100
    x0 = rand-0.5; %have a inital position between [-0.5,0.5]
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

in = [x xdot theta thetadot]'; %input matrix
out = force'; %output matrix

clearvars -except in out;

%% Create neural network
net = network(1,2,[1;1],[1;0],[0 0;1 0],[0,1]); %4 inputs,2 layers, 1 output

% add the rest of structure
net.inputs{1}.size = 4; % size of inputs
net.layers{1}.size = 10; %size of layers
net.layers{2}.size = 1;
net.layers{1}.transferFcn = 'poslin'; %poslin = relu
net.layers{2}.transferFcn = 'purelin'; % purelin = linear
net.initFcn = 'initlay';
net.trainFcn = 'trainbr'; %Bayesian regularization
net.layers{1}.initFcn = 'initnw';
net.layers{2}.initFcn = 'initnw';
%net.inputWeights{1}.delays = 0:1;

%Store the output simulations
y1 = net(in);
net = init(net);
net = train(net,in,out);
y2 = net(in);
% out = cell2mat(out);

% Calculate fit percentage
error = abs(y2-out);
error = error./out*100;
error = sum(error)/length(error);
fit_percentage_cont = 100- error


%% Train a neural network for the inverted pendulum plant
netp = network(1,2,[1;1],[1;0],[0 0;1 0],[0,1]); %1 inputs,2 layers, 4 output

% add the rest of structure
netp.inputs{1}.size = 1; % size of inputs
netp.layers{1}.size = 50; %size of layers
netp.layers{2}.size = 4;
netp.layers{1}.transferFcn = 'poslin'; %poslin = relu
netp.layers{2}.transferFcn = 'purelin'; % purelin = linear
netp.initFcn = 'initlay';
netp.trainFcn = 'trainbr'; %Bayesian regularization
netp.layers{1}.initFcn = 'initnw';
netp.layers{2}.initFcn = 'initnw';
net.inputWeights{1}.delays = 0:10;

%Store the output simulations
y3 = netp(out);
netp = init(netp);
netp = train(netp,out,in);
y4 = netp(out);
% out = cell2mat(out);

% Calculate fit percentage
error = abs(y2-out);
error1 = error./out*100;
error = sum(error)/length(error);
fit_percentage_plant = 100- error