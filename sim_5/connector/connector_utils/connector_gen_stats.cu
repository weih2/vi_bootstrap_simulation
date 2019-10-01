void connector::gen_stats(){
  for(int k = 0; k < N_CENTERS; k++){
    // count coverage rates
    coverage_rates[k] = 0;
    for(int n = 0; n < N_EXPERIMENTS; n++){
      coverage_rates[k] += credible_sets_covered[k][n];
    }
    coverage_rates[k] /= double(N_EXPERIMENTS);

    // mean and var stats
    credible_sets_lengths_means[k] = cal_mean(credible_sets_lengths[k], N_EXPERIMENTS);
    credible_sets_lengths_vars[k] = cal_variance(credible_sets_lengths[k], N_EXPERIMENTS);
  }
}
