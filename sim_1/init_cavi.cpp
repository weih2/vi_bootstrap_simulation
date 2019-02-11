cavi_estimation init_cavi(simulation_data& dat){
  cavi_estimation est;

  est.m = new double[dat.global_vars.K];
  est.s2 = new double[dat.global_vars.K];

  est.phi = new double*[dat.global_vars.n_samples];
  for(int i = 0; i < dat.global_vars.n_samples; i++){
    est.phi[i] = new double[dat.global_vars.K];
  }
}
