% this function takes a matrix A, which is an element of the ode list
% variable returned by other parts of the automata learning
function [out] = odeMatrixToString(A,varNames)
    x = [];
    
    n = length(varNames); % state space dimensionality
    
    for i = 1 : n
        x = [x; sym(varNames{i})];
    end
    
    tmp = string(vpa(A * x, 4)); % round to 4 decimals; TODO: make this a config option
    odeStrConjunction = '';
    for i = 1 : n
        odeStr = strcat(varNames(i), ''' == ', tmp{i});
        if i > 1
            odeStrConjunction = strcat(odeStrConjunction, ' & ');
        end
        odeStrConjunction = strcat(odeStrConjunction, ' ', odeStr);
        tmp(i) = java.lang.String(odeStr);
    end
    out = odeStrConjunction;
end