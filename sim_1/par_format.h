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
  int allocated;

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
  cavi_implementation(simulation_data&, int, int, double);

  simulation_data data;
  int max_n_iter;
  double epsilon;
  double elbo;
  cavi_estimation est;

  int n_bootstrap_samples;
  cavi_estimation* weighted_est;

  std::queue<double>* history_map;

  double** bootstrap_ci;
  double** credit_set;
  double** empirical_ci;

  void cavi_update(int&);
  void cavi_bootstrap_update(int&);

  void ci_construct();
  void cs_construct();
  void empirical_ci_construct();

  int ci_covered;
  int cs_covered;
  int *ci_covered_each;
  int *cs_covered_each;
  int n_experiments;
  void check_covered();

  void save_result(std::ostream&);

private:
  // protect from infinite iterations
  void cavi_estimate();
  void cavi_estimate_weighted();
  void generate_weights();
};
