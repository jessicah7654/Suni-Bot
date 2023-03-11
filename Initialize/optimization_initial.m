function x = optimization_initial()
    %x = initialize_torque_control_points;
    %x = initialize_wp_control_points();
    %x = initialize_frequency_phase();
    x = initialize_gains();
end

function x = initialize_time_chunks()
    x = [0 0 0 0 0 0 0];
end

function x = initialize_gains()
    %x = [0 0 0 0 0 0];
    x = [3.6471    4.1360   28.9373    5.7780    2.1909    1.5832];

end

function x = initialize_torque_control_points()
    shoulder_ctrl_pts = [0 0 0 0 0];
    waist_ctrl_pts = [0 0 0 0 0];
    x = [shoulder_ctrl_pts, waist_ctrl_pts];
end

function x = initialize_wp_control_points()
    frequency_ctrl_pts = [58.0011 41.7507 55.8290 40.8302 36.1025 52.1598 57.8050 53.1692];
    phase_ctrl_pts = [0.1539 0.0804 -0.0807 0.1556 0.1525 -0.0694 -0.1721 0.1218];
%     frequency_ctrl_pts = [40.3675   37.4171   44.3005   39.6899];
%     phase_ctrl_pts = [0.1337    0.0716    0.0967    0.1718];
    x = [frequency_ctrl_pts, phase_ctrl_pts];
end

function x = initialize_frequency_phase()
    w = 10;
    p = 10;
    x = [w p];
end