function [tspan, z_out, u_out, num_steps] = simulate(z0,x,p,max_sim_time,max_angle)
    tf = max_sim_time;
    dt = 0.001;
    t = 0;

    %% Perform Dynamic simulation    
    num_steps = floor(tf/dt);
    tspan = linspace(0, tf, num_steps); 
    z_out = zeros(6,num_steps);
    z_out(:,1) = z0;
    dz = [0,0,0,0,0,0]';
    u = control_law(x,z0,dz,p,t,tf,max_angle);
    u_out(:,1) = u;
    for i=1:num_steps-1
        t = i*dt;
        dz = dynamics(z_out(:,i), p, u);
        z_out(4:6,i+1) = z_out(4:6,i) + dz(4:6)*dt;
        z_out(1:3,i+1) = z_out(1:3,i) + z_out(4:6,i+1)*dt;
        u = control_law(x,z_out(:,i+1),dz,p,t,tf,max_angle);
        u_out(:,i+1) = u;
    end
end


function dz = dynamics(z,p,u)
    % Get mass matrix
    A = A_gymnast(z,p);
    
    % Get forces
    b = b_gymnast(z, u, p);

    % Joint limit forces
    T_c = joint_limit_torque(z,p);
    
    % Solve for qdd
    qdd = A\(b + T_c);
    dz = 0*z;
    
    % Form dz
    dz(1:3) = z(4:6);
    dz(4:6) = qdd;
end


function T_c = joint_limit_torque(z,p)
    % Fixed parameters for rotational spring damper at joint limit contact
    K = 0;
    D = 0;

    shoulder_th = z(2);    
    shoulder_dth = z(5);
    waist_th = z(3);
    waist_dth = z(6);

    shoulder_limits = [deg2rad(-10), deg2rad(90)];
    waist_limits = [deg2rad(-10), deg2rad(90)];

    T_c = [0; 0; 0];
    
    % Shoulder Constraints
    if  shoulder_th < shoulder_limits(1)
        e = shoulder_limits(1) - shoulder_th;
        T_c(2) = K*e - D*shoulder_dth;
    elseif shoulder_th > shoulder_limits(2)
        e = shoulder_limits(2) - shoulder_th;
        T_c(2) = K*e - D*shoulder_dth;
    end

    % Waist Constraints
    if waist_th < waist_limits(1)
        e = waist_limits(1) - waist_th;
        T_c(3) = K*e - D*waist_dth;
    elseif waist_th > waist_limits(2)
        e = waist_limits(2) - waist_th;
        T_c(3) = K*e - D*waist_dth;
    end

end