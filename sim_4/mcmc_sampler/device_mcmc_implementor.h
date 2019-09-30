class device_mcmc_implementor{
public:
  device_mcmc_implementor(double, int);
  int thread_id;
  double mu[K];

  ///////////////////////// per experiment
  // random samples
  double obs[N_OBS];

  double mu_samples[K][N_MCMC_SAMPLES];

  // cridible sets
  double mcmc_credible_sets[K][2];
  int covered[K];

  /////////////////////// experiment stats
  int covered_all[K];
  double mcmc_credible_sets_lens[K][N_EXPERIMENTS];
  double mcmc_credible_sets_lens_avg[K];
  double mcmc_credible_sets_lens_sd[K];

  ///////////////////// functions
  void gen_obs();
  void gen_mcmc_samples();

  void construct_mcmc_credible_sets();
};
