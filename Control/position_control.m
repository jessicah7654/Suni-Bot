function u = position_control(desired_angles, z)
    % Gains for position controller
    k_shoulder = 0.5;
    k_waist = 0.4;
    d_shoulder = 0.025;
    d_waist = 0.025;

    th2_des = deg2rad(desired_angles(1));
    th3_des = deg2rad(desired_angles(2));

    e_th2 = th2_des - z(2);
    e_th3 = th3_des - z(3);

    shoulder_t = k_shoulder*e_th2 - d_shoulder*z(5);
    waist_t = k_waist*e_th3 - d_waist*z(6);

    u = [shoulder_t waist_t]';
end
