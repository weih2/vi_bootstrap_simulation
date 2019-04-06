class bridge{
public:
  bridge(device_settings);
  // this will be generated at host
  device_settings host_dev_settings;
  // this is gpu's copy of settings
  device_settings device_dev_settings;

  // count how many are covered
  int *vwlb_cs_covered;
  int *vp_cs_covered;

  double *host_empirical_mu;
  double *device_empirical_mu;

  int *device_vwlb_cs_covered;
  int *device_vp_cs_covered;

  double empirical_ci[K][2];

  int vwlb_cs_covered_counts[K];
  int vp_cs_covered_counts[K];
  int empirical_ci_covered_counts[K];

  void init_device();
  void copy_to_device();
  void clean_device();

  void connect_to_execution();

  void count_coverage();
  void construct_empirical_ci();
  void save_settings(std::ostream&);
  // void save_result(std::ostream&);
  void save_result();
};
