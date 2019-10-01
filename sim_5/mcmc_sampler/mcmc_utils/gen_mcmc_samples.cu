__device__ void device_mcmc_implementor::gen_mcmc_samples(){
  curandState state;
  curand_init(thread_id, 2, 0, &state);

  double mu_sample0[N_CENTERS];
  double cat_prob[N_CENTERS];
  double cat_prob_normalizer;

  double cat_mu_sum[N_CENTERS];
  double cat_mu_count[N_CENTERS];

  double ru;
  double rn;

  double sample_var;
  int sample_count = 0;

  //////// draw a random initial value
  for(int k = 0; k < N_CENTERS; k++)
    mu_sample0[k] = 0;

  //////// burn-in period
  for(int step = 0; step < N_BURN_IN + N_MCMC_SAMPLES * N_INTER; step++){
    for(int k = 0; k < N_CENTERS; k++){
      cat_mu_sum[k] = 0;
      cat_mu_count[k] = 0;
    }
    // sample categorical categorical probabilities
    for(int i = 0; i < N_OBS; i++){
      cat_prob_normalizer = 0;
      for(int k = 0; k < N_CENTERS; k++){
        cat_prob_normalizer += ( cat_prob[k] = exp(- (obs[i] - mu_sample0[k]))/2. );
      }
      ru = curand_uniform_double(&state);
      ru /= cat_prob_normalizer;
      for(int k = 0; k < N_CENTERS; k++){
        if(ru < cat_prob[k]){
          cat_mu_count[k]++;
          cat_mu_sum[k] += obs[i];
          if(thread_id == 0) printf("%d \n", cat_mu_count[2]);
          break;
        }
        ru -= cat_prob[k];
      }
    }


    // sample mu
    for(int k = 0; k < N_CENTERS; k++){
      sample_var = PRIOR_SIGMA2/(1 + PRIOR_SIGMA2 * cat_mu_count[k]);
      rn = curand_normal_double(&state);
      mu_sample0[k] = rn * sqrt(sample_var) + sample_var * cat_mu_sum[k];
    }
    thrust::sort(thrust::device, mu_sample0, mu_sample0 + N_CENTERS);
    // take sample if
    if(step >= N_BURN_IN){
      if(step % N_INTER == 0){
        for(int k = 0; k < N_CENTERS; k++){
          mu_samples[k][sample_count] = mu_sample0[k];
        }
        sample_count ++;
      }
    }
  }
}
