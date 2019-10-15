void bridge::save_result(){
  printf("number of outliers %d\n", n_outliers);

  for(int k = 0; k < N_CLUSTERS; k++){
    printf("variational wlb confidence set coverage for parameter %d: %d\n",
      k + 1, vwlb_cs_covered_counts[k]);
  }

  for(int k = 0; k < N_CLUSTERS; k++){
    printf("variational confidence set coverage for parameter %d: %d\n",
      k + 1, vp_cs_covered_counts[k]);
  }

  for(int k = 0; k < N_CLUSTERS; k++){
    printf("empirical confidence set coverage for parameter %d: %d\n",
      k + 1, empirical_ci_covered_counts[k]);
  }
}
