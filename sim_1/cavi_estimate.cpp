using namespace std;

cavi_implementation::cavi_implementation(simulation_data& dat, int n_b_samples = 100,
  int max_iter = 1000, double precision = 0.001){
  data = dat;
  est = init_cavi(dat);

  max_n_iter = max_iter;
  epsilon = precision;

  n_bootstrap_samples = n_b_samples;
  weighted_est = new cavi_estimation[n_bootstrap_samples];
  for(int b = 0; b < n_bootstrap_samples; b++)
    weighted_est[b] = init_cavi(dat);

  ci_covered = 0;
  cs_covered = 0;
  ci_covered_each = new int[data.g_vars.K]();
  cs_covered_each = new int[data.g_vars.K]();

  n_experiments = 0;

  history_map = new queue<double>[data.g_vars.K];
  for(int k = 0; k < data.g_vars.K; k++){
    history_map[k] = queue<double>();
  }
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

    for(int k_prime = 0; k_prime < data.g_vars.K; k_prime++){
      if(k == k_prime) continue;
      product_x_phi -= est.m[k_prime]/BUFF; // repulsive
    }
    est.s2[k] = 1 / (1/data.g_vars.sigma_2 + sum_phi);
    est.m[k] = product_x_phi * est.s2[k];

    elbo += - (product_x_phi * product_x_phi + 1) * est.s2[k]/(2*data.g_vars.sigma_2) + log(est.s2[k])/2.;
    for(int i = 0; i < data.g_vars.n_samples; i++){
      elbo += est.phi[i][k] *
        (data.x[i] * (- data.x[i]/2. + est.m[k]) - (est.s2[k] + est.m[k]*est.m[k])/2.);
    }
  }

  for(int k = 0; k < data.g_vars.K; k++){
    for(int k_prime = k + 1; k_prime < data.g_vars.K; k_prime++){
      elbo -= est.m[k] * est.m[k_prime]/(2. * data.g_vars.sigma_2 * BUFF);
    }
  }
}

void cavi_implementation::cavi_update(int& n_steps){
  cavi_estimate();

  for(int n_step = 1; n_step <= n_steps; n_step++){
    double old_elbo = elbo;
    cavi_estimate();
    if((elbo - old_elbo) < epsilon) break;
    if(n_step >= max_n_iter) break;
  }
  gsl_sort2(est.m, 1, est.s2, 1, data.g_vars.K);

  for(int k = 0; k < data.g_vars.K; k++){
    history_map[k].push(est.m[k]);
  }
}
