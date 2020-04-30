%% Train a neural network for the inverted pendulum plant
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
% This is a recurrent neural network
net = network(1,3,[1;1;1],[1;0;0],[0 1 1;1 0 1;0 1 0],[0,0,1]); %4 inputs and 3 layers

% add the rest of structure
net.inputs{1}.size = 1; % size of inputs
net.layers{1}.size = 8; %size of layers
net.layers{2}.size = 10;
net.layers{3}.size = 4;
net.layers{1}.transferFcn = 'poslin'; %poslin = relu
net.layers{2}.transferFcn = 'poslin'; 
net.layers{3}.transferFcn = 'purelin'; % purelin = linear
net.initFcn = 'initlay';
net.trainFcn = 'trainlm'; %Levenberg�Marquardt algorithm
net.layers{1}.initFcn = 'initnw';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.initFcn = 'initnw';
net.inputWeights{1}.delays = 0:1;
net.layerWeights{1,2}.delays = 1:2;
net.layerWeights{1,3}.delays = 1:2;
net.layerWeights{2,3}.delays = 1:2;
view(net)

%% Train NN
% initialize parameters
net = init(net);
% train
net = train(net,out,in);