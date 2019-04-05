__global__ void cavi_execute(bridge bg){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= n_experiments) return;
  device_cavi_implementation thread_implementation(bg.device_dev_settings, t_id);
  // obtain point estimates
  thread_implementation.device_cavi_point_estimate();

  thread_implementation.device_weighted_cavi_point_estimate();
  thread_implementation.device_vwlb_cs_construct();
  thread_implementation.device_vp_cs_construct();

  for(int k = 0; k < K; k++){
    (bg.device_empirical_mu)[t_id + k * n_experiments] = thread_implementation.m[k];
    if(t_id == 0){
      printf("ci is [%f,%f]\n", thread_implementation.vwlb_cs[k][0],
       thread_implementation.vwlb_cs[k][1]);
    }
  }
}
