void cavi_implementation::empirical_ci_construct(){
  if(n_experiments != history_map[0].size()) cout << "something wrong" << endl;

  empirical_ci = new double*[data.g_vars.K];
  double** m_v = new double*[data.g_vars.K];

  for(int k = 0; k < data.g_vars.K; k++){
    m_v[k] = new double[n_experiments];
    empirical_ci[k] = new double[2];

    for(int n_e = 0; n_e < n_experiments; n_e++){
      m_v[k][n_e] =  history_map[k].front();
      history_map[k].pop();
    }

    gsl_sort(m_v[k], 1, n_experiments);
    empirical_ci[k][0] = gsl_stats_quantile_from_sorted_data(
      m_v[k], 1, n_experiments, (1 - data.b_vars.confidence)/2.
    );

    empirical_ci[k][1] = gsl_stats_quantile_from_sorted_data(
      m_v[k], 1, n_experiments, (1 + data.b_vars.confidence)/2.
    );
  }
  delete[] history_map;
}
