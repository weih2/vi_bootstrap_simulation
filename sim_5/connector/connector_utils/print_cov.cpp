void connector::print_cov(){
  int cov_count = 0;
  while(cov_count < N_CENTERS * N_CENTERS * N_EXPERIMENTS){
    for(int k = 0; k < N_CENTERS; k++){
      cov_count++;
      printf("%f ", fi_inv[k]);
    }
    printf("\n");
  }
}
