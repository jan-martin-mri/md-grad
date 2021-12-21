function mat_int = jm_mat_int( nodes, delta_t )
% JM_MAT_INT Returns the matrix for calculating the integral of
% 'nodes' discrete timesteps with a time difference 'delta_t' following the
% trapezoidal rule.
%
% Arguments
%
%    nodes - Number of timesteps
%
%    delta_t - Time difference between timesteps
%
% Return
%
%    mat_int - Dimension nodes-1 x nodes matrix for calculating the
%              integral according to the trapezoidal rule
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>


mat_int = eye(nodes);
mat_int(1, 1) = 1/2;
mat_int(nodes, nodes) = 1/2;
mat_int = mat_int * delta_t;

end

