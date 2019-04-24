__device__ void device_cavi_implementation::device_weighted_cavi_point_estimate(){
  double old_elbo;

  double alternative_elbo;

  for(; b_count < n_bootstrap_samples; b_count++){
    device_generate_weights();
    device_weighted_cavi_point_estimate_update(0);

    for(int n_step = 1; n_step <= device_max_n_iter; n_step++){
      old_elbo = elbo;
      device_weighted_cavi_point_estimate_update(0);
      if((elbo - old_elbo) < device_epsilon) break;
    }

    alternative_elbo = elbo;

    // run another cavi from different start point
    for(int k = 0; k < K; k++){
      s2_b[k] = sigma_2;
      for(int i = 0; i < n_samples; i++){
        phi_b[i][k] = 1/double(K);
      }
    }

    device_weighted_cavi_point_estimate_update(1);

    for(int n_step = 1; n_step <= device_max_n_iter; n_step++){
      old_elbo = elbo;
      device_weighted_cavi_point_estimate_update(1);
      if((elbo - old_elbo) < device_epsilon) break;
    }

    if(elbo < alternative_elbo){
      // first experiment is better
      thrust::sort_by_key(thrust::device, m_b, m_b + K, s2_b);
      // gsl_sort2(est.m, 1, est.s2, 1, data.g_vars.K);

      for(int k = 0; k < K; k++){
        map_mu[k][b_count] = m_b[k];
      }
    }else{
      thrust::sort_by_key(thrust::device, m_b + K, m_b + 2 * K, s2_b);
      // gsl_sort2(est.m, 1, est.s2, 1, data.g_vars.K);

      for(int k = 0; k < K; k++){
        map_mu[k][b_count] = m_b[k + K];
      }
    }

  }
}
