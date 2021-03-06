void bridge::count_coverage(){
  // waiting for execution of threads
  cudaMemcpy(vwlb_cs_covered, device_vwlb_cs_covered,
    sizeof(int) * N_CLUSTERS * n_experiments, cudaMemcpyDeviceToHost);

  cudaMemcpy(vwlb_cs2_covered, device_vwlb_cs2_covered,
    sizeof(int) * N_CLUSTERS * n_experiments, cudaMemcpyDeviceToHost);

  cudaMemcpy(vp_cs_covered, device_vp_cs_covered,
    sizeof(int) * N_CLUSTERS * n_experiments, cudaMemcpyDeviceToHost);

  // copy the centers back also
  cudaMemcpy(vp_first_centers, dev_vp_first_centers,
    sizeof(double) * n_experiments, cudaMemcpyDeviceToHost);
  cudaMemcpy(vwlb_first_centers, dev_vwlb_first_centers,
    sizeof(double) * n_experiments, cudaMemcpyDeviceToHost);
  cudaMemcpy(vwlb2_first_centers, dev_vwlb2_first_centers,
    sizeof(double) * n_experiments, cudaMemcpyDeviceToHost);

  construct_empirical_ci();

  for(int k = 0; k < N_CLUSTERS; k++){
    vp_cs_covered_counts[k] = 0;
    vwlb_cs_covered_counts[k] = 0;
    vwlb_cs2_covered_counts[k] = 0;

    for(int n = 0; n < n_experiments; n++){
      if(is_outlier[n]) continue;

      vp_cs_covered_counts[k]  += vp_cs_covered[k * n_experiments + n];
      vwlb_cs_covered_counts[k] += vwlb_cs_covered[k * n_experiments + n];
      vwlb_cs2_covered_counts[k] += vwlb_cs2_covered[k * n_experiments + n];

      if((empirical_ci[k][0] < host_empirical_mu[k*n_experiments + n])
        && (empirical_ci[k][1] > host_empirical_mu[k*n_experiments + n])
      ) empirical_ci_covered_counts[k]++;
    }
  }
}
