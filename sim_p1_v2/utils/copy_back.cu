void bridge::copy_back(){
  cudaMemcpy(host_empirical_mu, device_empirical_mu,
    sizeof(double) * K * n_experiments, cudaMemcpyDeviceToHost);

  cudaMemcpy(vwlb_cs_covered, device_vwlb_cs_covered,
    sizeof(int) * K * n_experiments, cudaMemcpyDeviceToHost);

  cudaMemcpy(vp_cs_covered, device_vp_cs_covered,
    sizeof(int) * K * n_experiments, cudaMemcpyDeviceToHost);
}
