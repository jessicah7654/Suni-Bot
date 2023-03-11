function e = max_end_energy(z_out, p)
    % Maximize the total system energy at the end of simulation
    z_final = z_out(:,end);
    e = energy_gymnast(z_final,p);
end