bridge::bridge(device_settings dev_settings){
  host_dev_settings = dev_settings;

  vwlb_cs_covered = new int[n_experiments * K];
  vp_cs_covered = new int[n_experiments * K];

  host_empirical_mu = new double[n_experiments * K];

  for(int k = 0; k < K; k++){
    empirical_ci_covered_counts[k] = 0;
  }

  init_device();
  copy_to_device();
}
