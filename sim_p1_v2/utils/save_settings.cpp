using namespace std;

void bridge::save_settings(ostream& result_stream){
  auto timenow = chrono::system_clock::to_time_t(chrono::system_clock::now());

  result_stream << "simulation starts at: " << ctime(&timenow) << endl;
  // global pars
  result_stream << "# categories: " << N_CLUSTERS << endl;
  result_stream << "variance of cluster center: " << sigma_2 << endl;
  result_stream << "# samples: " << n_samples << endl;
  result_stream << "# bootstrap samples: " << n_bootstrap_samples << endl << endl;

  result_stream << "confidence level: " <<
    *host_dev_settings.bootstrap_confidence << endl;

  result_stream << "true mu's are:" << endl;
  for(int k = 0; k < N_CLUSTERS; k++){
    result_stream << host_dev_settings.l_vars.mu[k] << " ";
  }
  result_stream << endl;
  // coverate
  result_stream << "number of experiments: " << n_experiments << endl;
}
