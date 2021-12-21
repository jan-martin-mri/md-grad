function [ fill_options ] = jm_fillOptions( finalNoOfNodes )
% JM_FILLOPTIONS Creates a table of possible combinations for equally spaced 
% nodes that can be interpolated well up to the 'finalNoOfNodes'.
% 
% Arguments
% 
%     finalNoOfNodes - Number of timesteps in the gradient waveform for the 
%                      scanner
% 
% Return
% 
%     fill_options - N x 2 array of options for equally space fill nodes
%
%
% Gradient waveforms on the scanner run on a fixed 10 us timestep. 
% Constrained optimization algorithms work best with a limited number of 
% nodes (approx. 75). This script is useful in determining a good number of 
% nodes for the optimization algorithm that is easily interpolated to the 
% final number of timesteps for the scanner.
%
% See also JM_OPT_PARAMS, JM_INTERPOLGRAD.

k = 1;
for i = 2 : 1 : finalNoOfNodes
    temp = ( finalNoOfNodes - i )/( i - 1 );
    if( rem(temp,1.0) == 0.0 )
        fill_options(k,1) = i;
        fill_options(k,2) = temp;
        k = k+1;
    end
end

end

