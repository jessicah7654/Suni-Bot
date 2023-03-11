function h = max_foot_height(z_out,p)
    % Maximize foot height achieved at any time during simulation
    max_height = -99999;
    full_len = p(1) + p(2) + p(3);
    for i = 1:length(z_out)
        z = z_out(:,i);
        keypoints = keypoints_gymnast(z,p);             % Get key points
        r_feet = keypoints(:,3);                        % Specifically feet
        foot_h = (r_feet(2)+full_len)*sign(z(1));       % Height of foot * sign of angle to encourage forward swinging
        max_height = max(max_height, foot_h);
    end
    h = max_height;
end