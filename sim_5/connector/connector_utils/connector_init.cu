connector::connector(){
  for(int k = 0; k < N_CENTERS; k++){
    cudaMalloc((void**)& device_credible_sets_lengths, N_CENTERS * N_EXPERIMENTS * sizeof(double));
    cudaMalloc((void**)& device_credible_sets_covered, N_CENTERS * N_EXPERIMENTS * sizeof(int));
  }
  // cudaMalloc((void**)& dev_fi_inv, N_CENTERS * N_CENTERS * N_EXPERIMENTS * sizeof(double));
}

connector::~connector(){
    cudaFree(device_credible_sets_lengths);
    cudaFree(device_credible_sets_covered);
    // cudaFree(dev_fi_inv);
}
