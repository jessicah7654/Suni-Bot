function f = objective(x, z0, p, max_sim_time, max_angle)
    % Simulate
    [tspan, z_out, u_out, num_steps] = simulate(z0,x,p,max_sim_time,max_angle);
    
    % Calculate objective function
    f = -max_foot_height(z_out,p);
    %f = -max_end_foot_height(z_out, p);
    %f = -max_end_energy(z_out, p);
    %f = -max_end_pole_angle(z_out, p);
    %f = -max_pole_angle();
end