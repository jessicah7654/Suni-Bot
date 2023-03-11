function [freq_values, phase_values] = control_values_sinusoid_swing_bezier(x, tspan)

    scaled_time = tspan/tspan(end);

    frequency_ctrl_pts = x(1:length(x)/2);
    phase_ctrl_pts = x((length(x)/2)+1:end);
    
    freq_values = zeros(1,length(scaled_time));
    phase_values = zeros(1,length(scaled_time));

    for i = 1:length(scaled_time)
        t = scaled_time(i);
        w = BezierCurve(frequency_ctrl_pts, t);
        p = BezierCurve(phase_ctrl_pts, t);   
        freq_values(i) = w;
        phase_values(i) = p;
    end