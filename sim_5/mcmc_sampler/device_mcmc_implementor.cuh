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

  ///////////////////// functions
  __device__ void gen_obs();
  __device__ void gen_mcmc_samples();
  __device__ void print_sample(int &);

  __device__ void construct_mcmc_credible_sets();
};
