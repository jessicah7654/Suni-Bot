function x = genetic_optimize(z0, p, max_angle, max_sim_time, var_count)
    lb = zeros(var_count,1);
    ub = ones(var_count,1);
    
    problem.fitnessfcn = @(x) objective(x,z0,p,max_sim_time,max_angle);    % create anonymous function that returns objective
    problem.nvars = var_count;
    problem.lb = lb;                                % lower bound on decision variables
    problem.ub = ub;                                % upper bound on decision variables
    problem.solver = 'ga';                          % required
    problem.intcon = 1:var_count;
    problem.options = optimoptions(@ga,'MaxGenerations',30, ...
                                       'MaxTime',30*60,...
                                       'Display','iter');
    x = ga(problem);  
end