using namespace std;

void bridge::save_settings(ostream& result_stream){
  auto timenow = chrono::system_clock::to_time_t(chrono::system_clock::now());

  result_stream << "simulation starts at: " << ctime(&timenow) << endl;
  // global pars
  result_stream << "# categories: " << K << endl;
  result_stream << "variance of cluster center: " << sigma_2 << endl;
  result_stream << "# samples: " << n_samples << endl;
  result_stream << "# bootstrap samples: " << n_bootstrap_samples << endl << endl;

  result_stream << "confidence level: " <<
    *host_dev_settings.bootstrap_confidence << endl;

  // coverate
  result_stream << "number of experiments: " << n_experiments << endl;
}
