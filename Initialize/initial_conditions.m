function z0 = initial_conditions()
    % Initial Conditions
    th_1 = deg2rad(5);
    th_2 = deg2rad(5);
    th_3 = deg2rad(5);

    dth_1 = 0;
    dth_2 = 0;
    dth_3 = 0;

    z0 = [th_1; th_2; th_3; dth_1; dth_2; dth_3];
end