void fixed_latent_vars_generation(latent_vars l_vars, double delta){
  l_vars.mu[0] = 0;
  for(int k = 1; k < K; k++){
    l_vars.mu[k] = l_vars.mu[k - 1] + delta;
  }
}
