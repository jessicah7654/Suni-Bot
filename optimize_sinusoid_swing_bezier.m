% Optimize frequency and phase shift control policy using simulated annealing
% for sinusoid swinging at fixed values

% Initialize parameters
max_angle = [50,50];     % Max joint angles
max_sim_time = 10;       % Duration of sim
p = model_parameters();
z0 = initial_conditions();
ctrl_pts = 5;

freq_pts = ones(1,ctrl_pts)*50;
phase_pts = zeros(1,ctrl_pts);
x0=[freq_pts phase_pts];

% Set Lower and Upper bounds on decision variables
min_freq_val = 0;
max_freq_val = 200;

min_phase_val = deg2rad(-180);
max_phase_val = deg2rad(180);

min_freq = ones(1,ctrl_pts)*min_freq_val;
min_phase = ones(1,ctrl_pts)*min_phase_val;
max_freq = ones(1,ctrl_pts)*max_freq_val;
max_phase = ones(1,ctrl_pts)*max_phase_val;

lb = [min_freq min_phase];
ub = [max_freq max_phase];

% Perform Optimization
x = anneal_optimize(x0, z0, p, lb, ub, max_angle, max_sim_time)
%x = fmincon_optimize(x0, z0, p, lb, ub, max_angle, max_sim_time)

% Save Solution
save_location = ['Results/SinusoidSwingBezier/optimal_control_sa' num2str(max_angle(1))... 
                                                            '_wa' num2str(max_angle(2))... 
                                                            '_pts' num2str(ctrl_pts)...
                                                            '_t' num2str(max_sim_time)];
save(save_location, 'x','max_sim_time','max_angle');