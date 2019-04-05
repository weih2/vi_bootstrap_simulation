using namespace std;

void bridge::save_result(ostream& result_stream){
    auto timenow = chrono::system_clock::to_time_t(chrono::system_clock::now());

    result_stream << "result at: " << ctime(&timenow) << endl;
    // global pars
    result_stream << "# categories: " << K << endl;
    result_stream << "variance of cluster center: " << sigma_2 << endl;
    result_stream << "# samples: " << n_samples << endl;
    result_stream << "# bootstrap samples: " << n_bootstrap_samples << endl << endl;

    // saving true value
    result_stream << "true mu's are:" << endl;
    for(int k = 0; k < K; k++){
      result_stream << host_dev_settings.l_vars.mu[k] << " ";
    }
    result_stream << endl;

    result_stream << "confidence level: " <<
      *host_dev_settings.bootstrap_confidence << endl;

    // coverate
    result_stream << "number of experiments: " << n_experiments << endl;

    for(int k = 0; k < K; k++){
      result_stream << "variational wlb confidence set coverage for parameter " << k + 1 << " :" << vwlb_cs_covered_counts[K] << endl;
    }

    for(int k = 0; k < K; k++){
      result_stream << "variational confidence set coverage for parameter " << k + 1 << " :" << vp_cs_covered_counts[k] << endl;
    }

    for(int k = 0; k < K; k++){
      result_stream << "empirical confidence set coverage for parameter " << k + 1 << " :" << empirical_ci_covered_counts[k] << endl;
    }

    result_stream << endl;
}
