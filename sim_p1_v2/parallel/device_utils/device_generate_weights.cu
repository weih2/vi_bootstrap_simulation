__device__ void device_cavi_implementation::device_generate_weights(){
  curandState state;
  curand_init(thread_id, b_count, 0, &state);

  double sum_weights = 0;
  for(int i = 0; i < n_samples; i++){
    sum_weights += (
      weights[i] = -log(curand_uniform_double(&state))
    );
  }

  for(int i = 0; i < n_samples; i++){
    weights[i] /= sum_weights;
  }

  // by the way we can initialize estimates
  for(int k = 0; k < g_vars.K; k++){
    m_b[k] = curand_normal_double(&state) * sqrt(g_vars.sigma_2);
    s2_b[k] = sigma_2;
    for(int i = 0; i < n_samples; i++){
      phi_b[k] = 1/double(K);
    }
  }
}
