% inverted pendulum model, generation of spaceex hybrid automaton and
% corresponding continuous-time stateflow model

%clear all;






theta_min_deg=-30;  %degrees
theta_max_deg=30;   %degrees
theta_min_rad=deg2rad(theta_min_deg);   %radians
theta_max_rad=deg2rad(theta_max_deg);   %radians
x_min=-0.2;         %meters
x_max=0.2;          %meters
xdot_min=-1;        %meters/second
xdot_max=1;         %meters/second
va_min=-4.95;       %volts
va_max=4.95;        %volts

Ts=0.020;
Tc=0.020;   %20ms control period
fs=1/Ts;
fc=1/Tc;

syms x1 x2 x3 x4;     %state variables
syms x01 x02 x03 x04; %initial conditions
syms a22 a23 a24 a42 a43 a44; %system matrix
syms a22w a23w a24w a42w a43w a44w; %system matrix
syms b2 b4; %control matrix
syms Va;

%physical parameters
g=-9.8; %gravity: -9.8 m/s
m=1;    %mass
Ki=0.9; %torque constant
Kb=0.9; %back-emf constant
Kg=1;   %gear ratio
r=2; %
Ra=0.95;    %armature resistance
Bm=1.95;    %
Btheta=0.95;    
Bbar=((Kg*Bm)/(r^2))+(((Kg^2)*Ki*Kb)/((r^2)*Ra));
Bl=((Kg*Ki)/(r*Ra));
M=5;    %mass
Jm=5;   %moment of inertia
l=0.5;  %length
Mbar=m+M+(Kg*Jm)/(r^2); %effective mass
Dl=(4*Mbar)-3*m;

X0s=[x01 x02 x03 x04]';
X=[x1 x2 x3 x4];
U=[Va];
%As=[0 1 0 0; 0 -a22 -a23 a24; 0 0 0 1; 0 a42 a43 -a44];
As=[0 0 1 0; ; 0 0 0 1; 0 -a22 -a23 a24; 0 a42 a43 -a44];
Asw=[0 1 0 0; 0 -a22w -a23w a24w; 0 0 0 1; 0 a42w a43w -a44w];
%Bs=[0; b2; 0; -b4];
Bs=[0; 0; b2; -b4];
%a22=0.1;  a23=0.01;    a24=0.01;  a42=0.01;  a43=0.5;  a44=0.1;
%a22w=(4*Bbar)/(Dl);  a23w=(3*m*g)/(Dl);   a24w=(6*Btheta)/(l*Dl);
%a42w=(6*Bbar)/(l*Dl);    a43w=(6*Mbar*g)/(l*Dl);  a44w=(12*Mbar*Btheta)/(m*(l^2)*Dl);
a22=2.75; a23=10.95; a24=0.0043; a42=28.58; a43=24.92; a44=0.044; %real matrix

%Xreal=[x theta xdot thetadot]'

%b2=0.1;   b4=0.5;
%b2=(4*Bl)/(Dl); b4=(6*Bl)/(l*Dl);
b2=1.94; b4=4.44; %real matrix
%x1=x, x2=x', x3=theta, x4=theta'
%x01=0.1; x02=0.2; x03=0.5; x04=-0.5;
%x01=0.05; x02=0.05; x03=0.05; x04=0.05; %interesting plot: edge of safety
%area
%x01=0.05; x02=0.05; x03=-0.05; x04=0.05;
%x01=0.1; x02=0.15; x03=0.05; x04=0.05;
%x01=0.05; x02=0.05; x03=-0.1; x04=-0.1; %edge of larger safety
%x01=-0.15; x02=-0.21; x03=0.4; x04=1.25;
x01=-0.19; x02=-0.2418; x03=0.3; x04=1.41; %extrema safety
%x01=-1; x02=-0.2581; x03=0.13; x04=1.17; %extrema experimental

A=eval(As);
Aw=eval(Asw);
B=eval(Bs);
X0=eval(X0s);

%A=[37.62, 58.22, 17.87, 11.61; 58.22, 313.16, 69.36, 56.09; 17.87, 69.36, 29.81, 14.81; 11.61, 56.09, 14.81, 12.04];
%A=[1 -0.00051281 0.017961 -0.0000026781; 0 1.0056 0.0046419 0.020029; 0 -0.049519 0.80322 -0.00043546; 0 0.55967 0.44824 1.0048;]

