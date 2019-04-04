__device__ void device_cavi_implementation::device_cavi_point_estimate(){
  device_cavi_point_estimate_update();
  double old_elbo;

  for(int n_step = 1; n_step <= max_n_iter; n_step++){
    old_elbo = elbo;
    device_cavi_point_estimate_update();
    if((elbo - old_elbo) < epsilon) break;
  }

  thrust::sort_by_key(thrust::device, m, m + K, s2);
  // gsl_sort2(est.m, 1, est.s2, 1, data.g_vars.K);

  for(int k = 0; k < data.g_vars.K; k++){
    map_mu[b_count - 1][k] = m[k];
  }
}
