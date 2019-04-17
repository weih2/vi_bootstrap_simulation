// true parameters, will all be fixed
struct global_pars{
  double beta[n_parameters];

  // theta
  double sigma_2;
  double sigma_b_2;
  double pi;
};

struct device_settings{
  global_pars* g_pars;
  double* x;
}

// vb posterior
struct vb_posterior_pars{
  // p-dimensional
  double alpha[n_parameters];  // posterior inclusion prob
  double mu[n_parameters];
  double s2[n_parameters];
}
