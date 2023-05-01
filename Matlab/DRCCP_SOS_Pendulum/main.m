clc;clear;

% Load parameters from Parameters.m file
params = Parameters;

% Define path to load training parameters
ca = 'case3';
path_train=['..\SOS_Lyapunov\',ca,'_samp_',num2str(params.xi_num),'_r_',num2str(params.theta)];
if ~exist(path_train, 'dir')
           mkdir(path_train)
end
if isfile(fullfile(path_train, [ca,'_samp_',num2str(params.xi_num),'.mat']))
    load(fullfile(path_train, [ca,'_samp_',num2str(params.xi_num),'.mat']));
    params.xi_trai = xi_trai_temp;
end

% Create LF formulations
[SOS,V_sos,dV_sos] = Formulation(params,'SOS');
[CCP,V_ccp,dV_ccp] = Formulation(params,'CCP');
[DRCCP,V_drccp,dV_drccp] = Formulation(params,'DRCCP');

if SOS.params.err == 0 && CCP.params.err == 0 && DRCCP.params.err == 0
    xi_trai_temp = params.xi_trai;
    
    % Create mesh grid
    [X,Y]=meshgrid([-2*pi:(4*pi/1000):2*pi],[-9:0.01:9]);
    [x_d,y_d] = size(X);
    vecX = reshape(X,[1,x_d*y_d]);
    vecY = reshape(Y,[1,x_d*y_d]);
    
    % SOS formulation plot
    Z_sos = dV_sos([sin(vecX);cos(vecX);vecY],params.xi_vali);
    val_sos = reshape(Z_sos,[x_d,y_d]);
    Vv_sos = V_sos(sin(vecX),cos(vecX),vecY);
    Vval_sos = reshape(Vv_sos,[x_d,y_d]);
    idx_V_sos = Vval_sos<=1e-6;
    
    %\dotV > 0 index
    idx_sos_p = val_sos>0;
    
    %\dotV > 0 value
    val_sos_p = val_sos.*idx_sos_p;
    %\dotV <= 0 value
    val_sos_n = val_sos.*~idx_sos_p;
    vio_sos_num = sum(idx_sos_p(:));
    vio_sos = vio_sos_num/(x_d*y_d)*100;
    vio_sos_dV_max = max(val_sos_p(:));
    figure(1);
    surf(X,Y,val_sos_n,'FaceAlpha',0.85,'EdgeColor','none','FaceLighting','phong');hold on;grid on;
    colorbar;
    cl = caxis;
    colorbar;
    s_sos = surf(X,Y,val_sos_p,'FaceColor','red','EdgeColor','none','FaceLighting','phong');hold off;
    s_sos.AlphaData = 0.85*idx_sos_p;
    s_sos.FaceAlpha = 'interp';
    caxis(cl);
    view(2);
    
    % CCP formulation plot
    figure(2);
    Z_ccp = dV_ccp([sin(vecX);cos(vecX);vecY],params.xi_vali);
    val_ccp = reshape(Z_ccp,[x_d,y_d]);
    Vv_ccp = V_ccp(sin(vecX),cos(vecX),vecY);
    Vval_ccp = reshape(Vv_ccp,[x_d,y_d]);
    idx_V_ccp = Vval_ccp<=1e-6;
    idx_ccp_p = val_ccp>0;
    val_ccp_p = val_ccp.*idx_ccp_p;
    val_ccp_n = val_ccp.*~idx_ccp_p;
    vio_ccp_num = sum(idx_ccp_p(:));
    vio_ccp = vio_ccp_num/(x_d*y_d)*100;
    vio_ccp_dV_max = max(val_ccp_p(:));
    
    % plot \dotV <= 0 part
    surf(X,Y,val_ccp_n,'FaceAlpha',0.85,'EdgeColor','none','FaceLighting','phong');hold on;grid on;
    colorbar;
    cl = caxis;
    colorbar;
    
    % plot \dotV > 0 part
    s_ccp = surf(X,Y,val_ccp_p,'FaceColor','red','EdgeColor','none','FaceLighting','phong');hold off;
    s_ccp.AlphaData = 0.85*idx_ccp_p;
    s_ccp.FaceAlpha = 'interp';
    caxis(cl);
    view(2);
    
    % DRCCP formulation plot
    figure(3);
    Z_drccp = dV_drccp([sin(vecX);cos(vecX);vecY],params.xi_vali);
    val_drccp = reshape(Z_drccp,[x_d,y_d]);
    Vv_drccp = V_drccp(sin(vecX),cos(vecX),vecY);
    Vval_drccp = reshape(Vv_drccp,[x_d,y_d]);
    idx_V_drccp = Vval_drccp<=1e-6;
    idx_drccp_p = val_drccp>0;
    val_drccp_p = val_drccp.*idx_drccp_p;
    val_drccp_n = val_drccp.*~idx_drccp_p;
    vio_drccp_num = sum(idx_drccp_p(:));
    vio_drccp = vio_drccp_num/(x_d*y_d)*100;
    vio_drccp_dV_max = max(val_drccp_p(:));
    surf(X,Y,val_drccp_n,'FaceAlpha',0.85,'EdgeColor','none','FaceLighting','phong');hold on;grid on;
    colorbar;
    cl = caxis;
    colorbar;
    s_drccp = surf(X,Y,val_drccp_p,'FaceColor','red','EdgeColor','none','FaceLighting','phong');hold off;
    s_drccp.AlphaData = 0.85*idx_drccp_p;
    s_drccp.FaceAlpha = 'interp';
    caxis(cl);
    view(2); 
    
    % Create folder and save results
    path_data = '..\SOS_Lyapunov\plot_py';
    if ~exist(path_data, 'dir')
           mkdir(path_data)
    end
    val = [];
    val = val_sos;
    save(fullfile(path_data,['vdot_sos_',ca,'.mat']),'val');
    val = [];
    val = val_ccp;
    save(fullfile(path_data,['vdot_ccp_',ca,'.mat']),'val');
    val = [];
    val = val_drccp;
    save(fullfile(path_data,['vdot_drccp_',ca,'.mat']),'val');
else
    return
end