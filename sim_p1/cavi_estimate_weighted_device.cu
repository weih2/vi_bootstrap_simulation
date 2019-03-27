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
  // allocate for device elbo
  cudaMalloc((void**)(&device_elbo), n_bootstrap_samples * sizeof(double));

  // cavi settings
  cudaMalloc((void**)(&device_epsilon), sizeof(double));
  cudaMemcpy(device_epsilon, &epsilon, sizeof(dobule), cudaMemcpyHostToDevice);
  cudaMalloc((void**)(&device_max_n_iter), sizeof(int));
  cudaMemcpy(device_max_n_iter, &max_n_iter, sizeof(int), cudaMemcpyHostToDevice);

  cudaMalloc((void**)(&device_exp_id), sizeof(int));
}

/*
The storage is in the spirit of
[n_bootstrap][n_sample][n_variable]
for all variables
except for device_est.device_m_transpose
*/

void cavi_implementation::cavi_weighted_copy_back(){
  // copy the latent variables back to ram
  cudaMemcpy(host_m_transpose, device_est.device_m_transpose,
     n_bootstrap_samples * data.g_vars.K * sizeof(double),
     cudaMemcpyDeviceToHost);
}

__device__
void cavi_implementation::device_generate_weights(int exp_id, int thread_id){
  // device_weights
  curandState state;
  curand_init(exp_id, thread_id, 0, &state);

  for(int n_sample = 0; n_sample < *device_n_boostrap_samples; n_sample++){
    device_weights[(*device_n_bootstrap_samples) * tread_id + n_sample]
      = curand_uniform(&state);
  }
}

__device__  // update estimate per thread per loop
void cavi_implementation::device_cavi_estimate_weighted(int thread_id){
  device_elbo[tread_id] = 0;
  double sum_phi;
  int phi_index;
  int par_index;
  int weight_index;

  for(int i = 0; i < *davice_g_vars.device_n_samples; i++){
    sum_phi = 0;
    weight_index = (*device_n_bootstrap_samples) * tread_id + i;

    for(int k = 0; k < *device_g_vars.device_K; k++){
      phi_index = tread_id
        * (*davice_g_vars.device_n_samples) * (*device_g_vars.device_K)
        + i
        * (*device_g_vars.device_K)
        + k;
      par_index = tread_id * (*device_g_vars.device_K) + k;

      sum_phi += (
        device_est.device_phi[par_index] =
          exp(device_x[i] * device_est.device_m[par_index]
            - (device_est.device_s2[par_index]
            + device_est.device_m[par_index]*device_est.device_m[par_index])/2.)
      );
    }
    for(int k = 0; k < *device_g_vars.device_K; k++){
      phi_index = tread_id
        * (*davice_g_vars.device_n_samples) * (*device_g_vars.device_K)
        + i
        * (*device_g_vars.device_K)
        + k;
      par_index = tread_id * (*device_g_vars.device_K) + k;

      device_est.device_phi[phi_index] /= sum_phi;
      device_elbo[tread_id] -=
        device_est.device_phi[phi_index]
        * device_weights[weight_index]
        * log(device_est.device_phi[phi_index]);
    }
  }

  double product_x_phi;
  for(int k = 0; k < *device_g_vars.device_K; k++){
    sum_phi = 0;
    product_x_phi = 0;

    par_index = tread_id * (*device_g_vars.device_K) + k;

    for(int i = 0; i < *davice_g_vars.device_n_samples; i++){
      phi_index = tread_id
        * (*davice_g_vars.device_n_samples) * (*device_g_vars.device_K)
        + i
        * (*device_g_vars.device_K)
        + k;
      weight_index = (*device_n_bootstrap_samples) * tread_id + i;
      sum_phi += device_est.device_phi[phi_index] * device_weights[weight_index];
      product_x_phi += device_x[i] * device_est.device_phi[phi_index]
        * device_weights[weight_index];
    }
    device_est.device_s2[par_index] = 1 / (1/(*device_g_vars.device_sigma_2) + sum_phi);
    device_est.device_m[par_index] = product_x_phi * device_est.device_s2[par_index];

    device_elbo[tread_id] +=
      - (product_x_phi * product_x_phi + 1) * device_est.device_s2[par_index]
        /(2*(*device_g_vars.device_sigma_2))
      + log(device_est.device_s2[par_index])/2.;
    for(int i = 0; i < data.g_vars.n_samples; i++){
      phi_index = tread_id
        * (*davice_g_vars.device_n_samples) * (*device_g_vars.device_K)
        + i
        * (*device_g_vars.device_K)
        + k;
      weight_index = (*device_n_bootstrap_samples) * tread_id + i;

      device_elbo[tread_id] += device_est.device_phi[phi_index] * device_weights[weight_index]
        *(device_x[i] * (-device_x[i]/2. + device_est.device_m[par_index])
        - (device_est.device_s2[par_index]
          + device_est.device_m[par_index]*device_est.device_m[par_index])/2.);
    }
  }
}

// for this method we only need vb posterior mean m_k
__global__
void cavi_implementation::device_cavi_bootstrap_update_single(){
  int tread_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(tread_id >= *device_n_boostrap_samples) return;

  const int par_index_start = tread_id * (*device_g_vars.device_K);
  const int par_index_end = (tread_id + 1) * (*device_g_vars.device_K);

  device_generate_weights((*device_exp_id), tread_id);
  double device_old_elbo;

  for(int n_iter = 0; n_iter < *device_max_n_iter; n_iter++){
    device_old_elbo = device_elbo[thread_id];
    device_cavi_estimate_weighted(tread_id);
    if(device_elbo[thread_id] - device_old_elbo < *device_epsilon) break;
  }

  thrust::sort_by_key(device_est.device_m + par_index_start,
    device_est.device_m + par_index_end,
    device_est.device_s2 + par_index_start);

  // rearrange
  for(int par_index = 0; par_index < (*device_g_vars.device_K); par_index++){
    device_est.device_m_transpose[+ tread_id]
      = device_est.device_m[par_index_start + par_index * (*device_n_boostrap_samples)];
  }
}

void cavi_implementation::device_cavi_bootstrap_update(){
  // yeah only one line
  cudaMemcpy(device_exp_id, &n_experiments, sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(device_x, data.x, data.g_vars.n_samples * sizeof(int) , cudaMemcpyHostToDevice);
  device_cavi_bootstrap_update_single<<<64, 64>>>();
}
