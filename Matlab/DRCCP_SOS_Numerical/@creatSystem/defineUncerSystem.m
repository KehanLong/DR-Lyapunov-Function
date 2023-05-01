function [xi, f_m, d] = defineUncerSystem(obj, x, f)
    syms xi1 xi2
    xi = [xi1;xi2];
    
    % Case 1
    %temp(:,1) = [-(x(1));-x(2)];
    %temp(:,2) = [-x(2);0];
    % Case 2
    temp(:,1) = [-(x(1)^3+x(2));-x(2)];
    temp(:,2) = [-x(2);-x(1)];
    
    %% Dynamics
    f_m = f;
    for i = 1:obj.params.xi_dim
        f_m = f_m + temp(:,i)*xi(i);
        d(:,i) = temp(:,i);
    end
end