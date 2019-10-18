class bridge{
public:
  bridge(device_settings);
  // this will be generated at host
  device_settings host_dev_settings;
  // this is gpu's copy of settings
  device_settings device_dev_settings;

  // indicate outlier
  int *is_outlier;
  // int *device_is_outlier;

  // count how many are covered
  int *vwlb_cs_covered;
  int *vwlb_cs2_covered;
  int *vp_cs_covered;

  double *host_empirical_mu;
  double *device_empirical_mu;

  int *device_vwlb_cs_covered;
  int *device_vwlb_cs2_covered;
  int *device_vp_cs_covered;

  // study the lengths distributions
  double *device_vwlb_cs_lengths;
  double *vwlb_cs_lengths;
  double *device_vwlb_cs2_lengths;
  double *vwlb_cs2_lengths;
  double *device_vp_cs_lengths;
  double *vp_cs_lengths;

  // first centers
  double *dev_vwlb_first_centers;
  double *dev_vwlb2_first_centers;
  double *dev_vp_first_centers;

  double *vwlb_first_centers;
  double *vwlb2_first_centers;
  double *vp_first_centers;

  double empirical_ci[N_CLUSTERS][2];

  int n_outliers;
  int vwlb_cs_covered_counts[N_CLUSTERS];
  int vwlb_cs2_covered_counts[N_CLUSTERS];
  int vp_cs_covered_counts[N_CLUSTERS];
  int empirical_ci_covered_counts[N_CLUSTERS];

  void init_device();
  void copy_to_device();
  void clean_device();

  void lengths_copy_back();

  void connect_to_execution();
  void connect_to_analysis();

  void count_coverage();
  void construct_empirical_ci();
  void save_settings(std::ostream&);
  // void save_result(std::ostream&);
  void save_result();
  void print_centers();
};
