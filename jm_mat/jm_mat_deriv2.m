function mat_deriv2 = jm_mat_deriv2( nodes, delta_t )
% JM_MAT_DERIV2 Returns the matrix for calculating the second derivative of
% 'nodes' discrete timesteps with a time difference 'delta_t'.
%
% Arguments
%
%    nodes - Number of timesteps
%
%    delta_t - Time difference between timesteps
%
% Return
%
%    mat_deriv2 - Dimension nodes-2 x nodes matrix for calculating the
%                 first derivative
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>


mat_deriv2 = zeros(nodes-2, nodes);
for index = 1 : 1 : nodes-2
    mat_deriv2(index, index) = 1;
    mat_deriv2(index, index+1) = -2;
    mat_deriv2(index, index+2) = 1;
end
mat_deriv2 = mat_deriv2 / delta_t / delta_t;

end

