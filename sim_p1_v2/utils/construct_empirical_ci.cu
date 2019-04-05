void bridge::construct_empirical_ci(){
  cudaMemcpy(host_empirical_mu, device_empirical_mu,
    sizeof(double) * K * n_experiments, cudaMemcpyDeviceToHost);

  // estimate standard deviation
  double sum_m[K];
  double variance_m_est[K];
  for(int k = 0; k < K; k++){
    sum_m[k] = 0;
    variance_m_est[k] = 0;
    for(int n = 0; n < n_experiments; n++)
      sum_m[k] += host_empirical_mu[k*n_experiments + n];
    for(int n = 0; n < n_experiments; n++)
      variance_m_est[k] +=
        (host_empirical_mu[k*n_experiments + n] - sum_m[k]/double(n_experiments))
        *
        (host_empirical_mu[k*n_experiments + n] - sum_m[k]/double(n_experiments));
    variance_m_est[k] /= double(n_experiments - 1);

    empirical_ci[k][0] = host_dev_settings.l_vars.mu[k] -
      (*host_dev_settings.ci_quantile) * sqrt(variance_m_est[k]);
    empirical_ci[k][1] = host_dev_settings.l_vars.mu[k] +
      (*host_dev_settings.ci_quantile) * sqrt(variance_m_est[k]);
  }
}
