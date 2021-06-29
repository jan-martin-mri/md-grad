function bq_init = jm_opt_init(opt)

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

