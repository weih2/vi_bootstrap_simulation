__device__ cavi_implementor::cavi_implementor(device_settings dev_settings, int t_id){
  b_count = 0;

  thread_id = t_id;
  x = dev_settings.x;

  for(int k = 0; k < p; k++){
    true_pars.beta[k] = (*dev_settings.g_pars).beta[k];
  }

  true_pars.sigma_2 = (*dev_settings.g_pars).sigma_2;
  true_pars.sigma_b_2 = (*dev_settings.g_pars).sigma_b_2;
  true_pars.pi = (*dev_settings.g_pars).pi;
}
