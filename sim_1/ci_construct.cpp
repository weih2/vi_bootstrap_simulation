void cavi_implementation::ci_construct(){
  
  double** m_v = new double*[data.g_vars.K];
  bootstrap_ci = new double*[data.g_vars.K];

  // rearrange estimates
  for(int k = 0; k < data.g_vars.K; k++){
    m_v[k] = new double[n_bootstrap_samples];
    bootstrap_ci[k] = new double[2];
    for(int b = 0; b < n_bootstrap_samples; b++){
      m_v[k][b] = weighted_est[b].m[k];
    }

    gsl_sort(m_v[k], 1, n_bootstrap_samples);
    // get ci
    bootstrap_ci[k][0] = gsl_stats_quantile_from_sorted_data(
      m_v[k], 1, n_bootstrap_samples, (1 + data.b_vars.confidence)/2.
    );

    bootstrap_ci[k][0] = 2 * est.m[k] - bootstrap_ci[k][0];

    bootstrap_ci[k][1] = gsl_stats_quantile_from_sorted_data(
      m_v[k], 1, n_bootstrap_samples, (1 - data.b_vars.confidence)/2.
    );

    bootstrap_ci[k][1] = 2 * est.m[k] - bootstrap_ci[k][1];
  }

}
