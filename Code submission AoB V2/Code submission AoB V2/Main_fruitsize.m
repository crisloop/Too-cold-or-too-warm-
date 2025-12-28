
%%%% Main file %%%%%%%%%%%%%

clearvars; close all; clc;

%% Data import and restructuring
M_data_fw_raw = xlsread('fruitweight.xlsx','1');                              % data set fruit weight
u_exp         = [14 4; 14 6; 14 8; 18 0; 30 1; 30 3; 30 4; 34 1; 34 3; 34 4]; % data [T D]

T_data_fw = u_exp(:,1);
D_data_fw = u_exp(:,2);

for j = 1:10
    M_data_fw{j} = M_data_fw_raw(:,j);
end

M_data_fw{4}(5:6) = []; % remove NaN 


%% Functions
% inputs are T (temperature [oC]) and D (duration [days])

% Pollen number
pollennumber % out: N_p(T)

% Viability fraction
Viability    % out: f_viablePollen (T,D)

% Germinated fraction
Germination  % out: f_germPollen (T,D)

% Viable pollen number N_v
N_v =@(T,D) N_p(T).*f_viablePollen(T,D);

% Germinated pollen number N_g
N_g = @(T,D) N_v(T,D).*f_germPollen(T,D);

% Seed number N_s
N_s = @(T,D) 0.0016.*N_g(T,D)+2.2351;

% Fruit weight M_fruit
M_fruit =@(x,d) 0.0785.*N_s(x,d)+2.063;

%% Simulation Fig 6, Pearson plot and RMSE
Temp_range = 12:0.1:37;
Dur_range  = 0 :0.1:6;   % continuous duration

Y_Fmodel  = zeros(1,size(u_exp,1));
for i = 1:10 % number of treatments
    Y_Fmodel(1,i) = M_fruit(u_exp(i,1),u_exp(i,2));
end
figure;
boxplot(M_data_fw_raw); hold on
plot(Y_Fmodel,'*');
legend('model predictions');
xtickangle(45); 
xticklabels({['14' char(176) 'C 4 days'], ['14' char(176) 'C 6 days'],['14' char(176) 'C 8 days'],['18' char(176) 'C constant'],['30' char(176) 'C 1 day'],...
    ['30' char(176) 'C 3 days'], ['30' char(176) 'C 4 days'], ['34' char(176) 'C 1 day'], ['34' char(176) 'C 3 days'], ['34' char(176) 'C 4 days']});
xlabel('Treatment','FontSize',16); ylabel('Fruit mass (g)','FontSize',16);

% Pearson correlation plot
figure; 
plot(Y_Fmodel,M_data_fw_raw,'*'); hold on
plot([0 5],[0,5]);
title('Pearson correlation'); xlabel('Model'); ylabel('Data'); axis([0 5 0 5]);


%% R2
% Initialize total sums
SS_res_total = 0;
SS_tot_total = 0;
all_y_obs    = []; % Collect all observed values
all_y_pred   = []; % Collect all predicted values

for j = 1:10
    y_obs  = M_data_fw{j};   % Observed fruit weight
    y_pred = Y_Fmodel(1,j)*ones(size(y_obs));
    
    % Store values 
    all_y_obs  = [all_y_obs; y_obs];
    all_y_pred = [all_y_pred; y_pred];
end

% Compute SS_res and SS_tot for the whole dataset
SS_res_total = sum((all_y_obs - all_y_pred).^2); % Residual sum of squares
SS_tot_total = sum((all_y_obs - mean(all_y_obs)).^2); % Total sum of squares

% Compute overall R²
R2_total     = 1 - (SS_res_total / SS_tot_total);

%%% RMSE
err  = all_y_obs - all_y_pred;
rmse = sqrt(mean(err.^2));


%% R2 average
% Initialize total sums
SS_res_total = 0;
SS_tot_total = 0;
all_y_obs    = []; % Collect all observed values
all_y_pred   = []; % Collect all predicted values

for j = 1:10
    y_obs  = mean(M_data_fw{j});   % Observed fruit weight
    y_pred = Y_Fmodel(1,j);
    
    % Store values 
    all_y_obs  = [all_y_obs; y_obs];
    all_y_pred = [all_y_pred; y_pred];
end

% Compute SS_res and SS_tot for the whole dataset
SS_res_total = sum((all_y_obs - all_y_pred).^2); % Residual sum of squares
SS_tot_total = sum((all_y_obs - mean(all_y_obs)).^2); % Total sum of squares

% Compute overall R²
R2_total_avg     = 1 - (SS_res_total / SS_tot_total);


%%% RMSE average
err_avg  = all_y_obs - all_y_pred;
rmse_avg = sqrt(mean(err_avg.^2));


% Display the result
disp(['R² value M_fruit                        = ' num2str(R2_total,2)]);
disp(['R² value M_fruit over mean observations = ' num2str(R2_total_avg,2)]);
disp(['RMSE M_fruit                            = ' num2str(rmse,2) ' g {fresh weight per fruit}']);
disp(['RMSE M_fruit over mean observations     = ' num2str(rmse_avg,2) ' g {fresh weight per fruit}']);



