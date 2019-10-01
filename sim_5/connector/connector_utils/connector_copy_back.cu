void connector::connector_copy_back(){
  for(int k = 0; k < N_CENTERS; k++){
    cudaMemcpy(credible_sets_lengths[k], device_credible_sets_lengths[k],
      sizeof(double) * N_EXPERIMENTS, cudaMemcpyDeviceToHost);
    cudaMemcpy(credible_sets_covered[k], device_credible_sets_covered[k],
      sizeof(int) * N_EXPERIMENTS, cudaMemcpyDeviceToHost);
  }
}
