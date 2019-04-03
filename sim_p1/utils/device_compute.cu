__device__
void device_generate_weights(int exp_id, int thread_id, device_storage device_store){
  // device_store.device_weights
  curandState state;
  curand_init(exp_id, thread_id, 0, &state);

  for(int n_sample = 0; n_sample < *device_store.device_n_bootstrap_samples; n_sample++){
    device_store.device_weights[(*device_store.device_n_bootstrap_samples) * thread_id + n_sample]
      // = curand_uniform_double(&state);
      = 1;
  }
}

__device__  // update estimate per thread per loop
void device_cavi_estimate_weighted(int thread_id, device_storage device_store){
  device_store.device_elbo[thread_id] = 0;
  double sum_phi;
  int phi_index;
  int par_index;
  int weight_index;

  for(int i = 0; i < *device_store.device_g_vars.device_n_samples; i++){
    sum_phi = 0;
    weight_index = (*device_store.device_n_bootstrap_samples) * thread_id + i;

    for(int k = 0; k < *device_store.device_g_vars.device_K; k++){
      phi_index = thread_id
        * (*device_store.device_g_vars.device_n_samples) * (*device_store.device_g_vars.device_K)
        + i
        * (*device_store.device_g_vars.device_K)
        + k;
      par_index = thread_id * (*device_store.device_g_vars.device_K) + k;

      sum_phi += (
        (device_store.device_est.device_phi)[phi_index] =
          exp((device_store.device_x)[i] * (device_store.device_est.device_m)[par_index]
            - ((device_store.device_est.device_s2)[par_index]
            + (device_store.device_est.device_m)[par_index]*(device_store.device_est.device_m)[par_index])/2.)
      );
    }
    for(int k = 0; k < *device_store.device_g_vars.device_K; k++){
      phi_index = thread_id
        * (*device_store.device_g_vars.device_n_samples) * (*device_store.device_g_vars.device_K)
        + i
        * (*device_store.device_g_vars.device_K)
        + k;
      par_index = thread_id * (*device_store.device_g_vars.device_K) + k;

      device_store.device_est.device_phi[phi_index] /= sum_phi;
      device_store.device_elbo[thread_id] -=
        device_store.device_est.device_phi[phi_index]
        * device_store.device_weights[weight_index]
        * log(device_store.device_est.device_phi[phi_index]);
    }
  }

  double product_x_phi;
  for(int k = 0; k < *device_store.device_g_vars.device_K; k++){
    sum_phi = 0;
    product_x_phi = 0;

    par_index = thread_id * (*device_store.device_g_vars.device_K) + k;

    for(int i = 0; i < *device_store.device_g_vars.device_n_samples; i++){
      phi_index = thread_id
        * (*device_store.device_g_vars.device_n_samples) * (*device_store.device_g_vars.device_K)
        + i
        * (*device_store.device_g_vars.device_K)
        + k;
      weight_index = (*device_store.device_n_bootstrap_samples) * thread_id + i;
      sum_phi += device_store.device_est.device_phi[phi_index] * device_store.device_weights[weight_index];
      product_x_phi += device_store.device_x[i] * device_store.device_est.device_phi[phi_index]
        * device_store.device_weights[weight_index];
    }
    
    device_store.device_est.device_s2[par_index] = 1 / (1/(*device_store.device_g_vars.device_sigma_2) + sum_phi);
    device_store.device_est.device_m[par_index] = product_x_phi * device_store.device_est.device_s2[par_index];

    device_store.device_elbo[thread_id] +=
      - (product_x_phi * product_x_phi + 1) * device_store.device_est.device_s2[par_index]
        /(2*(*device_store.device_g_vars.device_sigma_2))
      + log(device_store.device_est.device_s2[par_index])/2.;
    for(int i = 0; i < *device_store.device_g_vars.device_n_samples; i++){
      phi_index = thread_id
        * (*device_store.device_g_vars.device_n_samples) * (*device_store.device_g_vars.device_K)
        + i
        * (*device_store.device_g_vars.device_K)
        + k;
      weight_index = (*device_store.device_n_bootstrap_samples) * thread_id + i;

      device_store.device_elbo[thread_id] += device_store.device_est.device_phi[phi_index] * device_store.device_weights[weight_index]
        *(device_store.device_x[i] * (-device_store.device_x[i]/2. + device_store.device_est.device_m[par_index])
        - (device_store.device_est.device_s2[par_index]
          + device_store.device_est.device_m[par_index]*device_store.device_est.device_m[par_index])/2.);

    }
  }
}

__global__
void device_cavi_bootstrap_update_single(device_storage device_store){
  int thread_id = threadIdx.x + blockIdx.x * blockDim.x;
  if(thread_id >= *device_store.device_n_bootstrap_samples) return;

  const int par_index_start = thread_id * (*device_store.device_g_vars.device_K);
  const int par_index_end = (thread_id + 1) * (*device_store.device_g_vars.device_K);

  device_generate_weights((*device_store.device_exp_id), thread_id, device_store);
  double device_old_elbo;

  for(int n_iter = 0; n_iter < *device_store.device_max_n_iter; n_iter++){
    device_old_elbo = device_store.device_elbo[thread_id];
    device_cavi_estimate_weighted(thread_id, device_store);
    if(device_store.device_elbo[thread_id] - device_old_elbo < *device_store.device_epsilon) break;
  }

  thrust::sort_by_key(thrust::device, device_store.device_est.device_m + par_index_start,
    device_store.device_est.device_m + par_index_end,
    device_store.device_est.device_s2 + par_index_start);

  // rearrange
  for(int par_index = 0; par_index < (*device_store.device_g_vars.device_K); par_index++){
    device_store.device_est.device_m_transpose[par_index * (*device_store.device_n_bootstrap_samples) + thread_id]
      = device_store.device_est.device_m[par_index_start + par_index];
  }
}
