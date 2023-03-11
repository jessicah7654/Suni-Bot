function plot_energy(z_out,p,tspan)
    E = energy_gymnast(z_out,p);
    T = energy_Kinetic_gymnast(z_out,p);
    V = energy_Potential_gymnast(z_out,p);
    plot(tspan,T);
    hold on
    plot(tspan,V);
    hold on
    plot(tspan,E);
    xlabel('Time (s)'); 
    ylabel('Energy (J)');
    legend('Kinetic Energy','Potential Energy','Total Energy');
end