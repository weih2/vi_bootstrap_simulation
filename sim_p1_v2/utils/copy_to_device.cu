void bridge::init_device(){
  // allocate memory
  cudaMalloc((void**)&device_dev_settings.l_vars.mu, K * sizeof(double));
  cudaMalloc((void**)&device_dev_settings.l_vars.c, n_samples * sizeof(int));
  cudaMalloc((void**)&device_dev_settings.epsilon, sizeof(double));
  cudaMalloc((void**)&device_dev_settings.max_n_iter, sizeof(int));
  cudaMalloc((void**)&device_dev_settings.bootstrap_confidence, sizeof(double));
  cudaMalloc((void**)&device_dev_settings.ci_quantile, sizeof(double));

  cudaMalloc((void**)&device_dev_settings.data_count, sizeof(int));
  cudaMemset(device_dev_settings.data_count, 0, sizeof(int));

  cudaMalloc((void**)&device_vwlb_cs_covered,
    sizeof(int) * K * n_bootstrap_samples);
  cudaMemset(device_vwlb_cs_covered, 0, sizeof(int) * size_t(K * n_bootstrap_samples));
  cudaMalloc((void**)&device_vp_cs_covered,
    sizeof(int) * K * n_bootstrap_samples);
  cudaMemset(device_vp_cs_covered, 0, sizeof(int) * size_t(K * n_bootstrap_samples));

  cudaMalloc((void**)&device_empirical_mu,
    sizeof(double) * n_experiments * K);
}

void bridge::clean_device(){
  cudaFree(device_dev_settings.l_vars.mu);
  cudaFree(device_dev_settings.l_vars.c);
  cudaFree(device_dev_settings.epsilon);
  cudaFree(device_dev_settings.max_n_iter);
  cudaFree(device_dev_settings.bootstrap_confidence);
  cudaFree(device_dev_settings.ci_quantile);
  cudaFree(device_dev_settings.data_count);
  cudaFree(device_vwlb_cs_covered);
  cudaFree(device_vp_cs_covered);
  cudaFree(device_vp_cs_covered);
  cudaFree(device_empirical_mu);
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
