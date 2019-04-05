__device__ device_cavi_implementation::device_cavi_implementation(device_settings dev_settings, int t_id){
  // copy local variables
  for(int k = 0; k < K; k++){
    mu[k] = dev_settings.l_vars.mu[k];
  }

  for(int i = 0; i < n_samples; i++){
    c[i] = dev_settings.l_vars.c[i];
  }

  // copy settings
  device_max_n_iter = *dev_settings.max_n_iter;
  device_epsilon = *dev_settings.epsilon;
  device_bootstrap_confidence = *dev_settings.bootstrap_confidence;
  device_ci_quantile = *dev_settings.ci_quantile;

  // generate data
  thread_id = t_id;
  b_count = 0;

  // set random state
  curandState state;
  curand_init(thread_id + n_experiments * (*dev_settings.data_count), 0, 0, &state);
  if(t_id == 0) (*dev_settings.data_count)++;

  // initialize estimates
  for(int k = 0; k < K; k++){
    m[k] = curand_normal_double(&state) * sqrt(double(sigma_2));
    s2[k] = sigma_2;
    for(int i = 0; i < n_samples; i++){
      phi[i][k] = 1/double(K);
    }
  }

  for(int i = 0; i < n_samples; i++){
    // let variance be 1
    x[i] = mu[c[i]] + curand_normal_double(&state);
  }
}
