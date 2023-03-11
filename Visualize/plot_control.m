function plot_control(tspan,u_out,x,plot_controller)
    yyaxis left
    plot(tspan, u_out)
    hold on

    % Controller Plots
    if plot_controller == 1         % Sinusoid Swinging Bezier
        yyaxis right
        [freq_values,phase_values] = control_values_sinusoid_swing_bezier(x, tspan);
        plot(tspan, freq_values);
        hold on
        plot(tspan, phase_values);
        legend('Tau Shoulder','Tau Waist','Frequency', "Phase");
    else if plot_controller == 2    % Bend Extend
        yyaxis right
        x_long = control_values_bend_extend(x, tspan);
        plot(tspan, x_long); 
        legend('Tau Shoulder','Tau Waist','Control Logic');
    end

    xlabel('Time (s)'); 
    ylabel('Torque');

end