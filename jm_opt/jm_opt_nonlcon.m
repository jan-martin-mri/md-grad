function [c,ceq] = jm_opt_nonlcon(bq,opt)
% jm, 11.03.2019: WIP version includes options for spectral optimization.
    b = bq(1);
    Q = reshape(bq(2:end),opt.nodes+1,[]);
    
    % b-Tensor shape
    ceq = Q' * opt.constants.mat_int * Q - opt.constants.b_tensor * b;
    mask = triu(true(size(ceq)));
    ceq = ceq(mask);
    
    c = [];
    % Euclidean norm (only applies to higher order b-tensors)
    if strcmp(opt.norm,'euclid')
        c = sqrt(sum((opt.constants.mat_deriv1 * Q).^2,2)) - opt.constants.gyro_ratio * opt.Gmax;
    end
    % Heat weighting
    % Destabilisiert die Optimierung im eindimensionalen Fall sehr stark.
    if opt.bool_heat && (opt.heat < 1)
        heat = (opt.constants.mat_deriv1 * Q / opt.constants.gyro_ratio)' * (opt.constants.mat_deriv1 * Q / opt.constants.gyro_ratio) * opt.constants.delta_t;
        c_heat = heat / opt.Gmax^2 / (opt.duration - (opt.end - opt.start)) - opt.heat;
        c = [c; diag(c_heat)];
    end
    % Maxwell compensation
    % Ergebnisse mit starker Maxwell Kompensierung weisen oft Zacken auf.
    if opt.bool_maxwell && opt.maxwell_limit < 1e+06
        M = (opt.constants.mat_deriv1 * Q / opt.constants.gyro_ratio)' * opt.constants.mat_maxwell * (opt.constants.mat_deriv1 * Q / opt.constants.gyro_ratio);
        c_mw = sqrt(trace( M * M )) * 1e+09 - opt.maxwell_limit;
        c = [c; c_mw];
    end
    % Spectral anisotropy (only supported for sph b-tensors)
    if opt.bool_saniso && opt.lambda == 1/3
        M2 = (opt.constants.mat_deriv1 * Q / opt.constants.gyro_ratio)' * opt.constants.mat_int_g * (opt.constants.mat_deriv1 * Q / opt.constants.gyro_ratio);
        M2 = eig(M2);
        c_sa = sqrt(3/2) * sqrt((M2(1)-mean(M2))^2 + (M2(2)-mean(M2))^2 + (M2(3)-mean(M2))^2) / sqrt(sum(M2.^2)) - opt.saniso_limit;
        c = [c; c_sa];
    end

end