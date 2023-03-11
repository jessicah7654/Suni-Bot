function t = max_end_pole_angle(z_out, p)
    % Maximize the q1 angle at the end of simulation
    z_final = z_out(:,end);
    t = z_final(1);
end