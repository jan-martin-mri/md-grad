function opt_result = jm_opt_run(opt)
% JM_OPT_RUN Constrained optimization algorithm. Returns optimized gradient
% waveforms.
%
% Arguments
%
%    opt - Struct containing optimization options
%
% Return
%
%    opt_result - Struct comprised of optimized gradients gx, gy, gz and
%                 corresponding b-q vector
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>
%
% See also JM_OPT_PARAMS, JM_OPT_OPTIMSET.

% In case of linear b-tensors 'max' equals 'euclid'
if opt.lambda == 1 && strcmp(opt.norm,'euclid')
    opt.norm = 'max';
end
% Optimization parameters
opt = jm_opt_constants(opt);
% Objective function
funObj = @(bq) -bq(1);
% Initial bq vector
bq_init = jm_opt_init(opt);
% Linear inequality constraints
[A,b] = jm_opt_linIneq(opt);
% Linear equality constraints
[Aeq,beq] = jm_opt_linEq(opt);
% Lower and upper bounds
[lb,ub] = jm_opt_bounds();
% Nonlinear constraints
nonlcon = @(bq) jm_opt_nonlcon(bq,opt);
% Optimization algorithm options
options = jm_opt_optimset();

tic;
[opt_bq, opt_b, exitflag] = fmincon( funObj, bq_init, A, b, Aeq, beq, lb, ub, nonlcon, options );

% Format output
opt_result.exitflag = exitflag;
opt_result.runtime = toc;
opt_result.b = - opt_b * 1e-06;

nodes = opt.nodes + 1;
mat_d1 = jm_mat_deriv1( opt.nodes+1, opt.constants.delta_t ); 
if opt.lambda == 1
    opt_result.bq = [opt_bq; zeros(length(opt_bq)-1,1); zeros(length(opt_bq)-1,1)];
    opt_result.gx = mat_d1 * opt_bq( 2 : nodes+1 ) / opt.constants.gyro_ratio / opt.Gmax;
    opt_result.gy = zeros( size(opt_result.gx) );
    opt_result.gz = zeros( size(opt_result.gx) );
elseif opt.lambda == 0
    opt_result.bq = [opt_bq(1); zeros((length(bq_init)-1)/2,1); opt_bq(2:end)];
    opt_result.gy = mat_d1 * opt_bq(       2 :   nodes+1 ) / opt.constants.gyro_ratio / opt.Gmax;
    opt_result.gz = mat_d1 * opt_bq( nodes+2 : 2*nodes+1 ) / opt.constants.gyro_ratio / opt.Gmax;
    opt_result.gx = zeros( size(opt_result.gy) );
else
    opt_result.bq = opt_bq;
    opt_result.gx = mat_d1 * opt_bq(         2 :   nodes+1 ) / opt.constants.gyro_ratio / opt.Gmax;
    opt_result.gy = mat_d1 * opt_bq(   nodes+2 : 2*nodes+1 ) / opt.constants.gyro_ratio / opt.Gmax;
    opt_result.gz = mat_d1 * opt_bq( 2*nodes+2 : 3*nodes+1 ) / opt.constants.gyro_ratio / opt.Gmax;
end

end

