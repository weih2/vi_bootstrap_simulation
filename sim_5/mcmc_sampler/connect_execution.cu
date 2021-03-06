__global__ void connect_to_execution
(double delta, double *dev_credible_sets_lengths, int *dev_credible_sets_covered, double *dev_fi_inv,
  double *dev_first_center){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= N_EXPERIMENTS) return;

  device_mcmc_implementor thread_implementation(delta, t_id);
  thread_implementation.gen_obs();
  thread_implementation.gen_mcmc_samples();
  thread_implementation.construct_mcmc_credible_sets();
  thread_implementation.fi_inv_estimate();

  dev_first_center[t_id] = cal_mean( thread_implementation.mcmc_credible_sets[0], 2);

  for(int k = 0; k < N_CENTERS * N_CENTERS; k++)
    dev_fi_inv[k + t_id * N_CENTERS * N_CENTERS] = thread_implementation.fi_inv_estimation[k];

  for(int k = 0; k < N_CENTERS; k++){
    dev_credible_sets_covered[k * N_EXPERIMENTS + t_id] = thread_implementation.covered[k];
    dev_credible_sets_lengths[k * N_EXPERIMENTS + t_id] =
    thread_implementation.mcmc_credible_sets[k][1] - thread_implementation.mcmc_credible_sets[k][0];
  }
}
