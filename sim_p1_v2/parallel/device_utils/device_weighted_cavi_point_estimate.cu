__device__ void device_cavi_implementation::device_weighted_cavi_point_estimate(){
  double old_elbo;

  for(; b_count < n_bootstrap_samples; b_count++){
    device_generate_weights();
    device_weighted_cavi_point_estimate_update();

    for(int n_step = 1; n_step <= device_max_n_iter; n_step++){
      old_elbo = elbo;
      device_weighted_cavi_point_estimate_update();
      if((elbo - old_elbo) < device_epsilon) break;
    }

    thrust::sort_by_key(thrust::device, m_b, m_b + N_CLUSTERS, s2_b);
    // gsl_sort2(est.m, 1, est.s2, 1, data.g_vars.N_CLUSTERS);

    for(int k = 0; k < N_CLUSTERS; k++){
      map_mu[k][b_count] = m_b[k];
    }
  }

  device_is_outlier();
}
