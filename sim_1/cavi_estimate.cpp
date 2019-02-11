using namespace std;

cavi_implementation::cavi_implementation(simulation_data& dat,
  int max_iter = 1000, double precision = 0.0001){
  data = dat;
  est = init_cavi(dat);

  max_n_iter = max_iter;
  epsilon = precision;
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
    est.s2[k] = 1 / (1/data.g_vars.sigma_2 + sum_phi);
    est.m[k] = product_x_phi * est.s2[k];

    elbo += 1/(2 * product_x_phi) - log(est.s2[k])/2.;
  }
}

void cavi_implementation::cavi_update(int& n_steps){
  cavi_estimate();

  for(int n_step = 1; n_step <= n_steps; n_step++){
    cout << "current elbo: " << elbo << endl;
    double old_elbo = elbo;
    cavi_estimate();
    if((elbo - old_elbo) < epsilon) break;
  }
}