%B=[0.0003618; -0.00082708; 0.034913; -0.079879];

Q=eye(4); %positive definite Q
syms p11 p12 p13 p14 p22 p23 p24 p33 p34 p44;
P=[p11 p12 p13 p14; p12 p22 p23 p24; p13 p23 p33 p34; p14 p24 p34 p44];

%linear state feedback control: V_a=KX=inv(-R)B'SX
%A'S+SA-SBinv(R)B'S+D=0
%R1=0.01
%R2=0.01
%D=eye(4)

syms KS1 KS2 KS3 KS4 KB1 KB2 KB3 KB4 KE1 KE2 KE3 KE4;
%KS=[7.6,  13.54, 42.85,  8.25];     %safety
%KS=[6.0, 20.0, 60.0, 16.0];         %safety (real system)
KS=[7.6,  42.85, 13.54,  8.25];     %safety
KSs=[KS1, KS2, KS3, KS4];           %safety symbolic
%KB=[3.16, 19.85, 69.92,  14.38];    %baseline
%KB=[8.0, 32.0, 120.0, 12.0];        %baseline (real system)
KB=[3.16, 69.92, 19.85,  14.38];    %baseline
KBs=[KB1, KB2, KB3, KB4];
%KE=[10.0, 27.72, 103.36, 23.04];    %experimental
%KE=[5.7807, 42.2087, 14.0953, 8.6016];
KE=[10.0, 103.36, 27.72, 23.04];    %experimental
%KE=[10.0, 36.0, 140.0, 14.0];       %experimental (real system)
KEs=[KE1, KE2, KE3, KE4];



















% import data structures from Hyst
javaaddpath(['hyst', filesep, 'lib', filesep, 'Hyst.jar']);
import de.uni_freiburg.informatik.swt.spaceexboogieprinter.*;
import com.verivital.hyst.automaton.*;
import com.verivital.hyst.grammar.antlr.*;
import com.verivital.hyst.grammar.formula.*;
import com.verivital.hyst.importer.*;
import com.verivital.hyst.ir.*;
import com.verivital.hyst.junit.*;
import com.verivital.hyst.util.*;
import com.verivital.hyst.main.*;
import com.verivital.hyst.passes.*;
import com.verivital.hyst.printers.*;
import com.verivital.hyst.simulation.*;
import de.uni_freiburg.informatik.swt.sxhybridautomaton.*;
import de.uni_freiburg.informatik.swt.spaceexxmlprinter.*;
import de.uni_freiburg.informatik.swt.spaxeexxmlreader.*;


% create an empty hybrid automaton    
ha = com.verivital.hyst.ir.base.BaseComponent;

num_var = 5;

varNames = {};
for i = 1 : num_var
    varNames{i} = ['x', num2str(i)];
end

% override default names with theta, etc.
varNames = {};
varNames = {'x', 'theta', 'v', 'omega', 'u'};

% add the u input to A with zero derivatives so we can reference it
% appropriately, and also concatenate the B vector
Au = [[A B]; zeros(1,5)]; % without stabilizing controller, but with input applied as an input
%Au = [[(A + B*KS) zeros(4,1)]; zeros(1,5)]; % with stabilizing controller ( u = KS * x)

for i = 1 : 1 % one mode
    modesToFlows{i} = odeMatrixToString(Au, varNames);
end

% add variables to ha
for i_var = 1:num_var
    ha.variables.add(java.lang.String(varNames(i_var)));
end

% one mode
numLoc = 1;

for i_loc = 1:numLoc
    locName{i_loc} = java.lang.String(strcat('loc', num2str(i_loc)));
    invariant{i_loc} = java.lang.String('');
    
    flow{i_loc} = modesToFlows{i_loc};
    
    loc = ha.createMode(locName{i_loc},invariant{i_loc},flow{i_loc});
    locations(i_loc) = loc;
end

fromLocation = {};
toLocation= {};
%fromId = [pta_trace(:).id1];
%toId = [pta_trace(:).id2];
%for i=1:length(pta_trace)
%    fromLocation{end+1} = locations(fromId(i));
%    toLocation{end+1} = locations(toId(i));
%end

