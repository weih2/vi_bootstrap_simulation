using namespace std;

void cavi_implementation::save_result(ostream& result_stream){

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
  result_stream << "cs coverage: " << cs_covered << endl;
}
