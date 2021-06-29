function opt_params = jm_opt_constants(opt)
%jm_opt_constants Derive constant optimization parameters from user
%supplied struct.
%   Input: opt  Struct created with jm_opt_params
%   Output: opt_params  Optimization parameter struct ready to be used for
%   further optimization.

% Copy user supplied parameters
opt_params = opt;
% Gyromagnetic ratio
opt_params.constants.gyro_ratio = 2.6752219e+08;
% Optimization time step
opt_params.constants.delta_t = opt_params.duration / (opt_params.nodes - 1);
% Points of zero gradient amplitude (beginning, end, pause interval)
crit_point = [1; opt_params.nodes];
counter = 2;
for index = 2 : 1 : opt_params.nodes-1
    if ((opt_params.constants.delta_t * index) >= opt_params.start) ...
        && ((opt_params.constants.delta_t * index) <= opt_params.end)
        counter = counter + 1; 
        crit_point(counter) = index + 1;
    end
end
if (crit_point(end)-1) * opt_params.constants.delta_t < opt_params.end
    counter = counter + 1;
    crit_point(counter) = crit_point(end) + 1;
end
if (crit_point(3)-1) * opt_params.constants.delta_t > opt_params.start
    counter = counter + 1; 
    crit_point(counter) = crit_point(3) - 1;
end
crit_point = sort(crit_point);
opt_params.constants.crit_point = crit_point;

% Matrices for integration and derivatives of q
opt_params.constants.mat_int = jm_mat_int(opt_params.nodes+1,opt_params.constants.delta_t);
opt_params.constants.mat_int_g = jm_mat_int(opt_params.nodes,opt_params.constants.delta_t);
opt_params.constants.mat_deriv1 = jm_mat_deriv1(opt_params.nodes+1,opt_params.constants.delta_t);
opt_params.constants.mat_deriv2 = jm_mat_deriv2(opt_params.nodes+1,opt_params.constants.delta_t);
% Matrix for Maxwell compensation
mat_maxwell = eye( opt.nodes );
mat_maxwell(1,1) = 1/2;
mat_maxwell(end,end) = 1/2;
mat_maxwell = mat_maxwell * opt_params.constants.delta_t;
mat_maxwell(crit_point(2):crit_point(end-1) , : ) = 0;
mat_maxwell(crit_point(end-1):end, : ) = - mat_maxwell( crit_point(end-1):end, : );
opt_params.constants.mat_maxwell = mat_maxwell;

% B-Tensor
if opt_params.lambda == 1
    opt_params.constants.b_tensor = 1;
elseif opt_params.lambda == 0
    opt_params.constants.b_tensor = [0.5 0 ; 0 0.5];
else
    opt_params.constants.b_tensor = diag( [ opt_params.lambda (1-opt_params.lambda)/2 (1-opt_params.lambda)/2 ] );
end

end

