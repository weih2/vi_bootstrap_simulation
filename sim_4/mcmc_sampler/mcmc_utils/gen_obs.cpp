void device_mcmc_implementor::gen_obs(){
  int cat;

  for(int i = 0; i < N_OBS; i++){
    cat = floor(random_uniform() * K);
    obs[i] = mu[cat] + random_normal();
  }
}
