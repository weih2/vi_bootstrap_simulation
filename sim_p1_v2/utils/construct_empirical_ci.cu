void bridge::construct_empirical_ci(){
  for(int k = 0; k < K; k++){
    thrust::sort(thrust::host, host_empirical_mu + k * n_experiments,
      host_empirical_mu + (k + 1) * n_experiments);

    empirical_ci[k][0] = sample_quantile_from_sorted_data(
        host_empirical_mu + k * n_experiments,
        n_experiments, (1 - *host_dev_settings.bootstrap_confidence)/2.
    );

    empirical_ci[k][1] = sample_quantile_from_sorted_data(
        host_empirical_mu + k * n_experiments,
        n_experiments, (1 + *host_dev_settings.bootstrap_confidence)/2.
    );
  }
}
