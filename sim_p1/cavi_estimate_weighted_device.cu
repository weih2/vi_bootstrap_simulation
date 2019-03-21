void cavi_implementation::device_init_cavi_weighted(){
  // copy global setting to device
  cudaMalloc((void**)&(device_g_vars.device_K), sizeof(int));
  cudaMemcpy(device_g_vars.device_K, &data.g_vars.K, sizeof(int), cudaMemcpyHostToDevice);
  cudaMalloc((void**)&(device_g_vars.device_sigma_2), sizeof(double));
  cudaMemcpy(device_g_vars.device_sigma_2, &data.g_vars.sigma_2, sizeof(double),
    cudaMemcpyHostToDevice);
  cudaMalloc((void**)&(device_g_vars.device_n_samples), sizeof(int));
  cudaMemcpy(davice_g_vars.device_n_samples, &data.g_vars.n_samples, sizeof(int),
    cudaMemcpyHostToDevice);

  cudaMalloc((void**)&device_n_boostrap_samples, sizeof(int));
  cudaMemcpy(device_n_boostrap_samples, &n_bootstrap_samples,
    sizeof(int), cudaMemcpyHostToDevice);
  // allocate memory for weights using global memory temporarily
  cudaMalloc((void**)&device_weights,
    n_bootstrap_samples * data.g_vars.n_samples * sizeof(double));
  // allocate memory for device data
  cudaMalloc((void**)&device_x, data.g_vars.n_samples * sizeof(double));
  // allocate memory for device latent variables
  cudaMalloc((void**)&(device_est.device_m),
    n_bootstrap_samples * data.g_vars.K * sizeof(double));
  cudaMalloc((void**)&(device_est.device_s2),
    n_bootstrap_samples * data.g_vars.K * sizeof(double));
  cudaMalloc((void**)&(device_est.device_phi),
    n_bootstrap_samples * data.g_vars.n_samples * data.g_vars.K * sizeof(double));
  // allocate another block of memory for rearranged latent variables
  cudaMalloc((void**)&(device_est.device_m_transpose),
    n_bootstrap_samples * data.g_vars.K * sizeof(double));
}

/*
The storage is in the spirit of
[n_bootstrap][n_sample][n_variable]
for all variables
except for device_est.device_m_transpose
*/

void cavi_implementation::cavi_weighted_copy_back(){
  // copy the latent variables back to ram
}

__device__
void cavi_implementation::device_generate_weights(int exp_id, int thread_id){
  // device_weights
  curandState state;
  curand_init(exp_id, thread_id, 0, &state);

  for(int n_sample = 0; n_sample < *device_n_boostrap_samples; n_sample++){
    device_weights[(*device_n_bootstrap_samples) * tread_id + ] 
      = curand_uniform(&state);
  }
}

__device__
void cavi_implementation::device_cavi_estimate_weighted(){

}

// for this method we only need vb posterior mean m_k
__global__
void cavi_implementation::device_cavi_bootstrap_update_single(){
  int tread_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(tread_id >= n_bootstrap_samples) return;

  device_generate_weights(tread_id);

  double device_elbo;
  double device_old_elbo;

  for(){

  }
  thrust::sort_by_key();
  // rearrange
  for(){

  }
}

void cavi_implementation::device_cavi_bootstrap_update(){
  // yeah only one line
  device_cavi_bootstrap_update_single<<<64, 64>>>();
}
