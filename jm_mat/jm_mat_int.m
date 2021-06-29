function mat_int = jm_mat_int( nodes, delta_t )

%jm_mat_in Creation of an integration matrix for the integration of 'nodes'
%timesteps with a time difference 'delta_t' according to the
%trapezoidal rule.
%   Input
%   - nodes: Number of timesteps which are to be integrated over
%   - delta_t: Time difference between two timesteps
%   Output
%   - mat_int: nodes x nodes sized integration matrix according to the 
%   trapezoidal rule

mat_int = eye(nodes);
mat_int(1, 1) = 1/2;
mat_int(nodes, nodes) = 1/2;
mat_int = mat_int * delta_t;

end

