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

  // device storage
  device_storage device_store;

  // copy back
  double *host_m_transpose;

  void device_cavi_bootstrap_update();

private:
  // protect from infinite iterations
  void cavi_estimate();
  void cavi_estimate_weighted();
  void generate_weights();

  void device_init_cavi_weighted();
  void cavi_weighted_copy_back();
};
