using namespace std;

cavi_implementation::cavi_implementation(simulation_data& dat){
  data = dat;
  est = init_cavi(dat);

  cavi_estimate();
}

void cavi_implementation::cavi_estimate(){
  // setting constant
  elbo = 0;

  // update phi
  double sum_phi;
  for(int i = 0; i < data.g_vars.n_samples; i++){
    sum_phi = 0;
    for(int k = 0; k < data.g_vars.K; k++){
      sum_phi += (
        est.phi[i][k] = exp(data.x[i] * est.m[k] - (est.s2[k] + est.m[k]*est.m[k])/2.)
      );
    }
    for(int k = 0; k < data.g_vars.K; k++){
      est.phi[i][k] /= sum_phi;
      elbo += est.phi[i][k] *
        (data.x[i] * est.m[k] - (est.s2[k] + est.m[k]*est.m[k])/2.);
      elbo -= est.phi[i][k] * log(est.phi[i][k]);
    }
  }

  // update posterior of mu
  double product_x_phi;
  for(int k = 0; k < data.g_vars.K; k++){
    sum_phi = 0;
    product_x_phi = 0;

    for(int i = 0; i < data.g_vars.n_samples; i++){
      sum_phi += est.phi[i][k];
      product_x_phi += data.x[i] * est.phi[i][k];
    }
    est.m[k] = product_x_phi / (1/data.g_vars.sigma_2 + sum_phi);
  }
}
