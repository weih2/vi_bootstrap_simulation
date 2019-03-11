using namespace std;

void cavi_implementation::save_result(ostream& result_stream){
  auto timenow = chrono::system_clock::to_time_t(chrono::system_clock::now());

  result_stream << "result at: " << ctime(&timenow) << endl;
  // global pars
  result_stream << "# categories: " << data.g_vars.K << endl;
  result_stream << "variance of cluster center: " << data.g_vars.sigma_2 << endl;
  result_stream << "# samples: " << data.g_vars.n_samples << endl;
  result_stream << "# bootstrap samples: " << n_bootstrap_samples << endl << endl;

  // saving true value
  result_stream << "true mu's are:" << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << data.l_vars.mu[k] << " ";
  }
  result_stream << endl;

  result_stream << "confidence level: " << data.b_vars.confidence << endl;

  // coverate
  result_stream << "number of experiments: " << n_experiments << endl;
  result_stream << "ci coverage: " << ci_covered << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << "ci coverage for parameter " << k + 1 << " :" << ci_covered_each[k] << endl;
  }
  result_stream << "cs coverage: " << cs_covered << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << "cs coverage for parameter " << k + 1 << " :" << cs_covered_each[k] << endl;
  }

  // ci and cs
  result_stream << "confidence interval from last iteration: " << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << "[ " << bootstrap_ci[k][0] << ", " << bootstrap_ci[k][1] << "]" << endl;
  }
  result_stream << "credit set from last iteration: " << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << "[ " << credit_set[k][0] << ", " << credit_set[k][1] << "]" << endl;
  }
  result_stream << "empirical confidence interval:" << endl;
  for(int k = 0; k < data.g_vars.K; k++){
    result_stream << "[ " << empirical_ci[k][0] << ", " << empirical_ci[k][1] << "]" << endl;
  }
  result_stream << endl;
}
