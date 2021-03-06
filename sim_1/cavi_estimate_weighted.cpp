using namespace std;

void cavi_implementation::generate_weights(){
  static int allocated = 0;
  if(!allocated){
    data.b_vars.weights = new double[data.g_vars.n_samples];
    allocated = 1;
  }

  double sum_weights = 0;
  // generate exponential weigths only
  for(int i = 0; i < data.g_vars.n_samples ; i++){
    data.b_vars.weights[i] = - log(random_uniform());
    sum_weights += data.b_vars.weights[i];
  }

  // normalizing
  for(int i = 0; i < data.g_vars.n_samples ; i++)
   data.b_vars.weights[i] *= data.g_vars.n_samples/sum_weights;
}

void cavi_implementation::cavi_estimate_weighted(){
  // setting constant
  elbo = 0;
  // update phi
  double sum_phi;
  /* using unweighted variational posterior
  for(int i = 0; i < data.g_vars.n_samples; i++){
    sum_phi = 0;
    for(int k = 0; k < data.g_vars.K; k++){
      sum_phi += (
        est.phi[i][k] = exp(data.b_vars.weights[i]*(data.x[i] * est.m[k] - (est.s2[k] + est.m[k]*est.m[k])/2.))
      );
    }
    for(int k = 0; k < data.g_vars.K; k++){
      est.phi[i][k] /= sum_phi;
      elbo -= est.phi[i][k] * log(est.phi[i][k]);
    }
  }
  // */

  // /* using weighted variational posterior
  for(int i = 0; i < data.g_vars.n_samples; i++){
    sum_phi = 0;
    for(int k = 0; k < data.g_vars.K; k++){
      sum_phi += (
        est.phi[i][k] = exp(data.x[i] * est.m[k] - (est.s2[k] + est.m[k]*est.m[k])/2.)
      );
    }
    for(int k = 0; k < data.g_vars.K; k++){
      est.phi[i][k] /= sum_phi;
      elbo -= est.phi[i][k] * data.b_vars.weights[i] * log(est.phi[i][k]);
    }
  }
  // */

  // update posterior of mu
  double product_x_phi;
  for(int k = 0; k < data.g_vars.K; k++){
    sum_phi = 0;
    product_x_phi = 0;

    for(int i = 0; i < data.g_vars.n_samples; i++){
      sum_phi += est.phi[i][k] * data.b_vars.weights[i];
      product_x_phi += data.x[i] * est.phi[i][k] * data.b_vars.weights[i];
    }

    for(int k_prime = 0; k_prime < data.g_vars.K; k_prime++){
      if(k == k_prime) continue;
      product_x_phi -= est.m[k_prime]/BUFF; // repulsive
    }

    est.s2[k] = 1 / (1/data.g_vars.sigma_2 + sum_phi);
    est.m[k] = product_x_phi * est.s2[k];

    elbo += - (product_x_phi * product_x_phi + 1) * est.s2[k]/(2*data.g_vars.sigma_2) + log(est.s2[k])/2.;
    for(int i = 0; i < data.g_vars.n_samples; i++){
      elbo += est.phi[i][k] * data.b_vars.weights[i] *
        (data.x[i] * (-data.x[i]/2. + est.m[k]) - (est.s2[k] + est.m[k]*est.m[k])/2.);
    }
  }

  for(int k = 0; k < data.g_vars.K; k++){
    for(int k_prime = k + 1; k_prime < data.g_vars.K; k_prime++){
      elbo -= est.m[k] * est.m[k_prime]/(2. * data.g_vars.sigma_2 * BUFF);
    }
  }
}

void cavi_implementation::cavi_bootstrap_update(int& n_steps){
  cavi_estimation est_temp = est;
  for(int b = 0; b < n_bootstrap_samples; b++){
    generate_weights();
    est = weighted_est[b];
    cavi_estimate_weighted();

    for(int n_step = 1; n_step <= n_steps; n_step++){
      double old_elbo = elbo;
      cavi_estimate_weighted();
      if((elbo - old_elbo) < epsilon) break;
    }
    gsl_sort2(est.m, 1, est.s2, 1, data.g_vars.K);
    cout << est.m[0] << " ";
  }
  est = est_temp;
}
