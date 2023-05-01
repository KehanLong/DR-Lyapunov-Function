function [V,dV] = sosFormulater(obj)
    %% Input Check
    yalmip('clear')
    
    % 2d: Order of polynomial Lyapunov Function
    d=2;

    % variables
    x = sdpvar(obj.params.x_dim,1);

    % Polynomial Lyapunov Function of order 2d, c: coefficients, Vm: monomials
    [V,c,Vm] = polynomial(x,2*d);
    [L,cL,~] = polynomial(x,4);

    % dV(x)/dt
    dVdt = jacobian(V,x)*obj.f(x);

    % s1: SOS polynomial
    %[s1,c1] = polynomial([x1;x2;w],2*d);
    equi = [0;1;0;];

    % SOS Conditions:
    %V(0)=0--> c(1)==0
    %(strictly positive) V>0 for all (x notEqual 0) --->  V>=||x||^2 ---> V-||x||^2 in SOS
    %(strictly positive) -dVdt>0 for all w and (x notEqual 0) ---> -dVdt>=||x||^2 for all w--> -dVdt-||x||^2 -s1*(5-w)*(w-3) in SOS
    r = 0.1*((x-equi).'*(x-equi));
    V_equi = replace(V,x,equi);
    
    F = [sos(V-10*r),sos(-dVdt-L*(x(1).^2 + x(2).^2 - 1)-r*x(1).^2),V_equi == 0];

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