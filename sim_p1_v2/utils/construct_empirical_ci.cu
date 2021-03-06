void bridge::construct_empirical_ci(){
  cudaMemcpy(host_empirical_mu, device_empirical_mu,
    sizeof(double) * N_CLUSTERS * n_experiments, cudaMemcpyDeviceToHost);

  // cudaMemcpy(is_outlier, device_is_outlier,
  //  sizeof(int) * n_experiments, cudaMemcpyDeviceToHost);

  // estimate standard deviation
  double avg_m[N_CLUSTERS];
  double sd_m_est[N_CLUSTERS];
  for(int k = 0; k < N_CLUSTERS; k++){
    avg_m[k] = 0;
    sd_m_est[k] = 0;
    for(int n = 0; n < n_experiments; n++){
      avg_m[k] += host_empirical_mu[k*n_experiments + n];
    }

    avg_m[k] /= double(n_experiments);

    for(int n = 0; n < n_experiments; n++){
      sd_m_est[k] +=
        (host_empirical_mu[k*n_experiments + n] - avg_m[k])
        *
        (host_empirical_mu[k*n_experiments + n] - avg_m[k]);
    }

    sd_m_est[k] /= double(n_experiments - 1);
    sd_m_est[k] = sqrt(sd_m_est[k]);

  }
    // detect outlier
  for(int n = 0; n < n_experiments; n++){
    is_outlier[n] = 0;
    for(int k = 0; k < N_CLUSTERS; k++){
      // if(fabs(host_empirical_mu[k*n_experiments + n] - avg_m[k]) > sd_m_est[k] * 3 ){
      if(0){
        is_outlier[n] = 1;
        n_outliers ++;
        break;
      }
    }
  }

  for(int k = 0; k < N_CLUSTERS; k++){
    avg_m[k] = 0;
    sd_m_est[k] = 0;
    for(int n = 0; n < n_experiments; n++){
      if(is_outlier[n]) continue;
      avg_m[k] += host_empirical_mu[k*n_experiments + n];
    }

    avg_m[k] /= double(n_experiments - n_outliers);

    for(int n = 0; n < n_experiments; n++){
      if(is_outlier[n]) continue;
      sd_m_est[k] +=
        (host_empirical_mu[k*n_experiments + n] - avg_m[k])
        *
        (host_empirical_mu[k*n_experiments + n] - avg_m[k]);
    }

    sd_m_est[k] /= double(n_experiments - n_outliers - 1);
    sd_m_est[k] = sqrt(sd_m_est[k]);

      empirical_ci[k][0] = host_dev_settings.l_vars.mu[k] -
        (*host_dev_settings.ci_quantile) * sd_m_est[k];
      empirical_ci[k][1] = host_dev_settings.l_vars.mu[k] +
        (*host_dev_settings.ci_quantile) * sd_m_est[k];
  }
}
