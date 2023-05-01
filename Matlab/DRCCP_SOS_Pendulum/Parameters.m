function params = Parameters
    %% Uncertainty Parameters
    params.xi_dim = 2;
    params.xi_num = 3;
    params.var = 1;
    theta =0.3/params.xi_num;
    
    params.theta = theta*params.xi_num;
    
    % case3
    %params.xi_trai(1,:) = random('Normal',0,params.var,[1,params.xi_num]);
    %params.xi_trai(2,:) = random('Normal',0,params.var,[1,params.xi_num]);
    %params.xi_trai(3,:) = random('Normal',0,1,[1,params.xi_num]);
   
    % case 3, samp 3, r = 0.3, var = 1 and 0.1
    params.xi_vali(1,:) = -3.6;
    params.xi_vali(2,:) = 1.4;
    params.xi_vali_test(1,:) = random('Normal',1,2,[1,5000]);
    params.xi_vali_test(2,:) = random('Normal',1,2,[1,5000]);
    % case 3, samp 9, r = 0.3, var = 1
    %params.xi_vali(1,:) = -5.9;
    %params.xi_vali(2,:) = -0.9;
    %params.xi_vali_test(1,:) = random('Normal',1,2,[1,5000]);
    %params.xi_vali_test(2,:) = random('Normal',1,2,[1,5000]);
    % case 3, samp 9, r = 0.3, var = 0.1
    %params.xi_vali(1,:) = -4;
    %params.xi_vali(2,:) = 1.4;
    %params.xi_vali(3,:) = 2.4;
end