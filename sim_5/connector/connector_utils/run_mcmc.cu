void connector::run_mcmc(double delta){
  connect_to_execution<<<32,32>>>(delta, device_credible_sets_lengths, device_credible_sets_covered,
    dev_fi_inv_);
  cudaDeviceSynchronize();
  connector_copy_back();
  cudaDeviceSynchronize();
  invert_fi_back();
  cudaDeviceSynchronize();
}
