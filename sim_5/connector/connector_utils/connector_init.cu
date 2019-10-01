connector::connector(){
  for(int k = 0; k < N_CENTERS; k++){
    cudaMalloc((void**)& (device_credible_sets_lengths[k]), N_EXPERIMENTS * sizeof(double));
    cudaMalloc((void**)& (device_credible_sets_covered[k]), N_EXPERIMENTS * sizeof(int));
  }
}

connector::~connector(){
  for(int k = 0; k < N_CENTERS; k++){
    cudaFree(device_credible_sets_lengths[k]);
    cudaFree(device_credible_sets_covered[k]);
  }
}
