function options = jm_opt_optimset()

options = optimset;
options.Display = 'iter';
options.Algorithm = 'sqp';
options.MaxFunEvals = inf;
%options.MaxFunEvals = 100000;
options.MaxIter = inf;
%options.MaxIter = 1000;
options.TolX = 1e-12;
options.ScaleProblem = 'obj-and-constraints';

end