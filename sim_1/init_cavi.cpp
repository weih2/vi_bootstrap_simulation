cavi_estimation init_cavi(simulation_data& dat){
  cavi_estimation est;

  est.m = new double[dat.g_vars.K]();
  est.s2 = new double[dat.g_vars.K]();

  est.phi = new double*[dat.g_vars.n_samples];
  for(int i = 0; i < dat.g_vars.n_samples; i++){
    est.phi[i] = new double[dat.g_vars.K]();
  }

  // draw from prior
  for(int k = 0; k < dat.g_vars.K; k++){
    est.m[k] = random_normal();
    est.s2[k] = 1;
    for(int i = 0; i < dat.g_vars.n_samples; i++){
      est.phi[i][k] = 1/double(dat.g_vars.K);
    }
  }

  return est;
}
