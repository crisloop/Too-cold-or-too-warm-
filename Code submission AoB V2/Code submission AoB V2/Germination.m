disp('Computing germination fraction')

% Known parameters
alph_g = 0.31; % maximum germination fraction
T_opt  = 18; 

% Naming variables
for i=1:4
    temperature{i} = data{i}(:,1);    
    germination{i} = data{i}(:,5);
end
% outlier removal for 34 degrees celcius at D=6 days ->  
% temperature{4}(5:6)=[]; germination{4}(5:6)=[];


%% Fit parameter p_v for each duration and plot germination vs temperature 
figure; 
color1        = {'g','r','k','m', 'g*','r*','k*','m*'};
p0            = 0;                  % initial parameter value in fmincon  
lb            =-100;                % lower bound for search in fmincon
ub            = 100;                % upper bound for search in fmincon
minerror      = zeros(1,4);   
p_opt         = zeros(1,4);  

% loop over 4 durations, for each duration eq A9 is fitted by treating
% p_v as a constant. This yields 4 p_v values
for j=1:4     
    % fit polynomial with boundary conditions    
    xdata    = temperature{j}; 
    ydata    = germination{j};
   
    y         = @(x,p) max(p+2*(alph_g-p)/T_opt.*x +(p-alph_g)/T_opt^2.*x.^2,0); % model with fixed p    
    fiterror  = @(x,ydata,p) mean((y(x,p)-ydata).^2);

    [p_opt(j),minerror(j),~] = fmincon( @(p) fiterror(xdata,ydata,p),p0,[],[],[],[],lb,ub,[], optimpar);   
    
    x_cont    = 12:0.1:37;           % high-resolution range of temperature
    y_fit     = y(x_cont,p_opt(j));  % germination curve fitted to data for each duration
    
    % Plot p_g vs T 
    plot(x_cont,y_fit,color1{j}); hold on; plot(xdata,ydata,color1{j+4}); xlabel('Temperature (^o C)','FontSize',18); ylabel('germination (-)','FontSize',18);
end
legend('fit duration 1 day','data duration 1 day', 'fit duration 3 days','data duration 3 days', 'fit duration 4 days','data duration 4 days', 'fit duration 6 days','data duration 6 days');



%% Interpolate p_g values to p_g(D) and plot resulting function p_g(D) (figure A4)
% the 4 p_g values, together with 4 durations, are used to fit a function p_g(D) 

% Interpolation p_g(D)
dur           = [1 3 4 6];               % durations from data 
dur_cont      = dur(1):0.1:dur(end)+0.2; % high resolution duration
ydata         = p_opt;                   % p vector from previous fit

p0            = [-1 -1];                 % initial parameter value in fmincon  
lb            =-[10 10]; 
ub            = [10 10];
y             = @(x,p) p(1)+p(2)*x.^2;   
fiterror2     = @(x,ydata,p) sqrt(mean((y(x,p)-ydata).^2));

[theta_g, ~,~] = fmincon( @(p) fiterror2(dur,ydata,p), p0,[],[],[],[],lb,ub,[], optimpar);

p_interp      = theta_g(1)+dur_cont.^2*theta_g(2); %p = p(duration)

% Plot D vs p_g(D)
figure;
plot(dur,p_opt,'*', dur_cont,p_interp,'--');
xlabel('Duration (days)','FontSize',18); 
ylabel('Parameter{\it p} estimation for germination','FontSize',18);

%% f_germPollen and 3d plot f_germination vs temp vs duration 

% f_germPollen
p_g            = @(d) d.^2*theta_g(2)+theta_g(1);  %p=p(duration)
f_germPollen   = @(x,d) max(p_g(d)+2*(alph_g-p_g(d))/T_opt.*x +(p_g(d)-alph_g)/T_opt^2.*x.^2,0); % equation 3

% 3d plot f_germination vs temp vs duration 
figure;
germ=zeros(length(dur_cont)-1,length(x_cont));
for i=1:length(dur_cont)-1
    for j=1: length(x_cont)
        germ(i,j)= f_germPollen(x_cont(j),dur_cont(i)); % predicted germination
    end
end

[X,Y] = meshgrid(dur_cont(1):dur_cont(2)-dur_cont(1):dur_cont(end),x_cont(1):x_cont(2)-x_cont(1):x_cont(end));

se    = 0; 
count = 0;
surf(X,Y,germ'); hold on; % plot predicted germination
for j = 1:4
    for i = 1:length(temperature{j})
        plot3(dur(j),temperature{j}(i),germination{j}(i),color1{5},'LineWidth',3); hold on % plot data
        se    = se+(germination{j}(i)-f_germPollen(temperature{j}(i),dur(j)))^2; % compute rmse
        count = count+1;
    end
end
xlabel('Duration (days)','FontSize',16); ylabel('Temperature (^o C)','FontSize',16); zlabel('germination [-]','FontSize',18)

%% Plot top view of 3d plot (figure 4B) and RMSE and R2

figure;
% X(1,:) = duration    1x52
% Y(:,1) = temperature 251x1
% germ   = (temp,dur)  251x52

% Adjust the predicted germination surface at locations where data is
% available, to show data and model predictions together on one surface
for j = 1:4
    for i = 1:length(temperature{j}) 
       [c1 indextemp(i)] = min(abs(Y(:,1)-temperature{j}(i))); % temperature index
       [c2 indexdur(j)]  = min(abs(X(1,:)-dur(j)));            % duration index       
       germ(indexdur(j), indextemp(i)-3:indextemp(i)+3) = germination{j}(i); % adjust germ surface with 3x3 squares    
    end
end
s = surf(X,Y,germ'); hold on;
view(2); s.EdgeColor = 'none'; colorbar;
for j = 1:4
    for i = 1:length(temperature{j}) 
        plot3(dur(j)+0.05,temperature{j}(i),10,'square','LineWidth',1, 'Color','k','MarkerSize',18); hold on
    end
end

c                = colorbar; 
c.Label.String   = 'germination (-)'; 
c.Label.FontSize = 16;   % sets the label font size
xlabel('Duration (days)','FontSize',16); 
ylabel('Temperature (^o C)','FontSize',16);
xlim([1 6.1]); 
ylim([12 37]);

% Make axis tick labels bigger
ax                = gca;  % get current axes handle
ax.XAxis.FontSize = 14;   % x-axis numbers
ax.YAxis.FontSize = 14;   % y-axis numbers

%%% Compute RMSE
rmse=sqrt(se/count);


%%% Compute R2  
% Initialize total sums
SS_res_total = 0;
SS_tot_total = 0;
all_y_obs    = []; % Collect all observed values
all_y_pred   = []; % Collect all predicted values

for j = 1:4
    x      = temperature{j}; % Observed temperature
    y_obs  = germination{j};   % Observed germination
    y_pred = f_germPollen(x,dur(j));
    
    % Store values 
    all_y_obs  = [all_y_obs; y_obs];
    all_y_pred = [all_y_pred; y_pred];
end

% Compute SS_res and SS_tot for the whole dataset
SS_res_total = sum((all_y_obs - all_y_pred).^2); % Residual sum of squares
SS_tot_total = sum((all_y_obs - mean(all_y_obs)).^2); % Total sum of squares

% Compute overall R²
R2_total     = 1 - (SS_res_total / SS_tot_total);

% Display the result
disp(['RMSE f_germPollen                        = ' num2str(rmse,2)]);
disp(['R² value f_germPollen                    = ' num2str(R2_total,2)]);
disp(' ')










