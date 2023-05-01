function [x, f] = defineSystem(obj)
    % States
    syms x1 x2 x3
    x = [x1; x2; x3];
    obj.params.x_dim = height(x);
    
    % x1 = s, x2 = c, x3 = theta_dot
    b = 0.1;
    m = 1;
    l = 0.5;
    g = 9.81;
    
    % Dynamics
    f = [x2*x3;...
        -x1*x3;...
        -(b*x3 + m*g*l*x1)/(m*l^2)];
end