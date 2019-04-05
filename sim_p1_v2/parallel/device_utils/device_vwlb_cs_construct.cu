__device__ void device_cavi_implementation::device_vwlb_cs_construct(){
  for(int k = 0; k < K; k++){
    thrust::sort(thrust::device, map_mu[k], map_mu[k] + n_bootstrap_samples);
    vwlb_cs[k][0] = sample_quantile_from_sorted_data(
      map_mu[k], n_bootstrap_samples, (1 + device_bootstrap_confidence)/2.
    );
    vwlb_cs[k][0] = 2 * m[k] - vwlb_cs[k][0];

    vwlb_cs[k][1] = sample_quantile_from_sorted_data(
      map_mu[k], n_bootstrap_samples, (1 - device_bootstrap_confidence)/2.
    );
    vwlb_cs[k][1] = 2 * m[k] - vwlb_cs[k][1];
  }
}
