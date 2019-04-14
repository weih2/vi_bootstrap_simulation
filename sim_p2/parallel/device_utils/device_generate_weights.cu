__device__ void cavi_implementor::generate_weights(){
  curandState state;
  curand_init(thread_id, b_count + 1, 0, &state);

  double sum_weights = 0;
  for(int i = 0; i < n_samples; i++){
    sum_weights += (
      weights[i] = -log(curand_uniform_double(&state))
    );
  }

  for(int i = 0; i < n_samples; i++){
    weights[i] *= n_samples/sum_weights;
  }

  // by the way we can initialize estimates
}
