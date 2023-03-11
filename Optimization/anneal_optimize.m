function x = anneal_optimize(x0, z0, p, lb, ub, max_angle, max_sim_time)

    problem.objective = @(x) objective(x, z0, p, max_sim_time, max_angle);             % create anonymous function that returns objective
    problem.x0 = x0;                                        % initial guess for decision variables
    problem.lb = lb;                                        % lower bound on decision variables
    problem.ub = ub;                                        % upper bound on decision variables
    problem.solver = 'simulannealbnd';                      % solver
    problem.options = optimoptions(@simulannealbnd,'MaxIterations',600, ...
                                                   'MaxTime',30*60,...
                                                   'Display','iter');
    x = simulannealbnd(problem);  
end