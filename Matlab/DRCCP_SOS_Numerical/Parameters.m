function params = Parameters
    %% Uncertainty Parameters Case 1
    %params.xi_dim = 2;
    %params.xi_num = 9;
    %theta =2.5/params.xi_num;
    
    %params.theta = theta*params.xi_num;
    
    % Uncertainty parameters for plot
    %params.xi_vali(1,:) = 0.6;
    %params.xi_vali(2,:) = 1.8;
    
    % Uncertainty parameters for violation test
    % Uniform
    %params.xi_vali_test(1,:) = random('Uniform',1,4,[1,5000]);
    %params.xi_vali_test(2,:) = random('Uniform',1,2,[1,5000]);
    % Gaussian
    %params.xi_vali_test(1,:) = random('Normal',4,1.5,[1,5000]);
    %params.xi_vali_test(2,:) = random('Normal',1,1.5,[1,5000]);
    
    %% Uncertainty Parameters Case 2
    params.xi_dim = 2;
    params.xi_num = 9;
    theta =1.5/params.xi_num;
    
    params.theta = theta*params.xi_num;
    
    % Uncertainty parameters for plot
    params.xi_vali(1,:) = 1.9;
    params.xi_vali(2,:) = 3.0;
    
    % Uncertainty parameters for violation test
    % Uniform
    params.xi_vali_test(1,:) = random('Uniform',5,7,[1,5000]);
    params.xi_vali_test(2,:) = random('Uniform',-1,1,[1,5000]);
    % Gaussian
    %params.xi_vali_test(1,:) = random('Normal',7,1,[1,5000]);
    %params.xi_vali_test(2,:) = random('Normal',1,1,[1,5000]);
end