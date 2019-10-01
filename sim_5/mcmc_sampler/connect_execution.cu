__global__ void connect_to_execution
(double delta, double *dev_credible_sets_lengths[], int *dev_credible_sets_covered[]){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= N_EXPERIMENTS) return;

  if(t_id == 1) printf("\n");

  device_mcmc_implementor thread_implementation(delta, t_id);
  thread_implementation.gen_obs();
  thread_implementation.gen_mcmc_samples();
  if(t_id == 1) printf("\n");
  thread_implementation.construct_mcmc_credible_sets();

  if(t_id == 1) {
    printf("\n");
    thread_implementation.print_sample(N_BURN_IN);
  }

  for(int k = 0; k < N_CENTERS; k++){
    dev_credible_sets_covered[k][t_id] = thread_implementation.covered[k];
    dev_credible_sets_lengths[k][t_id] =
    thread_implementation.mcmc_credible_sets[k][1] - thread_implementation.mcmc_credible_sets[k][0];
  }
}
