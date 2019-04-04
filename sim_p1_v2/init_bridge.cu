bridge::bridge(device_settings dev_settings){
  host_dev_settings = dev_settings;

  vwlb_cs_covered = new int[n_bootstrap_samples * K];
  vp_cs_covered = new int[n_bootstrap_samples * K];

  map_mu = new double[n_bootstrap_samples * K];
}
