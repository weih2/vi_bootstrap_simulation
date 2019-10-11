__device__ device_mcmc_implementor::fi_inv_estimate(){
  double fi_inv_estimation[N_CENTERS * N_CENTERS]

  for(int k1 = 0; k1 < N_CENTERS; k1++){
    for(int k2 = 0; k2 <= k1; k2++){
      fi_inv_estimation[k1 * N_CENTERS + k2] = cal_covariance(mu_samples[k1], mu_samples[k2],
        N_MCMC_SAMPLES);
      fi_inv_estimation[k2 * N_CENTERS + k1] = fi_inv_estimation[k1 * N_CENTERS + k2];
    }
  }

  cublasHandle_t cnpHandle;
  cublasCreate(&cnpHandle);
  int pivot_arr[N_CENTERS];
  int info_cblas;

  // fxxking hard to use
  cublasDgetrfBatched(cnpHandle, N_CENTERS, fi_inv_estimation,
     N_CENTERS, pivot_arr, &info_cblas, 1);

  cublasDgetriBatched(cnpHandle, N_CENTERS, fi_inv_estimation, N_CENTERS, pivot_arr,
    fi_estimation, N_CENTERS, &info_cblas, 1);
}
