__global__ void cavi_execute(bridge bg){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= n_experiments) return;
  device_cavi_implementation thread_implementation(bg.device_dev_settings, t_id);
}
