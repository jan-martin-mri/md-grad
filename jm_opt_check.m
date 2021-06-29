function [ opt_check ] = jm_opt_check( opt_result, opt_params )
%% jm_opt_check

% Used to verify optimized gradient trajectories achieved with jm_opt_run.

% Input:
%   opt_result: Optimization result from jm_opt_run.
%   opt_params: Optimization parameters from jm_opt_params.

% Output:
%   opt_check: Struct containing results with respect to the employed
%   constraints.

% Calculate necessary constants
opt = jm_opt_constants(opt_params);

% Copy some parameters for improved readability
nodes = opt.nodes + 1;
bq = opt_result.bq;
gx = opt_result.gx;
gy = opt_result.gy;
gz = opt_result.gz;
qx = opt_result.bq(         2 :   nodes+1 );
qy = opt_result.bq(   nodes+2 : 2*nodes+1 );
qz = opt_result.bq( 2*nodes+2 : 3*nodes+1 );

% Setup output struct
opt_check = struct( 'gxGmax', 0, 'gyGmax', 0, 'gzGmax', 0, ...
                    'gxSmax', 0, 'gySmax', 0, 'gzSmax', 0, ...
                    'gxMom' , 0, 'gyMom' , 0, 'gzMom' , 0, ...
                    'bTensor', zeros(3) , 'bValue', 0,     ...
                    'heat_weighting', 0, 'maxwell', 0 );

%% Gradient amplitude
opt_check.gxGmax = max(abs( gx )) * opt.Gmax;
opt_check.gyGmax = max(abs( gy )) * opt.Gmax;
opt_check.gzGmax = max(abs( gz )) * opt.Gmax;
  
%% Gradient slewrate
gxS = zeros( opt.nodes-1,1 );
gyS = zeros( opt.nodes-1,1 );
gzS = zeros( opt.nodes-1,1 );
for index = 1 : 1 : opt.nodes-1
    gxS( index ) = (gx( index+1 ) - gx( index )) * opt.Gmax / opt.constants.delta_t;
    gyS( index ) = (gy( index+1 ) - gy( index )) * opt.Gmax / opt.constants.delta_t;
    gzS( index ) = (gz( index+1 ) - gz( index )) * opt.Gmax / opt.constants.delta_t;
end
opt_check.gxSmax = max(abs( gxS ));
opt_check.gySmax = max(abs( gyS ));
opt_check.gzSmax = max(abs( gzS ));

%% 0th gradient moment
for index = 1 : 1 : opt.nodes-1
    opt_check.gxMom = opt_check.gxMom + (gx( index ) + gx( index+1 ));
    opt_check.gyMom = opt_check.gyMom + (gy( index ) + gy( index+1 ));
    opt_check.gzMom = opt_check.gzMom + (gz( index ) + gz( index+1 ));
end
opt_check.gxMom = opt_check.gxMom * opt.constants.gyro_ratio * opt.constants.delta_t / 2;
opt_check.gyMom = opt_check.gyMom * opt.constants.gyro_ratio * opt.constants.delta_t / 2;
opt_check.gzMom = opt_check.gzMom * opt.constants.gyro_ratio * opt.constants.delta_t / 2;

%% b-Tensor
B = [qx qy qz]' * opt.constants.mat_int * [qx qy qz];
opt_check.bValue = trace( B );
opt_check.bTensor = B / opt_check.bValue;

%% Spectral components
opt_check.M2_ini = opt.constants.gyro_ratio^2 * opt.Gmax^2 * [gx gy gz]' * jm_mat_int(opt.nodes, opt.constants.delta_t) * [gx gy gz];
[opt_check.EigRot, opt_check.M2] = eig(opt_check.M2_ini, 'matrix');
opt_check.SA = sqrt(3/2) * sqrt((opt_check.M2(1,1)-trace(opt_check.M2)/3)^2 + (opt_check.M2(2,2)-trace(opt_check.M2)/3)^2 + (opt_check.M2(3,3)-trace(opt_check.M2)/3)^2) / sqrt(trace(opt_check.M2.^2));
%% Heat weighting
max_heat = opt.Gmax^2 * ( opt.duration - ( opt.end - opt.start ));
opt_check.heat_weighting = opt.constants.delta_t * trapz( [ gx*opt.Gmax gy*opt.Gmax gz*opt.Gmax ].^2 , 1 );
opt_check.heat_weighting = opt_check.heat_weighting / max_heat;

%% Maxwell Index
G = [gx gy gz] * opt.Gmax;
M = G' * opt.constants.mat_maxwell * G;
opt_check.maxwell = sqrt(trace(M*M)) * 1e+09; % (mT/m)^2 * ms

%% Output
fprintf( '============== jm_opt_check ==============\n' );
fprintf( 'B-Value: %d / %d \n', opt_check.bValue , bq(1) ); 
fprintf( 'Gradient in x-direction: \n\tAmplitude:\t%.2d / %.2d T/m \n\tSlewrate:\t%.2d / %d T/m/s \n\t0th Moment:\t%.2d \n', opt_check.gxGmax , opt.Gmax , opt_check.gxSmax, opt.Smax, opt_check.gxMom );
fprintf( 'Gradient in y-direction: \n\tAmplitude:\t%.2d / %.2d T/m \n\tSlewrate:\t%.2d / %d T/m/s \n\t0th Moment:\t%.2d \n', opt_check.gyGmax , opt.Gmax , opt_check.gySmax, opt.Smax, opt_check.gyMom );
fprintf( 'Gradient in z-direction: \n\tAmplitude:\t%.2d / %.2d T/m \n\tSlewrate:\t%.2d / %d T/m/s \n\t0th Moment:\t%.2d \n', opt_check.gzGmax , opt.Gmax , opt_check.gzSmax, opt.Smax, opt_check.gzMom );
fprintf( 'B-tensor: \n' );
fprintf( '\t %d \t %d \t %d \n', opt_check.bTensor.' );
if opt_params.bool_heat
    fprintf( 'Heat-weighting: \n\tx-direction: \t%.2d / %.2d \n\ty-direction: \t%.2d / %.2d \n\tz-direction: \t%.2d / %.2d \n', opt_check.heat_weighting(1), opt.heat, opt_check.heat_weighting(2), opt.heat, opt_check.heat_weighting(3), opt.heat );
end
if opt_params.bool_maxwell
    fprintf( 'Maxwell-Index: %.2d <= %.2d (mT/m)² ms\n', opt_check.maxwell, opt.maxwell_limit );
end
fprintf( 'Spectral tuning: \n' );
fprintf( '\t %.2d / %.2d / %.2d\n', opt_check.M2(1,1), opt_check.M2(2,2), opt_check.M2(3,3));
fprintf( '\t SA = %.2d\n', opt_check.SA);
fprintf( '\t tr(M2) = %.2d\n', opt_check.M2(1,1)+opt_check.M2(2,2)+opt_check.M2(3,3));
fprintf( '==========================================\n' );

figure('name','Gradient trajectory');
plot(gx);
hold on
plot(gy);
plot(gz);
hold off

figure('name','q-Space trajectory');
plot3(qx,qy,qz);

end

