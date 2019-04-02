void cavi_implementation::device_init_cavi_weighted(){
  // copy global setting to device
  cudaMalloc((void**)&(device_store.device_g_vars.device_K), sizeof(int));
  cudaMemcpy(device_store.device_g_vars.device_K, &data.g_vars.K, sizeof(int), cudaMemcpyHostToDevice);
  cudaMalloc((void**)&(device_store.device_g_vars.device_sigma_2), sizeof(double));
  cudaMemcpy(device_store.device_g_vars.device_sigma_2, &data.g_vars.sigma_2, sizeof(double),
    cudaMemcpyHostToDevice);
  cudaMalloc((void**)&(device_store.device_g_vars.device_n_samples), sizeof(int));
  cudaMemcpy(device_store.device_g_vars.device_n_samples, &data.g_vars.n_samples, sizeof(int),
    cudaMemcpyHostToDevice);

  cudaMalloc((void**)&device_store.device_n_bootstrap_samples, sizeof(int));
  cudaMemcpy(device_store.device_n_bootstrap_samples, &n_bootstrap_samples,
    sizeof(int), cudaMemcpyHostToDevice);
  // allocate memory for weights using global memory temporarily
  cudaMalloc((void**)&device_store.device_weights,
    n_bootstrap_samples * data.g_vars.n_samples * sizeof(double));
  // allocate memory for device data
  cudaMalloc((void**)&device_store.device_x, data.g_vars.n_samples * sizeof(double));
  // allocate memory for device latent variables
  cudaMalloc((void**)&(device_store.device_est.device_m),
    n_bootstrap_samples * data.g_vars.K * sizeof(double));
  cudaMalloc((void**)&(device_store.device_est.device_s2),
    n_bootstrap_samples * data.g_vars.K * sizeof(double));
  cudaMalloc((void**)&(device_store.device_est.device_phi),
    n_bootstrap_samples * data.g_vars.n_samples * data.g_vars.K * sizeof(double));
  // allocate another block of memory for rearranged latent variables
  cudaMalloc((void**)&(device_store.device_est.device_m_transpose),
    n_bootstrap_samples * data.g_vars.K * sizeof(double));
  // allocate for device elbo
  cudaMalloc((void**)(&device_store.device_elbo), n_bootstrap_samples * sizeof(double));

  // cavi settings
  cudaMalloc((void**)(&device_store.device_epsilon), sizeof(double));
  cudaMemcpy(device_store.device_epsilon, &epsilon, sizeof(double), cudaMemcpyHostToDevice);
  cudaMalloc((void**)(&device_store.device_max_n_iter), sizeof(int));
  cudaMemcpy(device_store.device_max_n_iter, &max_n_iter, sizeof(int), cudaMemcpyHostToDevice);

  cudaMalloc((void**)(&device_store.device_exp_id), sizeof(int));
}

/*
The storage is in the spirit of
[n_bootstrap][n_sample][n_variable]
for all variables
except for device_store.device_est.device_m_transpose
*/

void cavi_implementation::cavi_weighted_copy_back(){
  // copy the latent variables back to ram
  cudaMemcpy(host_m_transpose, device_store.device_est.device_m_transpose,
     n_bootstrap_samples * data.g_vars.K * sizeof(double),
     cudaMemcpyDeviceToHost);
}

void cavi_implementation::device_cavi_bootstrap_update(){
  // yeah only one line
  cudaMemcpy(device_store.device_exp_id, &n_experiments, sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(device_store.device_x, data.x, data.g_vars.n_samples * sizeof(double) , cudaMemcpyHostToDevice);
  std::cout << "running..." << std::endl;
  device_cavi_bootstrap_update_single<<<64, 64>>>(device_store);
  cavi_weighted_copy_back();
}
