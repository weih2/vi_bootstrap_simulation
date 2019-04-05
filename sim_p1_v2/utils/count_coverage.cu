void bridge::count_coverage(){
  // waiting for execution of threads
  cudaMemcpy(vwlb_cs_covered, device_vwlb_cs_covered,
    sizeof(int) * K * n_experiments, cudaMemcpyDeviceToHost);

  cudaMemcpy(vp_cs_covered, device_vp_cs_covered,
    sizeof(int) * K * n_experiments, cudaMemcpyDeviceToHost);

  for(int k = 0; k < K; k++){
    for(int n = 0; n < n_experiments; n++){
      vp_cs_covered_counts[k]  += vp_cs_covered[k * n_experiments + n];
      vwlb_cs_covered_counts[k] += vwlb_cs_covered[k * n_experiments + n];
    }
  }
}
