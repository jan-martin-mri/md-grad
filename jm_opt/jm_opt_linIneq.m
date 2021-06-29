function [A,b] = jm_opt_linIneq(opt)

% Check that opt contains instructions for jm_opt_linIneq
if ~isfield(opt,'norm') || ~isfield(opt,'lambda')
    error('Struct opt does not contain all required fields.');
end

deriv1 = jm_mat_deriv1( opt.nodes+1, opt.constants.delta_t );
deriv2 = jm_mat_deriv2( opt.nodes+1, opt.constants.delta_t );

% Number of constraints depends on b-tensor shape
if opt.lambda == 1
    A1 = deriv1;
    A2 = deriv2;
elseif opt.lambda == 0
    A1 = kron( eye(2), deriv1);
    A2 = kron( eye(2), deriv2);
else
    A1 = kron( eye(3), deriv1);
    A2 = kron( eye(3), deriv2);
end

grad_const( 1 : size( A1, 1 )) = opt.constants.gyro_ratio * opt.Gmax;
slew_const( 1 : size( A2, 1 )) = opt.constants.gyro_ratio * opt.Smax;

% Number of constraints depends on normalization
if strcmp(opt.norm,'max')
    A = [A1; -A1; A2; -A2];
    b = [grad_const, grad_const, slew_const, slew_const]';
elseif strcmp(opt.norm,'euclid')
    A = [A2; -A2];
    b = [slew_const, slew_const]';
else
    error('Unknown option for opt.norm.');
end

% Row of zeros necesssary for b as first entry
A = [zeros(size(A,1),1) A];

end

