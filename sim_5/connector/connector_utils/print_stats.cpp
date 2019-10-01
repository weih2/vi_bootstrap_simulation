void connector::print_stats(){
  for(int k = 0; k < N_CENTERS; k++){
    printf("%f ", coverage_rates[k]);
  }
  printf("\n");
  for(int k = 0; k < N_CENTERS; k++){
    printf("%f ", credible_sets_lengths_means[k]);
  }
  printf("\n");
  for(int k = 0; k < N_CENTERS; k++){
    printf("%f ", credible_sets_lengths_vars[k]);
  }
  printf("\n");
}
