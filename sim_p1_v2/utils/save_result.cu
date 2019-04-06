void bridge::save_result(){
  for(int k = 0; k < K; k++){
    printf("variational wlb confidence set coverage for parameter %d: %d\n",
      k + 1, vwlb_cs_covered_counts[k]);
  }

  for(int k = 0; k < K; k++){
    printf("variational confidence set coverage for parameter %d: %d\n",
      k + 1, vp_cs_covered_counts[k]);
  }

  for(int k = 0; k < K; k++){
    printf("empirical confidence set coverage for parameter %d: %d\n",
      k + 1, empirical_ci_covered_counts[k]);
  }
}
