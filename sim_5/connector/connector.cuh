class connector{
public:
  //// initialize device
  connector();
  ~connector();

  double credible_sets_lengths[N_CENTERS][N_EXPERIMENTS];
  double *device_credible_sets_lengths;

  int credible_sets_covered[N_CENTERS][N_EXPERIMENTS];
  int *device_credible_sets_covered;

  double *dev_fi_inv_[N_EXPERIMENTS];
  double *dev_fi_inv;
  double fi_est[N_CENTERS * N_CENTERS * N_EXPERIMENTS]; // point to host

  //// run connection
  void run_mcmc(double);
  void connector_copy_back();
  void invert_fi_back();
  //// stats
  double coverage_rates[N_CENTERS];
  double credible_sets_lengths_means[N_CENTERS];
  double credible_sets_lengths_vars[N_CENTERS];

  //// host side calculate stats
  void gen_stats();
  void print_stats();
};
