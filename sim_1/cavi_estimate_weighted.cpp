using namespace std;

void cavi_implementation::generate_weights(){
  static int allocated = 0;
  if(!allocated){
    data.b_vars.weights = new double[data.g_vars.n_samples];
    allocated = 1;
  }

  // generate exponential weigths only
  for(int i = 0; i < data.g_vars.n_samples ; i++){
    data.b_vars.weights[i] = - log(random_uniform());
  }
}

void cavi_implementation::cavi_estimate_weighted(){
  // setting constant
  elbo = 0;
  // update phi
  double sum_phi;
  for(int i = 0; i < data.g_vars.n_samples; i++){
    sum_phi = 0;
    for(int k = 0; k < data.g_vars.K; k++){
      sum_phi += (
        est.phi[i][k] = exp(data.b_vars.weights[i]*(data.x[i] * est.m[k] - (est.s2[k] + est.m[k]*est.m[k])/2.))
      );
    }
    for(int k = 0; k < data.g_vars.K; k++){
      est.phi[i][k] /= sum_phi;
      elbo += est.phi[i][k] * data.b_vars.weights[i] *
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
      sum_phi += est.phi[i][k] * data.b_vars.weights[i] * data.b_vars.weights[i];
      product_x_phi += data.x[i] * est.phi[i][k] * data.b_vars.weights[i] * data.b_vars.weights[i];
    }
    est.s2[k] = 1 / (1/data.g_vars.sigma_2 + sum_phi);
    est.m[k] = product_x_phi * est.s2[k];

    elbo += (product_x_phi * product_x_phi - 1) * est.s2[k]/2. + log(est.s2[k])/2.;
  }
}

void cavi_implementation::cavi_bootstrap_update(int& n_steps){
  cavi_estimation est_temp = est;
  for(int b = 0; b < n_bootstrap_samples; b++){
    generate_weights();
    cavi_estimate_weighted();

    est = weighted_est[b];
    for(int n_step = 1; n_step <= n_steps; n_step++){
      cout << "current elbo: " << elbo << endl;
      double old_elbo = elbo;
      cavi_estimate_weighted();
      if((elbo - old_elbo) < epsilon) break;
    }
  }
  est = est_temp;
}
