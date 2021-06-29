function mat_deriv2 = jm_mat_deriv2( nodes, delta_t )

%jm_mat_deriv1 Creation of a derivation matrix for calculating the second
%derivative of 'nodes' discrete timesteps with a time difference 'delta_t'.
%   Input
%   - nodes: Number of timesteps which are to be derivated
%   - delta_t: Time difference between two timesteps
%   Output
%   - mat_deriv2: nodes-2 x nodes sized derivation matrix

mat_deriv2 = zeros(nodes-2, nodes);
for index = 1 : 1 : nodes-2
    mat_deriv2(index, index) = 1;
    mat_deriv2(index, index+1) = -2;
    mat_deriv2(index, index+2) = 1;
end
mat_deriv2 = mat_deriv2 / delta_t / delta_t;

end

