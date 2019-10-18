void bridge::print_centers(){
  printf("vp centers are: \n");
  for(int i = 0; i < n_experiments; i++){
    printf("%f ", vp_first_centers[i]);
  }
  printf("\n");

  printf("vwlb centers are: \n");
  for(int i = 0; i < n_experiments; i++){
    printf("%f ", vwlb_first_centers[i]);
  }
  printf("\n");

  printf("vwlb2 centers are: \n");
  for(int i = 0; i < n_experiments; i++){
    printf("%f ", vwlb2_first_centers[i]);
  }
  printf("\n");
}

void bridge::print_lengths(){
  printf("vp lengths stat: \n");
  for(int k = 0; k < N_CLUSTERS; k++){
    printf("mean is: %f\n", cal_mean(vp_cs_lengths + k * n_experiments, n_experiments));
    printf("sd is: %f\n", sqrt(cal_variance(vp_cs_lengths + k * n_experiments, n_experiments)));
  }
  printf("\n");

  printf("vwlb lengths stat: \n");
  for(int k = 0; k < N_CLUSTERS; k++){
    printf("mean is: %f\n", cal_mean(vwlb_cs_lengths + k * n_experiments, n_experiments));
    printf("sd is: %f\n", sqrt(cal_variance(vwlb_cs_lengths + k * n_experiments, n_experiments)));
  }
  printf("\n");
}
