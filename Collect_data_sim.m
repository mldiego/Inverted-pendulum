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

%clearvars -except in out;

%% Create neural network controller
% net = network(1,2,[1;1],[1;0],[0 0;1 0],[0,1]); %4 inputs,2 layers, 1 output
% 
% % add the rest of structure
% net.inputs{1}.size = 4; % size of inputs
% net.layers{1}.size = 10; %size of layers
% net.layers{2}.size = 1;
% net.layers{1}.transferFcn = 'poslin'; %poslin = relu
% net.layers{2}.transferFcn = 'purelin'; % purelin = linear
% net.initFcn = 'initlay';
% net.trainFcn = 'trainbr'; %Bayesian regularization
% net.layers{1}.initFcn = 'initnw';
% net.layers{2}.initFcn = 'initnw';
% %net.inputWeights{1}.delays = 0:1;
% 
% %Store the output simulations
% y1 = net(in);
% net = init(net);
% net = train(net,in,out);
% y2 = net(in);
% % out = cell2mat(out);
% 
% % Calculate fit percentage
% error = abs(y2-out);
% error = error./out*100;
% error = sum(error)/length(error);
% fit_percentage_cont = 100- error


%% Train a neural network for the inverted pendulum plant
net = network(1,3,[1;1;1],[1;0;0],[0 1 1;1 0 1;0 1 0],[0,0,1]); %4 inputs and 3 layers

% add the rest of structure
% add the rest of structure
net.inputs{1}.size = 1; % size of inputs
net.layers{1}.size = 8; %size of layers
net.layers{2}.size = 10;
net.layers{3}.size = 4;
net.layers{1}.transferFcn = 'poslin'; %poslin = relu
net.layers{2}.transferFcn = 'poslin'; % tansig = tanh
net.layers{3}.transferFcn = 'purelin'; % purelin = linear
net.initFcn = 'initlay';
net.trainFcn = 'trainlm'; %Levenberg–Marquardt algorithm
net.layers{1}.initFcn = 'initnw';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.initFcn = 'initnw';
net.inputWeights{1}.delays = 0:1;
net.layerWeights{1,2}.delays = 1:2;
net.layerWeights{1,3}.delays = 1:2;
net.layerWeights{2,3}.delays = 1:2;
view(net)

%initialize and train neural network
net = init(net);
net = train(net,out,in);
