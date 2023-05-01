function [V,dV] = ccpFormulater(obj)
    %% Input Check
    yalmip('clear')
    % 2d: Order of polynomial Lyapunov Function
    d=2;

    % variables
    x = sdpvar(obj.params.x_dim,1);

    % Polynomial Lyapunov Function of order 2d, c: coefficients, Vm: monomials
    [V,c,Vm] = polynomial(x,2*d);
    [L,cL,~] = polynomial(x,4);
    
    dV_x = jacobian(V,x);
    
    equi = [0;1;0;];
    
    r = 0.1*((x-equi).'*(x-equi));
    
    xi_trai = obj.params.xi_trai;
    %ca21 = [2.5*ones(1,3),3*ones(1,3),3.5*ones(1,3)];
    %ca22 = kron(ones(1,3),[1.5,2,2.5]);
    
    %xi_trai = 2:0.25:4;
    %xi_trai = [ca21;ca22];
    
    constraints = dV_x*(kron(ones(1,obj.params.xi_num),obj.f(x)) + obj.d(x)*xi_trai);
    V_equi = replace(V,x,equi);
    
    F = [sos(V-10*r), V_equi == 0];
    
    for i = 1:obj.params.xi_num
        F = [F,sos(-constraints(1,i)-L*(x(1).^2 + x(2).^2 - 1)-r*x(1).^2)];
    end
    
    %SDP solver
    ops = sdpsettings('solver','mosek');

    % Solve SOS based SDP
    sol = solvesos(F,[],ops,[c;cL]);
    obj.params.err = sol.problem;

    %% Results
    % Obtained coefficients of polynomial Lyapunov Function
    cc=value(c);

    % dV(x)/dt
    V = sdisplay(cc'*Vm);
    internal = obj.x;
    V = eval(V{1});
    dV = jacobian(V)*obj.f_m(obj.x,obj.xi);
    V = matlabFunction(V, 'vars', obj.x);
    dV = matlabFunction(dV, 'vars', {obj.x,obj.xi});
end