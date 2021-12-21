# Multidimensional Diffusion Gradient Optimization

This GitHub repository contains MATLAB code for optimizing multidimensional diffusion gradient waveforms according to the constrained optimization scheme originally presented by Sjölund et al. (https://doi.org/10.1016/j.jmr.2015.10.012).

The optimization parameters are set using the function jm_opt_params. The optimization is run using jm_opt_run and the resulting gradient waveforms may be checked for consistency using jm_opt_check.

Example usage:

```matlab
opt = jm_opt_params();
res = jm_opt_run(opt);
jm_opt_check(res, opt);
```

Convergence speed depends on the optimization settings. A good solution is typically characterized by the highest possible b-value while also showing a smooth gradient amplitude waveform.

A range of support functions exists that allows interpolating the optimization results to a higher number of nodes for use at the scanner, creating simple trapezoidal waveforms for specific slew rates, and exporting the results as .csv files.