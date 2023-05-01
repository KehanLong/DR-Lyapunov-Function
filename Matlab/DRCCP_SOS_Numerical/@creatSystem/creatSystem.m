classdef creatSystem < handle    
    %% Control-Affine System
    properties
        % System parameters
        params 
        x
        %% Control Affine Uncertainty Free System: xdot = f(x)
        % f(x)
        f 
        
        %% Control Affine Uncertain System: xdot = f(x,xi)
        % f(x, xi)
        f_m 
        % uncertainty mode
        d
        % uncertainty
        xi
    end
    
    methods
        function obj = creatSystem(params) 
            obj.params = params;
            [x, f] = obj.defineSystem;
            obj.x = x;
            obj.f = matlabFunction(f, 'vars', {x});
            [xi, f_m, d] = obj.defineUncerSystem(x, f);
            obj.f_m = matlabFunction(f_m, 'vars', {x,xi});
            obj.d = matlabFunction(d, 'vars', {x});  
            obj.xi = xi;
        end
    end
end