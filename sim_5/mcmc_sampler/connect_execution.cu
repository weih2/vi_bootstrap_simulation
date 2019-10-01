__global__ void connect_to_execution
(double delta, double *dev_credible_sets_lengths[], int *dev_credible_sets_covered[]){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= N_EXPERIMENTS) return;

  device_mcmc_implementor thread_implementation(delta, t_id);
  thread_implementation.gen_obs();
  thread_implementation.gen_mcmc_samples();
  thread_implementation.construct_mcmc_credible_sets();

  for(int k = 0; k < N_CENTERS; k++){
    printf("%d\n", t_id);
    dev_credible_sets_covered[k][t_id] = thread_implementation.covered[k];
    dev_credible_sets_lengths[k][t_id] =
    thread_implementation.mcmc_credible_sets[k][1] - thread_implementation.mcmc_credible_sets[k][0];
  }
}
