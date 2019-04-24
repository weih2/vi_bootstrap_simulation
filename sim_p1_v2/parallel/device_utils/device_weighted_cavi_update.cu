__device__ void
device_cavi_implementation::device_weighted_cavi_point_estimate_update(){
  // setting constant
  elbo = 0;
  // update phi
  double sum_phi;
  for(int i = 0; i < n_samples; i++){
    sum_phi = 0;
    for(int k = 0; k < K; k++){
      phi_b[i][k] = exp(x[i] * m_b[k] - (s2_b[k] + m_b[k]*m_b[k])/2.);
      sum_phi += phi_b[i][k];
    }
    for(int k = 0; k < K; k++){
      phi_b[i][k] /= sum_phi;
      elbo -= phi_b[i][k] * log(phi_b[i][k]) * weights[i];
    }
  }

  // update posterior of mu
  double product_x_phi;
  for(int k = 0; k < K; k++){
    sum_phi = 0;
    product_x_phi = 0;

    for(int i = 0; i < n_samples; i++){
      sum_phi += phi_b[i][k] * weights[i];
      product_x_phi += x[i] * phi_b[i][k]* weights[i];
    }
    s2_b[k] = 1 / (1/double(sigma_2) + sum_phi);
    m_b[k] = product_x_phi * s2_b[k];

    elbo += - (product_x_phi * product_x_phi + 1) * s2_b[k]/(2.*double(sigma_2)) + log(s2_b[k])/2.;
    for(int i = 0; i < n_samples; i++){
      elbo += phi_b[i][k] * weights[i] *
        (x[i] * (- x[i]/2. + m_b[k]) - (s2_b[k] + m_b[k]*m_b[k])/2.);
    }
  }
}
