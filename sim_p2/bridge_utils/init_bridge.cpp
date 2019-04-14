bridge::bridge(global_pars& g_pars){
  host_dev_settings.x = new double[n * p];
  generate_x(host_dev_settings.x, experiment_ac);

  host_dev_settings.g_pars = &g_pars;

  init_device();
  copy_to_device();
}
