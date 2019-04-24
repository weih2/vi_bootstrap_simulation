__device__ void device_cavi_implementation::device_vwlb_cs2_construct(){
  double b_sample_variance;

  for(int k = 0; k < K; k++){
    b_sample_variance = cal_variance(map_mu[k], n_bootstrap_samples);
    vwlb_cs2[k][0] = m[k] - device_ci_quantile * sqrt(b_sample_variance);
    vwlb_cs2[k][1] = m[k] + device_ci_quantile * sqrt(b_sample_variance);
  }
  
  if(thread_id == 0){
    printf("the bootstrap sample for first map is\n", );
    for(int n_b = 0; n_b < n_bootstrap_samples; n_b++){
      printf("%f ", map_mu[0][n_b]);
    }
    printf("\n");
  }
}
