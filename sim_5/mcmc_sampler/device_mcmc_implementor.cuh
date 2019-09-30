class device_mcmc_implementor{
public:
  __device__ device_mcmc_implementor(double, int);
  int thread_id;
  double mu[N_CENTERS];

  ///////////////////////// per experiment
  // random samples
  double obs[N_OBS];

  double mu_samples[N_CENTERS][N_MCMC_SAMPLES];

  // cridible sets
  double mcmc_credible_sets[N_CENTERS][2];
  int covered[N_CENTERS];

  /////////////////////// experiment stats
  int covered_all[N_CENTERS];
  double mcmc_credible_sets_lens[N_CENTERS][N_EXPERIMENTS];
  double mcmc_credible_sets_lens_avg[N_CENTERS];
  double mcmc_credible_sets_lens_sd[N_CENTERS];

  ///////////////////// functions
  __device__ void gen_obs();
  __device__ void gen_mcmc_samples();

  __device__ void construct_mcmc_credible_sets();
};
