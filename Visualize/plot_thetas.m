function plot_thetas(z_out,p,tspan,x,plot_controller)
    th1 = z_out(1,:);
    th2 = z_out(2,:);
    th3 = z_out(3,:);
    yyaxis left
    plot(tspan,th1);        % Theta 1
    hold on
    plot(tspan,th2);        % Theta 2
    hold on
    plot(tspan,th3);        % Theta 3
    hold on

    % Controller Plots
    if plot_controller == 1         % Sinusoid Swinging Bezier
        yyaxis right
        [freq_values,phase_values] = control_values_sinusoid_swing_bezier(x, tspan);
        plot(tspan, freq_values);
        hold on
        plot(tspan, phase_values);
        legend('Theta 1','Theta 2','Theta 3','Frequency', "Phase");
    else if plot_controller == 2    % Bend Extend
        yyaxis right
        x_long = control_values_bend_extend(x, tspan);
        plot(tspan, x_long); 
        legend('Theta 1','Theta 2','Theta 3','Control Logic');
    end

    xlabel('Time (s)'); 
    ylabel('Angle (rads)');
end