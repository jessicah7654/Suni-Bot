% Play solution provided

% Initialize parameters
p = model_parameters();
z0 = initial_conditions();
solution = load('Results/SinusoidSwingBezier/optimal_control_sa50_wa50_pts5_t10.mat');
% x = solution.x;
% max_sim_time = solution.max_sim_time;           % Duration of sim
% max_angle = solution.max_angle;                 % Max angles of shoulder and waist joints respectively

x = [20 5 0 0];
max_sim_time = 2;                             % Duration of sim
max_angle = [80,80];                           % Max angles of shoulder and waist joints respectively


% Simulate
[tspan, z_out, u_out, num_steps] = simulate(z0,x,p,max_sim_time,max_angle);

% Animate Solution
figure(1); clf;
animate(z_out, tspan, p, num_steps)

% Plot Control
figure(2); clf;
plot_control(tspan,u_out,x,1)

% Plot Energy
figure(3); clf;
plot_energy(z_out,p,tspan)

% Plot Thetas
figure(4); clf;
plot_thetas(z_out,p,tspan,x,1)

% Plot Omegas
figure(5); clf;
plot_omegas(z_out,p,tspan,x,1)

% Plot COM
figure(6); clf;
plot_com(z_out,p)