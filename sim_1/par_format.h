struct global_vars{
  // # categories
  int K;
  // variance of cluster center
  double sigma_2;
  // # samples
  int n_samples;
};

struct latent_vars{
  // cluster centers
  double* mu;
  // categories of each sample
  double* c;
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

class cavi_implementation{
public:
  cavi_implementation(simulation_data&);

  simulation_data data;
  int max_n_iter;
  double epsilon;
  double elbo;
  cavi_estimation est;
  cavi_estimation weighted_est[];

  void cal_elbo();
  void cal_elbo_weighted();
  void cavi_estimate();
  void cavi_estimate_weighted();
}
