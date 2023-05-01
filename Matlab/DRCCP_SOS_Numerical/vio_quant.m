clear all; close all;

params = Parameters;

ca = 'case2_samp_';
rad = '_r_';
path_train=['..\SOS_Lyapunov\',ca,num2str(params.xi_num),rad,num2str(params.theta)];
if ~exist(path_train, 'dir')
    mkdir(path_train)
end
if isfile(fullfile(path_train, [ca,num2str(params.xi_num),'.mat']))
    load(fullfile(path_train, [ca,num2str(params.xi_num),'.mat']));
    params.xi_trai = xi_trai_temp;
end

[SOS,dV_sos] = Formulation(params,'SOS');
[CCP,dV_ccp] = Formulation(params,'CCP');
[DRCCP,dV_drccp] = Formulation(params,'DRCCP');

[X,Y]=meshgrid([-2:0.01:2],[-2:0.01:2]);
[x_d,y_d] = size(X);
vecX = reshape(X,[1,x_d*y_d]);
vecY = reshape(Y,[1,x_d*y_d]);

xi_temp = params.xi_vali_test;

% Test the training result with 5000 random generated validation
% uncertainty parameters
for k = 1:length(xi_temp)
    xi_vali = xi_temp(:,k);
    
    % Check if there exists any \dotV > 0 in all three formulations on our
    % test points
    Z_sos = dV_sos([vecX;vecY],xi_vali);
    val_sos = reshape(Z_sos,[x_d,y_d]);
    vio.val_sos_max(k) = max(max(val_sos));
    idx_sos_p = val_sos>0;
    vio_sos_num = sum(idx_sos_p(:));
    if vio_sos_num ~= 0
        vio.sos_idx(k) = 1;
        vio.sos_num(k) = vio_sos_num;
    else
        vio.sos_idx(k) = 0;
        vio.sos_num(k) = vio_sos_num;
    end

    Z_ccp = dV_ccp([vecX;vecY],xi_vali);
    val_ccp = reshape(Z_ccp,[x_d,y_d]);
    vio.val_ccp_max(k) = max(max(val_ccp));
    idx_ccp_p = val_ccp>0;
    vio_ccp_num = sum(idx_ccp_p(:));
    if vio_ccp_num ~= 0
        vio.ccp_idx(k) = 1;
        vio.ccp_num(k) = vio_ccp_num;
    else
        vio.ccp_idx(k) = 0;
        vio.ccp_num(k) = vio_ccp_num;
    end

    Z_drccp = dV_drccp([vecX;vecY],xi_vali);
    val_drccp = reshape(Z_drccp,[x_d,y_d]);
    vio.val_drccp_max(k) = max(max(val_drccp));
    idx_drccp_p = val_drccp>0;
    vio_drccp_num = sum(idx_drccp_p(:));
    if vio_drccp_num ~= 0
        vio.drccp_idx(k) = 1;
        vio.drccp_num(k) = vio_drccp_num;
    else
        vio.drccp_idx(k) = 0;
        vio.drccp_num(k) = vio_drccp_num;
    end
end

% Sum up violation results
vio.sos_rate = sum(vio.sos_idx)/5000;
vio.ccp_rate = sum(vio.ccp_idx)/5000;
vio.drccp_rate = sum(vio.drccp_idx)/5000;

vio.sos_area = sum(vio.sos_num)/5000/(x_d*y_d);
vio.ccp_area = sum(vio.ccp_num)/5000/(x_d*y_d);
vio.drccp_area = sum(vio.drccp_num)/5000/(x_d*y_d);

vio.sos_max = sum(vio.val_sos_max)/5000;
vio.ccp_max = sum(vio.val_ccp_max)/5000;
vio.drccp_max = sum(vio.val_drccp_max)/5000;

save(fullfile(path_train,'vio.mat'),'vio');
