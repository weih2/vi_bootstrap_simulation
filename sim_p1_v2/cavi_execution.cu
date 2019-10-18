__global__ void cavi_execute(bridge bg, int bootstrap_execution){
  int t_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(t_id >= n_experiments) return;
  device_cavi_implementation thread_implementation(bg.device_dev_settings, t_id);
  // obtain point estimates
  thread_implementation.device_cavi_point_estimate();

  if(bootstrap_execution != 0){
    thread_implementation.device_weighted_cavi_point_estimate();
    thread_implementation.device_vwlb_cs_construct();
    // thread_implementation.device_vwlb_cs2_construct();
    thread_implementation.device_vp_cs_construct();

    /*
    bg.dev_vp_first_centers[t_id] = cal_mean(thread_implementation.vp_cs[0], 2);
    bg.dev_vwlb_first_centers[t_id] = cal_mean(thread_implementation.vwlb_cs[0], 2);
    bg.dev_vwlb2_first_centers[t_id] = cal_mean(thread_implementation.vwlb_cs2[0], 2);
    */

    for(int k = 0; k < N_CLUSTERS; k++){
      if((thread_implementation.vp_cs[k][0] < thread_implementation.mu[k])
        &&(thread_implementation.vp_cs[k][1] > thread_implementation.mu[k]))
        bg.device_vp_cs_covered[k * n_experiments + t_id] = 1;
        else bg.device_vp_cs_covered[k * n_experiments + t_id] = 0;
      if((thread_implementation.vwlb_cs[k][0] < thread_implementation.mu[k])
        &&(thread_implementation.vwlb_cs[k][1] > thread_implementation.mu[k]))
        bg.device_vwlb_cs_covered[k * n_experiments + t_id] = 1;
        else bg.device_vwlb_cs_covered[k * n_experiments + t_id] = 0;
      if((thread_implementation.vwlb_cs2[k][0] < thread_implementation.mu[k])
        &&(thread_implementation.vwlb_cs2[k][1] > thread_implementation.mu[k]))
        bg.device_vwlb_cs2_covered[k * n_experiments + t_id] = 1;
        else bg.device_vwlb_cs2_covered[k * n_experiments + t_id] = 0;
    }
  }

  // bg.device_is_outlier[t_id] = thread_implementation.is_outlier;

  if(bootstrap_execution == 2){  // consider length
    for(int k = 0; k < N_CLUSTERS; k++){
      bg.device_vwlb_cs_lengths[k * n_experiments + t_id] =
        thread_implementation.vwlb_cs[k][1] - thread_implementation.vwlb_cs[k][0];
      bg.device_vwlb_cs2_lengths[k * n_experiments + t_id] =
        thread_implementation.vwlb_cs2[k][1] - thread_implementation.vwlb_cs2[k][0];
      bg.device_vp_cs_lengths[k * n_experiments + t_id] =
        thread_implementation.vp_cs[k][1] - thread_implementation.vp_cs[k][0];
    }
  }

  // in a non-bootstrap implementation this is all we need
  for(int k = 0; k < N_CLUSTERS; k++){
    (bg.device_empirical_mu)[t_id + k * n_experiments] = thread_implementation.m[k];
  }
}
