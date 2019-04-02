void cavi_implementation::ci_construct(){
  for(int k = 0; k < data.g_vars.K; k++){
    // gsl_sort(m_v[k], 1, n_bootstrap_samples);
    thrust::sort(host_m_transpose + k*n_bootstrap_samples,
      host_m_transpose + (k+1)*n_bootstrap_samples);

    // get ci
    bootstrap_ci[k][0] = sample_quantile_from_sorted_data(
      host_m_transpose + k*n_bootstrap_samples,
      n_bootstrap_samples, (1 + data.b_vars.confidence)/2.
    );
    std::cout << *(host_m_transpose + k*n_bootstrap_samples) << std::endl;

    bootstrap_ci[k][0] = 2 * est.m[k] - bootstrap_ci[k][0];

    bootstrap_ci[k][1] = sample_quantile_from_sorted_data(
      host_m_transpose + k*n_bootstrap_samples,
      n_bootstrap_samples, (1 - data.b_vars.confidence)/2.
    );

    bootstrap_ci[k][1] = 2 * est.m[k] - bootstrap_ci[k][1];
  }
}
