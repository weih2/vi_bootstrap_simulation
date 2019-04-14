struct hyper_prior_pars{
  double sigma_2_lower;
  double sigma_2_upper;
  double sigma_b_2_lower;
  double sigma_b_2_upper;
  double log_pi_lower;
  double log_pi_upper;
};

// using same x throghout the simulation
struct observations{
  double* x;
  double* y;
};

// true parameters
struct global_pars{
  double beta[p];

  // theta
  double sigma_2;
  double sigma_b_2;
  double pi;
};


// vb posterior
struct vb_posterior_pars{
  // p-dimensional
  double alpha[p];  // posterior inclusion prob
  double mu[p];
  double s2[p];
}
