__device__ void cavi_implementor::generate_y(){
  // set random state
  curandState state;
  curand_init(-1, thread_id, 0, &state);

  for(i = 0; i < n_samples; i++){
    y[i] = 0;
    for(k = 0; k < n_parameters; k++){
      y[i] += true_pars.beta[k] * x[i * n_parameters + k];
    }
    y[i] += curand_normal_double(&state) * sqrt(true_pars.sigma_2);
  }
}
