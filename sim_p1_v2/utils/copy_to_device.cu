void bridge::init_device(){
  // allocate memory
  cudaMalloc((void**)&device_dev_settings.l_vars.mu, K * sizeof(double));
  cudaMalloc((void**)&device_dev_settings.l_vars.c, n_samples * sizeof(int));
  cudaMalloc((void**)&device_dev_settings.epsilon, sizeof(double));
  cudaMalloc((void**)&device_dev_settings.max_n_iter, sizeof(int));
  cudaMalloc((void**)&device_dev_settings.bootstrap_confidence, sizeof(double));
  cudaMalloc((void**)&device_dev_settings.ci_quantile, sizeof(double));

  cudaMalloc((void**)&device_vwlb_cs_covered,
    sizeof(int) * K * n_bootstrap_samples);
  cudaMalloc((void**)&device_vp_cs_covered,
    sizeof(int) * K * n_bootstrap_samples);

  cudaMalloc((void**)&device_empirical_mu,
    sizeof(double) * n_experiments * K);
}

void bridge::copy_to_device(){
  cudaMemcpy(device_dev_settings.l_vars.mu, host_dev_settings.l_vars.mu,
    K * sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(device_dev_settings.l_vars.c, host_dev_settings.l_vars.c,
    n_samples * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(device_dev_settings.epsilon, host_dev_settings.epsilon,
    sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(device_dev_settings.max_n_iter, host_dev_settings.max_n_iter,
    sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(device_dev_settings.bootstrap_confidence, host_dev_settings.bootstrap_confidence,
    sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(device_dev_settings.ci_quantile, host_dev_settings.ci_quantile,
    sizeof(double), cudaMemcpyHostToDevice);
}
