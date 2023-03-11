function u = control_law(x,z,dz,p,t,tf,max_angle)
    %u = bezier_ctrl_point_control(x,z,p,t/tf);
    %u = spline_ctrl_point_control(x,z,p,t,tf);
    %u = periodic_swinging(z,p,t);
    %u = energy_pumping(z,p,t);
    %u = energy_shaping(x,z,dz,p,t);
    %u = direction_of_velocity(z,p,t);
    %u = bend_extend_independent(x,z,t/tf,max_angle);
    
    % These 3 are the ones in the "final cut"
    %u = sinusoid_swinging(x,z,t,max_angle);
     u = sinusoid_swinging_bezier(x,z,p,t/tf,max_angle);
    %u = bend_extend_together(x,z,t/tf,max_angle);


end

function u = bend_extend_together(x,z,t,max_angle)
    % Extract desired pose (extended/bent) at time t
    time_chunks = length(x)-1;
    idx = floor(t*time_chunks)+1;
    desired = x(idx);
    
    % Get max shoulder angles
    max_shoulder_angle = max_angle(1);
    max_waist_angle = max_angle(2);

    % Pose Controls
    if desired == 0
        th2_des = 0;
        th3_des = 0;
    end

    if desired == 1
        th2_des = max_shoulder_angle;
        th3_des = max_waist_angle;
    end

    u = position_control([th2_des th3_des], z);
end

function u = bend_extend_independent(x,z,t,max_angle)
    x_s = x(1:length(x)/2);
    x_w = x(length(x)/2+1:end);

    time_chunks = length(x_s)-1;
    idx = floor(t*time_chunks)+1;
    
    desired_s = x_s(idx);
    desired_w = x_w(idx);

    % Get max shoulder angles
    max_shoulder_angle = max_angle(1);
    max_waist_angle = max_angle(2);

    % Shoulder Controls
    if desired_s == 0
        th2_des = 0;
    end

    if desired_s == 1
        th2_des = max_shoulder_angle;
    end

    % Waist Controls
    if desired_w == 0
        th3_des = 0;
    end

    if desired_w == 1
        th3_des = max_waist_angle;
    end

    u = position_control([th2_des th3_des], z);
end

function u = sinusoid_swinging(x,z,t,max_angle)
    % Swing shoulders and waist with frequency w and p phase shift x(1) and
    % x(2) respectively. 

    shoulder_angle_max = max_angle(1);
    waist_angle_max = max_angle(2);

    w = x(1);
    p = x(2);

    th2_des = (shoulder_angle_max*sin(w*t))/2 + shoulder_angle_max/2;
    th3_des = (waist_angle_max*sin(w*t+p))/2 + waist_angle_max/2;

    u = position_control([th2_des th3_des], z);
end

function u = sinusoid_swinging_bezier(x,z,p,t,max_angle)
    % Swing shoulders and waist with frequency w and p phase shift x(1) and
    % x(2) respectively
    
    % Get joint limits
    shoulder_angle_max = max_angle(1);
    waist_angle_max = max_angle(2);    
    
    % Get control points
    frequency_ctrl_pts = x(1:length(x)/2);
    phase_ctrl_pts = x((length(x)/2)+1:end);

    % Calculate instantaneous frequency and phase control values
    w = BezierCurve(frequency_ctrl_pts, t);
    p = BezierCurve(phase_ctrl_pts, t);    

    % Calculate Desired Angles
    th2_des = (shoulder_angle_max*sin(w*t))/2 + shoulder_angle_max/2;
    th3_des = (waist_angle_max*sin(w*t+p))/2 + waist_angle_max/2;

    % Generate Control
    u = position_control([th2_des th3_des], z);

end

function u = direction_of_velocity(z,p,t);
    max_shoulder_t = 200;
    max_waist_t = 200;
    
    q1_dot = z(4);

    shoulder_t = sign(q1_dot)*max_shoulder_t;
    waist_t = sign(q1_dot)*max_waist_t;

    u = [shoulder_t waist_t]'
end

function u = energy_shaping(x,z,dz,p,t)
    % Gains
    k21 = x(1);
    k22 = x(2);
    k23 = x(3);

    k31 = x(4);
    k32 = x(5);
    k33 = x(6);

    % Mass Matrix
    M = A_gymnast(z,p);

    % Angles
    q1 = z(1);
    q2 = z(2);
    q3 = z(3);

    % Velocities
    q1_dot = z(4);
    q2_dot = z(5);
    q3_dot = z(6);

    % Energy
    Ec = energy_gymnast([deg2rad(180) 0 0 0 0 0]',p);
    E = energy_gymnast(z,p) - Ec;

    % U Bars
    u2_ = k23*sat(E*q1_dot,30);
    u3_ = k33*sat(E*q2_dot,30);

    % U
    u2 = -k21*q2 - k22*q2_dot + u2_;
    u3 = -k31*q3 - k32*q3_dot + u3_;

    % Accelerations
    q1_ddot = dz(4);
    q2_ddot = u2;
    q3_ddot = u3;

    % Motion Terms
    terms = motion_terms_gymnast(z,p);
    h_p_2 = terms(2);
    h_p_3 = terms(3);


    % Torques
    t2 = M(2,1)*q1_ddot + M(2,2)*q2_ddot + M(2,3)*q3_ddot + h_p_2;
    t3 = M(3,1)*q1_ddot + M(3,2)*q2_ddot + M(3,3)*q3_ddot + h_p_3;
    
    % Cap Torques
    t2 = min(max(t2,-40),50);
    t3 = min(max(t3,-40),50);

    u = [t2 t3]';
end

function b = sat(a,m)
    if abs(a) <= m
        b = a;
    else
        b = m * (a/abs(a));
    end
end

function u = bezier_ctrl_point_control(x,z,p,t)
    % Extract Shoulder and Waist Torque Ctrl Pts
    shoulder_ctrl_pts = x(1:length(x)/2);
    waist_ctrl_pts = x((length(x)/2)+1:end);
    
    shoulder_t = BezierCurve(shoulder_ctrl_pts, t);
    waist_t = BezierCurve(waist_ctrl_pts, t);

    u = [shoulder_t waist_t]';
end

function u = spline_ctrl_point_control(x,z,p,t,tf)
    % Extract Shoulder and Waist Torque Ctrl Pts
    shoulder_ctrl_pts = x(1:length(x)/2);
    waist_ctrl_pts = x((length(x)/2)+1:end);
    
    shoulder_t = SplineCurve(shoulder_ctrl_pts, t, tf);
    waist_t = SplineCurve(waist_ctrl_pts, t, tf);
    u = [shoulder_t waist_t]';
end

function u = periodic_swinging(z,p,t)
    tau_max = 15;
    if z(4)>0
        u = [0 tau_max]';
    else
        u = [0 -tau_max]';
    end
end

function u = energy_pumping(z,p,t)
    tau_shoulder_max = 15;
    tau_waist_max = 15;

    deriv = dqE_gymnast(z,p);
    d_shoulder = deriv(2);
    d_waist = deriv(3);

    shoulder_tau = ((sign(d_shoulder)*tau_shoulder_max)+tau_shoulder_max)/2;
    waist_tau = ((sign(d_waist)*tau_waist_max)+tau_waist_max)/2;


    u = [shoulder_tau waist_tau]';
end






