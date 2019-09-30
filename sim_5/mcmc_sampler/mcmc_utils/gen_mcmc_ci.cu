__device__ device_mcmc_implementor::construct_mcmc_credible_sets(){
  for(k = 0; k < N_CENTERS; k++){
    thrust::sort(thrust::device, mu_samples[k], mu_samples[k] + N_MCMC_SAMPLES);
    mcmc_credible_sets[k][0] =
    sample_quantile_from_sorted_data(mu_samples[k], N_MCMC_SAMPLES, 0.025);
    mcmc_credible_sets[k][1] =
    sample_quantile_from_sorted_data(mu_samples[k], N_MCMC_SAMPLES, 0.975);
    if((mcmc_credible_sets[k][0] <= mu[k])&&(mcmc_credible_sets[k][1] >= mu[k])) covered[k] = 1;
    else covered[k] = 0;
  }
}
