struct device_settings{
  latent_vars l_vars;

  double *epsilon;
  int *max_n_iter;
  double *bootstrap_confidence;
  double *ci_quantile;
  int *data_count;

  int thread_id;
};
