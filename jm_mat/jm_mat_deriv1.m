function mat_deriv1 = jm_mat_deriv1( nodes, delta_t )
% JM_MAT_DERIV1 Returns the matrix for calculating the first derivative of
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
%    mat_deriv1 - Dimension nodes-1 x nodes matrix for calculating the
%                 first derivative
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>


mat_deriv1 = zeros(nodes-1, nodes);
for index = 1 : 1 : nodes-1
    mat_deriv1(index, index) = -1;
    mat_deriv1(index, index+1) = 1;
end
mat_deriv1 = mat_deriv1 / delta_t;

end

