__device__ void device_cavi_implementation::device_vwlb_cs_construct(){
  for(int k = 0; k < N_CLUSTERS; k++){
    thrust::sort(thrust::device, map_mu_clean[k], map_mu_clean[k] + n_bootstrap_samples - n_outliers);
    vwlb_cs[k][0] = sample_quantile_from_sorted_data(
      map_mu_clean[k], (n_bootstrap_samples - n_outliers) , (1 - device_bootstrap_confidence)/2.
    );


    vwlb_cs[k][1] = sample_quantile_from_sorted_data(
      map_mu_clean[k], (n_bootstrap_samples - n_outliers), (1 + device_bootstrap_confidence)/2.
    );

    vwlb_cs2[k][0] = 2 * m[k] - vwlb_cs[k][1];
    vwlb_cs2[k][1] = 2 * m[k] - vwlb_cs[k][0];
  }
}
