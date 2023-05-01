function [V,dV] = drccpFormulater(obj)
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
    d_x = obj.d(x);
    
    equi = [0;1;0;];
    r = 0.1*((x-equi).'*(x-equi));
    V_equi = replace(V,x,equi);
    
    xi_trai = obj.params.xi_trai;
    %xi_trai = obj.params.trai_gain*random(obj.params.trai.type,obj.params.trai_para_1,obj.params.trai_para_2,[obj.params.xi_dim, obj.params.xi_num]) + obj.params.trai_offset;
    %xi_trai = 2:0.25:4;
    
    %ca21 = [2.5*ones(1,3),3*ones(1,3),3.5*ones(1,3)];
    %ca22 = kron(ones(1,3),[1.5,2,2.5]);
    %xi_trai = [ca21;ca22];
    
    constraints = dV_x*(kron(ones(1,obj.params.xi_num),obj.f(x)) + obj.d(x)*xi_trai);
    
    F = [sos(V-10*r), V_equi == 0];
    
    for j = 1:obj.params.xi_dim
        for i = 1:obj.params.xi_num
            F = [F,sos(-obj.params.theta*dV_x*d_x(:,j)-constraints(1,i)-L*(x(1).^2 + x(2).^2 - 1)-r*x(1).^2)...
                ,sos(obj.params.theta*dV_x*d_x(:,j)-constraints(1,i)-L*(x(1).^2 + x(2).^2 - 1)-r*x(1).^2)];
        end
    end
    
    %SDP solver
    ops = sdpsettings('solver','mosek','verbose',2,'debug',1);

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