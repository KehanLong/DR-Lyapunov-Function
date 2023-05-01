function [x, f] = defineSystem(obj)
    % States
    syms x1 x2
    x = [x1; x2];
    obj.params.x_dim = height(x);
    
    % Dynamics
    f = [-1.5*x1^2-0.5*x1^3-x2; 6*x1 - x2];
end