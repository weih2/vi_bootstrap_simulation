void bridge::init_device(){
  cudaMalloc((void**)&(device_dev_settings.g_pars), sizeof(global_pars));
  cudaMalloc((void**)&(device_dev_settings.x), n * p * sizeof(double));
}

void bridge::copy_to_device(){
  cudaMemcpy(device_dev_settings.g_pars, host_dev_settings.g_pars,
    sizeof(global_pars), cudaMemcpyHostToDevice);
  cudaMemcpy(device_dev_settings.x, host_dev_settings.x,
    sizeof(double) * n * p, cudaMemcpyHostToDevice);
}

void bridge::clean_device(){
  cudaFree(device_dev_settings.g_pars);
  cudaFree(device_dev_settings.x);
}
