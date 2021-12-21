function jm_writeGradToCsv( input_array, filename, fn_out )
% JM_WRITEGRADTOCSV Write an array of values to .csv using ' ' as a
% delimiter.
%
% Arguments
%
%    input_array - N x 1 array of values to be exported
%
%    filename - Filename of the .csv file as string
%
%    fn_out - Path indicating the export destination
%
%
% See also JM_WRITERESULTTOCSV.

% Set each value below tolerance to zero
tolerance = 1e-12;
temp = zeros( length( input_array ), 1 );
for i = 1 : 1 : length( input_array )
    if abs( input_array( i ) ) < tolerance
        temp( i ) = 0.000000;
    else
        temp(i) = input_array(i);
    end
end
temp = temp';

% Write array to csv
output_path = fullfile(fn_out, strcat(filename,'.txt'));
dlmwrite( output_path, temp, 'delimiter', ' ', 'precision', '%.6f' );

end

