// take inversion of sample covariance matrices
// which is approximation of Fisher information
void connector::invert_fi_back(){
  // initialize a handle
  cublasHandle_t handle;
  cublasCreate(&handle);

  // useless arrays..
  int *p_arr, *info_arr;
  // temporarily store fisher info estimate
  double *device_fi[N_EXPERIMENTS], *device_fi_;

  cudaMalloc((void**)&p_arr, N_CENTERS * N_EXPERIMENTS * sizeof(int));
  cudaMalloc((void**)&info_arr, N_CENTERS * N_EXPERIMENTS * sizeof(int));
  // exist in global memory
  cudaMalloc((void**)&device_fi_,
    N_CENTERS * N_CENTERS * N_EXPERIMENTS * sizeof(double));

  for(int n = 0; n < N_EXPERIMENTS; n++)
    device_fi[n] = device_fi_ + N_CENTERS * N_CENTERS * n;


  // LU decompositions
  cublasDgetrfBatched(handle, N_CENTERS, dev_fi_inv_,
    N_CENTERS, p_arr, info_arr, N_EXPERIMENTS);
  // inversion
  cublasDgetriBatched(handle, N_CENTERS, dev_fi_inv_, N_CENTERS, p_arr,
    device_fi, N_CENTERS, info_arr, N_EXPERIMENTS);

  // copy back to host
  cudaMemcpy(fi_est, device_fi_,
    N_CENTERS * N_CENTERS * N_EXPERIMENTS * sizeof(double), cudaMemcpyDeviceToHost);

  cudaFree(p_arr);
  cudaFree(info_arr);
  cudaFree(device_fi_);
  cublasDestroy(handle);
}
