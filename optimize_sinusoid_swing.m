% Optimize frequency and phase shift control policy using simulated annealing
% for sinusoid swinging at fixed values

% Initialize parameters
max_angle = [50,50];     % Max joint angles
max_sim_time = 10;       % Duration of sim
p = model_parameters();
z0 = initial_conditions();
x0=[0 0];

% Set Lower and Upper bounds on decision variables
min_freq = 0;
max_freq = 50;

min_phase = deg2rad(-180);
max_phase = deg2rad(180);

lb = [min_freq min_phase];
ub = [max_freq max_phase];

% Perform Optimization
x = anneal_optimize(x0, z0, p, lb, ub, max_angle, max_sim_time)

% Save Solution
save_location = ['Results/SinusoidSwing/optimal_control_sa' num2str(max_angle(1))... 
                                                      '_wa' num2str(max_angle(2))... 
                                                      '_t' num2str(max_sim_time)];
save(save_location, 'x','max_sim_time','max_angle');