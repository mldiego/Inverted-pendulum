%% Create and train neural network controller
clc;clear;close all;
%% Load data 
load('../data/invpend_data');
out = dataf.u;
in = dataf.y;
% Prepare data
for i=1:length(in)
    out{i} = out{i}';
    in{i} = in{i}';
end

% Divide for training and testing
out_train = out{1:46};
out_test = out{47:end};
in_train = in{1:46};
in_test = in{47:end};

%% Create NN
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

% Train NN
net = init(net);
net = train(net,in_train,out_train);


%% Calculate performance on train data
y = net(in_test);
performance = perform(net,out_test,y);