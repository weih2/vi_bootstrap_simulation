// #define SEED_RUNIFORM 0

__device__ double device_random_uniform(int thread_id){
  curandState state;
  // seed = 12345
  curand_init(clock64(), thread_id, 0, &state);
  return curand_uniform(&state);
}
