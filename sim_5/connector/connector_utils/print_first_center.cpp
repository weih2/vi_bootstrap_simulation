void connector::print_first_center(){
  printf("The first centers are\n");
  for(int i = 0; i < N_EXPERIMENTS; i++)
    printf("%f ", first_center[i]);
}