% add guards and resets in an order of transitions
%for i = 1 : length(pta_trace)
%    li_id = pta_trace(i).guard;
%    v = label_guard{li_id};
%    guard{i} = guardVectorToString(v, varNames);
%end

guard = {''};
reset = {''};

% guard = {%'vc >= Vref+Vtol';'vc >= Vref-Vtol';'il <= 0';'vc >= Vref-Vtol'
%         };
%reset = {%'vc=vc & il=il';'vc=vc & il=il';
%         %'vc=vc & il=il';'vc=vc & il=il'
%         };

numTran = length(fromLocation);
for i_tran = 1:numTran
    tran = ha.createTransition(fromLocation{i_tran}, toLocation{i_tran});
    tran.guard = com.verivital.hyst.grammar.formula.FormulaParser.parseGuard(guard{i_tran});
    
    %if (~isempty(reset(i_tran)))
    if (~isempty(reset))
    rstTmp = strsplit(char(reset(i_tran)),'&');
        for i_rst = 1: length(rstTmp)
            rstTmp_token = strsplit(char(rstTmp(i_rst)),'=');
            rstTmp_token_two = com.verivital.hyst.grammar.formula.Variable(char(rstTmp_token(2)));
            tran.reset.put(java.lang.String(rstTmp_token(1)),com.verivital.hyst.ir.base.ExpressionInterval(rstTmp_token_two));
        end
    end
end

% add a list of constants and their values
constantList = {
%'a00o'; 'a01o'; 'a10o'; 'a11o'; 'a00c'; 'a01c'; 'a10c'; 'a11c'; 'bounds'; 'T'; 'b0o'; 'b1o'; 'b0c'; 'b1c'; 'Vs'; 'tmax'; 'Vtol'; 'Vref';
};
constantValue = [
%-1.963e+02; -3.775e+02; 4.547e+02; -45.51; -2.718e+02; -3.775e+02; 4.547e+02; -45.51; 100; 2.0e-05; 0; 0; 3.775e+02; 0; 24; 0.02; 0.1; 12
];

if length(constantList) == length(constantValue)
    try
        for i_const = 1:length(constantList) 
            ha.constants.put(java.lang.String(constantList(i_const)),constantValue(i_const));
        end
    catch
    end
end

% add initial condition 
initalLoc = 'loc1'; % todo: check naming, first location in fromLocation is initial

initialExpression = 'loc(invpend) == loc1';
for i = 1 : length(varNames)
    initialExpression = strcat(initialExpression, ' & ', varNames{i}, ' == 0'); % todo: pick a reasonable initial condition
end
    
%generate configuration
config = com.verivital.hyst.ir.Configuration(ha);
config.init.put(initalLoc,com.verivital.hyst.grammar.formula.FormulaParser.parseInitialForbidden(initialExpression));

configValues = de.uni_freiburg.informatik.swt.sxhybridautomaton.SpaceExConfigValues;
configValues.scenario = 'supp';
configValues.outputFormat = 'GEN';

vars = ha.variables.toArray();
if num_var > 1
    jsa = javaArray('java.lang.String', num_var);
    for i = 1: ha.variables.size()
          jsa(i) = java.lang.String(vars(i));
    end 
end

file_name ='invpend'; % todo: suffix example name
config.settings.plotVariableNames = jsa;
config.settings.spaceExConfig = configValues;
printer = com.verivital.hyst.printers.SpaceExPrinter;
printer.setBaseName(file_name);
printer.setConfig(config);
printer.setBaseComponent(ha);
config.DO_VALIDATION = false;
doc = printer.convert(ha);

% Save the SpaceEx document and the configuration file 
xml_printer = de.uni_freiburg.informatik.swt.spaceexxmlprinter.SpaceExXMLPrinter(doc);
fileID = fopen([file_name,'.cfg'],'w');
fprintf(fileID,char(xml_printer.getCFGString(1)));
fclose(fileID);

fileID = fopen([file_name,'.xml'],'w');
fprintf(fileID,char(xml_printer.stringXML()));
fclose(fileID);

cd('hyst\src\matlab');
try
    SpaceExToStateflow('..\..\..\invpend.xml');
catch
end
cd('..\..\..');