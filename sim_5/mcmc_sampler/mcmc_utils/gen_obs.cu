__device__ void device_mcmc_implementor::gen_obs(){
  int cat;
  curandState state;
  curand_init(thread_id, 1, 0, &state);

  for(int i = 0; i < N_OBS; i++){
    cat = floor(curand_uniform_double(&state) * K);
    obs[i] = mu[cat] + curand_normal_double(&state);
  }
}
