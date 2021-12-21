function [ result ] = jm_trapezGrad( nodes, gradAmp, slewrate )
% JM_TRAPEZGRAD Creates a trapezoidal gradient waveform with normalized 
% amplitude for a given number of timesteps 'nodes', max. gradient 
% amplitude 'gradAmp', and max. slew rate 'slewrate'.
%
% Arguments
%
%    nodes - number of timesteps
%
%    gradAmp - max. gradient amplitude in mT/m
%
%    slewrate - max. slew rate in T/m/s
%
% Return
%
%    result - N x 1 array of normalized gradient amplitude
    
% Calculate the necessary number of nodes for the ramp-up and -down
ramp = ceil( gradAmp / slewrate * 1e+02 );
result = zeros( nodes, 1 );
% Set up gradient shape
for index = 1 : 1 : nodes
    if index <= ramp
        result(index) = (index-1) / (ramp-1);
    elseif (index > ramp) && (index <= nodes-ramp)
        result(index) = 1;
    elseif index > (nodes - ramp)
        result(index) = 1 - (index - (nodes-ramp+1)) / (ramp-1);
    end %if
end %for
end %function
