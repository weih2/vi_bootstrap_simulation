__device__ void device_mcmc_implementor::fi_inv_estimate(){

  for(int k1 = 0; k1 < N_CENTERS; k1++){
    for(int k2 = 0; k2 <= k1; k2++){
      fi_inv_estimation[k1 * N_CENTERS + k2] = cal_covariance(mu_samples[k1], mu_samples[k2],
        N_MCMC_SAMPLES);
      fi_inv_estimation[k2 * N_CENTERS + k1] = fi_inv_estimation[k1 * N_CENTERS + k2];
    }
  }
}
