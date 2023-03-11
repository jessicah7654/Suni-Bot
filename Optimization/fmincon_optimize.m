function x = fmincon_optimize(x0, z0, p, lb, ub, max_angle, max_sim_time)
    shoulder_torque_max = 30 * ones(1,length(x0)/2);
    waist_torque_max = 30 * ones(1,length(x0)/2);
    shoulder_torque_min = -30 * ones(1,length(x0)/2);
    waist_torque_min = -30 * ones(1,length(x0)/2);

    problem.objective = @(x) objective(x, z0, p, max_sim_time, max_angle); % create anonymous function that returns objective
    %problem.nonlcon = @(x) constraints(x,z0,p);             % create anonymous function that returns nonlinear constraints
    problem.x0 = x0;                                        % initial guess for decision variables
    problem.lb = lb;                                        % lower bound on decision variables
    problem.ub = ub;                                        % upper bound on decision variables
    problem.Aineq = []; problem.bineq = [];                 % no linear inequality constraints
    problem.Aeq = []; problem.beq = [];                     % no linear equality constraints
    problem.options = optimset('Display','iter');           % set options
    problem.solver = 'fmincon';                             % required
    x = fmincon(problem);                                   % solve nonlinear programming problem 
end