void device_mcmc_implementor::gen_mcmc_samples(){
  int cat_sample[N_OBS];
  double mu_sample0[K];
  double cat_prob[K];
  double cat_prob_normalizer;

  double cat_mu_sum[K];
  double cat_mu_count[K];

  double ru;
  double rn;

  double sample_var;
  int sample_count = 0;

  //////// draw a random initial value
  for(int i = 0; i < N_OBS; i++)
    cat_sample[i] = floor(random_uniform() * K);

  for(int k = 0; k < K; k++)
    mu_sample0[k] = 0;

  //////// burn-in period
  for(int step = 0; step < N_BURN_IN + N_MCMC_SAMPLES * N_INTER; step++){
    if(step % 100 == 0 ) cout << step << endl;
    for(int k = 0; k < K; k++){
      cat_mu_sum[k] = 0;
      cat_mu_count[k] = 0;
    }
    // sample categorical categorical probabilities
    for(int i = 0; i < N_OBS; i++){

      cat_prob_normalizer = 0;
      for(int k = 0; k < K; k++){
        cat_prob_normalizer += ( cat_prob[k] = exp(- (obs[i] - mu_sample0[k]))/2. );
      }
      ru = random_uniform() / cat_prob_normalizer;
      for(int k = 0; k < K; k++){
        if(ru < cat_prob[k]){
          cat_sample[i] = k;
          cat_mu_count[k]++;
          cat_mu_sum[k] += obs[i];
          break;
        }
        ru -= cat_prob[k];
      }
    }

    // sample mu
    for(int k = 0; k < K; k++){
      sample_var = PRIOR_SIGMA2/(1 + PRIOR_SIGMA2 * cat_mu_count[k]);
      rn = random_normal();
      mu_sample0[k] = rn * sqrt(sample_var) + sample_var * cat_mu_sum[k];
    }
    // gsl_sort(mu_sample0, 1, K);

    // take sample if
    if(step > N_BURN_IN){
      if(step % N_INTER == 0){
        for(int k = 0; k < K; k++){
          mu_samples[k][sample_count] = mu_sample0[k];
        }
      }
      sample_count ++;
    }
  }
}
