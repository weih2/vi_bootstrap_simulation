connector::connector(){
  for(int k = 0; k < N_CENTERS; k++){
    cudaMalloc((void**)& device_credible_sets_lengths, N_CENTERS * N_EXPERIMENTS * sizeof(double));
    cudaMalloc((void**)& device_credible_sets_covered, N_CENTERS * N_EXPERIMENTS * sizeof(int));
  }
  cudaMalloc((void**)& dev_fi_inv, N_CENTERS * N_CENTERS * N_EXPERIMENTS * sizeof(double));
  for(int n = 0; n < N_EXPERIMENTS; n++)
    dev_fi_inv_[n] = dev_fi_inv + N_CENTERS * N_CENTERS * n;
}

connector::~connector(){
    printf("%f\n", dev_fi_inv_[0][0]);
    cudaFree(device_credible_sets_lengths);
    cudaFree(device_credible_sets_covered);
    cudaFree(dev_fi_inv_);
}
