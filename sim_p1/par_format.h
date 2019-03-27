struct global_vars{
  // # categories
  int K;
  // variance of cluster center
  double sigma_2;
  // # samples
  int n_samples;
};

struct global_vars_device{
  int *device_K;
  double *device_sigma_2;
  // number of x in each experiment
  int *device_n_samples;
};

struct latent_vars{
  // cluster centers
  double* mu;
  // categories of each sample
  int* c;
};

struct bootstrap_vars{
  double confidence;
  double *weights;
};

struct simulation_data{
  global_vars g_vars;
  latent_vars l_vars;
  // Gaussian sequnce data
  double *x;

  bootstrap_vars b_vars;
};

struct cavi_estimation{
  // posterior parameters for mu
  double *m;
  double *s2;
  // posterior parameters for c
  double **phi;
};

struct device_cavi_estimation{
  double **device_m;
  double **device_s2;
  double ***device_phi;
  double **device_m_transpose;
};
