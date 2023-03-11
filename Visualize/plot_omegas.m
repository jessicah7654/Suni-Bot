function plot_omegas(z_out,p,tspan,x,plot_controller)
    w1 = z_out(4,:);
    w2 = z_out(5,:);
    w3 = z_out(6,:);
    yyaxis left
    plot(tspan,w1);     % Angular Velocity theta 1
    hold on
    plot(tspan,w2);     % Angular Velocity theta 2
    hold on
    plot(tspan,w3);     % Angular Velocity theta 3
    hold on

    % Controller Plots
    if plot_controller == 1         % Sinusoid Swinging Bezier
        yyaxis right
        [freq_values,phase_values] = control_values_sinusoid_swing_bezier(x, tspan);
        plot(tspan, freq_values);
        hold on
        plot(tspan, phase_values);
        legend('w 1','w 2','w 3','Frequency', "Phase");
    else if plot_controller == 2    % Bend Extend
        yyaxis right
        x_long = control_values_bend_extend(x, tspan);
        plot(tspan, x_long); 
        legend('w 1','w 2','w 3','Control Logic');
    end

    xlabel('Time (s)'); 
    ylabel('Angular Velocity (rads/s)');
end