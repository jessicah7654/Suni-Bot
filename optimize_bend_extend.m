% Optimize discrete control policy using genetic algorithm solver
% and save solution to file

% Initialize parameters
max_angle = [90,90];    % Max angles of shoulder and waist joints respectively
max_sim_time = 3;       % Duration of sim
var_count = 30;         % Discrete time chunks to break sim time

p = model_parameters();
z0 = initial_conditions();

% Perform Optimization
x = genetic_optimize(z0, p, max_angle, max_sim_time, var_count)

% Save Solution
save_location = ['Results/BendExtend/optimal_control_sa' num2str(max_angle(1))... 
                                                   '_wa' num2str(max_angle(2))... 
                                                   '_x' num2str(var_count)...
                                                   '_t' num2str(max_sim_time)];
save(save_location,'x','max_sim_time','max_angle');
