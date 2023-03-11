function x_long = control_values_bend_extend(x, tspan)
    time_chunks = length(x)-1;
    scaled_time = tspan/tspan(end);
    x_long = zeros(1,length(scaled_time));

    for i = 1:length(x_long)
        t = scaled_time(i);
        idx = floor(t*time_chunks)+1;
        desired = x(idx);
        x_long(i) = desired;
    end
end