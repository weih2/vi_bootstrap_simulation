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
