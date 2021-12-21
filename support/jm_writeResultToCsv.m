function jm_writeResultToCsv(opt_result_f, opt_params_f, fn_out)
% JM_WRITERESULTTOCSV Export optimization results as .csv files for import
% on the scanner.
%
% Arguments
%
%    opt_result_f - Struct containing optimization results after
%                   interpolation
%
%    opt_params_f - Struct containing optimization options after
%                   interpolation
%
%    fn_out - Path to folder for exported .csv files
%
%
% See also JM_WRITEGRADTOCSV.

pause_start = opt_params_f.start * 1e+05;
pause_end = opt_params_f.end * 1e+05 + 1;

if opt_params_f.lambda == 1  
    b_tensor = 'lin';
elseif opt_params_f.lambda == 0
    b_tensor = 'pln';
elseif opt_params_f.lambda == 1/3
    b_tensor = 'sph';
elseif opt_params_f.lambda < 1/3 && opt_params_f.lambda > 0
    b_tensor = 'pts';
else
    b_tensor = 'stl';
end

jm_writeGradToCsv( opt_result_f.gx(1:pause_start), strcat( 'p1_', b_tensor), fn_out );
jm_writeGradToCsv( opt_result_f.gy(1:pause_start), strcat( 'r1_', b_tensor), fn_out );
jm_writeGradToCsv( opt_result_f.gz(1:pause_start), strcat( 's1_', b_tensor), fn_out );
jm_writeGradToCsv( opt_result_f.gx(pause_end:end), strcat( 'p2_', b_tensor), fn_out );
jm_writeGradToCsv( opt_result_f.gy(pause_end:end), strcat( 'r2_', b_tensor), fn_out );
jm_writeGradToCsv( opt_result_f.gz(pause_end:end), strcat( 's2_', b_tensor), fn_out );

end