function h = max_end_foot_height(z_out, p)
    % Maximize foot height at the end of the simulation
    z_final = z_out(:,end);
    keypoints = keypoints_gymnast(z_final,p);   % Get key points
    r_feet = keypoints(:,3);                    % Specifically feet
    h = sign(r_feet(2))*r_feet(2)^2;                              % y coordinate
end