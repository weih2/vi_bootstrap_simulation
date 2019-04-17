__device__ void cavi_implementor::importance_sampling(){
  for(int sigma_2_ind = 0; sigma_2_ind < n_sigma_2; sigma_2_ind++){
    current_pars.sigma_2 = sigma_2_lower + (sigma_2_upper - sigma_2_lower)
      * sigma_2_ind / double(n_sigma_2);
    for(int sigma_b_2_ind = 0; sigma_b_2_ind < n_sigma_b_2; sigma_b_2_ind++){
      current_pars.sigma_b_2 = sigma_b_2_lower + (sigma_b_2_upper - sigma_b_2_lower)
        * sigma_b_2_ind / double(n_sigma_b_2);
      for(int pi_ind = 0; pi_ind < n_pi; pi_ind++){
        current_pars.pi = exp10(
          log_pi_lower + (log_pi_upper - log_pi_lower) * pi_ind / double(n_pi);
        );
        // innder loop
      }
    }
  }

  // calculate posterior MAP
}
