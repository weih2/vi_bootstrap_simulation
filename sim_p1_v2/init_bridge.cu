bridge::bridge(device_settings dev_settings){
  host_dev_settings = dev_settings;

  vwlb_cs_covered = new int[n_experiments * N_CLUSTERS];
  vwlb_cs2_covered = new int[n_experiments * N_CLUSTERS];
  vp_cs_covered = new int[n_experiments * N_CLUSTERS];

  host_empirical_mu = new double[n_experiments * N_CLUSTERS];

  vwlb_cs_lengths = new double[n_experiments * N_CLUSTERS];
  vwlb_cs2_lengths = new double[n_experiments * N_CLUSTERS];
  vp_cs_lengths = new double[n_experiments * N_CLUSTERS];

  is_outlier = new int[n_experiments];

  for(int k = 0; k < N_CLUSTERS; k++){
    empirical_ci_covered_counts[k] = 0;
  }

  n_outliers = 0;

  init_device();
  copy_to_device();
}
