function dV = drccpFormulater(obj)
    %% Input Check
    yalmip('clear')
    % 2d: Order of polynomial Lyapunov Function
    d=2;

    % variables
    x = sdpvar(obj.params.x_dim,1);

    % Polynomial Lyapunov Function of order 2d, c: coefficients, Vm: monomials
    [V,c,Vm] = polynomial(x,2*d);
    
    dV_x = jacobian(V,x);
    d_x = obj.d(x);
    
    r = 0.1*(x'*x);
    
    xi_trai = obj.params.xi_trai;
    
    constraints = dV_x*(kron(ones(1,obj.params.xi_num),obj.f(x)) + obj.d(x)*xi_trai);
    
    F = [sos(V-10*r),c(1)==0];
    
    for j = 1:obj.params.xi_dim
        for i = 1:obj.params.xi_num
            F = [F,sos(-obj.params.theta*dV_x*d_x(:,j)-constraints(1,i)-r)...
                ,sos(obj.params.theta*dV_x*d_x(:,j)-constraints(1,i)-r)];
        end
    end
    
    %SDP solver
    ops = sdpsettings('solver','mosek');

    % Solve SOS based SDP
    sol = solvesos(F,[],ops,c);
    obj.params.err = sol.problem;

    %% Results
    % Obtained coefficients of polynomial Lyapunov Function
    cc=value(c);

    % dV(x)/dt
    V = sdisplay(cc'*Vm);
    internal = obj.x;
    V = eval(V{1});
    dV = jacobian(V)*obj.f_m(obj.x,obj.xi);
    dV = matlabFunction(dV, 'vars', {obj.x,obj.xi});
end