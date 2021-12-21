function options = jm_opt_optimset()
% JM_OPT_OPTIMSET Set options for constrained optimization algorithm.
%
% Return
%
%    options - Options for the constrained optimization algorithm
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>
%
% Optimization options: <a href="matlab: web ('https://www.mathworks.com/help/optim/ug/fmincon.html')">Nonlinear optimization in Matlab</a>


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