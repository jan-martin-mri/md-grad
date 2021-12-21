function [opt_result_f, opt_params_f] = jm_interpolGrad(opt_result, opt_params)
% JM_INTERPOLGRAD Interpolate a set of optimized gradients for use at the
% scanner.
%
% Arguments
%
%    opt_result - Struct containing optimization results
%
%    opt_params - Struct containing optimization options
%
% Return
%
%    opt_result_f - Struct containing optimization results interpolated to
%                   realistic timing for the scanner
%
%    opt_params_f - Struct containing updated optimization parameters
%                   corresponding to opt_result_f
%
%
% See also JM_OPT_RUN, JM_FILLOPTIONS.

opt_result_f = opt_result;
% Interpolated gradient trajectories
% Calculate the number of interpolation points between two timesteps
n_interpol = (opt_params.duration * 1e+05 - opt_params.nodes) / (opt_params.nodes - 1);
n = ( 1 : 1 : opt_params.nodes );
nf = ( 1 : 1/(n_interpol+1) : opt_params.nodes );
opt_result_f.gx = interp1(n, opt_result.gx, nf)';
opt_result_f.gy = interp1(n, opt_result.gy, nf)';
opt_result_f.gz = interp1(n, opt_result.gz, nf)';
% Interpolated bq vector
n_interpol = (opt_params.duration * 1e+05 - opt_params.nodes ) / opt_params.nodes;
n = ( 1 : 1 : opt_params.nodes+1 );
nf = ( 1 : 1/(n_interpol+1) : opt_params.nodes+1 );
opt_result_f.bq = [ opt_result.bq(1), ...
                    interp1(n, opt_result.bq(2                        :   (opt_params.nodes+1)+1), nf), ...
                    interp1(n, opt_result.bq(  (opt_params.nodes+1)+2 : 2*(opt_params.nodes+1)+1), nf), ...
                    interp1(n, opt_result.bq(2*(opt_params.nodes+1)+2 : end), nf) ]';

opt_params_f = opt_params;
% Updated opt_params
opt_params_f.nodes = length(opt_result_f.gx);
% For check calculation compute the correct delta_t
opt_params.constants.delta_t = opt_params_f.duration / (opt_params_f.nodes-1);

end
