function opt_params = jm_opt_params()

%jm_opt_params Creates the necessary parameter structure for the
%optimization.
%   Output
%   - opt_params: Structure containing all necessary fields for the
%   optimization
%       .duration: Total time for diffusion gradients (slice selection
%       for 180° included) in [s]
%       .start: Start time for slice selection gradient relative to start 
%       of diffusion gradients in [s]
%       .end: Finish time for slice selection gradient relative to start of
%       diffusion gradients in [s]
%       .nodes: Number of diffusion gradient timesteps (q-vector contains
%       nodes+1 timesteps)
%       .lambda: Shape factor for the B-tensor [0 = planar, 1 = linear, 
%       1/3 = spherical]
%       .Gmax: Maximum allowed gradient amplitude in [T/m]
%       .Smax: Maximum allowed gradient slew rate in [T/m/s]
%       .norm: Gradient normalization ['max' = max. norm, 'euclid' =
%       Euclidean L2 norm]
%       .bool_heat: Switches heat-weighting on / off [0 = off, 1 = on]
%       .heat: Heat-weighting factor [0 = no gradient activity, 1 = no heat weighting]
%       .bool_maxwell: Switches maxwell-compensation on / off [0 = off, 
%       1 = on]
%       .maxwell_limit: limiting value for concomitant gradients 
%       [(mT/m)^2ms]
%       .constants: Automatically calculated constants used during the
%       optimization
%           .gyro_ratio: gyro magnetic ratio in [rad/s/T]
%           .delta_t: time difference between two timesteps
%           .crit_point: timesteps where the gradient is required to be
%           zero (beginning, end, slice selection duration)
%   Reference
%   - Sjölund J, et al. Constrained optimization of gradient waveforms for
%   generalized diffusion encoding, J. of Magn. Res., 2015:261
%   Comment on timing in jm_QTI / jm_MDM:
%   - SliceSelTime = Duration of the slice selection process (3540 at 3T)
%   - TimeBeforePulse = Duration of diffusion gradient lobe AND 100 us of
%                       balance gradient
%   - TimeAfterPulse = Duration of diffusion gradient lobe

% Number of optimization points
opt_params.nodes        = 64;
% Sequence timing
opt_params.duration     = 85.06 * 1e-03;
opt_params.start        = 39.87 * 1e-03;
opt_params.end          = 46.33 * 1e-03;
% b-Tensor shape
opt_params.lambda       = 0;
opt_params.norm         = 'euclid';
% Hardware requirements
opt_params.Gmax         = 80 * 1e-03;
opt_params.Smax         = 100;
% Heat weighting
opt_params.bool_heat    = 0;
opt_params.heat         = 0.6;
% Maxwell compensation
opt_params.bool_maxwell  = 1;
opt_params.maxwell_limit = 1e+03;
% Spectral anisotropy (only supported for spherical b-tensors)
opt_params.bool_saniso = 0;
opt_params.saniso_limit = 0.01;
% Initialization
opt_params.init = 'rand';

end

