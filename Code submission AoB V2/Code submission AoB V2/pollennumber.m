 
disp('Computing pollen number')
%% Read data_pol for parameter optimization
data_pol= xlsread('pollennumber.xlsx','1');

%% Read data_pol for plotting the experimental data_pol
data_pol2= xlsread('pollennumber_2.xlsx','1'); % This data_pol is arranged to display the SEM 

%% Calculating sem_N_p
% Calculate the mean_N_p and sem_N_p for each treatment
mean_N_p        = mean(data_pol2);
sem_N_p         = std(data_pol2) / sqrt(size(data_pol2, 1)); % size(data_pol, 1) returns the number of rows
Tdata_pol2      = [14 18 30 34];                             % temperatures in data_pol set 

% Display the results (uncomment to display)
% disp(['Treatment 1: Mean = ' num2str(mean_N_p(1),2) ', SEM = ' num2str(sem_N_p(1),2)]);
% disp(['Treatment 2: Mean = ' num2str(mean_N_p(2),2) ', SEM = ' num2str(sem_N_p(2),2)]);
% disp(['Treatment 3: Mean = ' num2str(mean_N_p(3),2) ', SEM = ' num2str(sem_N_p(3),2)]);
% disp(['Treatment 4: Mean = ' num2str(mean_N_p(4),2) ', SEM = ' num2str(sem_N_p(4),2)]);

%% Parameter optimization
T_data_pol   = data_pol(:,1); % temperature data_pol 
N_p_data_pol = data_pol(:,3); % pollen number data_pol

% Known parameters
mu         = 5;          % shape parameter (selected a priori)
Tb         = 13;         % base temperature
Tc         = 48;         % ceiling temperature
T0         = 1;          % scaling temperature (1 degree celcius)
T_opt      = 18;         % optimal temperature
N_p_star   = 66056;      % number of pollen observed at optimal temperature 

% Calculated parameters
d(1) = (T_opt-Tb)/T0; 
d(2) = (Tc-T_opt)/T0; 
d(3) = (d(1)/d(2));

beta_N_p    = (log(N_p_star)-mu)./(d(3)*log(d(1))+log(d(2)));            % eq A5
N_p         = @(x) exp(mu).*(x-Tb).^(beta_N_p*d(3)).*(Tc-x).^(beta_N_p); % eq A4


%% Plotting FIGURE 3 
figure;
T_range     = Tb:Tc; % plotted temperature range

% plot experimental data_pol
errorbar(Tdata_pol2, mean_N_p, sem_N_p, 'ob', 'MarkerSize', 8, 'MarkerFaceColor', 'blue', 'LineWidth', 1);
hold on;

% plot model predictions
plot(T_range,N_p(T_range),'-r', "MarkerFaceColor","r", 'LineWidth', 2.5);

xlabel('Temperature (°C)', 'FontSize', 16);
ylabel('Pollen number per flower', 'FontSize', 16);

%% Compute RMSE
all_y_obs  = N_p_data_pol;
all_y_pred = N_p(T_data_pol);
err        = all_y_obs - all_y_pred; % model error
rmse       = sqrt(mean( (err).^2 ));

all_y_pred_avg = N_p(Tdata_pol2);
err_avg        = mean_N_p - all_y_pred_avg; % model error over average 
rmse_avg       = sqrt(mean( (err_avg).^2 ));


%% Compute R2

% Compute SS_res and SS_tot for the whole dataset
SS_res_total = sum((err).^2);                         % Residual sum of squares
SS_tot_total = sum((all_y_obs - mean(all_y_obs)).^2); % Total sum of squares

% Compute R²
R2_total     = 1 - (SS_res_total / SS_tot_total);

% Compute SS_res and SS_tot for average observations
SS_res_total = sum((err_avg).^2);                         % Residual sum of squares
SS_tot_total = sum((all_y_pred_avg - mean(all_y_pred_avg)).^2); % Total sum of squares

% Compute R² over averages
R2_total_avg     = 1 - (SS_res_total / SS_tot_total);


% Display the result
disp(['RMSE N_pollen                            = ' num2str(rmse,2)]);
disp(['RMSE N_pollen over mean observations     = ' num2str(rmse_avg,2)]);
disp(['R² value N_Pollen                        = ' num2str(R2_total,2)]);
disp(['R² value N_Pollen over mean observations = ' num2str(R2_total_avg,2)]);
disp(' ');








