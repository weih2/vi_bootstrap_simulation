// #define SEED_RUNIFORM 0

__device__
inline double device_random_uniform(int thread_id, int exp_id){
  curandState state;
  // seed = 12345
  // i hope this will work for each thread
  // that is, each thread has a private static inited indicator
  static int inited = 0;
  if(!inited){
    curand_init(exp_id, thread_id, 0, &state);
    inited = 1;
  }
  return curand_uniform(&state);
}
