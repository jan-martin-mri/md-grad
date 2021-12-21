function [Aeq, beq] = jm_opt_linEq(opt)
% JM_OPT_LINEQ Returns linear equality constraints for constrained 
% optimization.
%
% Arguments
%
%    opt - Struct containing optimization options
%
% Return
%
%    Aeq, beq - Equality constraints for constrained optimization.
%
%
% Ref: <a href="matlab: web ('https://www.sciencedirect.com/science/article/abs/pii/S1090780715002451?via%3Dihub')">Sjölund et al.: Constrained optimization of gradient waveforms for generalized diffusion encoding, J. Mag. Reson. 261, 157-168 (2015)</a>
%
% Formulating Constraints: <a href="matlab: web ('https://de.mathworks.com/help/optim/ug/nonlinear-equality-and-inequality-constraints.html')">Nonlinear equality and inequality constraints in Matlab</a>

% Check that opt contains instructions for jm_opt_linIneq
if ~isfield(opt.constants,'crit_point') || ~isfield(opt,'lambda')
    error('Struct opt does not contain all required fields.');
end

Aeq = zeros( length(opt.constants.crit_point), opt.nodes+1 );
for index = 1 : 1 : length(opt.constants.crit_point)
    Aeq( index, opt.constants.crit_point(index)   ) = -1;
    Aeq( index, opt.constants.crit_point(index)+1 ) =  1;
end
Aeq( end+1, 1           ) = 1;
Aeq( end+1, opt.nodes+1 ) = 1;

if opt.lambda == 1
                               % qx
elseif opt.lambda == 0
    Aeq = kron( eye(2), Aeq ); % qy, qz
else
    Aeq = kron( eye(3), Aeq ); % qx, qy, qz
end

Aeq = [zeros(size(Aeq,1),1) Aeq];
beq = zeros(size(Aeq,1), 1);

end

