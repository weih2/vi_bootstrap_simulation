__global__ void cavi_execute(bridge* bg){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= n_experiments) return;
  printf("my id is %d", t_id);
  device_cavi_implementation thread_implementation(bg->device_dev_settings, t_id);

  // obtain point estimates
  thread_implementation.device_cavi_point_estimate();
  for(int k = 0; k < K; k++){
    (bg -> device_empirical_mu)[t_id + k * n_experiments] = thread_implementation.m[k];
  }
}
