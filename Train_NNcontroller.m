%% Create neural network controller
clc;clear
% Load data 
d = load('invpend_data');
out = d.out;
in = d.in;

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
fit_percentage_cont = 100- error;