function mat_deriv1 = jm_mat_deriv1( nodes, delta_t )

%jm_mat_deriv1 Creation of a derivation matrix for calculating the first
%derivative of 'nodes' discrete timesteps with a time difference 'delta_t'.
%   Input
%   - nodes: Number of timesteps which are to be derivated
%   - delta_t: Time difference between two timesteps
%   Output
%   - mat_deriv1: nodes-1 x nodes sized derivation matrix

mat_deriv1 = zeros(nodes-1, nodes);
for index = 1 : 1 : nodes-1
    mat_deriv1(index, index) = -1;
    mat_deriv1(index, index+1) = 1;
end
mat_deriv1 = mat_deriv1 / delta_t;

end

