__device__ void device_cavi_implementation::device_is_outlier(){
  double b_sample_sds[N_CLUSTERS];
  n_outliers = 0;

  for(int k = 0; k < N_CLUSTERS; k++){
    b_sample_sds[k] = sqrt(cal_variance(map_mu[k], n_bootstrap_samples));
  }

  // is_outlier = 1;
  for(int b = 0; b < n_bootstrap_samples; b++){
    is_outlier[b] = 0;
    for(int k = 0; k < N_CLUSTERS; k++){
      if(0){
        is_outlier[b] = 1;
        n_outliers ++;
        break;
      }
    }
  }

  int b_clean = 0;
  for(int b = 0; b < n_bootstrap_samples; b++){
    if(!is_outlier[b]){
      for(int k = 0; k < N_CLUSTERS; k++){
        map_mu_clean[k][b_clean] = map_mu[k][b];
      }
      b_clean ++;
    }
  }

  return;
}
