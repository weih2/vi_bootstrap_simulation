void fixed_latent_vars_generation(latent_vars l_vars, double delta){
  l_vars.mu[0] = - floor(N_CLUSTERS/2) * delta;
  for(int k = 1; k < N_CLUSTERS; k++){
    l_vars.mu[k] = l_vars.mu[k-1] + delta;
  }
}
