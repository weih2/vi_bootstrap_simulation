cavi_estimation init_cavi(simulation_data& dat){
  cavi_estimation est;

  // set everything to 0
  est.m = new double[dat.g_vars.K]();
  est.s2 = new double[dat.g_vars.K]();

  est.phi = new double*[dat.g_vars.n_samples];
  for(int i = 0; i < dat.g_vars.n_samples; i++){
    est.phi[i] = new double[dat.g_vars.K]();
  }
}
