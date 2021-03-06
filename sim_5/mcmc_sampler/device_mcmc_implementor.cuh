class device_mcmc_implementor{
public:
  __device__ device_mcmc_implementor(double, int);
  int thread_id;
  double mu[N_CENTERS];

  ///////////////////////// per experiment
  // random samples
  double obs[N_OBS];

  double mu_samples[N_CENTERS][N_MCMC_SAMPLES];

  // cridible sets to send back to host
  double mcmc_credible_sets[N_CENTERS][2];
  int covered[N_CENTERS];
  // upper triangular fisher info estimate
  double fi_inv_estimation[N_CENTERS * N_CENTERS];

  ///////////////////// functions
  __device__ void gen_obs();
  __device__ void gen_mcmc_samples();
  __device__ void print_sample(int);

  __device__ void construct_mcmc_credible_sets();

  __device__ void fi_inv_estimate();
};
