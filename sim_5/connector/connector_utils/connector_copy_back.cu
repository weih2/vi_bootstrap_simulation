void connector::connector_copy_back(){
  for(int k = 0; k < N_CENTERS; k++){
    cudaMemcpy(credible_sets_lengths[k], device_credible_sets_lengths + k * N_EXPERIMENTS,
      sizeof(double) * N_EXPERIMENTS, cudaMemcpyDeviceToHost);
    cudaMemcpy(credible_sets_covered[k], device_credible_sets_covered + k * N_EXPERIMENTS,
      sizeof(int) * N_EXPERIMENTS, cudaMemcpyDeviceToHost);
  }
  cudaMemcpy(fi_inv, dev_fi_inv,
    sizeof(double) * N_CENTERS * N_CENTERS * N_EXPERIMENTS, cudaMemcpyDeviceToHost);

  cudaMemcpy(first_center, dev_first_center, sizeof(double) * N_EXPERIMENTS, cudaMemcpyDeviceToHost);
}
