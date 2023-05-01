function [xi, f_m, d] = defineUncerSystem(obj, x, f)
    % Uncertainty Mode
    %obj.params.xi_dim = 2;
    syms xi1 xi2
    xi = [xi1;xi2];
    
    b = 0.1;
    m = 1;
    l = 0.5;
    g = 9.81;
    
    temp(:,1) = [0;...
                0;...
                -(0.05*b*x(3))/(m*l^2)];
    temp(:,2) = [0;...
                0;...
                -(0.05*m*g*l*x(1))/(m*l^2)];

    % Dynamics
    f_m = f;
    for i = 1:obj.params.xi_dim
        f_m = f_m + temp(:,i)*xi(i);
        d(:,i) = temp(:,i);
    end
end