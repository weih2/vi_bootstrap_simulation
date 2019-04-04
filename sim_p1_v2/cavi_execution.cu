__global__ void cavi_execute(bridge bg){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= n_experiments) return;
  printf("%f\n", (bg.device_dev_settings).l_vars.mu[0]);
  device_cavi_implementation thread_implementation(bg.device_dev_settings, t_id);
  printf("my id is %d\n", thread_implementation.thread_id);
  // obtain point estimates
  thread_implementation.device_cavi_point_estimate();
  for(int k = 0; k < K; k++){
    (bg -> device_empirical_mu)[t_id + k * n_experiments] = thread_implementation.m[k];
  }
}
