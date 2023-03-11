function h = max_pole_angle(z_out,p)
    % Maximize pole angle height achieved at any time during simulation
    max_angle = -99999;
    for i = 1:length(z_out)
        angle = z_out(1,i);
        max_angle = max(max_angle, angle);
    end
    h = max_angle;
end