__device__ void device_cavi_implementation::device_cavi_point_estimate_update(){
  // setting constant
  elbo = 0;
  // update phi
  double sum_phi;
  for(int i = 0; i < n_samples; i++){
    sum_phi = 0;
    for(int k = 0; k < N_CLUSTERS; k++){
      phi[i][k] = exp(x[i] * m[k] - (s2[k] + m[k]*m[k])/2.);
      sum_phi += phi[i][k];
    }
    for(int k = 0; k < N_CLUSTERS; k++){
      phi[i][k] /= sum_phi;
      elbo -= phi[i][k] * log(phi[i][k]);
    }
  }

  // update posterior of mu
  double product_x_phi;
  for(int k = 0; k < N_CLUSTERS; k++){
    sum_phi = 0;
    product_x_phi = 0;

    for(int i = 0; i < n_samples; i++){
      sum_phi += phi[i][k];
      product_x_phi += x[i] * phi[i][k];
    }
    s2[k] = 1 / (1/double(sigma_2) + sum_phi);
    m[k] = product_x_phi * s2[k];

    elbo += - (product_x_phi * product_x_phi + 1) * s2[k]/(2.*double(sigma_2)) + log(s2[k])/2.;
    for(int i = 0; i < n_samples; i++){
      elbo += phi[i][k] *
        (x[i] * (- x[i]/2. + m[k]) - (s2[k] + m[k]*m[k])/2.);
    }
  }
}
