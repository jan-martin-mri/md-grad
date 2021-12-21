function bq_init = jm_opt_init(opt)
% JM_OPT_INIT Returns initial b-q vector for constrained optimization.
%
% Arguments
%
%    opt - Struct containing optimization options
%
% Return
%
%    bq_init - Dimension nodes+2 x 1 initial b-q vector
%
% Initial b-q vector is either comprised of random values or zeros 
% depending on the value of opt.init. 
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>
%
% See also JM_OPT_PARAMS.

% Check that opt contains instructions for jm_opt_init
if ~isfield(opt,'init') || ~isfield(opt,'lambda')
    error('Struct opt does not contain all required fields.');
end

% Set length of bq_init depending on b-tensor shape
if opt.lambda == 1
    bq_length = (opt.nodes+1) + 1;
elseif opt.lambda == 0
    bq_length = 2 * (opt.nodes+1) + 1;
else
    bq_length = 3 * (opt.nodes+1) + 1;
end

% Create bq_init
if strcmp(opt.init,'rand')
    bq_init = 2 * rand( bq_length, 1 ) - 1;
elseif strcmp( opt.init, 'zero' )
    bq_init = zeros( bq_length, 1 );
else
    error('Unknown option for opt.init');
end

% Scale bq_init up for faster convergence
bq_init = bq_init * 1e+04;

end

