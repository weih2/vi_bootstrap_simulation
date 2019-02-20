void cavi_implementation::empirical_ci_construct(){
  if(n_experiments != history_est.size()) cout << "something wrong" << endl;

  empirical_ci = new double*[data.g_vars.K];

  cavi_estimation est_temp;
  double** m_v = new double*[data.g_vars.K];

  for(int k = 0; k < data.g_vars.K; k++){
    m_v[k] = new double[history_est.size()];
    empirical_ci[k] = new double[2];
  }

  for(int n_e = 0; n_e < n_experiments; n_e++){
    est_temp = history_est.front();
    history_est.pop();

    for(int k = 0; k < data.g_vars.K; k++){
      m_v[k][n_e] = est_temp.m[k];
    }
  }

  for(int k = 0; k < data.g_vars.K; k++){
    gsl_sort(m_v[k], 1, n_experiments);
    empirical_ci[k][0] = gsl_stats_quantile_from_sorted_data(
      m_v[k], 1, n_experiments, (1 - data.b_vars.confidence)/2.
    );

    empirical_ci[k][1] = gsl_stats_quantile_from_sorted_data(
      m_v[k], 1, n_experiments, (1 + data.b_vars.confidence)/2.
    );
  }
}
