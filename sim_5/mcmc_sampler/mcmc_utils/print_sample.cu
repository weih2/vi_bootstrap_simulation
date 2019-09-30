__device__ void device_mcmc_implementor::print_sample(int &n_samp){
  printf("sample #%d: ", n_samp);
  for(int k = 0; k < N_CENTERS; k++) printf("%f ", mu_samples[k][n_samp]);
  printf("\n");
}
